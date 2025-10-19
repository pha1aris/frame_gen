/**
 * @brief 同步延迟FIFO
 * @param DELAY      FIFO可以容纳的数据项数量（深度）。
 * @param DATA_WIDTH 每个数据项的位宽。
 */
module delay_fifo#(
    parameter DELAY      = 8,
    parameter DATA_WIDTH = 8
)(
    input  wire                  clk,
    input  wire                  rst, 
    // 写端口
    input  wire [DATA_WIDTH-1:0] din,
    input  wire                  wr_en,
    output wire                  full,
    // 读端口
    output reg [DATA_WIDTH-1:0] dout,
    input  wire                  rd_en,
    output wire                  empty
);

    reg [DATA_WIDTH-1:0] RAM [0:DELAY-1];
    reg [$clog2(DELAY)-1:0] wr_ptr, rd_ptr;

    // 3. 状态标志计数器
    reg [$clog2(DELAY+1)-1:0] count;

    // 4. 指针和计数器更新逻辑
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 'd0;
            rd_ptr <= 'd0;
            count  <= 'd0;
        end else begin
            // 指针和计数器仅根据各自的使能信号和FIFO的状态（写操作时非满，读操作时非空）进行更新。
            // 此逻辑正确处理四种情况：- 仅写, 仅读, 同时读写, 无操作。
            
            if (wr_en && !full) begin
                wr_ptr <= (wr_ptr == DELAY - 1) ? 'd0 : wr_ptr + 1;
            end

            if (rd_en && !empty) begin
                rd_ptr <= (rd_ptr == DELAY - 1) ? 'd0 : rd_ptr + 1;
            end

            // 根据操作更新计数器
            if (wr_en && !full && !rd_en) begin // 仅写操作
                count <= count + 1;
            end else if (!wr_en && rd_en && !empty) begin // 仅读操作
                count <= count - 1;
            end
            // 如果同时进行读写操作 (wr_en && rd_en) 或无操作 (!wr_en && !rd_en)，计数器保持不变。
        end
    end

    // 5. 存储器写操作
    always @(posedge clk) begin
        if (wr_en && !full) begin
            RAM[wr_ptr] <= din;
        end
    end

    // 6. 存储器读操作（寄存器化输出）
    // 为了改善时序（提高fmax），输出数据被寄存。这增加了一个时钟周期的读延迟，
    // 是FIFO设计的标准实践。数据从rd_ptr指向的存储器位置读出。
    always @(posedge clk) begin
        if (rd_en && !empty) begin
            dout <= RAM[rd_ptr];
        end
    end

    // 7. 状态标志赋值
    assign empty = (count == 0);
    assign full  = (count == DELAY);

endmodule

