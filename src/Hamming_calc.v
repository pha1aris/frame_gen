`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/10
// Design Name: 
// Module Name: Hamming_calc
// Description: 64-bit 汉明权重计算器 (纯组合逻辑优化，时序风险高)
//
//////////////////////////////////////////////////////////////////////////////////

module Hamming_calc #(
    parameter DATA_WIDTH = 64
)(
    input                   clk,
    input                   rst,
    input  [63:0]           data_i,
    input                   data_valid_i,

    output reg [6:0]        pop_count,
    output reg              pop_count_valid
);

    //============================================================
    // Stage 1: 输入寄存
    //============================================================
    reg [63:0] data_d1;
    reg        data_valid_d1;
    reg         data_valid_d2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_d1       <= 0;
            data_valid_d1 <= 0;
        end else begin
            data_d1       <= data_i;
            data_valid_d1 <= data_valid_i;
        end
    end

    //============================================================
    // Stage 2: 并行 Popcount 和汇总加法 (纯组合逻辑)
    //============================================================
    wire [7:0] data_w [0:7];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            assign data_w[i] = data_d1[63 - i*8 : 56 - i*8];
        end
    endgenerate

    wire [3:0] byte_count [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin
            // **已修改**: 将 popcount8 函数替换为显式的纯组合逻辑加法器树
            // 这将确保 byte_count 和 data_w 严格同步，没有延迟
            wire [2:0] s1, s2;
            wire [1:0] s3, s4, s5, s6;
            assign s3 = data_w[i][0] + data_w[i][1];
            assign s4 = data_w[i][2] + data_w[i][3];
            assign s5 = data_w[i][4] + data_w[i][5];
            assign s6 = data_w[i][6] + data_w[i][7];
            assign s1 = s3 + s4;
            assign s2 = s5 + s6;
            assign byte_count[i] = s1 + s2;
        end
    endgenerate

    // 汇总加法
    wire [6:0] total_count = byte_count[0] + byte_count[1] + byte_count[2] + byte_count[3] +
                             byte_count[4] + byte_count[5] + byte_count[6] + byte_count[7];

    //============================================================
    // Stage 3: 输出寄存（仍然需要一级寄存来锁存巨大的组合逻辑结果）
    //============================================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pop_count       <= 0;
            pop_count_valid <= 0;
            data_valid_d2 <= 0;
        end else begin
            // 锁存整个巨大组合逻辑（popcount + total_count）的结果
            pop_count       <= total_count;
            data_valid_d2 <= data_valid_d1;
            // 同步锁存 valid 信号
            pop_count_valid <= data_valid_d1;

        end
    end

endmodule
