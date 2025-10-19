`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/10
// Design Name: 
// Module Name: Hamming_calc
// Description: 64-bit 汉明权重计算器（100MHz，2周期延迟）
// 
//////////////////////////////////////////////////////////////////////////////////

module Hamming_calc #(
    parameter DATA_WIDTH = 64
)(
    input           clk,
    input           rst,

    input  [63:0]   data_i,
    input           data_valid_i,

    output reg [6:0] pop_count,
    output reg       pop_count_valid
);

    //============================================================
    // 输入寄存器
    //============================================================
    reg [63:0] data_d;
    reg        data_valid_d;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_d       <= 0;
            data_valid_d <= 0;
        end else begin
            data_d       <= data_i;
            data_valid_d <= data_valid_i;
        end
    end

    //============================================================
    // 数据拆分为 8 个字节
    //============================================================
    wire [7:0] data_w [0:7];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            assign data_w[i] = data_d[63 - i*8 : 56 - i*8];
        end
    endgenerate

    //============================================================
    // 每字节 popcount 计算（8-bit 内部）
    //============================================================
    wire [3:0] byte_count [0:7];
    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin
            assign byte_count[j] = popcount8(data_w[j]);
        end
    endgenerate

    function [3:0] popcount8; // 计算8位中“1”的个数
        input [7:0] data;
        integer k;
        begin
            popcount8 = 0;
            for (k = 0; k < 8; k = k + 1)
                popcount8 = popcount8 + data[k];
        end
    endfunction

    //============================================================
    // 汇总加法 + 输出寄存
    //============================================================
    wire [6:0] total_count =
        byte_count[0] + byte_count[1] + byte_count[2] + byte_count[3] +
        byte_count[4] + byte_count[5] + byte_count[6] + byte_count[7];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pop_count       <= 0;
            pop_count_valid <= 0;
        end else begin
            pop_count       <= total_count;
            pop_count_valid <= data_valid_d; // 输出延迟 = 输入延迟 + 1 拍
        end
    end

endmodule
