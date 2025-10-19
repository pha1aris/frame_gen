`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: Vote_Calculator
//
// Description:
//   一个参数化的投票计算器。
// 0 latency
//////////////////////////////////////////////////////////////////////////////////
module Vote_Calculator #(
    parameter SYNC_REPETITION = 8, // 投票的总路数
    parameter VOTE_THRESHOLD  = 2  // 判定通过需要的最少票数
)(
    input  wire [SYNC_REPETITION-1:0] match_votes_i, // 输入：各路检测器的投票结果
    output wire                       sync_match_o   // 输出：最终的同步判决结果
);

    localparam CNT_WIDTH = $clog2(SYNC_REPETITION+1);

    // -------- 层级加法树 (Hierarchical Adder Tree) --------
    // 每一层将相邻元素相加，直到只剩一个总和
    
    // 动态生成加法树所需的层数
    localparam LEVELS = $clog2(SYNC_REPETITION);
    
    // 存放每层加法结果的中间信号
    // 使用 reg 类型，因为我们将在 always @(*) 块中赋值
    reg [CNT_WIDTH-1:0] sum_levels [0:LEVELS][0:SYNC_REPETITION-1];

    integer level, i;

    // 组合逻辑块，用于构建整个加法树
    always @(*) begin
        // 第0层：直接使用输入投票值
        for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
            sum_levels[0][i] = match_votes_i[i];
        end
        // 对未使用的部分赋零，避免产生不必要的latch
        for (i = SYNC_REPETITION; i < (1 << LEVELS); i = i + 1) begin
             sum_levels[0][i] = 0;
        end


        // 逐层构建加法树
        for (level = 0; level < LEVELS; level = level + 1) begin
            for (i = 0; i < (SYNC_REPETITION >> level) ; i = i + 2) begin
                if (i+1 < (SYNC_REPETITION >> level)) begin
                    sum_levels[level+1][i/2] = sum_levels[level][i] + sum_levels[level][i+1];
                end else begin
                    sum_levels[level+1][i/2] = sum_levels[level][i];
                end
            end
        end
    end

    // 最终总和来自最后一层的第一个节点
    wire [CNT_WIDTH-1:0] total_votes = sum_levels[LEVELS][0];

    // 判决
    assign sync_match_o = (total_votes >= VOTE_THRESHOLD);

endmodule

