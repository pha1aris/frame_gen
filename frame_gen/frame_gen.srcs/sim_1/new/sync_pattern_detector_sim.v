`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/11 21:25:59
// Design Name: 
// Module Name: sync_pattern_detector_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sync_pattern_detector_sim();
   // =================================================================
    // 参数定义 (与DUT保持一致)
    // =================================================================
    localparam [63:0] SYNC_MARKER      = 64'hB1699558A53333A8;
    localparam integer SYNC_REPETITION = 3;
    localparam integer HAMMING_WIDTH   = 8;
    localparam integer ERROR_THRESHOLD = 10;
    
    // =================================================================
    // 信号定义
    // =================================================================
    reg clk;
    reg rst;
    reg [7:0] byte_in;
    reg enable;

    wire [SYNC_REPETITION-1:0]                match_votes_out;
    wire [(SYNC_REPETITION*HAMMING_WIDTH)-1:0] packed_hamming_out;

    // =================================================================
    // 实例化待测模块 (DUT)
    // =================================================================
    sync_pattern_detector #(
        .SYNC_MARKER      (SYNC_MARKER),
        .SYNC_REPETITION  (SYNC_REPETITION),
        .HAMMING_WIDTH    (HAMMING_WIDTH),
        .ERROR_THRESHOLD  (ERROR_THRESHOLD)
    ) u_dut (
        .clk                (clk),
        .rst                (rst),
        .byte_in            (byte_in),
        .enable             (enable),
        .match_votes_out    (match_votes_out),
        .packed_hamming_out (packed_hamming_out)
    );

    // =================================================================
    // 时钟和复位生成
    // =================================================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz 时钟
    end

    initial begin
        rst = 1;
        enable = 0;
        byte_in = 8'h00;
        repeat(5) @(posedge clk);
        rst = 0;
        $display("[%0t ns] 复位结束，开始发送数据...", $time);
    end

    // =================================================================
    // 激励生成
    // =================================================================
        integer i, j;
    initial begin

        
        // 等待复位结束
        @(negedge rst);
        
        // --- 1. 发送一些垃圾数据 ---
        $display("[%0t ns] 发送垃圾数据...", $time);
        drive_byte(8'hAA);
        drive_byte(8'hBB);
        drive_byte(8'hCC);
        
        // --- 2. 发送完整的同步序列 (重复3次SYNC_MARKER) ---
        $display("[%0t ns] 发送同步序列...", $time);
        for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                // 从高位到低位逐字节发送 SYNC_MARKER
                drive_byte( (SYNC_MARKER >> (8 * (7-j))) & 8'hFF );
            end
        end
        
        // --- 3. 发送一些模拟的载荷数据 ---
        $display("[%0t ns] 发送载荷数据...", $time);
        for (i = 0; i < 16; i = i + 1) begin
            drive_byte(i[7:0]);
        end
        
        // 停止激励
        @(posedge clk);
        enable <= 1'b0;

        // 等待流水线流出
        repeat(10) @(posedge clk);
        $display("[%0t ns] 仿真结束。", $time);
        $finish;
    end
    
    // 辅助任务：驱动一个字节的数据
    task drive_byte(input [7:0] data);
        begin
            @(posedge clk);
            #1; // 增加微小延迟，确保在时钟沿之后驱动，避免竞争冒险
            byte_in = data;
            enable = 1'b1;
        end
    endtask

    // VCD波形文件生成
    // initial begin
    //     $dumpfile("sync_pattern_detector_sim.vcd");
    //     $dumpvars(0, tb_sync_pattern_detector);
    // end

endmodule
