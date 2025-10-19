/**
 * @brief frame_sync_top 模块的仿真测试平台 (Testbench)
 * @details 该Testbench用于验证帧同步顶层模块的功能，
 * 包含了正常锁定、失锁、重锁等关键场景。
 */
`timescale 1ns / 1ps

module tb_frame_sync_top;

// =================================================================
// --- 参数定义 ---
// =================================================================
parameter CLK_PERIOD = 10; // 时钟周期: 10ns -> 100MHz

// DUT 参数
parameter DATA_WIDTH          = 192;
parameter SYNC_MARKER         = 64'hB1699558A53333A8;
parameter SYNC_REPETITION     = 3;
parameter VERIFY_THRESHOLD_M  = 3;
parameter PROTECT_THRESHOLD_N = 3;

// 仿真参数
// 为了便于观察，定义一个较短的帧
// 同步字长度 = 192 bits = 24 bytes
// 载荷长度   = 8 bytes
// 总帧长     = 24 + 8 = 32 bytes
localparam FRAME_LEN_BYTES = 32;
localparam PAYLOAD_LEN_BYTES = FRAME_LEN_BYTES - (DATA_WIDTH / 8);
localparam SYNC_LEN_BYTES = DATA_WIDTH / 8;

// =================================================================
// --- 信号定义 ---
// =================================================================
// 时钟和复位
reg clk;
reg rst_n;

// DUT 输入
reg  [7:0]            i_error_threshold;
reg  [15:0]           i_frame_len_bytes;
reg  [7:0]            s_axis_input_tdata;
reg                   s_axis_input_tvalid;
wire                  s_axis_input_tready;

// DUT 输出
wire [7:0]            o_data;
wire                  o_data_valid;
wire                  o_sof;
wire                  o_eof;
wire                  o_sync_locked;

// =================================================================
// --- 实例化 DUT (被测设计) ---
// =================================================================
frame_sync_top #(
    .DATA_WIDTH          (DATA_WIDTH),
    .SYNC_MARKER         (SYNC_MARKER),
    .SYNC_REPETITION     (SYNC_REPETITION),
    .VERIFY_THRESHOLD_M  (VERIFY_THRESHOLD_M),
    .PROTECT_THRESHOLD_N (PROTECT_THRESHOLD_N)
) uut (
    .clk                 (clk),
    .rst_n               (rst_n),
    .i_error_threshold   (i_error_threshold),
    .i_frame_len_bytes   (i_frame_len_bytes),
    .s_axis_input_tdata  (s_axis_input_tdata),
    .s_axis_input_tvalid (s_axis_input_tvalid),
    .s_axis_input_tready (s_axis_input_tready),
    .o_data              (o_data),
    .o_data_valid        (o_data_valid),
    .o_sof               (o_sof),
    .o_eof               (o_eof),
    .o_sync_locked       (o_sync_locked)
);

// =================================================================
// --- 时钟和复位生成 ---
// =================================================================
initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
end

initial begin
    rst_n = 1'b0; // 复位
    s_axis_input_tvalid = 1'b0;
    s_axis_input_tdata = 8'h00;
    i_error_threshold = 8'd3; // 设置容错门限
    i_frame_len_bytes = FRAME_LEN_BYTES;
    repeat(5) @(posedge clk);
    rst_n = 1'b1; // 释放复位
end

// =================================================================
// --- 仿真激励 (Stimulus) ---
// =================================================================
initial begin
    $display("INFO: Simulation Started.");
    @(posedge rst_n);

    // --- 场景1: 正常锁定过程 ---
    $display("INFO: Scenario 1: Attempting to lock...");
    // 发送M=3个正确的帧
    send_frame(SYNC_MARKER, PAYLOAD_LEN_BYTES);
    send_frame(SYNC_MARKER, PAYLOAD_LEN_BYTES);
    send_frame(SYNC_MARKER, PAYLOAD_LEN_BYTES);
    
    // 发送第4个帧，此时应该已经锁定
    $display("INFO: Should be locked now. Sending one more valid frame.");
    send_frame(SYNC_MARKER, PAYLOAD_LEN_BYTES);
    
    repeat(50) @(posedge clk); // 等待数据流出

    // --- 场景2: 失锁过程 ---
    $display("INFO: Scenario 2: Attempting to lose lock...");
    // 发送1个错误帧，进入保护状态
    $display("INFO: Sending 1 bad frame (should enter PROTECT state)");
    send_frame(SYNC_MARKER + 1, PAYLOAD_LEN_BYTES); // 错误的同步字
    
    // 发送1个正确帧，应该能恢复锁定
    $display("INFO: Sending 1 good frame (should recover to LOCK state)");
    send_frame(SYNC_MARKER, PAYLOAD_LEN_BYTES);

    // 连续发送N=3个错误帧，应该失锁
    $display("INFO: Sending %0d consecutive bad frames (should lose lock)", PROTECT_THRESHOLD_N);
    repeat(PROTECT_THRESHOLD_N) begin
        send_frame(SYNC_MARKER + 1, PAYLOAD_LEN_BYTES);
    end

    repeat(50) @(posedge clk);
    
    // --- 场景3: 重新锁定 ---
    $display("INFO: Scenario 3: Attempting to re-lock...");
    send_frame(SYNC_MARKER, PAYLOAD_LEN_BYTES);
    send_frame(SYNC_MARKER, PAYLOAD_LEN_BYTES);
    send_frame(SYNC_MARKER, PAYLOAD_LEN_BYTES);

    repeat(100) @(posedge clk);
    $display("INFO: Simulation Finished.");
    $finish;
end

// =================================================================
// --- 任务 (Tasks) ---
// =================================================================

// 发送一个字节的任务
task send_byte(input [7:0] data);
begin
    s_axis_input_tvalid <= 1'b1;
    s_axis_input_tdata  <= data;
    @(posedge clk);
    while (!s_axis_input_tready) begin
        @(posedge clk);
    end
    s_axis_input_tvalid <= 1'b0;
end
endtask

// 发送一整个帧的任务
task send_frame(input [63:0] marker, input integer payload_len);
    integer i;
    // 1. 发送同步字 (24字节)
    for (i = 0; i < SYNC_REPETITION; i = i + 1) begin
        send_byte(marker[63:56]);
        send_byte(marker[55:48]);
        send_byte(marker[47:40]);
        send_byte(marker[39:32]);
        send_byte(marker[31:24]);
        send_byte(marker[23:16]);
        send_byte(marker[15:8]);
        send_byte(marker[7:0]);
    end
    
    // 2. 发送载荷 (8字节)
    for (i = 0; i < payload_len; i = i + 1) begin
        send_byte($random);
    end
endtask


// =================================================================
// --- 监控 (Monitor) ---
// =================================================================
always @(posedge clk) begin
    if (o_sof) begin
        $display("MONITOR @ %0t: Start of Frame (SOF) detected!", $time);
    end
    if (o_eof) begin
        $display("MONITOR @ %0t: End of Frame (EOF) detected!", $time);
    end
end

endmodule
