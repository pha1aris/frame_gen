`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: sync_pattern_detector
//
// 目标: 数据采集与预处理前端。
// 职责: 维护一个大型滑动窗口，并行调用Hamming_calc计算多个数据切片的汉明距离，
//       并在计算结果有效时，同步地寄存并输出这些结果。
//////////////////////////////////////////////////////////////////////////////////
module sync_pattern_detector #(
    parameter [63:0] SYNC_MARKER      = 64'hB1699558A53333A8,
    parameter integer SYNC_REPETITION = 3,
    parameter integer HAMMING_WIDTH   = 8,
    parameter integer ERROR_THRESHOLD = 10
)(
    input  wire         clk,
    input  wire         rst,
    input  wire [7:0]   byte_in,      // 从FIFO来的数据
    input  wire         enable,       // 使能信号，等同于 fifo_rd_en

    output reg [SYNC_REPETITION-1:0]                match_votes_out,
    output reg [(SYNC_REPETITION*HAMMING_WIDTH)-1:0] packed_hamming_out
);
    // 内部参数定义
    localparam SYNC_BYTES        = 8;
    localparam SHIFT_REG_WIDTH   = SYNC_BYTES * SYNC_REPETITION * 8;
    
    // 1. 大型滑动窗口 (Shift Register)
    reg [SHIFT_REG_WIDTH-1:0] shift_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) shift_reg <= {SHIFT_REG_WIDTH{1'b0}};
        else if (enable) shift_reg <= {shift_reg[SHIFT_REG_WIDTH-9:0], byte_in};
    end

    // 2. 并行实例化 Hamming_calc，进行汉明距离计算
    wire [HAMMING_WIDTH-1:0] hamming_distances [0:SYNC_REPETITION-1];
    wire popcnt_valid_vec [0:SYNC_REPETITION-1];
    genvar gi;
    generate
        for (gi = 0; gi < SYNC_REPETITION; gi = gi + 1) begin : HD_CALC_INST
            wire [63:0] received_word = shift_reg[(gi+1)*SYNC_BYTES*8-1 -: 64];
            wire [63:0] diff = received_word ^ SYNC_MARKER;
            
            // 实例化我们上一步完成的 Hamming_calc 模块
            Hamming_calc u_hamming_calc (
                .clk(clk), .rst(rst),
                .data_i(diff), .data_valid_i(enable),
                .pop_count(hamming_distances[gi]),
                .pop_count_valid(popcnt_valid_vec[gi])
            );
        end
    endgenerate

    // 假设所有 Hamming_calc 实例同步有效，取第一个作为代表
    wire any_pop_valid = popcnt_valid_vec[0];
    
    // 3. 同步寄存输出
    // 在 Hamming_calc 计算结果有效时，锁存结果到输出寄存器
    integer kk;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            match_votes_out <= 0;
            packed_hamming_out <= 0;
        end else if (any_pop_valid) begin // 使用来自Hamming_calc的valid信号作为使能
            for (kk = 0; kk < SYNC_REPETITION; kk = kk + 1) begin
                // 生成简单的布尔投票向量
                match_votes_out[kk] <= (hamming_distances[kk] <= ERROR_THRESHOLD);
                // 将并行的汉明距离打包成一个宽向量
                packed_hamming_out[(kk+1)*HAMMING_WIDTH-1 -: HAMMING_WIDTH] <= hamming_distances[kk];
            end
        end
    end
    
endmodule