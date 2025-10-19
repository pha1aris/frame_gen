`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: tb_lock_detector
//
// 描述:
//   - lock_detector 最终生产版模块的功能验证测试平台。
//   - **已更新**: 移除了对 _dbg 调试端口的连接和监控。
//   - 核心测试序列与场景保持不变。
//////////////////////////////////////////////////////////////////////////////////
module tb_lock_detector;

       // =================================================================
    // 参数定义 (集中管理所有参数)
    // =================================================================
    localparam [63:0] SYNC_MARKER      = 64'hB1699558A53333A8;
    localparam integer SYNC_REPETITION = 3;
    localparam integer HAMMING_WIDTH   = 8;
    localparam integer ERROR_THRESHOLD = 10;
    localparam integer SCORE_HIGH      = 4;
    localparam integer SCORE_MED       = 2;
    localparam integer HAMM_HIGH       = 2;
    localparam integer HAMM_MED        = 5;
    localparam integer SCORE_THRESHOLD = 6;
    localparam integer TEMPORAL_DEPTH  = 3;
    localparam integer TEMPORAL_VOTE   = 2;
    localparam integer K_GOOD          = 3;
    localparam integer K_BAD           = 4;
    
    // =================================================================
    // 信号定义
    // =================================================================
    reg clk;
    reg rst;
    reg [7:0] byte_in;
    reg enable;

    // 连接两个模块的内部信号线
    wire [SYNC_REPETITION-1:0]                match_votes_out;
    wire [(SYNC_REPETITION*HAMMING_WIDTH)-1:0] packed_hamming_out;

    // lock_detector 的最终输出
    wire pos_sync_match_pulse;
    wire locked;
    wire temporal_ok;

    // =================================================================
    // 模块实例化
    // =================================================================
    // 1. 实例化数据采集前端
    sync_pattern_detector #(
        .SYNC_MARKER(SYNC_MARKER), .SYNC_REPETITION(SYNC_REPETITION),
        .HAMMING_WIDTH(HAMMING_WIDTH), .ERROR_THRESHOLD(ERROR_THRESHOLD)
    ) u_pattern_detector (
        .clk(clk), .rst(rst),
        .byte_in(byte_in), .enable(enable),
        .match_votes_out(match_votes_out),
        .packed_hamming_out(packed_hamming_out)
    );

    // 2. 实例化决策大脑，输入直接来自前端
    lock_detector #(
        .SYNC_REPETITION(SYNC_REPETITION), .HAMMING_WIDTH(HAMMING_WIDTH),
        .SCORE_HIGH(SCORE_HIGH), .SCORE_MED(SCORE_MED), .HAMM_HIGH(HAMM_HIGH), .HAMM_MED(HAMM_MED),
        .SCORE_THRESHOLD(SCORE_THRESHOLD), .TEMPORAL_DEPTH(TEMPORAL_DEPTH), .TEMPORAL_VOTE(TEMPORAL_VOTE),
        .K_GOOD(K_GOOD), .K_BAD(K_BAD)
    ) u_lock_detector (
        .clk(clk), .rst(rst),
        .match_votes_i(match_votes_out), 
        .hamming_dist_i(packed_hamming_out),
        .pos_sync_match_pulse(pos_sync_match_pulse),
        .locked(locked),
        .temporal_ok(temporal_ok)
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
        #52;
        rst = 0;
    end

    // =================================================================
    // 激励生成
    // =================================================================
            integer i, j;
    initial begin

        
        // 等待复位结束
        @(negedge rst);
        $display("\n[%0t ns] <<< 复位结束，开始集成测试 >>>", $time);
        
        // --- 场景 1: 搜索并锁定 ---
        $display("\n[%0t ns] --- 场景 1: 发送垃圾数据和同步序列 ---", $time);
        drive_byte(8'hAA);
        drive_byte(8'hBB);
        
        // 发送完整的同步序列
        for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                drive_byte( (SYNC_MARKER >> (8 * (7-j))) & 8'hFF );
            end
        end
        // 再发送几个好字节，确保L2能稳定
        drive_byte( (SYNC_MARKER >> (8 * 7)) & 8'hFF );
        drive_byte( (SYNC_MARKER >> (8 * 6)) & 8'hFF );

        // --- 场景 2: 发送载荷与瞬时噪声 ---
        $display("\n[%0t ns] --- 场景 2: 发送载荷与瞬时噪声 ---", $time);
        // 模拟10个字节的载荷
        for (i = 0; i < 10; i = i + 1) begin
            drive_byte(i[7:0]);
        end
        // 注入一个坏字节 (会破坏一个切片)
        drive_byte(8'hDE); 
        drive_byte(8'hAD);
        // 恢复正常载荷
        for (i = 10; i < 20; i = i + 1) begin
            drive_byte(i[7:0]);
        end

        // --- 场景 3: 信号持续丢失 ---
        $display("\n[%0t ns] --- 场景 3: 信号持续丢失 ---", $time);
        for (i = 0; i < 30; i = i + 1) begin
            drive_byte($random); // 连续发送随机数据模拟失锁
        end

        // 停止激励
        @(posedge clk);
        enable <= 1'b0;

        wait_cycles(10);
        $display("\n[%0t ns] <<< 仿真结束 >>>", $time);
        $finish;
    end
    
    // 辅助任务
    task drive_byte(input [7:0] data);
        begin
            @(posedge clk);
            #1;
            byte_in = data;
            enable = 1'b1;
        end
    endtask

    task wait_cycles(input integer N);
        repeat(N) @(posedge clk);
    endtask

    // =================================================================
    // 实时监控
    // =================================================================
    initial begin
        $monitor("[%0t ns] locked=%b, pulse=%b, temporal_ok=%b, hamming_out[7:0]=%2h, match_votes=%b",
                 $time, locked, pos_sync_match_pulse, temporal_ok, 
                 packed_hamming_out[7:0], match_votes_out);
    end
    
    // VCD波形文件生成
    // initial begin
    //     $dumpfile("detector_integration_sim.vcd");
    //     $dumpvars(0, tb_detector_integration);
    // end

endmodule