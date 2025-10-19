`timescale 1ns / 1ps
// lock_detector.v
// (最终生产版)
//
// 功能: 工业级 L1-L3 锁定决策引擎。
// 职责: 接收预处理后的匹配信息，通过空间域(L1)、时间域(L2)、状态域(L3)
//       三层过滤，输出高可靠的锁定指令和状态。

module lock_detector #(
    parameter integer SYNC_REPETITION = 3,
    parameter integer HAMMING_WIDTH   = 8,
    // L1: 评分阈值
    parameter integer SCORE_HIGH      = 4,
    parameter integer SCORE_MED       = 2,
    parameter integer HAMM_HIGH       = 2,
    parameter integer HAMM_MED        = 5,
    parameter integer SCORE_THRESHOLD = 6,
    // L2: 时间域
    parameter integer TEMPORAL_DEPTH  = 3,
    parameter integer TEMPORAL_VOTE   = 2,
    // L3: 迟滞
    parameter integer K_GOOD          = 3,
    parameter integer K_BAD           = 4
) (
    input  wire                                       clk,
    input  wire                                       rst,
    input  wire [SYNC_REPETITION-1:0]                 match_votes_i,
    input  wire [(SYNC_REPETITION*HAMMING_WIDTH)-1:0]  hamming_dist_i,
    output reg                                        pos_sync_match_pulse,
    output reg                                        locked,
    output reg                                        temporal_ok
);

    // -------------------------------------------------------------------------
    // 解包汉明距离
    // -------------------------------------------------------------------------
    localparam integer H_WIDTH = HAMMING_WIDTH;
    genvar g;
    wire [H_WIDTH-1:0] hamming [0:SYNC_REPETITION-1];
    generate
        for (g = 0; g < SYNC_REPETITION; g = g + 1) begin : UNPACK
            assign hamming[g] = hamming_dist_i[(g+1)*H_WIDTH-1 -: H_WIDTH];
        end
    endgenerate

    // -------------------------------------------------------------------------
    // L1: 每个切片的得分 (组合逻辑)
    // -------------------------------------------------------------------------
    integer i;
    reg [7:0] score_arr [0:SYNC_REPETITION-1];
    reg [15:0] total_score;
    always @(*) begin
        total_score = 0;
        for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
            if (hamming[i] <= HAMM_HIGH) score_arr[i] = SCORE_HIGH;
            else if (hamming[i] <= HAMM_MED) score_arr[i] = SCORE_MED;
            else score_arr[i] = 0;
            total_score = total_score + score_arr[i];
        end
    end

    wire anchor_ok = (score_arr[0] >= SCORE_MED);
    wire [3:0] vote_sum;
    generate
        if (SYNC_REPETITION == 1) assign vote_sum = match_votes_i[0];
        else if (SYNC_REPETITION == 2) assign vote_sum = match_votes_i[0] + match_votes_i[1];
        else begin
            reg [3:0] tmp_sum;
            always @(*) begin
                tmp_sum = 0;
                for (i = 0; i < SYNC_REPETITION; i = i + 1) tmp_sum = tmp_sum + match_votes_i[i];
            end
            assign vote_sum = tmp_sum;
        end
    endgenerate
    
    wire spatial_ok = anchor_ok && ((total_score >= SCORE_THRESHOLD) || (vote_sum >= 2));

    // -------------------------------------------------------------------------
    // L2: 时间域投票 (spatial_ok 的历史记录)
    // -------------------------------------------------------------------------
    reg [TEMPORAL_DEPTH-1:0] match_history;
    integer j;
    always @(posedge clk or posedge rst) begin
        if (rst) match_history <= {TEMPORAL_DEPTH{1'b0}};
        else match_history <= {match_history[TEMPORAL_DEPTH-2:0], spatial_ok};
    end

    reg [7:0] recent_count;
    always @(*) begin
        recent_count = 0;
        for (j = 0; j < TEMPORAL_DEPTH; j = j + 1) recent_count = recent_count + match_history[j];
        temporal_ok = (recent_count >= TEMPORAL_VOTE);
    end

    reg temporal_ok_d;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temporal_ok_d <= 1'b0;
            pos_sync_match_pulse <= 1'b0;
        end else begin
            pos_sync_match_pulse <= (temporal_ok && ~temporal_ok_d);
            temporal_ok_d <= temporal_ok;
        end
    end

    // -------------------------------------------------------------------------
    // L3: 迟滞锁定状态
    // -------------------------------------------------------------------------
    reg [15:0] good_cnt;
    reg [15:0] bad_cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            locked <= 1'b0;
            good_cnt <= 0;
            bad_cnt  <= 0;
        end else begin
            if (temporal_ok) begin
                good_cnt <= (good_cnt >= 16'hFFFF) ? 16'hFFFF : good_cnt + 1;
                bad_cnt  <= 0;
            end else begin
                bad_cnt <= (bad_cnt >= 16'hFFFF) ? 16'hFFFF : bad_cnt + 1;
                good_cnt <= 0;
            end

            if (!locked && good_cnt >= K_GOOD) locked <= 1'b1;
            else if (locked && bad_cnt >= K_BAD) locked <= 1'b0;
        end
    end

endmodule