`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 模块名称: circular_buffer
//
// 描述:
//   - 实现了带有回退功能的环形缓冲区，接口与您的例化代码完全匹配。
//   - 内部逻辑已根据BRAM的1周期读延迟进行流水线处理，确保数据与valid信号同步。
//   - 读指针回退逻辑已处理地址回绕，确保计算正确。
//   - 注意: 此版本的接口没有tready信号，假定下游模块总能接收数据。
//
//////////////////////////////////////////////////////////////////////////////////
module circular_buffer #(
    parameter integer BUF_DEPTH = 64,
    parameter integer DELAY_TO_SYNC = 10,    // 检测延迟拍数
    parameter integer FRAME_LEN = 64        // 一帧的总长度
)(
    input  wire        clk,
    input  wire        rst,

    // 数据输入
    input  wire [7:0]  fifo_dout,
    input  wire        fifo_rd_en,

    // 控制信号
    input  wire        pos_sync_pulse,     // 检测到同步头
    
    // 数据输出
    output reg  [7:0]  frame_data_out,
    output reg         frame_data_valid
);

    // ===========================================================
    // 1. 环形缓冲 RAM
    // ===========================================================
    // 综合时，推荐使用厂商提供的RAM IP核代替此行为级模型
    reg [7:0] buffer [0:BUF_DEPTH-1];

    // ===========================================================
    // 2. 写指针
    // ===========================================================
    reg [$clog2(BUF_DEPTH)-1:0] write_ptr;
    always @(posedge clk or posedge rst) begin
        if (rst)
            write_ptr <= 0;
        else if (fifo_rd_en)
            write_ptr <= write_ptr + 1; // 地址自动回卷
    end

    always @(posedge clk) begin
        if (fifo_rd_en)
            buffer[write_ptr] <= fifo_dout;
    end

    // ===========================================================
    // 3. 读指针 + 控制逻辑
    // ===========================================================
    reg [$clog2(BUF_DEPTH)-1:0] read_ptr;
    reg                         reading_frame;
    reg [$clog2(FRAME_LEN)-1:0] read_cnt;

    // reading_frame 状态标志
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reading_frame <= 1'b0;
        // 在收到同步脉冲且当前未在读时，开始新一帧
        end else if (pos_sync_pulse && !reading_frame) 
            reading_frame <= 1'b1;
        // 当成功发送完最后一个字节后，停止读取
         else if (reading_frame && (read_cnt == FRAME_LEN - 1)) 
            reading_frame <= 1'b0;
        
    end

    // 读指针和计数器控制
    always@(posedge clk or posedge rst) begin
        if (rst) begin
            read_ptr <= 0;
            read_cnt <= 0;
        // 在收到同步脉冲且即将开始读取时，计算回退地址
        end else if (pos_sync_pulse && !reading_frame) begin
            // **已修正**: 明确处理指针回绕
            if (write_ptr >= DELAY_TO_SYNC) begin
                read_ptr <= write_ptr - DELAY_TO_SYNC;
            end else begin
                read_ptr <= BUF_DEPTH + write_ptr - DELAY_TO_SYNC;
            end
            read_cnt <= 0;
        // **已修改**: 因为没有tready，只要在读取状态就推进指针
        end else if (reading_frame) begin
            read_ptr <= read_ptr + 1;
            read_cnt <= read_cnt + 1;
        end
    end

    // ===========================================================
    // 4. 输出数据 (硬件修正流水线)
    // ===========================================================
    reg [7:0] read_data_from_ram;
    reg       reading_frame_d1;
    
    // **步骤1: 模拟BRAM的1周期读延迟**
    always @(posedge clk) begin
        // 读指针更新后，下一个周期才能从RAM读出对应数据
        read_data_from_ram <= buffer[read_ptr];
        // 同步延迟状态标志，用于驱动下一级的valid信号
        reading_frame_d1   <= reading_frame;
    end
    
    // **步骤2: 输出寄存器，对齐 valid 和 data**
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            frame_data_out  <= 8'h00;
            frame_data_valid <= 1'b0;
        end else begin
            // **关键修正**: valid 信号现在是 reading_frame 延迟一拍的结果
            // 这样就与经过RAM延迟一拍的数据对齐了
            frame_data_valid <= reading_frame_d1;
            
            if (reading_frame_d1) begin
                frame_data_out <= read_data_from_ram;
            end
        end
    end

endmodule