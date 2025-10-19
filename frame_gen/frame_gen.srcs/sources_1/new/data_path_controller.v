`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: data_path_controller
//
// 功能: 数据通路主控FSM。
// 职责: 接收锁定指令，管理状态机，并生成所有数据流控制信号，
//       如同一个交通指挥官，指挥数据的流动。
//////////////////////////////////////////////////////////////////////////////////
module data_path_controller #(
    // 将会影响计数的参数
    parameter integer SYNC_REPETITION   = 3,
    parameter integer PAYLOAD_LEN       = 64
)(
    input  wire         clk,
    input  wire         rst,
    // --- 来自 lock_detector 的指令 ---
    input  wire         lock_pulse_in,    // pos_sync_match_pulse, 告诉FSM“我们找到了一个帧”
    input  wire         lock_stable_in,   // is_temporal_ok, 告诉FSM“锁定状态依然稳定”
    // --- 来自系统的状态 ---
    input  wire         fifo_empty,
    input  wire         m_axis_tready_in, // 下游模块是否准备好接收数据
    // --- 输出的控制信号 ---
    output wire         fifo_rd_en_out,
    output reg          sof_out,          // start_of_frame, 帧起始脉冲
    output reg          tvalid_out        // m_axis_output_tvalid
);
    // 内部参数计算
    localparam SYNC_BYTES        = 8;
    localparam TOTAL_SYNC_BYTES  = SYNC_BYTES * SYNC_REPETITION;
    localparam PADDING_LEN       = (4 - ((TOTAL_SYNC_BYTES + PAYLOAD_LEN) % 4)) % 4;
    localparam PAYLOAD_TOTAL_LEN = PAYLOAD_LEN + PADDING_LEN;
    localparam PIPELINE_DELAY    = TOTAL_SYNC_BYTES;
    
    // 简洁的三状态FSM定义
    localparam [1:0] S_SEARCH = 2'd0, S_FLUSH  = 2'd1, S_VERIFY = 2'd2;

    // FSM状态寄存器
    reg [1:0] state, n_state;
    // 计数器
    reg [$clog2(PAYLOAD_TOTAL_LEN)-1:0] payload_byte_cnt;
    reg [$clog2(PIPELINE_DELAY+1)-1:0] flush_cnt;
    
    // AXI-Stream 握手信号
    wire m_axis_fire = tvalid_out && m_axis_tready_in;

    // FSM 状态转移逻辑
    always @(posedge clk or posedge rst) begin
        if (rst) state <= S_SEARCH;
        else     state <= n_state;
    end
    
    // FSM 下一状态组合逻辑
    always @(*) begin
        n_state = state;
        case (state)
            S_SEARCH: // 搜索状态：等待来自 lock_detector 的锁定脉冲
                if (lock_pulse_in) n_state = S_FLUSH;
                
            S_FLUSH:  // 冲刷状态：等待 flush_cnt 计数完成
                if (flush_cnt == PIPELINE_DELAY - 1) n_state = S_VERIFY;
                
            S_VERIFY: // 验证/传输状态：在帧尾检查是否失锁
                // 仅当一帧的最后一个字节被成功发送后，才检查
                if (payload_byte_cnt == PAYLOAD_TOTAL_LEN - 1 && m_axis_fire) begin
                    if (!lock_stable_in) // 如果 lock_detector 报告信号不稳定，则返回搜索
                        n_state = S_SEARCH;
                end
        endcase
    end

    // 计数器与帧起始信号(sof)生成逻辑
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            payload_byte_cnt <= 0;
            flush_cnt <= 0;
            sof_out <= 1'b0;
        end else begin
            // flush_cnt: 在FLUSH状态下，每当从FIFO读出一个字节时，计数器加1
            if (n_state == S_FLUSH && state != S_FLUSH) flush_cnt <= 0;
            else if (state == S_FLUSH && fifo_rd_en_out) flush_cnt <= flush_cnt + 1;

            // sof_out: 在FLUSH状态的最后一拍产生一个单周期脉冲
            sof_out <= (state == S_FLUSH && flush_cnt == PIPELINE_DELAY - 1);

            // payload_byte_cnt: 在VERIFY状态下，每当成功发送一个字节时，计数器加1
            if (state != S_VERIFY) payload_byte_cnt <= 0;
            else if (m_axis_fire) begin
                if (payload_byte_cnt == PAYLOAD_TOTAL_LEN - 1) payload_byte_cnt <= 0;
                else payload_byte_cnt <= payload_byte_cnt + 1;
            end
        end
    end

    // FIFO读使能信号生成
    assign fifo_rd_en_out = 
        ( ((state == S_SEARCH) || (state == S_FLUSH)) && !fifo_empty ) ||
        ( (state == S_VERIFY) && (!tvalid_out || m_axis_tready_in) );

    // 输出 tvalid 逻辑 (标准AXI-Stream握手)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tvalid_out <= 1'b0;
        end else begin
            // 只有当下游准备好接收，或者当前tvalid本就无效时，才尝试置位tvalid
            if (m_axis_tready_in || !tvalid_out) begin
                tvalid_out <= (state == S_VERIFY && !fifo_empty);
            end
        end
    end
endmodule