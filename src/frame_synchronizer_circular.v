`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: frame_synchronizer (V8 - 模块化集成版)
//
// 描述:
//   - **已集成**: 将硬件修正后的 circular_buffer 作为一个独立的子模块进行例化。
//   - 顶层模块负责产生控制信号(pos_sync_pulse)，子模块负责缓冲与回读输出。
//   - 这是一个结构清晰、易于维护的模块化设计。
//
//////////////////////////////////////////////////////////////////////////////////
module frame_synchronizer_circular #(
    // ================== 集中管理所有可调参数 ==================
    parameter [63:0] SYNC_MARKER       = 64'hB1699558A53333A8,
    parameter integer  SYNC_REPETITION = 3,
    parameter integer  PAYLOAD_LEN     = 64,
    parameter integer  PACKAGE_LEN = SYNC_REPETITION * 64 + PAYLOAD_LEN,
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
    // AXI-Stream 输出 (来自回读缓冲区)
    output wire [7:0]   m_axis_output_tdata,
    output wire         m_axis_output_tvalid,
    input  wire         m_axis_output_tready,
    // 状态输出
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
    // Section 1: 数据采集与预处理
    // =================================================================
    wire        fifo_rd_en;
    wire        fifo_empty;
    wire        fifo_full;
    wire [7:0]  fifo_dout;

    assign s_axis_input_tready = !fifo_full;

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
    reg shift_work;
    always @(posedge clk or posedge rst) begin
        if (rst)begin
            shift_reg <= {SHIFT_REG_WIDTH{1'b0}};
            shift_work <= 1'b0;
        end else if (fifo_rd_en)begin
            shift_reg <= {shift_reg[SHIFT_REG_WIDTH-9:0], fifo_dout};
            shift_work <= 1'b1;
        end
    end

    // =================================================================
    // Section 1.5: 流水线“预热”逻辑
    // =================================================================
    reg pipeline_full_reg;
    reg [$clog2(TOTAL_SYNC_BYTES)-1:0] startup_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pipeline_full_reg <= 1'b0;
            startup_cnt       <= 0;
        end else if (!pipeline_full_reg && fifo_rd_en) begin
            if (startup_cnt == TOTAL_SYNC_BYTES - 1) begin
                pipeline_full_reg <= 1'b1;
            end else begin
                startup_cnt <= startup_cnt + 1;
            end
        end
    end

        wire match_pulse;

         pipelined_sync_match #(
            .DATA_WIDTH(192)   // 必须是8的倍数
        )pipelined_sync_match(
            .clk   (clk),
            .rst_n (!rst),
        // 输入
            .data_in(shift_reg),           // 192位数据窗口
            .pattern_in({SYNC_MARKER,SYNC_MARKER,SYNC_MARKER}),        // 192位同步字图样
            .mask_len(192),          // 同步字有效长度(bit)
            .i_error_threshold(3), // 容错门限
            .data_valid (shift_work),        // 输入数据有效信号
            // 输出
            .o_match_pulse(match_pulse)      // 匹配脉冲(1clk)
        );

    // =================================================================
    // Section 1.6: 汉明距离计算 
    // =================================================================

    wire [6:0] hamming_distances [0:SYNC_REPETITION-1];
    wire       popcnt_valid_vec [0:SYNC_REPETITION-1];
    genvar     gi;

    generate
        for (gi = 0; gi < SYNC_REPETITION; gi = gi + 1) begin : HD_CALC_INST
            wire [63:0] received_word = shift_reg[(gi+1)*SYNC_BYTES*8-1 -: 64];
            Hamming_calc u_hamming_calc (
                .clk            (clk),
                .rst            (rst),
                .data_i         (received_word ^ SYNC_MARKER),
                .data_valid_i   (fifo_rd_en),
                .pop_count      (hamming_distances[gi]),
                .pop_count_valid(popcnt_valid_vec[gi])
            );
        end
    endgenerate


    reg any_pop_valid_comb;
    integer pvi;
    always @(*) begin
        any_pop_valid_comb = 1'b0;
        for (pvi = 0; pvi < SYNC_REPETITION; pvi = pvi + 1)
            any_pop_valid_comb = any_pop_valid_comb | popcnt_valid_vec[pvi];
    end

    wire any_pop_valid = any_pop_valid_comb;

    reg [6:0]  hamming_distances_reg [0:SYNC_REPETITION-1];
    reg        any_pop_valid_reg;
    integer    i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            any_pop_valid_reg <= 1'b0;
            for (i = 0; i < SYNC_REPETITION; i = i + 1)
                hamming_distances_reg[i] <= 7'h7F;
        end else begin
            any_pop_valid_reg <= any_pop_valid;
            if (any_pop_valid) begin
                for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
                    hamming_distances_reg[i] <= hamming_distances[i];
                end
            end
        end
    end
    // 汉明举例输出 上升沿
    wire sample_valid_pulse = any_pop_valid && !any_pop_valid_reg;

    reg [SYNC_REPETITION-1:0]              match_votes_i;
    reg [(SYNC_REPETITION*HAMMING_WIDTH)-1:0] hamming_dist_i;
    integer                                  kk;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            match_votes_i  <= {SYNC_REPETITION{1'b0}};
            hamming_dist_i <= {(SYNC_REPETITION*HAMMING_WIDTH){1'b1}};
        end else begin
            for (kk = 0; kk < SYNC_REPETITION; kk = kk + 1) begin
                match_votes_i[kk] <= (hamming_distances_reg[kk] <= ERROR_THRESHOLD);
                hamming_dist_i[(kk+1)*HAMMING_WIDTH-1 -: HAMMING_WIDTH] <= hamming_distances_reg[kk];
            end
        end
    end

    // =================================================================
    // Section 2: L1-L3 锁定决策逻辑 
    // =================================================================
    wire        spatial_ok_raw;
    wire        spatial_ok;
    wire        pos_sync_pulse;
    wire        is_locked;
    wire        is_temporal_ok;

    // --- L1: 空间域判决 ---
    reg [7:0]   score_arr [0:SYNC_REPETITION-1];
    reg [15:0]  total_score;
    reg [7:0] vote_sum;
    localparam  integer H_WIDTH = HAMMING_WIDTH;
    wire [H_WIDTH-1:0] hamming_unpacked [0:SYNC_REPETITION-1];
    genvar      g2;
    generate //将三个汉明距离分开
        for (g2 = 0; g2 < SYNC_REPETITION; g2 = g2 + 1) begin : UNPACK2
            assign hamming_unpacked[g2] = hamming_dist_i[(g2+1)*H_WIDTH-1 -: H_WIDTH];
        end
    endgenerate

    always @(*) begin
        total_score = 0;
        for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
            if (hamming_unpacked[i] <= HAMM_HIGH)
                score_arr[SYNC_REPETITION-1-i] = SCORE_HIGH;
            else if (hamming_unpacked[i] <= HAMM_MED)
                score_arr[SYNC_REPETITION-1-i] = SCORE_MED;
            else
                score_arr[SYNC_REPETITION-1-i] = 0;

            total_score = total_score + score_arr[SYNC_REPETITION-1-i];
        end
    end 

    wire anchor_ok;

    always @(*) begin
        vote_sum = 0;
            for (i = 0; i < SYNC_REPETITION; i = i + 1)
                vote_sum = vote_sum + match_votes_i[i];
    end

    reg anchor_ok_d, total_score_ok_d, vote_sum_ok_d;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            anchor_ok_d       <= 1'b0;
            total_score_ok_d  <= 1'b0;
            vote_sum_ok_d     <= 1'b0;
        end else begin
            anchor_ok_d       <= (score_arr[1] >= SCORE_MED);
            total_score_ok_d  <= (total_score >= SCORE_THRESHOLD);
            vote_sum_ok_d     <= (vote_sum >= 2);
        end
    end

    assign anchor_ok = (score_arr[0] >= SCORE_MED); //锚点认证
    // assign spatial_ok_raw = anchor_ok_r && ((total_score_r0 >= SCORE_THRESHOLD) || (vote_sum >= 2));
    // assign spatial_ok_raw = ((total_score_r0 >= SCORE_THRESHOLD) || (vote_sum >= 2));
    assign spatial_ok_raw = anchor_ok_d && total_score_ok_d && vote_sum_ok_d;
    assign spatial_ok = total_score_ok_d && anchor_ok_d && vote_sum_ok_d;
    // assign spatial_ok = spatial_ok_raw;

    // --- L2: 时间域投票 ---
    reg [TEMPORAL_DEPTH-1:0] match_history;
    // always @(posedge clk or posedge rst) begin
    //     if (rst) begin
    //         match_history <= {TEMPORAL_DEPTH{1'b0}};
    //     end else begin  //将spatial_ok移位进match_history
    //         match_history <= {match_history[TEMPORAL_DEPTH-2:0], spatial_ok_raw};
    //     end
    // end

//三个同步头64*3 = 192 clk
reg [7:0] header_cnt;
reg spatial_ok_raw_d0,spatial_ok_raw_d1;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        header_cnt <= 0;
    end else begin
        header_cnt <= header_cnt + 1;
    end
end


    // always @(posedge clk or posedge rst) begin
    //     if (rst) begin
    //         match_history <= {TEMPORAL_DEPTH{1'b0}};
    //     end else if (spatial_ok_raw) begin
    //         match_history <= {match_history[TEMPORAL_DEPTH-2:0], 1'b1};
    //     end
    // end

// reg [TEMPORAL_DEPTH-1:0] match_history;
reg [15:0] no_match_cnt;   // 计时：多久未检测到spatial_ok_raw

localparam integer TIMEOUT_CYCLES = 20; // 超过此时间未匹配则清零

always @(posedge clk or posedge rst) begin
    if (rst) begin
        match_history <= 0;
        no_match_cnt  <= 0;
    end else begin
        if (spatial_ok_raw) begin
            // 只在检测到新匹配脉冲时移位更新
            match_history <= {match_history[TEMPORAL_DEPTH-2:0], 1'b1};
            no_match_cnt  <= 0;  // 重置无匹配计数器
        end else begin
            no_match_cnt <= no_match_cnt + 1;
            // 若长时间没有新的匹配，则清空历史（防止上一帧影响）
            if (no_match_cnt >= TIMEOUT_CYCLES)
                match_history <= {TEMPORAL_DEPTH{1'b0}};
        end
    end
end


    localparam      REC_W = $clog2((TEMPORAL_DEPTH > 0 ? TEMPORAL_DEPTH : 1) + 1);
    reg [REC_W-1:0] recent_count;
    integer         j;
    always @(*) begin
        recent_count = 0;
        for (j = 0; j < TEMPORAL_DEPTH; j = j + 1) //求match_history中1数量
            recent_count = recent_count + match_history[j];
    end

    assign is_temporal_ok = (recent_count >= TEMPORAL_VOTE); //spatial_ok 拉高次数达到阈值


    reg [$clog2(TEMPORAL_DEPTH+1)-1:0] match_count;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            match_count <= 0;
        end else begin
            // 如果拉高就加一
            if (spatial_ok_raw)
                match_count <= match_count + 1;
            // 可以在某个窗口周期后衰减
            else if (match_count > 2)
                match_count <= 0;
        end
    end

// assign is_temporal_ok = (match_count >= TEMPORAL_THRESHOLD);


    reg is_temporal_ok_d;
    always @(posedge clk or posedge rst) begin
        if (rst)
            is_temporal_ok_d <= 1'b0;
        else 
            is_temporal_ok_d <= is_temporal_ok;
    end
    assign pos_sync_pulse = is_temporal_ok && !is_temporal_ok_d;


    assign locked_o = is_temporal_ok;

    // =================================================================
    // Section 2: 回读缓冲区例化与控制
    // =================================================================
    // (此处省略了对 buffer full 的处理，简化设计，假设BUF_DEPTH足够大)
    assign fifo_rd_en = !fifo_empty;

    circular_buffer #(
        .BUF_DEPTH(1 << BUF_DEPTH_BITS),
        .DELAY_TO_SYNC(6),
        .FRAME_LEN(PAYLOAD_LEN)
    ) u_circular_buffer (
        .clk              (clk),
        .rst              (rst),
        .fifo_dout        (fifo_dout),
        .fifo_rd_en       (fifo_rd_en),
        .pos_sync_pulse   (pos_sync_pulse),
        .frame_data_out   (m_axis_output_tdata),
        .frame_data_valid (m_axis_output_tvalid)
    );

    // =================================================================
    // Section 3: 状态输出
    // =================================================================
    // start_of_frame_o 脉冲: 在开始读取一帧的第一个周期拉高
    reg pos_sync_pulse_d1;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            pos_sync_pulse_d1 <= 1'b0;
        else
            pos_sync_pulse_d1 <= pos_sync_pulse;
    end

    assign start_of_frame_o = pos_sync_pulse && !pos_sync_pulse_d1;

endmodule