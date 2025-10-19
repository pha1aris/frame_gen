`timescale 1ns / 1ps
// lock_detector.v (修正版 - 增加 spatial_ok_out 接口，修复若干综合/仿真问题)

module lock_detector #(
    parameter integer SYNC_REPETITION = 3,
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
) (
    input  wire                                       clk,
    input  wire                                       rst,
    input  wire [SYNC_REPETITION-1:0]                 match_votes_i,
    input  wire [(SYNC_REPETITION*HAMMING_WIDTH)-1:0] hamming_dist_i,
    output reg                                        pos_sync_match_pulse,
    output reg                                        locked,
    output reg                                        temporal_ok,
    output wire                                       spatial_ok_out
);

    // Unpack hamming distances
    localparam integer H_WIDTH = HAMMING_WIDTH;
    genvar g;
    wire [H_WIDTH-1:0] hamming [0:SYNC_REPETITION-1];
    generate
        for (g = 0; g < SYNC_REPETITION; g = g + 1) begin : UNPACK
            // assign hamming[g] = hamming_dist_i[(g+1)*H_WIDTH-1 -: H_WIDTH];
            assign hamming[g] = hamming_dist_i[(SYNC_REPETITION-g)*H_WIDTH-1 -: H_WIDTH];
        end
    endgenerate

    // Score each slice and compute total score (combinational)
    integer i;
    reg [7:0] score_arr [0:SYNC_REPETITION-1];
    reg [31:0] total_score; // 宽一点以防溢出
    always @(*) begin
        total_score = 0;
        for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
            if (hamming[i] <= HAMM_HIGH)       score_arr[i] = SCORE_HIGH;
            else if (hamming[i] <= HAMM_MED)   score_arr[i] = SCORE_MED;
            else                               score_arr[i] = 0;
            total_score = total_score + score_arr[i];
        end
    end

    // Anchor condition
    // wire anchor_ok = (score_arr[0] >= SCORE_MED);
wire anchor_ok = (score_arr[SYNC_REPETITION-1] >= SCORE_MED);

    // Sum votes robustly (combinational)
    // 宽度设为 8 位，通常足够；若 SYNC_REPETITION 很大请增宽或用 $clog2
    reg [7:0] vote_sum;
    integer k;
    always @(*) begin
        vote_sum = 0;
        for (k = 0; k < SYNC_REPETITION; k = k + 1) vote_sum = vote_sum + match_votes_i[k];
    end

    // L1 decision
    wire spatial_ok = anchor_ok && ((total_score >= SCORE_THRESHOLD) || (vote_sum >= 2));
    assign spatial_ok_out = spatial_ok;

    // L2: temporal history (shifting) - 使用移位 + OR 的通用写法，避免索引越界
    reg [TEMPORAL_DEPTH-1:0] match_history;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            match_history <= {TEMPORAL_DEPTH{1'b0}};
        end else begin
            // 将历史左移一位并把最新 spatial_ok 写入最低位
            // 该写法对 TEMPORAL_DEPTH == 1 也安全
            match_history <= (match_history << 1) | {{(TEMPORAL_DEPTH-1){1'b0}}, spatial_ok};
        end
    end

    // count recent successes (combinational)
    reg [7:0] recent_count;
    integer j;
    always @(*) begin
        recent_count = 0;
        for (j = 0; j < TEMPORAL_DEPTH; j = j + 1) recent_count = recent_count + match_history[j];
        temporal_ok = (recent_count >= TEMPORAL_VOTE);
    end

    // edge detect temporal_ok -> pos_sync_match_pulse
    reg temporal_ok_d;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temporal_ok_d <= 1'b0;
            pos_sync_match_pulse <= 1'b0;
        end else begin
            pos_sync_match_pulse <= (temporal_ok && !temporal_ok_d);
            temporal_ok_d <= temporal_ok;
        end
    end

    // L3 hysteresis lock
    reg [31:0] good_cnt;
    reg [31:0] bad_cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            locked   <= 1'b0;
            good_cnt <= 0;
            bad_cnt  <= 0;
        end else begin
            if (temporal_ok) begin
                good_cnt <= (good_cnt >= 32'hFFFFFFFF) ? 32'hFFFFFFFF : good_cnt + 1;
                bad_cnt  <= 0;
            end else begin
                bad_cnt  <= (bad_cnt  >= 32'hFFFFFFFF) ? 32'hFFFFFFFF : bad_cnt + 1;
                good_cnt <= 0;
            end

            if (!locked && good_cnt >= K_GOOD)
                locked <= 1'b1;
            else if (locked && bad_cnt >= K_BAD)
                locked <= 1'b0;
        end
    end


    // 在 posedge clk 的时序块里加一个条件打印（只在非复位时）
    always @(posedge clk) begin
        if (!rst) begin
            // 每次 spatial_ok 计算后打印一次（或者根据需要加条件）
            $display("%0t ns: h0=0x%0h h1=0x%0h h2=0x%0h | score0=%0d score1=%0d score2=%0d | total=%0d vote_sum=%0d anchor=%b spatial_ok=%b temporal_ok=%b locked=%b",
                     $time, hamming[0], hamming[1], hamming[2],
                     score_arr[0], score_arr[1], score_arr[2],
                     total_score, vote_sum, anchor_ok, spatial_ok, temporal_ok, locked);
        end
    end


endmodule
