`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: tb_frame_synchronizer_final
//
// 描述:
//   - 用于测试最终单文件版 frame_synchronizer 模块的端到端测试平台。
//   - **已修改**: 实例化目标已从分层版更改为单文件集成版。
//
//////////////////////////////////////////////////////////////////////////////////
module tb_frame_synchronizer_final;

    // =================================================================
    // 参数定义
    // =================================================================
    localparam [63:0] SYNC_MARKER      = 64'hB1699558A53333A8;
    localparam integer SYNC_REPETITION = 3;
    localparam integer PAYLOAD_LEN     = 64;
    localparam integer ERROR_THRESHOLD = 10;
    localparam integer HAMMING_WIDTH   = 8;
    localparam integer SCORE_HIGH      = 4;
    localparam integer SCORE_MED       = 2;
    localparam integer HAMM_HIGH       = 2;
    localparam integer HAMM_MED        = 5;
    localparam integer SCORE_THRESHOLD = 6;
    localparam integer TEMPORAL_DEPTH  = 3;
    localparam integer TEMPORAL_VOTE   = 2;
    localparam integer K_GOOD          = 3;
    localparam integer K_BAD           = 4;

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
    // **已修改**: 实例化单文件版的 frame_synchronizer
    frame_synchronizer_circular #(
        .SYNC_MARKER(SYNC_MARKER), .SYNC_REPETITION(SYNC_REPETITION), .PAYLOAD_LEN(PAYLOAD_LEN),
        .ERROR_THRESHOLD(ERROR_THRESHOLD), .HAMMING_WIDTH(HAMMING_WIDTH), .SCORE_HIGH(SCORE_HIGH),
        .SCORE_MED(SCORE_MED), .HAMM_HIGH(HAMM_HIGH), .HAMM_MED(HAMM_MED),
        .SCORE_THRESHOLD(SCORE_THRESHOLD), .TEMPORAL_DEPTH(TEMPORAL_DEPTH), .TEMPORAL_VOTE(TEMPORAL_VOTE),
        .K_GOOD(K_GOOD), .K_BAD(K_BAD)
    ) u_dut (
        .clk(clk), .rst(rst),
        .s_axis_input_tdata(s_axis_tdata), .s_axis_input_tvalid(s_axis_tvalid), .s_axis_input_tready(s_axis_tready),
        .m_axis_output_tdata(m_axis_tdata), .m_axis_output_tvalid(m_axis_tvalid), .m_axis_output_tready(m_axis_tready),
        .start_of_frame_o(start_of_frame_o), .locked_o(locked_o)
    );

    // =================================================================
    // 时钟和复位
    // =================================================================
    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin rst = 1; #52; rst = 0; end

    // =================================================================
    // 激励生成 (与之前版本相同)
    // =================================================================
    initial begin
        s_axis_tdata  <= 8'h00;
        s_axis_tvalid <= 1'b0;

        @(negedge rst);
        // $display("\n[%0t ns] <<< 复位结束, 开始单文件版模块端到端测试 >>>", $time);
        
        wait_cycles(10);
        // $display("[%0t ns] --- 发送第一帧 (Payload从0开始) ---", $time);
        send_frame(0);
        wait_cycles(10);
        // $display("[%0t ns] --- 发送第二帧 (Payload同样从0开始) ---", $time);
        send_frame(0);
        wait_cycles(10);
        send_frame(0);
        wait_cycles(10);
        send_frame(0);
        wait_cycles(10);
        send_frame(0);
        wait_cycles(10);
        send_frame(0);
        wait_cycles(10);
        send_frame(0);
        wait_cycles(10);
        // wait_cycles(200);
        
        if (error_count == 0 && golden_q_size == 0) begin
            $display("\n-------------------------------------------------");
            $display("[%0t ns] [PASS] 所有数据校验通过! 共发送 %0d 字节, 接收 %0d 字节。", $time, sent_payload_count, received_payload_count);
            $display("-------------------------------------------------");
        end
        $finish;
    end

    // =================================================================
    // 任务定义
    // =================================================================
    task send_frame;
        input [7:0] start_payload;
        begin
            for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
                for (j = 0; j < 8; j = j + 1) begin
                    send_axi_byte((SYNC_MARKER >> (8 * (7-j))) & 8'hFF);
                end
            end
            for (i = 0; i < PAYLOAD_LEN; i = i + 1) begin
                payload_byte = start_payload + i;
                golden_payload_mem[golden_q_wr_ptr] = payload_byte;
                golden_q_wr_ptr = (golden_q_wr_ptr + 1) % GOLDEN_Q_SIZE;
                golden_q_size = golden_q_size + 1;
                sent_payload_count = sent_payload_count + 1;
                send_axi_byte(payload_byte);
            end
        end
    endtask

    task send_axi_byte;
        input [7:0] data;
        begin
            // 只在ready有效时更新数据
            @(posedge clk);
            while (!s_axis_tready) @(posedge clk);
            s_axis_tvalid <= 1'b1;
            s_axis_tdata  <= data;
        end
    endtask


    task wait_cycles;
        input integer N;
        begin
            repeat(N) @(posedge clk);
        end
    endtask

    // =================================================================
    // 输出接收与校验
    // =================================================================
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
                    $display("[%0t ns] [CHECK OK] Received: 0x%0h, Expected: 0x%0h", $time, m_axis_tdata, expected_data);
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

