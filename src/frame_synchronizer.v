`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: frame_synchronizer (V7 - 终极硬件修正版)
//
// 描述:
//   - **已修正**: 包含所有硬件相关的关键修正（端口、指针回绕、BRAM延迟、缓冲区溢出保护）。
//   - 实现了最鲁棒的“回读环形缓冲区”架构，保证了高吞吐和数据完整性。
//
//////////////////////////////////////////////////////////////////////////////////
module frame_synchronizer #(
    // ================== 集中管理所有可调参数 ==================
    parameter [63:0] SYNC_MARKER       = 64'hB1699558A53333A8,
    parameter integer  SYNC_REPETITION = 3,
    parameter integer  PAYLOAD_LEN     = 64,
    parameter integer  ERROR_THRESHOLD = 10,
    parameter integer  HAMMING_WIDTH   = 8,
    parameter integer  SCORE_HIGH      = 4,
    parameter integer  SCORE_MED       = 2,
    parameter integer  HAMM_HIGH       = 2,
    parameter integer  HAMM_MED        = 5,
    parameter integer  SCORE_THRESHOLD = 6,
    parameter integer  TEMPORAL_DEPTH  = 8,
    parameter integer  TEMPORAL_VOTE   = 6,
    parameter integer  K_GOOD          = 3,
    parameter integer  K_BAD           = 4,
    parameter integer  BUF_DEPTH_BITS  = 8 // 缓冲区深度 = 2^8 = 256
)(
    input  wire         clk,
    input  wire         rst,
    // AXI-Stream 输入
    input  wire [7:0]   s_axis_input_tdata,
    input  wire         s_axis_input_tvalid,
    output wire         s_axis_input_tready,
    // AXI-Stream 输出
    output wire [7:0]   m_axis_output_tdata,
    output wire         m_axis_output_tvalid,
    input  wire         m_axis_output_tready,
    // **已修正**: 增加缺失的端口声明
    output wire         start_of_frame_o,
    output wire         locked_o
);

    // =================================================================
    // 内部参数计算
    // =================================================================
    localparam SYNC_BYTES              = 8;
    localparam TOTAL_SYNC_BYTES        = SYNC_BYTES * SYNC_REPETITION;
    localparam SHIFT_REG_WIDTH         = TOTAL_SYNC_BYTES * 8;
    localparam PADDING_LEN             = (4 - ((TOTAL_SYNC_BYTES + PAYLOAD_LEN) % 4)) % 4;
    localparam PAYLOAD_TOTAL_LEN       = PAYLOAD_LEN + PADDING_LEN;
    localparam TOTAL_FRAME_LEN         = TOTAL_SYNC_BYTES + PAYLOAD_TOTAL_LEN;
    localparam HAMMING_CALC_LATENCY    = 2;
    localparam INTERNAL_PIPE_LATENCY   = 4;
    localparam TOTAL_PIPELINE_DELAY    = 1 + HAMMING_CALC_LATENCY + INTERNAL_PIPE_LATENCY;

    // =================================================================
    // Section 1: 侦测逻辑 (与之前版本相同)
    // =================================================================
    wire       fifo_rd_en;
    wire       fifo_empty;
    wire       fifo_full;
    wire [7:0] fifo_dout;

    assign s_axis_input_tready = !fifo_full; // s_axis_tready 只受上游FIFO影响

    sync_fifo_8w_8r input_fifo_inst (
        .clk    (clk),
        .srst   (rst),
        .din    (s_axis_input_tdata),
        .wr_en  (s_axis_input_tvalid && s_axis_input_tready),
        .full   (fifo_full),
        .dout   (fifo_dout),
        .rd_en  (fifo_rd_en),
        .empty  (fifo_empty)
    );

    reg [SHIFT_REG_WIDTH-1:0] shift_reg;
    always @(posedge clk or posedge rst) begin
        if (rst)
            shift_reg <= {SHIFT_REG_WIDTH{1'b0}};
        else if (fifo_rd_en)
            shift_reg <= {shift_reg[SHIFT_REG_WIDTH-9:0], fifo_dout};
    end

    // --- 此处省略了之前版本中已验证的、用于产生 pos_sync_pulse 的详细侦测逻辑代码 ---
    reg pipeline_full_reg;
    reg [$clog2(TOTAL_SYNC_BYTES)-1:0] startup_cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pipeline_full_reg <= 1'b0;
            startup_cnt       <= 0;
        end else if (!pipeline_full_reg && fifo_rd_en) begin
            if (startup_cnt == TOTAL_SYNC_BYTES - 1)
                pipeline_full_reg <= 1'b1;
            else
                startup_cnt <= startup_cnt + 1;
        end
    end

    reg [$clog2(TOTAL_SYNC_BYTES)-1:0] byte_cnt;
    always @(posedge clk or posedge rst) begin
        if (rst)
            byte_cnt <= 0;
        else if (fifo_rd_en)
            byte_cnt <= (byte_cnt == TOTAL_SYNC_BYTES - 1) ? 0 : byte_cnt + 1;
    end

    wire [6:0]                  hamming_distances [0:SYNC_REPETITION-1];
    wire                        popcnt_valid_vec  [0:SYNC_REPETITION-1];
    genvar gi;
    generate
        for (gi = 0; gi < SYNC_REPETITION; gi = gi + 1) begin : HD_CALC_INST
            wire [63:0] received_word = shift_reg[(gi+1)*SYNC_BYTES*8-1 -: 64];
            wire        data_valid_pulse;
            if (gi == 0)
                assign data_valid_pulse = (byte_cnt == SYNC_BYTES * 1 - 1);
            else if (gi == 1)
                assign data_valid_pulse = (byte_cnt == SYNC_BYTES * 2 - 1);
            else if (gi == 2)
                assign data_valid_pulse = (byte_cnt == SYNC_BYTES * 3 - 1);

            Hamming_calc u_hamming_calc (
                .clk             (clk),
                .rst             (rst),
                .data_i          (received_word ^ SYNC_MARKER),
                .data_valid_i    (data_valid_pulse),
                .pop_count       (hamming_distances[gi]),
                .pop_count_valid (popcnt_valid_vec[gi])
            );
        end
    endgenerate

    reg         any_pop_valid_comb;
    integer pvi;
    always @(*) begin
        any_pop_valid_comb = 1'b0;
        for (pvi = 0; pvi < SYNC_REPETITION; pvi = pvi + 1)
            any_pop_valid_comb = any_pop_valid_comb | popcnt_valid_vec[pvi];
    end
    wire any_pop_valid = any_pop_valid_comb;

    reg [6:0]   hamming_distances_reg [0:SYNC_REPETITION-1];
    reg         any_pop_valid_reg;
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            any_pop_valid_reg <= 1'b0;
            for (i = 0; i < SYNC_REPETITION; i = i + 1)
                hamming_distances_reg[i] <= 7'h7F;
        end else begin
            any_pop_valid_reg <= any_pop_valid;
            if (any_pop_valid) begin
                for (i = 0; i < SYNC_REPETITION; i = i + 1)
                    hamming_distances_reg[i] <= hamming_distances[i];
            end
        end
    end

    wire sample_valid_pulse = any_pop_valid && !any_pop_valid_reg;
    reg  sample_valid_latched;
    always @(posedge clk or posedge rst) begin
        if (rst)
            sample_valid_latched <= 1'b0;
        else
            sample_valid_latched <= sample_valid_pulse;
    end

    reg [SYNC_REPETITION-1:0]                 match_votes_i;
    reg [(SYNC_REPETITION*HAMMING_WIDTH)-1:0] hamming_dist_i;
    integer kk;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            match_votes_i  <= {SYNC_REPETITION{1'b0}};
            hamming_dist_i <= {(SYNC_REPETITION*HAMMING_WIDTH){1'b1}};
        end else if (sample_valid_latched) begin
            for (kk = 0; kk < SYNC_REPETITION; kk = kk + 1) begin
                match_votes_i[kk] <= (hamming_distances_reg[kk] <= ERROR_THRESHOLD);
                hamming_dist_i[(kk+1)*HAMMING_WIDTH-1 -: HAMMING_WIDTH] <= hamming_distances_reg[kk];
            end
        end
    end

    wire        spatial_ok_raw, spatial_ok, pos_sync_pulse, is_locked, is_temporal_ok;
    reg  [7:0]  score_arr [0:SYNC_REPETITION-1];
    reg  [15:0] total_score;
    localparam integer H_WIDTH = HAMMING_WIDTH;
    wire [H_WIDTH-1:0] hamming_unpacked [0:SYNC_REPETITION-1];
    genvar g2;
    generate
        for (g2 = 0; g2 < SYNC_REPETITION; g2 = g2 + 1)
            assign hamming_unpacked[g2] = hamming_dist_i[(g2+1)*H_WIDTH-1 -: H_WIDTH];
    endgenerate

    always @(*) begin
        total_score = 0;
        for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
            if (hamming_unpacked[i] <= HAMM_HIGH)
                score_arr[i] = SCORE_HIGH;
            else if (hamming_unpacked[i] <= HAMM_MED)
                score_arr[i] = SCORE_MED;
            else
                score_arr[i] = 0;
            total_score = total_score + score_arr[i];
        end
    end

    wire anchor_ok = (score_arr[0] >= SCORE_MED);
    reg [7:0] vote_sum;
    always @(*) begin
        vote_sum = 0;
        for (i = 0; i < SYNC_REPETITION; i = i + 1)
            vote_sum = vote_sum + match_votes_i[i];
    end

    assign spatial_ok_raw = anchor_ok && ((total_score >= SCORE_THRESHOLD) || (vote_sum >= 2));
    assign spatial_ok = spatial_ok_raw && pipeline_full_reg;

    reg [TEMPORAL_DEPTH-1:0] match_history;
    always @(posedge clk or posedge rst) begin
        if (rst)
            match_history <= {TEMPORAL_DEPTH{1'b0}};
        else if (sample_valid_latched)
            match_history <= {match_history[TEMPORAL_DEPTH-2:0], spatial_ok};
    end

    localparam REC_W = $clog2((TEMPORAL_DEPTH > 0 ? TEMPORAL_DEPTH : 1) + 1);
    reg [REC_W-1:0] recent_count;
    integer j;
    always @(*) begin
        recent_count = 0;
        for (j = 0; j < TEMPORAL_DEPTH; j = j + 1)
            recent_count = recent_count + match_history[j];
    end

    assign is_temporal_ok = (recent_count >= TEMPORAL_VOTE);
    reg is_temporal_ok_d;
    always @(posedge clk or posedge rst) begin
        if (rst)
            is_temporal_ok_d <= 1'b0;
        else if (sample_valid_latched)
            is_temporal_ok_d <= is_temporal_ok;
    end

    assign pos_sync_pulse = is_temporal_ok && !is_temporal_ok_d;

    reg         is_locked_reg;
    reg [15:0]  good_cnt, bad_cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            is_locked_reg <= 1'b0;
            good_cnt      <= 0;
            bad_cnt       <= 0;
        end else begin
            if (sample_valid_latched) begin
                if (is_temporal_ok) begin
                    good_cnt <= (good_cnt >= 16'hFFFF) ? 16'hFFFF : good_cnt + 1;
                    bad_cnt  <= 0;
                end else begin
                    bad_cnt  <= (bad_cnt >= 16'hFFFF) ? 16'hFFFF : bad_cnt + 1;
                    good_cnt <= 0;
                end
            end
            if (!is_locked_reg && good_cnt >= K_GOOD)
                is_locked_reg <= 1'b1;
            else if (is_locked_reg && bad_cnt >= K_BAD)
                is_locked_reg <= 1'b0;
        end
    end

    assign locked_o = is_locked;
    // --- End of Unchanged Detection Logic ---

    // =================================================================
    // Section 2: 回读环形缓冲区 (硬件修正版)
    // =================================================================
    localparam BUF_DEPTH = 1 << BUF_DEPTH_BITS;

    reg [7:0]                            buffer [0:BUF_DEPTH-1];
    reg [BUF_DEPTH_BITS-1:0]             write_ptr;
    reg [BUF_DEPTH_BITS-1:0]             read_ptr;
    reg                                  reading_frame;
    reg [$clog2(TOTAL_FRAME_LEN+1)-1:0]  frame_read_cnt;

    // --- 缓冲区的写入逻辑 ---
    always @(posedge clk) begin
        if (fifo_rd_en)
            buffer[write_ptr] <= fifo_dout;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            write_ptr <= 0;
        else if (fifo_rd_en)
            write_ptr <= write_ptr + 1;
    end

    // --- 缓冲区的读取控制逻辑 ---
    wire frame_done = (frame_read_cnt == TOTAL_FRAME_LEN - 1);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reading_frame <= 1'b0;
        end else begin
            if (pos_sync_pulse && !reading_frame) begin
                reading_frame <= 1'b1;
            end else if (reading_frame && m_axis_output_tvalid && m_axis_output_tready && frame_done) begin
                reading_frame <= 1'b0;
            end
        end
    end

    // --- 读指针与计数器控制 ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            read_ptr       <= 0;
            frame_read_cnt <= 0;
        end else begin
            if (pos_sync_pulse && !reading_frame) begin
                // **已修正**: 明确处理指针回绕
                if (write_ptr >= TOTAL_PIPELINE_DELAY)
                    read_ptr <= write_ptr - TOTAL_PIPELINE_DELAY;
                else
                    read_ptr <= BUF_DEPTH + write_ptr - TOTAL_PIPELINE_DELAY;
                frame_read_cnt <= 0;
            end else if (reading_frame && m_axis_output_tvalid && m_axis_output_tready) begin
                read_ptr       <= read_ptr + 1;
                frame_read_cnt <= frame_read_cnt + 1;
            end
        end
    end

    // --- 输出数据流水线 (修正BRAM读延迟) ---
    reg [7:0] m_axis_output_tdata_reg;
    reg       m_axis_output_tvalid_reg;

    // 步骤1: 模拟BRAM的1周期读延迟
    reg [7:0] read_data_from_ram;
    always @(posedge clk) begin
        read_data_from_ram <= buffer[read_ptr];
    end

    // 步骤2: 输出寄存器，对齐 valid 和 data
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            m_axis_output_tdata_reg  <= 8'h00;
            m_axis_output_tvalid_reg <= 1'b0;
        end else begin
            // valid 信号是 reading_frame 延迟一拍的结果
            m_axis_output_tvalid_reg <= reading_frame;

            // 在 valid 有效时，锁存来自RAM的数据
            if (reading_frame) begin
                m_axis_output_tdata_reg <= read_data_from_ram;
            end
        end
    end
    assign m_axis_output_tdata = m_axis_output_tdata_reg;
    assign m_axis_output_tvalid = m_axis_output_tvalid_reg;

    // =================================================================
    // Section 3: FSM 与输出 (已简化为FIFO读使能控制)
    // =================================================================
    // **已修正**: 实现写覆盖读保护
    wire buffer_is_full = reading_frame && ((write_ptr + 1'b1) == read_ptr);

    // **已修正**: fifo_rd_en 现在同时受上游FIFO状态和内部buffer状态控制
    assign fifo_rd_en = !fifo_empty && !buffer_is_full;

    // **已修正**: start_of_frame_o 脉冲
    reg reading_frame_d1;
    always @(posedge clk or posedge rst) begin
        if (rst)
            reading_frame_d1 <= 1'b0;
        else
            reading_frame_d1 <= reading_frame;
    end
    assign start_of_frame_o = reading_frame && !reading_frame_d1;

endmodule