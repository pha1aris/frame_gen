`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: data_path_controller_sim (名称修正版)
//
// 描述:
//   - data_path_controller 模块的功能验证测试平台。
//   - **已修正**: 解决了 $monitor 中对 u_dut.payload_cnt 的错误引用问题。
//
//////////////////////////////////////////////////////////////////////////////////
module data_path_controller_sim;
 // =================================================================
    // 参数定义 (集中管理所有参数)
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
    // --- Testbench 驱动的信号 ---
    reg [7:0] byte_in;      // 模拟来自FIFO的数据
    reg fifo_empty;
    reg m_axis_tready_in;
    // --- 模块间的连接线 ---
    wire fifo_rd_en;
    wire [SYNC_REPETITION-1:0]                detector_match_votes;
    wire [(SYNC_REPETITION*HAMMING_WIDTH)-1:0] detector_packed_hamming;
    wire lock_pulse;        // 不再是 reg, 而是由 lock_detector 驱动
    wire is_locked;
    wire is_temporal_ok;    // 不再是 reg, 而是由 lock_detector 驱动
    // --- 最终输出 ---
    wire sof_out;
    wire tvalid_out;

    // =================================================================
    // 模块实例化
    // =================================================================
    // 1. 数据采集前端
    sync_pattern_detector #(
        .SYNC_MARKER(SYNC_MARKER), .SYNC_REPETITION(SYNC_REPETITION),
        .HAMMING_WIDTH(HAMMING_WIDTH), .ERROR_THRESHOLD(ERROR_THRESHOLD)
    ) u_pattern_detector (
        .clk(clk), .rst(rst),
        .byte_in(byte_in), .enable(fifo_rd_en), // enable 由控制器反馈
        .match_votes_out(detector_match_votes),
        .packed_hamming_out(detector_packed_hamming)
    );

    // 2. 决策大脑
    lock_detector #(
        .SYNC_REPETITION(SYNC_REPETITION), .HAMMING_WIDTH(HAMMING_WIDTH),
        .SCORE_HIGH(SCORE_HIGH), .SCORE_MED(SCORE_MED), .HAMM_HIGH(HAMM_HIGH), .HAMM_MED(HAMM_MED),
        .SCORE_THRESHOLD(SCORE_THRESHOLD), .TEMPORAL_DEPTH(TEMPORAL_DEPTH), .TEMPORAL_VOTE(TEMPORAL_VOTE),
        .K_GOOD(K_GOOD), .K_BAD(K_BAD)
    ) u_lock_detector (
        .clk(clk), .rst(rst),
        .match_votes_i(detector_match_votes), 
        .hamming_dist_i(detector_packed_hamming),
        .pos_sync_match_pulse(lock_pulse),
        .locked(is_locked),
        .temporal_ok(is_temporal_ok)
    );

    // 3. 数据通路控制器 (DUT)
    data_path_controller #(
        .SYNC_REPETITION(SYNC_REPETITION), .PAYLOAD_LEN(PAYLOAD_LEN)
    ) u_dut (
        .clk(clk), .rst(rst),
        .lock_pulse_in(lock_pulse),         // 输入来自 u_lock_detector
        .lock_stable_in(is_temporal_ok),    // 输入来自 u_lock_detector
        .fifo_empty(fifo_empty), .m_axis_tready_in(m_axis_tready_in),
        .fifo_rd_en_out(fifo_rd_en),
        .sof_out(sof_out),
        .tvalid_out(tvalid_out)
    );
    
    // =================================================================
    // 时钟和复位
    // =================================================================
    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin rst = 1; #52; rst = 0; end

    // =================================================================
    // 激励生成 (现在是发送字节流)
    // =================================================================
    initial begin
        integer i, j;
        fifo_empty = 1'b0;
        m_axis_tready_in = 1'b1;

        @(negedge rst);
        $display("\n[%0t ns] <<< 复位结束，开始集成测试 >>>", $time);

        // --- 场景 1: 发送同步序列以触发锁定 ---
        $display("\n[%0t ns] --- 场景 1: 搜索并锁定 ---", $time);
        drive_byte(8'hAA);
        for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                drive_byte( (SYNC_MARKER >> (8 * (7-j))) & 8'hFF );
            end
        end
        // 持续发送一些载荷数据
        for (i = 0; i < PAYLOAD_LEN + 10; i = i + 1) drive_byte(i[7:0]);
        
        // --- 场景 2: 模拟反压 ---
        $display("\n[%0t ns] --- 场景 2: 模拟下游反压 ---", $time);
        m_axis_tready_in = 1'b0;
        wait_cycles(5);
        m_axis_tready_in = 1'b1;
        
        // --- 场景 3: 模拟失锁 ---
        $display("\n[%0t ns] --- 场景 3: 模拟失锁 (发送随机数据) ---", $time);
        // 持续发送随机数据，这会使 is_temporal_ok 在帧尾变低，从而触发失锁
        for (i = 0; i < PAYLOAD_LEN + 10; i = i + 1) drive_byte($random);

        wait_cycles(20);
        $display("\n[%0t ns] <<< 仿真结束 >>>", $time);
        $finish;
    end
    
    task drive_byte(input [7:0] data);
        begin @(posedge clk); #1; byte_in = data; end
    endtask
    task wait_cycles(input integer N); repeat(N) @(posedge clk); endtask

    // =================================================================
    // 实时监控
    // =================================================================
    initial begin
        $monitor("[%0t ns] state=%s, locked=%b, pulse=%b, t_ok=%b, rd_en=%b, tvalid=%b, tready=%b, sof=%b",
                 $time, u_dut.state_to_ascii(u_dut.state), is_locked, lock_pulse, is_temporal_ok,
                 fifo_rd_en, tvalid_out, m_axis_tready_in, sof_out);
    end

    // 状态机状态转ASCII函数
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