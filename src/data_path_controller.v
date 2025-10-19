`timescale 1ns / 1ps
// data_path_controller.v (最终数据防丢版)
//
// **已修正**: 增加 spatial_ok_in 接口，并修改 fifo_rd_en_out 逻辑，
//           在 S_SEARCH 状态下，一旦发现疑似同步信号就暂停读取FIFO，
//           从根本上杜绝帧间数据丢失问题。

module data_path_controller #(
    parameter integer SYNC_REPETITION   = 3,
    parameter integer PAYLOAD_LEN       = 64
)(
    input  wire         clk,
    input  wire         rst,
    input  wire         lock_pulse_in,
    input  wire         lock_stable_in,
    // --- 新增端口 ---
    input  wire         spatial_ok_in,
    input  wire         fifo_empty,
    input  wire         m_axis_tready_in,
    output wire         fifo_rd_en_out,
    output reg          sof_out,
    output reg          tvalid_out
);
    // ... (localparam 和 reg/wire 定义与之前相同) ...
    localparam SYNC_BYTES        = 8;
    localparam TOTAL_SYNC_BYTES  = SYNC_BYTES * SYNC_REPETITION;
    localparam PADDING_LEN       = (4 - ((TOTAL_SYNC_BYTES + PAYLOAD_LEN) % 4)) % 4;
    localparam PAYLOAD_TOTAL_LEN = PAYLOAD_LEN + PADDING_LEN;
    localparam PIPELINE_DELAY    = TOTAL_SYNC_BYTES;
    localparam [1:0] S_SEARCH = 2'd0, S_FLUSH  = 2'd1, S_VERIFY = 2'd2;

    reg [1:0] state, n_state;
    reg [$clog2(PAYLOAD_TOTAL_LEN)-1:0] payload_byte_cnt;
    reg [$clog2(PIPELINE_DELAY+1)-1:0] flush_cnt;
    wire m_axis_fire = tvalid_out && m_axis_tready_in;

    // FSM 状态机 (逻辑无需改动)
    always @(posedge clk or posedge rst) begin if (rst) state <= S_SEARCH; else state <= n_state; end
    always @(*) begin
        n_state = state;
        case (state)
            S_SEARCH: 
                if (lock_pulse_in) 
                n_state = S_FLUSH;
            S_FLUSH:  
                if (flush_cnt == PIPELINE_DELAY - 1) 
                    n_state = S_VERIFY;
            S_VERIFY: 
                if (payload_byte_cnt == PAYLOAD_TOTAL_LEN - 1 && m_axis_fire) 
                    n_state = S_SEARCH;
        endcase
    end
    
    // 计数器逻辑 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            payload_byte_cnt <= 0;
            flush_cnt <= 0;
            sof_out <= 1'b0;
        end else begin
            if (n_state == S_FLUSH && state != S_FLUSH) flush_cnt <= 0;
            else if (state == S_FLUSH && fifo_rd_en_out) flush_cnt <= flush_cnt + 1;
            sof_out <= (state == S_FLUSH && flush_cnt == PIPELINE_DELAY - 1);
            if (state != S_VERIFY) payload_byte_cnt <= 0;
            else if (m_axis_fire) begin
                if (payload_byte_cnt == PAYLOAD_TOTAL_LEN - 1) payload_byte_cnt <= 0;
                else payload_byte_cnt <= payload_byte_cnt + 1;
            end
        end
    end

    // **关键修正**: FIFO读使能信号生成
    assign fifo_rd_en_out = 
        ( (state == S_FLUSH) && !fifo_empty ) ||
        ( (state == S_VERIFY) && (!tvalid_out || m_axis_tready_in) ) ||
        ( (state == S_SEARCH) && !fifo_empty && !spatial_ok_in );

    // 输出 tvalid 逻辑 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tvalid_out <= 1'b0;
        end else begin
            if (m_axis_tready_in || !tvalid_out) begin
                tvalid_out <= (state == S_VERIFY && !fifo_empty);
            end
        end
    end
endmodule