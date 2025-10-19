module frame_controller #(
    parameter integer PAYLOAD_LEN = 64
)(
    input  wire clk,
    input  wire rst,
    input  wire pos_sync_pulse,       // 来自同步检测模块
    input  wire frame_data_valid,     // 来自 circular_buffer
    output reg  start_read,           // 启动 circular_buffer
    output reg  stop_read,            // 停止 circular_buffer
    output reg  clr_buffer            // 清空 circular_buffer
);
    reg [15:0] payload_cnt;
    reg reading;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reading      <= 1'b0;
            payload_cnt  <= 16'd0;
            start_read   <= 1'b0;
            stop_read    <= 1'b0;
            clr_buffer   <= 1'b0;
        end else begin
            start_read <= 1'b0;  // 默认拉低
            stop_read  <= 1'b0;
            clr_buffer <= 1'b0;

            if (!reading && pos_sync_pulse) begin
                start_read  <= 1'b1;
                reading     <= 1'b1;
                payload_cnt <= 16'd0;
            end else if (reading && frame_data_valid) begin
                payload_cnt <= payload_cnt + 1;
                if (payload_cnt == PAYLOAD_LEN - 1) begin
                    stop_read  <= 1'b1;
                    clr_buffer <= 1'b1;   // 同时清空缓冲
                    reading    <= 1'b0;
                end
            end
        end
    end
endmodule
