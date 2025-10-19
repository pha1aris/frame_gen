
//8 clk period latency pipline

module pipelined_sync_match #(
    parameter DATA_WIDTH = 192
)(
    input  wire                      clk,
    input  wire                      rst_n,
    input  wire [DATA_WIDTH-1:0]     data_in,
    input  wire [DATA_WIDTH-1:0]     pattern_in,
    input  wire [7:0]                mask_len,
    input  wire [7:0]                i_error_threshold,
    input  wire                      data_valid,
    output wire                      o_match_pulse
);

    localparam NUM_SEGMENTS = DATA_WIDTH / 8;

    // 掩码生成
    wire [DATA_WIDTH-1:0] mask;
    assign mask = (mask_len == 0) ? {DATA_WIDTH{1'b0}} :
                  ({DATA_WIDTH{1'b1}} >> (DATA_WIDTH - mask_len));

    // --- 输入寄存 ---
    reg [DATA_WIDTH-1:0] data_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_d <= {DATA_WIDTH{1'b1}}; // 初始化为全1，防止上电误匹配
        else if (data_valid)
            data_d <= data_in;
    end

    // --- 异或 + 掩码 ---
    wire [DATA_WIDTH-1:0] xor_result    = data_d ^ pattern_in;
    wire [DATA_WIDTH-1:0] masked_result = xor_result & mask;

    reg [DATA_WIDTH-1:0] masked_result_r;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            masked_result_r <= {DATA_WIDTH{1'b1}};
        else
            masked_result_r <= masked_result;
    end

    // --- 8bit 分段 popcount ---
    reg [3:0] stage1_sums [NUM_SEGMENTS-1:0];
    genvar i;
    generate
        for (i = 0; i < NUM_SEGMENTS; i = i + 1) begin : gen_stage1_popcount
            wire [7:0] bits = masked_result_r[i*8 +: 8];
            wire [3:0] pop = bits[0]+bits[1]+bits[2]+bits[3]+bits[4]+bits[5]+bits[6]+bits[7];
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    stage1_sums[i] <= 4'b1111;
                else
                    stage1_sums[i] <= pop;
            end
        end
    endgenerate

    // --- 后续流水线加法器树 ---
    reg [4:0] stage2_sums [NUM_SEGMENTS/2-1:0];
    generate
        for (i = 0; i < NUM_SEGMENTS/2; i = i + 1) begin : gen_stage2_add
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    stage2_sums[i] <= 5'b11111;
                else
                    stage2_sums[i] <= stage1_sums[i*2] + stage1_sums[i*2+1];
            end
        end
    endgenerate

    reg [5:0] stage3_sums [NUM_SEGMENTS/4-1:0];
    generate
        for (i = 0; i < NUM_SEGMENTS/4; i = i + 1) begin : gen_stage3_add
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    stage3_sums[i] <= 6'b111111;
                else
                    stage3_sums[i] <= stage2_sums[i*2] + stage2_sums[i*2+1];
            end
        end
    endgenerate

    reg [6:0] stage4_sums [NUM_SEGMENTS/8-1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage4_sums[0] <= 7'b1111111;
            stage4_sums[1] <= 7'b1111111;
            stage4_sums[2] <= 7'b1111111;
        end else begin
            stage4_sums[0] <= stage3_sums[0] + stage3_sums[1];
            stage4_sums[1] <= stage3_sums[2] + stage3_sums[3];
            stage4_sums[2] <= stage3_sums[4] + stage3_sums[5];
        end
    end

    // --- 最终求和 ---
    reg [7:0] distance_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            distance_reg <= 8'b1111_1111;
        else
            distance_reg <= stage4_sums[0] + stage4_sums[1] + stage4_sums[2];
    end

    // --- 比较 + 脉冲 ---
    reg match_flag, match_flag_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            match_flag   <= 1'b0;
            match_flag_d <= 1'b0;
        end else begin
            match_flag   <= (distance_reg <= i_error_threshold);
            match_flag_d <= match_flag;
        end
    end

    // --- 输出 ---
    assign o_match_pulse = data_valid ? (match_flag & ~match_flag_d) : 1'b0;

endmodule
