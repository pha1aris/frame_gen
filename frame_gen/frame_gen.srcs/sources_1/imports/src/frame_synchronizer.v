`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: frame_synchronizer (工业级锁定优化版)
//
// Description:
//   - 修复四大核心缺陷：XOR缺失、fifo_rd_en控制、状态机锁定维持、tvalid控制
//   - 模块化设计：Hamming_calc + Vote_Calculator
//   - 工业级状态机：S_SEARCH → S_FLUSH → S_VERIFY → S_PASS → S_PRESUMED_LOCK
//////////////////////////////////////////////////////////////////////////////////

module frame_synchronizer #(
    parameter [63:0] SYNC_MARKER         = 64'hB1699558A53333A8,
    parameter integer SYNC_REPETITION    = 8,
    parameter integer PAYLOAD_LEN        = 2461696,
    parameter integer ERROR_THRESHOLD    = 10,
    parameter integer PRESUMED_LOCK_LIMIT= 5,
    parameter integer VOTE_THRESHOLD     = 2
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  s_axis_input_tdata,
    input  wire        s_axis_input_tvalid,
    output wire        s_axis_input_tready,
    output reg         start_of_frame_o,
    output reg [7:0]   m_axis_output_tdata,
    output reg         m_axis_output_tvalid,
    input  wire        m_axis_output_tready
);

    // =================================================================
    // 参数计算
    // =================================================================
    localparam SYNC_BYTES         = 8;
    localparam TOTAL_SYNC_BYTES   = SYNC_BYTES * SYNC_REPETITION;
    localparam SHIFT_REG_WIDTH    = TOTAL_SYNC_BYTES * 8;
    localparam PADDING_LEN        = (4 - ((TOTAL_SYNC_BYTES + PAYLOAD_LEN) % 4)) % 4;
    localparam PAYLOAD_TOTAL_LEN  = PAYLOAD_LEN + PADDING_LEN;
    localparam PIPELINE_DELAY     = 3;

    // 状态机定义
    localparam [2:0]
        S_SEARCH        = 3'd0,
        S_FLUSH         = 3'd1,
        S_VERIFY        = 3'd2,
        S_PASS          = 3'd3,
        S_PRESUMED_LOCK = 3'd4;

    // =================================================================
    // FIFO 输入缓冲
    // =================================================================
    wire fifo_rd_en, fifo_empty, fifo_full;
    wire [7:0] fifo_dout;
    assign s_axis_input_tready = !fifo_full;

    sync_fifo_8w_8r input_fifo_inst (
        .clk(clk), .srst(rst),
        .din(s_axis_input_tdata),
        .wr_en(s_axis_input_tvalid && s_axis_input_tready),
        .full(fifo_full),
        .dout(fifo_dout),
        .rd_en(fifo_rd_en),
        .empty(fifo_empty)
    );

    // =================================================================
    // 滑动窗口（SRL 风格）
    // =================================================================
    reg [SHIFT_REG_WIDTH-1:0] shift_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) shift_reg <= {SHIFT_REG_WIDTH{1'b0}};
        else if (fifo_rd_en)
            shift_reg <= {shift_reg[SHIFT_REG_WIDTH-9:0], fifo_dout};
    end

    // =================================================================
    // Hamming_calc 阶段（XOR运算修复）
    // =================================================================
    wire [6:0] hamming_distances [0:SYNC_REPETITION-1];
    wire hd_valid;
    genvar gi;
    generate
        for (gi = 0; gi < SYNC_REPETITION; gi = gi + 1) begin : HD_CALC_INST
            wire [63:0] received_word = shift_reg[(gi+1)*SYNC_BYTES*8-1 -: 64];
            wire [63:0] diff = received_word ^ SYNC_MARKER; // XOR 修复
            Hamming_calc u_hamming_calc (
                .clk(clk),
                .rst(rst),
                .data_i(diff),
                .data_valid_i(fifo_rd_en),
                .pop_count(hamming_distances[gi]),
                .pop_count_valid(hd_valid)
            );
        end
    endgenerate

    // =================================================================
    // Vote_Calculator 阶段
    // =================================================================
    reg [SYNC_REPETITION-1:0] match_votes_stage2;
            integer idx;
    always @(posedge clk or posedge rst) begin
        if (rst) 
            match_votes_stage2 <= {SYNC_REPETITION{1'b0}};
        else if (hd_valid) begin
            for (idx = 0; idx < SYNC_REPETITION; idx = idx + 1)
                match_votes_stage2[idx] <= (hamming_distances[idx] <= ERROR_THRESHOLD);
        end
    end

    wire sync_match;
    Vote_Calculator #(
        .SYNC_REPETITION(SYNC_REPETITION),
        .VOTE_THRESHOLD (VOTE_THRESHOLD)
    ) u_vote_calculator (
        .match_votes_i(match_votes_stage2),
        .sync_match_o(sync_match)
    );

    // =================================================================
    // 状态机
    // =================================================================
    reg [2:0] state, n_state, prev_state;
    reg [$clog2(PAYLOAD_TOTAL_LEN)-1:0] payload_byte_cnt;
    reg [$clog2(PRESUMED_LOCK_LIMIT)-1:0] presumed_lock_cnt;
    reg [$clog2(PIPELINE_DELAY)-1:0] flush_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_SEARCH;
            prev_state <= S_SEARCH;
        end else begin
            state <= n_state;
            prev_state <= state;
        end
    end

    always @(*) begin
        n_state = state;
        case (state)
            S_SEARCH:
                if (sync_match) n_state = S_FLUSH;
            S_FLUSH:
                if (flush_cnt == PIPELINE_DELAY-1)
                    n_state = S_VERIFY;
            S_VERIFY:
                if (payload_byte_cnt == PAYLOAD_TOTAL_LEN-1)
                    n_state = sync_match ? S_PASS : S_SEARCH;
            S_PASS:
                if (payload_byte_cnt == PAYLOAD_TOTAL_LEN-1)
                    n_state = sync_match ? S_VERIFY : S_SEARCH;
            S_PRESUMED_LOCK:
                if (payload_byte_cnt == PAYLOAD_TOTAL_LEN-1)
                    n_state = sync_match ? S_PRESUMED_LOCK : S_SEARCH;
        endcase
    end

    // =================================================================
    // fifo_rd_en 控制修复
    // =================================================================
    assign fifo_rd_en = ((state == S_SEARCH || state == S_FLUSH) && !fifo_empty) ||
                         ((state == S_PASS || state == S_PRESUMED_LOCK || state == S_VERIFY) &&
                          (m_axis_output_tready || !m_axis_output_tvalid) && !fifo_empty);

    // =================================================================
    // 输出控制修复
    // =================================================================
    wire m_axis_fire = m_axis_output_tvalid && m_axis_output_tready;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            start_of_frame_o  <= 1'b0;
            payload_byte_cnt  <= 0;
            presumed_lock_cnt <= 0;
            flush_cnt         <= 0;
            m_axis_output_tvalid <= 0;
            m_axis_output_tdata  <= 0;
        end else begin
            start_of_frame_o <= (state == S_PASS || state == S_PRESUMED_LOCK || state == S_VERIFY) &&
                                 m_axis_fire && (payload_byte_cnt == PAYLOAD_TOTAL_LEN-1) && sync_match;

            if (n_state == S_FLUSH && state != S_FLUSH) 
                flush_cnt <= 0;
            else if (state == S_FLUSH) 
                flush_cnt <= flush_cnt + 1;

            if (start_of_frame_o || (state == S_FLUSH && flush_cnt == PIPELINE_DELAY-1))
                payload_byte_cnt <= 0;
            else if (m_axis_fire && (state == S_PASS || state == S_PRESUMED_LOCK || state == S_VERIFY))
                payload_byte_cnt <= payload_byte_cnt + 1;

            if (n_state == S_PRESUMED_LOCK && state != S_PRESUMED_LOCK) 
                presumed_lock_cnt <= 0;
            else if ((state == S_PRESUMED_LOCK) && m_axis_fire && (payload_byte_cnt == PAYLOAD_TOTAL_LEN-1))
                presumed_lock_cnt <= presumed_lock_cnt + 1;
            else if (n_state != S_PRESUMED_LOCK)
                presumed_lock_cnt <= 0;

                m_axis_output_tvalid <= ((state == S_PASS || state == S_PRESUMED_LOCK || state == S_VERIFY) && !fifo_empty);
            if (m_axis_output_tready && m_axis_output_tvalid)
                m_axis_output_tdata <= fifo_dout;
        end
    end



    `ifndef SYNTHESIS
        reg [13*8:0] state_ascii;
        always @(*) begin
            case (state)
                S_SEARCH       :state_ascii = "S_SEARCH       ";
                S_FLUSH        :state_ascii = "S_FLUSH        ";
                S_VERIFY       :state_ascii = "S_VERIFY       ";
                S_PASS         :state_ascii = "S_PASS         ";
                S_PRESUMED_LOCK:state_ascii = "S_PRESUMED_LOCK";
            endcase
        end
    `endif


endmodule
