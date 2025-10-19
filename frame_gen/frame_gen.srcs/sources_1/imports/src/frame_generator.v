`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Module Name: frame_generator (最终匹配版)
//
// Description:
//   发送端同步帧生成模块。本版本修正了帧长度处理逻辑，
//   确保生成的帧结构(同步头+载荷+填充)与接收端完全匹配。
//
//////////////////////////////////////////////////////////////////////////////////
module frame_generator (
    input  wire        clk,
    input  wire        rst,

    // --- AXI-Stream 从接口输入 (来自 DDR Interleaver) ---
    input  wire [7:0]  s_axis_input_tdata,
    input  wire        s_axis_input_tvalid,
    output wire        s_axis_input_tready,

    // --- AXI-Stream 主接口输出 (送往物理层) ---
    output reg  [7:0]  m_axis_output_tdata,
    output reg         m_axis_output_tvalid,
    input  wire        m_axis_output_tready
);

    // =================================================================
    //  参数定义 (必须与接收端 frame_synchronizer 严格匹配)
    // =================================================================
    parameter [63:0] SYNC_MARKER       = 64'hB1699558A53333A8;
    parameter integer  SYNC_REPETITION   = 3;
    parameter integer  PAYLOAD_LEN       = 2461696;

    localparam integer SYNC_BYTES          = 8;
    localparam integer TOTAL_SYNC_BYTES    = SYNC_BYTES * SYNC_REPETITION;
    localparam integer PADDING_LEN         = (4 - ((TOTAL_SYNC_BYTES + PAYLOAD_LEN) % 4)) % 4;

    // =================================================================
    //  状态机定义
    // =================================================================
    localparam S_IDLE          = 3'd0;
    localparam S_SEND_SYNC     = 3'd1;
    localparam S_SEND_PAYLOAD  = 3'd2;
    localparam S_SEND_PADDING  = 3'd3;

    reg [2:0] state, n_state;

    // =================================================================
    //  内部信号与计数器
    // =================================================================
    wire [7:0] fifo_dout;
    wire       fifo_empty;
    wire       fifo_full;
    wire       fifo_rd_en;

    reg [4:0]                           sync_byte_cnt;
    reg [$clog2(PAYLOAD_LEN)-1:0]       payload_byte_cnt;
    reg [1:0]                           pad_byte_cnt;
    
    wire m_axis_fire = m_axis_output_tvalid && m_axis_output_tready;

    // =================================================================
    //  输入缓冲 FIFO
    // =================================================================
    assign s_axis_input_tready = !fifo_full;
    sync_fifo_8w_8r input_fifo_inst (
        .clk    (clk),
        .srst    (rst),
        .din    (s_axis_input_tdata),
        .wr_en  (s_axis_input_tvalid && s_axis_input_tready),
        .full   (fifo_full),
        .dout   (fifo_dout),
        .rd_en  (fifo_rd_en),
        .empty  (fifo_empty)
    );

    // =================================================================
    //  主状态机 (三段式)
    // =================================================================
    always @(posedge clk or posedge rst) begin
        if (rst) state <= S_IDLE;
        else     state <= n_state;
    end

    always @(*) begin
        n_state = state;
        case (state)
            S_IDLE:
                if (!fifo_empty)
                    n_state = S_SEND_SYNC;
            S_SEND_SYNC:
                if (m_axis_fire && (sync_byte_cnt == TOTAL_SYNC_BYTES - 1))
                    n_state = S_SEND_PAYLOAD;
            S_SEND_PAYLOAD:
                if (m_axis_fire && (payload_byte_cnt == PAYLOAD_LEN - 1))
                    n_state = (PADDING_LEN > 0) ? S_SEND_PADDING : S_IDLE;
            S_SEND_PADDING:
                if (m_axis_fire && (pad_byte_cnt == PADDING_LEN - 1))
                    n_state = S_IDLE;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync_byte_cnt    <= 'd0;
            payload_byte_cnt <= 'd0;
            pad_byte_cnt     <= 'd0;
        end else begin
            if (state == S_SEND_SYNC)
                sync_byte_cnt <= sync_byte_cnt + 1;
            else if (n_state == S_SEND_SYNC) // 只要下一个状态是SEND_SYNC，就复位计数器
                sync_byte_cnt <= 'd0;

            if (state == S_SEND_PAYLOAD)
                payload_byte_cnt <= payload_byte_cnt + 1;
            else if (n_state == S_SEND_PAYLOAD)
                payload_byte_cnt <= 'd0;

            if (state == S_SEND_PADDING)
                pad_byte_cnt <= pad_byte_cnt + 1;
            else if (n_state == S_SEND_PADDING)
                pad_byte_cnt <= 'd0;
        end
    end

    // =================================================================
    //  数据通路与输出逻辑
    // =================================================================
    assign fifo_rd_en = (state == S_SEND_PAYLOAD) && (m_axis_output_tready || !m_axis_output_tvalid) && !fifo_empty;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            m_axis_output_tdata  <= 8'd0;
            m_axis_output_tvalid <= 1'b0;
        end else begin
            if (m_axis_output_tready || !m_axis_output_tvalid) begin
                m_axis_output_tvalid <= 1'b0; // 默认拉低
                
                case (state)
                    S_SEND_SYNC: begin
                        // if(m_axis_fire)begin
                            case(sync_byte_cnt[2:0])
                                3'd0: m_axis_output_tdata <= SYNC_MARKER[63:56];
                                3'd1: m_axis_output_tdata <= SYNC_MARKER[55:48];
                                3'd2: m_axis_output_tdata <= SYNC_MARKER[47:40];
                                3'd3: m_axis_output_tdata <= SYNC_MARKER[39:32];
                                3'd4: m_axis_output_tdata <= SYNC_MARKER[31:24];
                                3'd5: m_axis_output_tdata <= SYNC_MARKER[23:16];
                                3'd6: m_axis_output_tdata <= SYNC_MARKER[15:8];
                                3'd7: m_axis_output_tdata <= SYNC_MARKER[7:0];
                            endcase
                        // end
                        m_axis_output_tvalid <= 1'b1;
                    end
                    S_SEND_PAYLOAD: begin
                        if (!fifo_empty) begin
                            m_axis_output_tdata  <= fifo_dout;
                            m_axis_output_tvalid <= 1'b1;
                        end
                    end
                    S_SEND_PADDING: begin
                        if (pad_byte_cnt < PADDING_LEN) begin
                            m_axis_output_tdata  <= 8'h00;
                            m_axis_output_tvalid <= 1'b1;
                        end
                    end
                endcase
            end
        end
    end


    `ifndef SYNTHESIS
        reg [47:0] state_ascii;
        reg [47:0] n_state_ascii;

        always @(*) begin
            case (state)
                S_IDLE        :state_ascii = "S_IDLE";
                S_SEND_SYNC   :state_ascii = "S_SEND_SYNC";
                S_SEND_PAYLOAD:state_ascii = "S_SEND_PAYLOAD";
                S_SEND_PADDING:state_ascii = "S_SEND_PADDING";
            endcase
        end

        always @(*) begin
            case (n_state)
                S_IDLE        :n_state_ascii = "S_IDLE";
                S_SEND_SYNC   :n_state_ascii = "S_SEND_SYNC";
                S_SEND_PAYLOAD:n_state_ascii = "S_SEND_PAYLOAD";
                S_SEND_PADDING:n_state_ascii = "S_SEND_PADDING";
            endcase
        end
        
    `endif



endmodule