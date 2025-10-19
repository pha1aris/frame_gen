`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: tb_controller_integrated (时序修正版)
//
// 描述:
//   - **已修正**: 采用非阻塞赋值同步更新 byte_in 和 enable 信号，
//     解决了 byte_in 与其有效信号(enable)之间存在的1周期延迟问题。
//
//////////////////////////////////////////////////////////////////////////////////
module data_path_controller_sim;

    // =================================================================
    // 参数定义 (与之前版本相同)
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
    reg [7:0] byte_in;
    // 'enable' 不再由 testbench 直接驱动，而是由 fifo_rd_en 决定
    reg fifo_empty;
    reg m_axis_tready_in;
    
    wire fifo_rd_en;
    wire [SYNC_REPETITION-1:0]                detector_match_votes;
    wire [(SYNC_REPETITION*HAMMING_WIDTH)-1:0] detector_packed_hamming;
    wire lock_pulse;
    wire is_locked;
    wire is_temporal_ok;
    wire sof_out;
    wire tvalid_out;

    // =================================================================
    // 模块实例化 (与之前版本相同)
    // =================================================================
    sync_pattern_detector #(.SYNC_MARKER(SYNC_MARKER), .SYNC_REPETITION(SYNC_REPETITION), .HAMMING_WIDTH(HAMMING_WIDTH), .ERROR_THRESHOLD(ERROR_THRESHOLD))
    u_pattern_detector (.clk(clk), .rst(rst), .byte_in(byte_in), .enable(fifo_rd_en), .match_votes_out(detector_match_votes), .packed_hamming_out(detector_packed_hamming));

    lock_detector #(.SYNC_REPETITION(SYNC_REPETITION), .HAMMING_WIDTH(HAMMING_WIDTH), .SCORE_HIGH(SCORE_HIGH), .SCORE_MED(SCORE_MED), .HAMM_HIGH(HAMM_HIGH), .HAMM_MED(HAMM_MED), .SCORE_THRESHOLD(SCORE_THRESHOLD), .TEMPORAL_DEPTH(TEMPORAL_DEPTH), .TEMPORAL_VOTE(TEMPORAL_VOTE), .K_GOOD(K_GOOD), .K_BAD(K_BAD))
    u_lock_detector (.clk(clk), .rst(rst), .match_votes_i(detector_match_votes), .hamming_dist_i(detector_packed_hamming), .pos_sync_match_pulse(lock_pulse), .locked(is_locked), .temporal_ok(is_temporal_ok));

    data_path_controller #(.SYNC_REPETITION(SYNC_REPETITION), .PAYLOAD_LEN(PAYLOAD_LEN))
    u_dut (.clk(clk), .rst(rst), .lock_pulse_in(lock_pulse), .lock_stable_in(is_temporal_ok), .fifo_empty(fifo_empty), .m_axis_tready_in(m_axis_tready_in), .fifo_rd_en_out(fifo_rd_en), .sof_out(sof_out), .tvalid_out(tvalid_out));
    
    // =================================================================
    // 时钟和复位
    // =================================================================
    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin rst = 1; #52; rst = 0; end

    // =================================================================
    // 激励生成 (已修正)
    // =================================================================

        integer i, j;
    initial begin
        fifo_empty <= 1'b0;
        m_axis_tready_in <= 1'b1;
        byte_in <= 8'h00;

        @(negedge rst);
        $display("\n[%0t ns] <<< 复位结束，开始集成测试 >>>", $time);

        // --- 场景 1: 搜索并锁定 ---
        $display("\n[%0t ns] --- 场景 1: 搜索并锁定 ---", $time);
        // 使用非阻塞赋值，在时钟沿之前准备好数据
        @(posedge clk); byte_in <= 8'hAA;
        @(posedge clk); byte_in <= 8'hBB;

        for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                @(posedge clk); byte_in <= (SYNC_MARKER >> (8 * (7-j))) & 8'hFF;
            end
        end
        for (i = 0; i < PAYLOAD_LEN + 10; i = i + 1) begin
            @(posedge clk); byte_in <= i[7:0];
        end
        
        // --- 场景 2: 模拟反压 ---
        $display("\n[%0t ns] --- 场景 2: 模拟下游反压 ---", $time);
        @(posedge clk); m_axis_tready_in <= 1'b0;
        repeat(5) @(posedge clk);
        @(posedge clk); m_axis_tready_in <= 1'b1;
        
        // --- 场景 3: 模拟失锁 ---
        $display("\n[%0t ns] --- 场景 3: 模拟失锁 (发送随机数据) ---", $time);
        for (i = 0; i < PAYLOAD_LEN + 10; i = i + 1) begin
            @(posedge clk); byte_in <= $random;
        end

        wait_cycles(20);
        $display("\n[%0t ns] <<< 仿真结束 >>>", $time);
        $finish;
    end
    
    task wait_cycles(input integer N);
        repeat(N) @(posedge clk);
    endtask

    // =================================================================
    // 实时监控 (与之前版本相同)
    // =================================================================
    initial begin
        $monitor("[%0t ns] state=%s, locked=%b, pulse=%b, t_ok=%b, rd_en=%b, tvalid=%b, tready=%b, sof=%b",
                 $time, state_to_ascii(u_dut.state), is_locked, lock_pulse, is_temporal_ok,
                 fifo_rd_en, tvalid_out, m_axis_tready_in, sof_out);
    end

    function [8*8-1:0] state_to_ascii;
        input [1:0] state;
        case(state)
            u_dut.S_SEARCH: state_to_ascii = "SEARCH";
            u_dut.S_FLUSH:  state_to_ascii = "FLUSH";
            u_dut.S_VERIFY: state_to_ascii = "VERIFY";
            default:        state_to_ascii = "UNKNOWN";
        endcase
    endfunction

endmodule