`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: tb_end_to_end_final (时序修正版)
//
// 描述:
//   - **已修正**: 修复了 `send_frame` 任务中发送同步头的时序逻辑，
//     确保每个字节都在一个单独的时钟周期发送。
//   - 现在该测试平台可以正确生成连续的、无损的数据帧流。
//
//////////////////////////////////////////////////////////////////////////////////
module tb_end_to_end_final;

    // =================================================================
    // 参数定义
    // =================================================================
    localparam [63:0] SYNC_MARKER      = 64'hB1699558A53333A8;
    localparam integer SYNC_REPETITION = 3;
    localparam integer PAYLOAD_LEN     = 64;

    // =================================================================
    // 信号定义
    // =================================================================
    reg clk;
    reg rst;
    reg [7:0]  s_axis_tdata;
    reg        s_axis_tvalid;
    wire       s_axis_tready;
    wire [7:0] m_axis_tdata;
    wire       m_axis_tvalid;
    reg        m_axis_tready;
    wire       start_of_frame_o;
    wire       locked_o;
    
    // --- 自校验逻辑使用的信号 ---
    localparam GOLDEN_Q_SIZE = 256;
    reg [7:0] golden_payload_mem [0:GOLDEN_Q_SIZE-1];
    integer golden_q_wr_ptr = 0;
    integer golden_q_rd_ptr = 0;
    integer golden_q_size = 0;
    
    integer error_count = 0;
    integer sent_payload_count = 0;
    integer received_payload_count = 0;

    integer i, j;
    reg [7:0] payload_byte;
    reg [7:0] expected_data;

    // =================================================================
    // 实例化待测模块 (DUT)
    // =================================================================
    frame_synchronizer #(
        .PAYLOAD_LEN(PAYLOAD_LEN)
    ) u_dut (
        .clk(clk), 
        .rst(rst),
        .s_axis_input_tdata(s_axis_tdata), 
        .s_axis_input_tvalid(s_axis_tvalid), 
        .s_axis_input_tready(s_axis_tready),
        .m_axis_output_tdata(m_axis_tdata), 
        .m_axis_output_tvalid(m_axis_tvalid), 
        .m_axis_output_tready(m_axis_tready),
        .start_of_frame_o(start_of_frame_o), 
        .locked_o(locked_o)
    );

    // =================================================================
    // 时钟和复位
    // =================================================================
    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin rst = 1; #52; rst = 0; end

    // =================================================================
    // 激励生成
    // =================================================================
    initial begin
        s_axis_tdata  <= 8'h00;
        s_axis_tvalid <= 1'b0;

        @(negedge rst);
        $display("\n[%0t ns] <<< 复位结束, 开始端到端测试 >>>", $time);
        
        wait_cycles(10);
        
        $display("[%0t ns] --- 开始发送连续数据帧 ---", $time);
        send_frame(0); 
        send_frame(1); 
        send_frame(2); 
        send_frame(3); 
        send_frame(4); 

        wait_cycles(200);
        
        if (error_count == 0 && golden_q_size == 0) begin
            $display("\n-------------------------------------------------");
            $display("[%0t ns] [PASS] 所有数据校验通过! 共发送 %0d 字节, 接收 %0d 字节。", $time, sent_payload_count, received_payload_count);
            $display("-------------------------------------------------");
        end else begin
            $display("\n-------------------------------------------------");
            $display("[%0t ns] [FAIL] 测试失败! 错误计数: %0d, 剩余期望数据: %0d 字节", $time, error_count, golden_q_size);
            $display("-------------------------------------------------");
        end
        $finish;
    end

    // **已修正**: 辅助任务，确保同步头和载荷都按每周期一字节发送
    task send_frame;
        input [7:0] start_payload;
        begin
            // --- 发送同步头 ---
            for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
                for (j = 0; j < 8; j = j + 1) begin
                    s_axis_tvalid <= 1'b1;
                    s_axis_tdata  <= (SYNC_MARKER >> (8 * (7-j))) & 8'hFF;
                    @(posedge clk); // **关键修正**: 增加时钟等待
                    while (!s_axis_tready) @(posedge clk);
                end
            end
            
            // --- 发送数据载荷 ---
            for (i = 0; i < PAYLOAD_LEN; i = i + 1) begin
                payload_byte = start_payload + i;
                golden_payload_mem[golden_q_wr_ptr] = payload_byte;
                golden_q_wr_ptr = (golden_q_wr_ptr + 1) % GOLDEN_Q_SIZE;
                golden_q_size = golden_q_size + 1;
                sent_payload_count = sent_payload_count + 1;
                
                s_axis_tvalid <= 1'b1;
                s_axis_tdata  <= payload_byte;
                @(posedge clk);
                while (!s_axis_tready) @(posedge clk);
            end

            // 在帧结束后，拉低 tvalid
            s_axis_tvalid <= 1'b0;
        end
    endtask
    
    task wait_cycles;
        input integer N;
        begin
            repeat(N) @(posedge clk);
        end
    endtask

    initial begin
        m_axis_tready <= 1'b0;
        @(negedge rst); 
        m_axis_tready <= 1'b1;
    end

    always @(posedge clk) begin
        if (!rst && m_axis_tvalid && m_axis_tready) begin
            if (golden_q_size > 0) begin
                expected_data = golden_payload_mem[golden_q_rd_ptr];
                golden_q_rd_ptr = (golden_q_rd_ptr + 1) % GOLDEN_Q_SIZE;
                golden_q_size = golden_q_size - 1;
                received_payload_count = received_payload_count + 1;
                
                if (m_axis_tdata === expected_data) begin
                    // $display("[%0t ns] [CHECK OK] Received: 0x%0h, Expected: 0x%0h", $time, m_axis_tdata, expected_data);
                end else begin
                    $error("[%0t ns] [CHECK FAIL] Received: 0x%0h, Expected: 0x%0h", $time, m_axis_tdata, expected_data);
                    error_count = error_count + 1;
                end
            end else begin
                $error("[%0t ns] [CHECK FAIL] Received unexpected data: 0x%0h when golden queue is empty!", $time, m_axis_tdata);
                error_count = error_count + 1;
            end
        end
    end

endmodule

