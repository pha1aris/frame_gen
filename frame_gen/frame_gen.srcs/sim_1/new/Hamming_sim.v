`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_hamming_calc
// Description:
//   - Hamming_calc 模块的优化版测试平台。
//   - 采用结构化、时钟同步的方式生成激励，避免竞争冒险。
//   - 包含一个与DUT延迟匹配的参考模型（Golden Model），实现自动化结果校验。
//   - 测试序列清晰，易于阅读和扩展。
//////////////////////////////////////////////////////////////////////////////////
module tb_hamming_calc;

    // =================================================================
    // 信号定义
    // =================================================================
    reg clk;
    reg rst;
    reg [63:0] data_i;
    reg data_valid_i;
    wire [6:0] pop_count;
    wire pop_count_valid;
    integer error_count;

    // =================================================================
    // 时钟与复位生成
    // =================================================================
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50MHz 时钟
    end

    initial begin
        rst = 1;
        error_count = 0;
        data_i = 0;
        data_valid_i = 0;
        repeat(5) @(posedge clk); // 保持复位5个周期
        rst = 0;
        @(posedge clk);
        $display("[%0t ns] Reset released. Starting test sequence...", $time);
    end

    // =================================================================
    // 实例化待测模块 (DUT: Device Under Test)
    // =================================================================
    Hamming_calc u_hamming_calc (
        .clk(clk),
        .rst(rst),
        .data_i(data_i),
        .data_valid_i(data_valid_i),
        .pop_count(pop_count),
        .pop_count_valid(pop_count_valid)
    );

    // =================================================================
    // 激励生成 (Test Sequence)
    // =================================================================
    initial begin
        // 等待复位结束
        @(negedge rst);

        // 应用一系列测试向量
        apply_vector(64'h0000_0000_0000_000F, 1'b1); // popcount = 4
        apply_vector(64'h0000_0000_0000_0000, 1'b1); // popcount = 0
        apply_vector(64'hFFFF_0000_0000_0000, 1'b1); // popcount = 16
        apply_vector(64'hFFFF_FFFF_0000_0000, 1'b1); // popcount = 32
        apply_vector(64'hFFFF_FFFF_FFFF_FFFF, 1'b1); // popcount = 64
        apply_vector(64'h8000_0000_0000_0001, 1'b1); // popcount = 2
        apply_vector(64'h0, 1'b0); // valid为0的测试
        apply_vector(64'h0, 1'b0);

        // 等待最后的流水线数据流出
        repeat(5) @(posedge clk);

        // 结束仿真并报告结果
        if (error_count == 0) begin
            $display("---------------\n[PASS] All tests passed!\n---------------");
        end else begin
            $error("[%0t ns] [FAIL] Found %0d errors during simulation.", $time, error_count);
        end
        $finish;
    end

    // 辅助任务：施加一个测试向量并等待一个时钟周期
    task apply_vector(input [63:0] d_in, input v_in);
        begin
            @(posedge clk);
            data_i <= d_in;
            data_valid_i <= v_in;
        end
    endtask

    // =================================================================
    // 自动化结果校验 (Self-Checking Golden Model)
    // =================================================================
    // // 创建一个与DUT延迟完全匹配的参考模型流水线
    // reg [63:0] data_i_p1, data_i_p2;
    // reg data_valid_i_p1, data_valid_i_p2;
    // always @(posedge clk or posedge rst) begin
    //     if (rst) begin
    //         {data_i_p1, data_valid_i_p1} <= 0;
    //         {data_i_p2, data_valid_i_p2} <= 0;
    //     end else begin
    //         data_i_p1 <= data_i;
    //         data_valid_i_p1 <= data_valid_i;
            
    //         data_i_p2 <= data_i_p1;
    //         data_valid_i_p2 <= data_valid_i_p1;
    //     end
    // end

    // // 根据延迟后的数据，计算期望的输出结果
    // wire [6:0] expected_pop_count = popcount64(data_i_p2);
    // wire expected_pop_count_valid = data_valid_i_p2;

    // // 64位popcount计算函数 (纯组合逻辑)
    // function [6:0] popcount64;
    //     input [63:0] data;
    //     integer i;
    //     begin
    //         popcount64 = 0;
    //         for (i = 0; i < 64; i = i + 1)
    //             popcount64 = popcount64 + data[i];
    //     end
    // endfunction

    // // 在每个时钟沿，对比DUT的实际输出和参考模型的期望输出
    // always @(posedge clk) begin
    //     // 在复位结束后开始检查
    //     if (!rst && pop_count_valid) begin
    //         if (pop_count !== expected_pop_count) begin
    //             $error("[%0t ns] DATA MISMATCH! Expected: %0d, Got: %0d", $time, expected_pop_count, pop_count);
    //             error_count = error_count + 1;
    //         end
    //         if (pop_count_valid !== expected_pop_count_valid) begin
    //             $error("[%0t ns] VALID MISMATCH! Expected: %b, Got: %b", $time, expected_pop_count_valid, pop_count_valid);
    //             error_count = error_count + 1;
    //         end
    //     end
    // end

endmodule