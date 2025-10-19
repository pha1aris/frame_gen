/**
 * @brief 帧同步顶层模块 (参考论文优化版)
 * @details 该模块集成了输入缓冲FIFO、流水线匹配模块 (pipelined_sync_match) 和
 * 延迟FIFO (delay_fifo)，以实现一个完整的帧同步器。
 * FSM和帧计数逻辑已根据论文《一种高速并行帧同步的FPGA实现方法》进行优化。
 *
 * @param DATA_WIDTH           数据总线位宽，与子模块保持一致。
 * @param VERIFY_THRESHOLD_M   进入锁定状态需要的连续同步帧数。
 * @param PROTECT_THRESHOLD_N  判定失锁需要连续丢失的同步帧数。
 */
module frame_sync_top #(
    parameter DATA_WIDTH          = 192,
    parameter VERIFY_THRESHOLD_M  = 3, // 锁定门限 (M)
    parameter PROTECT_THRESHOLD_N = 3  // 失锁门限 (N)
)(
    // --- 系统信号 ---
    input  wire                  clk,
    input  wire                  rst_n, // 低电平有效复位

    // --- 同步器配置 ---
    input  wire [DATA_WIDTH-1:0] i_pattern_in,      // 期望匹配的同步字图样
    input  wire [7:0]            i_mask_len,        // 同步字的有效长度 (bit)
    input  wire [7:0]            i_error_threshold, // 汉明距离容错门限
    input  wire [15:0]           i_frame_len_bytes, // 以字节为单位的帧长度

    // --- 输入数据流 ---
    input  wire [DATA_WIDTH-1:0] i_data,      // 从数据源（如主FIFO）来的数据
    input  wire                  i_data_valid,  // 输入数据有效信号

    // --- 输出数据流 ---
    output wire [DATA_WIDTH-1:0] o_data,      // 对齐后的有效帧数据
    output wire                  o_data_valid,  // 输出数据有效信号
    output wire                  o_sof,         // 帧起始信号 (Start of Frame)
    output wire                  o_eof,         // 帧结束信号 (End of Frame)
    output wire                  o_sync_locked    // 同步锁定状态指示
);

    localparam BYTES_PER_WORD = DATA_WIDTH / 8;

    // --- 内部信号 ---
    wire match_pulse;
    wire delay_fifo_empty;
    wire sync_pos_expected;

    // 输入缓冲FIFO接口信号
    wire [DATA_WIDTH-1:0] input_fifo_dout;
    wire                  input_fifo_empty;
    wire                  input_fifo_full;
    wire                  input_fifo_rd_en;
    wire                  pipeline_data_valid;

    // --- FSM 状态定义 ---
    localparam [1:0] STATE_SEARCH  = 2'b00;
    localparam [1:0] STATE_VERIFY  = 2'b01;
    localparam [1:0] STATE_LOCK    = 2'b10;
    localparam [1:0] STATE_PROTECT = 2'b11;

    reg [1:0] current_state, next_state;

    // --- 计数器 ---
    reg [$clog2(VERIFY_THRESHOLD_M)-1:0]   verify_counter;
    reg [$clog2(PROTECT_THRESHOLD_N)-1:0]  protect_counter;
    reg [15:0]                             frame_byte_counter;

    // 0. 实例化输入数据缓冲FIFO
    // 假设存在一个名为 sync_fifo 的同步FIFO模块
    localparam INPUT_FIFO_DEPTH = 16;
    sync_fifo #(
        .DEPTH(INPUT_FIFO_DEPTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) u_input_fifo (
        .clk    (clk),
        .rst    (!rst_n), // 假设FIFO使用高电平复位
        .din    (i_data),
        .wr_en  (i_data_valid),
        .full   (input_fifo_full),
        .dout   (input_fifo_dout),
        .rd_en  (input_fifo_rd_en),
        .empty  (input_fifo_empty)
    );

    // 控制输入FIFO的读取，只要非空就一直读取，保证数据流不断
    assign input_fifo_rd_en = !input_fifo_empty;
    // 进入处理流水线的数据有效信号
    assign pipeline_data_valid = !input_fifo_empty;

    // 1. 实例化流水线匹配模块
    localparam SYNC_MATCH_LATENCY = 8;

    pipelined_sync_match #(
        .DATA_WIDTH(DATA_WIDTH)
    ) u_sync_match (
        .clk               (clk),
        .rst_n             (rst_n),
        .data_in           (input_fifo_dout), // 数据来自输入FIFO
        .pattern_in        (i_pattern_in),
        .mask_len          (i_mask_len),
        .i_error_threshold (i_error_threshold),
        .data_valid        (pipeline_data_valid), // 有效信号来自输入FIFO
        .o_match_pulse     (match_pulse)
    );

    // 2. 实例化延迟FIFO用于延迟补偿
    delay_fifo #(
        .DELAY      (SYNC_MATCH_LATENCY),
        .DATA_WIDTH (DATA_WIDTH)
    ) u_delay_fifo (
        .clk    (clk),
        .rst    (!rst_n),
        .din    (input_fifo_dout),      // 数据来自输入FIFO
        .wr_en  (pipeline_data_valid),  // 有效信号来自输入FIFO
        .full   (),
        .dout   (o_data),
        .rd_en  (o_data_valid),
        .empty  (delay_fifo_empty)
    );

    // 顶层状态机 (FSM)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= STATE_SEARCH;
        else        current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            STATE_SEARCH: begin
                if (match_pulse) begin
                    next_state = STATE_VERIFY;
                end
            end
            STATE_VERIFY: begin
                if (sync_pos_expected) begin
                    if (match_pulse) begin
                        if (verify_counter == VERIFY_THRESHOLD_M - 1) begin
                            next_state = STATE_LOCK;
                        end
                    end else begin
                        next_state = STATE_SEARCH;
                    end
                end
            end
            STATE_LOCK: begin
                if (sync_pos_expected && !match_pulse) begin
                    next_state = STATE_PROTECT;
                end
            end
            STATE_PROTECT: begin
                if (sync_pos_expected) begin
                    if (match_pulse) begin
                        next_state = STATE_LOCK;
                    end else if (protect_counter == PROTECT_THRESHOLD_N - 1) begin
                        next_state = STATE_SEARCH; // 失锁
                    end
                end
            end
            default: next_state = STATE_SEARCH;
        endcase
    end

    // 4. 计数器逻辑
    assign sync_pos_expected = (frame_byte_counter + BYTES_PER_WORD >= i_frame_len_bytes);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            frame_byte_counter <= 'd0;
            verify_counter     <= 'd0;
            protect_counter    <= 'd0;
        end else begin
            // 帧字节计数器
            // 只有当有有效数据进入流水线时才计数
            if (current_state != STATE_SEARCH && pipeline_data_valid) begin
                if (sync_pos_expected) begin
                    frame_byte_counter <= frame_byte_counter + BYTES_PER_WORD - i_frame_len_bytes;
                end else begin
                    frame_byte_counter <= frame_byte_counter + BYTES_PER_WORD;
                end
            end else if (next_state == STATE_VERIFY && current_state == STATE_SEARCH) begin
                 frame_byte_counter <= 'd0; // 找到第一个同步字，计数器清零
            end

            // 校验计数器
            if (next_state != STATE_VERIFY) begin
                verify_counter <= 'd0;
            end else if (sync_pos_expected && match_pulse) begin
                verify_counter <= verify_counter + 1;
            end

            // 保护计数器
            if (next_state != STATE_PROTECT) begin
                protect_counter <= 'd0;
            end else if (sync_pos_expected && !match_pulse) begin
                protect_counter <= protect_counter + 1;
            end
        end
    end

    // 5. 输出信号生成
    assign o_sync_locked = (current_state == STATE_LOCK) || (current_state == STATE_PROTECT);
    assign o_data_valid  = (current_state == STATE_LOCK) && !delay_fifo_empty;
    assign o_sof         = (next_state == STATE_LOCK) && (current_state == STATE_VERIFY);
    assign o_eof         = (current_state == STATE_LOCK) && sync_pos_expected;

endmodule

