`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_frame_end2end (语法修正版)
//
// Description:
//   - 修正了 "Generator Output Checker" 中错误的 wire/assign 声明。
//
//////////////////////////////////////////////////////////////////////////////////
module tb_frame_end2end;

    // =================================================================
    // 时钟与复位
    // =================================================================
    reg clk = 0;
    always #5 clk = ~clk;  // 100MHz

    reg rst = 1;
    initial begin
        #100 rst = 0;
    end

    // =================================================================
    // 实例化 DUT 和信号线
    // =================================================================

    // --- 信号线 ---
    reg  [7:0] src_data = 0;
    reg        src_valid = 0;
    wire       src_ready;

    wire [7:0] gen_out_tdata;
    wire       gen_out_tvalid;
    wire       gen_out_tready;

    wire [7:0] noisy_tdata;
    wire       noisy_tvalid;
    wire       noisy_tready;

    wire [7:0] sync_out_tdata;
    wire       sync_out_tvalid;
    wire       sync_out_tready;
    wire       start_of_frame_o;

    // --- 实例化 ---
    localparam PAYLOAD_LEN = 64;
    localparam [63:0] SYNC_MARKER = 64'hB1699558A53333A8;
    
    frame_generator #(
        .SYNC_MARKER(SYNC_MARKER),
        .SYNC_REPETITION(3),
        .PAYLOAD_LEN(PAYLOAD_LEN)
    ) u_frame_generator (
        .clk(clk), .rst(rst),
        .s_axis_input_tdata(src_data), .s_axis_input_tvalid(src_valid), .s_axis_input_tready(src_ready),
        .m_axis_output_tdata(gen_out_tdata), .m_axis_output_tvalid(gen_out_tvalid), .m_axis_output_tready(gen_out_tready)
    );

    frame_synchronizer #(
        .SYNC_MARKER(SYNC_MARKER),
        .SYNC_REPETITION(3),
        .PAYLOAD_LEN(PAYLOAD_LEN)
    ) u_frame_synchronizer (
        .clk(clk), .rst(rst),
        .s_axis_input_tdata(noisy_tdata), .s_axis_input_tvalid(noisy_tvalid), .s_axis_input_tready(noisy_tready),
        .start_of_frame_o(start_of_frame_o),
        .m_axis_output_tdata(sync_out_tdata), .m_axis_output_tvalid(sync_out_tvalid), .m_axis_output_tready(sync_out_tready)
    );

    // =================================================================
    // 1. 数据源
    // =================================================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            src_data  <= 0;
            src_valid <= 0;
        end else begin
            src_valid <= 1;
            if (src_valid && src_ready)begin
                if(src_data == PAYLOAD_LEN - 1)begin
                    src_data <= 'd0;
                end else begin
                    src_data <= src_data + 1;
                end
            end
        end
    end

    // =================================================================
    // 2. 信道模型与错误注入
    // =================================================================
    reg corrupt_sync_header = 0;
    reg corrupt_payload     = 0;

    assign noisy_tdata = (corrupt_sync_header || corrupt_payload) ? ~gen_out_tdata : gen_out_tdata;
    assign noisy_tvalid = gen_out_tvalid;
    assign gen_out_tready = noisy_tready;

    // =================================================================
    // 3. 【修正】检验 frame_generator 输出
    // =================================================================
    localparam TOTAL_SYNC_BYTES = 24;
    localparam PADDING_LEN      = (4 - ((TOTAL_SYNC_BYTES + PAYLOAD_LEN) % 4)) % 4;
    localparam FRAME_LEN        = TOTAL_SYNC_BYTES + PAYLOAD_LEN + PADDING_LEN;

    reg [7:0] gen_byte_cnt = 0;
    always @(posedge clk) begin
        if (!rst && gen_out_tvalid && gen_out_tready) begin
            
            // 检查同步头部分
            if (gen_byte_cnt < TOTAL_SYNC_BYTES) begin
                if (gen_out_tdata != (SYNC_MARKER >> (8 * (7 - (gen_byte_cnt % 8))))) begin
                    $error("[%0t ns] GENERATOR ERROR: Sync header byte %0d incorrect. Expected %02h, Got %02h",
                           $time, gen_byte_cnt, (SYNC_MARKER >> (8 * (7 - (gen_byte_cnt % 8)))), gen_out_tdata);
                end
            end
            // 检查载荷部分
            else if (gen_byte_cnt < TOTAL_SYNC_BYTES + PAYLOAD_LEN) begin
                if (gen_out_tdata != (gen_byte_cnt - TOTAL_SYNC_BYTES)) begin
                    $error("[%0t ns] GENERATOR ERROR: Payload byte %0d incorrect. Expected %02h, Got %02h",
                           $time, (gen_byte_cnt - TOTAL_SYNC_BYTES), (gen_byte_cnt - TOTAL_SYNC_BYTES), gen_out_tdata);
                end
            end
            // 检查填充部分
            else begin
                 if (gen_out_tdata != 8'h00) begin
                    $error("[%0t ns] GENERATOR ERROR: Padding byte incorrect. Expected 00, Got %02h", $time, gen_out_tdata);
                 end
            end

            if (gen_byte_cnt == FRAME_LEN - 1)
                gen_byte_cnt <= 0;
            else
                gen_byte_cnt <= gen_byte_cnt + 1;
        end
    end

    // =================================================================
    // 4. 检验 frame_synchronizer 输出
    // =================================================================
    assign sync_out_tready = 1'b1;
    reg [7:0] expected_sync_data = 0;
    reg       checker_enabled = 0;

    always @(posedge clk) begin
        if (rst) begin
            expected_sync_data <= 0;
            checker_enabled <= 0;
        end else begin
            if (start_of_frame_o) begin
                $display("[%0t ns] *** Detected Frame Boundary, golden model reset to 0. ***", $time);
                expected_sync_data <= 0;
                checker_enabled <= 1'b1;
            end

            if (checker_enabled && sync_out_tvalid && sync_out_tready) begin
                if (expected_sync_data < PAYLOAD_LEN) begin
                    if (sync_out_tdata != expected_sync_data) begin
                        $error("[%0t ns] SYNCHRONIZER E2E ERROR: Data mismatch! Expected: %02h, Got: %02h",
                               $time, expected_sync_data, sync_out_tdata);
                    end
                end
                
                if (expected_sync_data == (PAYLOAD_LEN + PADDING_LEN - 1)) begin
                     checker_enabled <= 0;
                     expected_sync_data <= 0;
                end else begin
                     expected_sync_data <= expected_sync_data + 1;
                end
            end
        end
    end

    // =================================================================
    // 5. 仿真控制
    // =================================================================
    initial begin
        $dumpfile("tb_frame_end2end.vcd");
        $dumpvars(0, tb_frame_end2end);

        #2000;
        $display("------ Scenario 1: Normal transmission complete. ------");

        $display("------ Scenario 2: Injecting error into SYNC HEADER... ------");
        corrupt_sync_header = 1;
        #50;
        corrupt_sync_header = 0;
        $display("------ Error injection finished. ------");
        #2000;
        
        $display("------ Scenario 3: Injecting error into PAYLOAD... ------");
        #800;
        corrupt_payload = 1;
        #100;
        corrupt_payload = 0;
        $display("------ Error injection finished. ------");

        #5000;
        $display("Simulation finished.");
        $finish;
    end

endmodule