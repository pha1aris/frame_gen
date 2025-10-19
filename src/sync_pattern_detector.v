`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: sync_pattern_detector (启动时序修正版)
//
// **已修正**: 增加了一级内部流水线寄存器 (hamming_distances_reg, any_pop_valid_reg)，
//           以解决启动时采样到旧复位值的竞争问题，确保初始状态的正确性。
//////////////////////////////////////////////////////////////////////////////////
module sync_pattern_detector #(
    parameter [63:0] SYNC_MARKER      = 64'hB1699558A53333A8,
    parameter integer SYNC_REPETITION = 3,
    parameter integer HAMMING_WIDTH   = 8,
    parameter integer ERROR_THRESHOLD = 10
)(
    input  wire         clk,
    input  wire         rst,
    input  wire [7:0]   byte_in,
    input  wire         enable,

    output reg [SYNC_REPETITION-1:0]                match_votes_out,
    output reg [(SYNC_REPETITION*HAMMING_WIDTH)-1:0] packed_hamming_out
);
    // 内部参数定义
    localparam SYNC_BYTES        = 8;
    localparam SHIFT_REG_WIDTH   = SYNC_BYTES * SYNC_REPETITION * 8;
    
    // 1. 大型滑动窗口 (无需改动)
    reg [SHIFT_REG_WIDTH-1:0] shift_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) 
            shift_reg <= {SHIFT_REG_WIDTH{1'b0}};
        else if (enable) 
            shift_reg <= {shift_reg[SHIFT_REG_WIDTH-9:0], byte_in};
    end


        wire match_pulse;

         pipelined_sync_match #(
            .DATA_WIDTH(192)   // 必须是8的倍数
        )pipelined_sync_match(
            .clk   (clk),
            .rst_n (rst_n),

            // 输入
            .data_in(shift_reg),           // 192位数据窗口
            .pattern_in({SYNC_MARKER,SYNC_MARKER,SYNC_MARKER}),        // 192位同步字图样
            .mask_len('d0),          // 同步字有效长度(bit)
            .i_error_threshold(3), // 容错门限

            // 输出
            .o_match_pulse(match_pulse)      // 匹配脉冲(1clk)
        );


    // 2. 并行实例化 Hamming_calc 
    wire [6:0] hamming_distances [0:SYNC_REPETITION-1]; // 使用正确的7位位宽
    wire popcnt_valid_vec [0:SYNC_REPETITION-1];
    genvar gi;
    generate
        for (gi = 0; gi < SYNC_REPETITION; gi = gi + 1) begin : HD_CALC_INST
            wire [63:0] received_word = shift_reg[(gi+1)*SYNC_BYTES*8-1 -: 64];
            wire [63:0] diff = received_word ^ SYNC_MARKER;
            Hamming_calc u_hamming_calc (
                .clk(clk), .rst(rst),
                .data_i(diff), .data_valid_i(enable),
                .pop_count(hamming_distances[gi]),
                .pop_count_valid(popcnt_valid_vec[gi])
            );
        end
    endgenerate

    wire any_pop_valid = popcnt_valid_vec[0];
    
    // =======================================================
    //  内部流水线寄存器，用于解耦和安全采样
    // =======================================================
    reg [6:0] hamming_distances_reg [0:SYNC_REPETITION-1];
    reg       any_pop_valid_reg;
    integer   i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            any_pop_valid_reg <= 1'b0;
            for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
                hamming_distances_reg[i] <= 7'b1111111;
            end
        end else begin
            // 将来自 Hamming_calc 的结果和有效位寄存一拍
            any_pop_valid_reg <= any_pop_valid;
            if (any_pop_valid) begin
                for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
                    hamming_distances_reg[i] <= hamming_distances[i];
                end
            end
        end
    end

    // =======================================================
    // 3. 同步寄存输出 (已修正)
    // =======================================================
    integer kk;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            match_votes_out <= 0;
            packed_hamming_out <= {(SYNC_REPETITION*HAMMING_WIDTH-1){1'b1}};
        // **修正**: 使用延迟一拍后的有效位作为使能
        end else if (any_pop_valid_reg) begin 
            for (kk = 0; kk < SYNC_REPETITION; kk = kk + 1) begin
                match_votes_out[kk] <= (hamming_distances_reg[kk] <= ERROR_THRESHOLD);
                packed_hamming_out[(kk+1)*HAMMING_WIDTH-1 -: HAMMING_WIDTH] <= hamming_distances_reg[kk];
            end
        end
    end
    
endmodule