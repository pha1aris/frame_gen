`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: frame_synchronizer_hierarchical
//
// 功能: 最终分层版顶层模块 (总装)。
// 职责: 例化并连接所有子模块(FIFO, 模式检测器, 决策引擎, 数据通路控制器)，
//       对外提供标准的 AXI-Stream 接口。
//////////////////////////////////////////////////////////////////////////////////
module frame_synchronizer_hierarchical #(
    // 将所有可调参数都提升到顶层，便于集中管理
    parameter [63:0] SYNC_MARKER      = 64'hB1699558A53333A8,
    parameter integer SYNC_REPETITION = 3,
    parameter integer PAYLOAD_LEN     = 64,
    parameter integer ERROR_THRESHOLD = 10,
    parameter integer HAMMING_WIDTH   = 8,
    parameter integer SCORE_HIGH      = 4,
    parameter integer SCORE_MED       = 2,
    parameter integer HAMM_HIGH       = 2,
    parameter integer HAMM_MED        = 5,
    parameter integer SCORE_THRESHOLD = 6,
    parameter integer TEMPORAL_DEPTH  = 3,
    parameter integer TEMPORAL_VOTE   = 2,
    parameter integer K_GOOD          = 3,
    parameter integer K_BAD           = 4
)(
    input  wire         clk,
    input  wire         rst,
    // AXI-Stream 输入接口
    input  wire [7:0]   s_axis_input_tdata,
    input  wire         s_axis_input_tvalid,
    output wire         s_axis_input_tready,
    // AXI-Stream 输出接口
    output reg  [7:0]   m_axis_output_tdata,
    output wire         m_axis_output_tvalid,
    input  wire         m_axis_output_tready,
    // 状态输出
    output wire         start_of_frame_o,
    output wire         locked_o
);

    // =================================================================
    // 内部信号线定义 (用于连接各个子模块)
    // =================================================================
    // --- 内部信号线定义 ---
    wire        fifo_rd_en, fifo_empty, fifo_full;
    wire [7:0]  fifo_dout;
    wire [2:0]  detector_match_votes;
    wire [23:0] detector_packed_hamming; // 根据参数调整
    wire        lock_pulse, is_locked, is_temporal_ok;
    wire        is_spatial_ok;
    // =================================================================
    // 1. 实例化 FIFO 缓冲
    // =================================================================
    assign s_axis_input_tready = !fifo_full;
    // 假设您有一个名为 sync_fifo_8w_8r 的FIFO IP核或模块
    sync_fifo_8w_8r input_fifo_inst (
        .clk(clk), 
        .srst(rst),
        .din(s_axis_input_tdata), 
        .wr_en(s_axis_input_tvalid && s_axis_input_tready), 
        .full(fifo_full),
        .dout(fifo_dout), 
        .rd_en(fifo_rd_en), 
        .empty(fifo_empty)
    );

    // =================================================================
    // 2. 实例化 模式检测前端 ("雷达阵列")
    // =================================================================
    sync_pattern_detector #(
        .SYNC_MARKER(SYNC_MARKER), 
        .SYNC_REPETITION(SYNC_REPETITION),
        .HAMMING_WIDTH(HAMMING_WIDTH), 
        .ERROR_THRESHOLD(ERROR_THRESHOLD)
    ) u_pattern_detector (
        .clk(clk), 
        .rst(rst),
        .byte_in(fifo_dout), 
        .enable(fifo_rd_en),
        .match_votes_out(detector_match_votes),
        .packed_hamming_out(detector_packed_hamming)
    );

    // =================================================================
    // 3. 实例化 锁定决策引擎 ("决策大脑")
    // =================================================================
    lock_detector #(
        .SYNC_REPETITION(SYNC_REPETITION), 
        .HAMMING_WIDTH(HAMMING_WIDTH),
        .SCORE_HIGH(SCORE_HIGH), 
        .SCORE_MED(SCORE_MED), 
        .HAMM_HIGH(HAMM_HIGH), 
        .HAMM_MED(HAMM_MED),
        .SCORE_THRESHOLD(SCORE_THRESHOLD), 
        .TEMPORAL_DEPTH(TEMPORAL_DEPTH), 
        .TEMPORAL_VOTE(TEMPORAL_VOTE),
        .K_GOOD(K_GOOD), 
        .K_BAD(K_BAD)
    ) u_lock_detector (
        .clk(clk), 
        .rst(rst),
        .match_votes_i(detector_match_votes), 
        .hamming_dist_i(detector_packed_hamming),
        .pos_sync_match_pulse(lock_pulse),
        .temporal_ok(is_temporal_ok),
        .spatial_ok_out(is_spatial_ok) 
    );

    // =================================================================
    // 4. 实例化 数据通路控制器 ("交通指挥官")
    // =================================================================
    data_path_controller #(
        .SYNC_REPETITION(SYNC_REPETITION), 
        .PAYLOAD_LEN(PAYLOAD_LEN)
    ) u_controller (
         .clk(clk), .rst(rst),
        .lock_pulse_in(lock_pulse), 
        .lock_stable_in(is_temporal_ok),
        // --- 新增连接 ---
        .spatial_ok_in(is_spatial_ok),
        .fifo_empty(fifo_empty), 
        .m_axis_tready_in(m_axis_output_tready),
        .fifo_rd_en_out(fifo_rd_en),
        .sof_out(start_of_frame_o),
        .tvalid_out(m_axis_output_tvalid)
    );

    assign locked_o = is_locked;

    // =================================================================
    // 5. 输出数据路径 (直接由FIFO输出，受控制器信号的调度)
    // =================================================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            m_axis_output_tdata <= 8'h00;
        end else begin
            // 只有在数据即将被发送时，才更新输出数据寄存器
            // 这个条件与 data_path_controller 内部的 tvalid 更新条件一致
            if (m_axis_output_tready || !m_axis_output_tvalid) begin
                m_axis_output_tdata <= fifo_dout;
            end
        end
    end
endmodule