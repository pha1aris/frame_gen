// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Oct  9 15:10:39 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top sync_fifo_8w_8r -prefix
//               sync_fifo_8w_8r_ sync_fifo_8w_8r_sim_netlist.v
// Design      : sync_fifo_8w_8r
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "sync_fifo_8w_8r,fifo_generator_v13_2_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_11,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module sync_fifo_8w_8r
   (clk,
    srst,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty,
    wr_rst_busy,
    rd_rst_busy);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 core_clk CLK" *) (* x_interface_mode = "slave core_clk" *) (* x_interface_parameter = "XIL_INTERFACENAME core_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input clk;
  input srst;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) (* x_interface_mode = "slave FIFO_WRITE" *) input [7:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) (* x_interface_mode = "slave FIFO_READ" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [7:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output wr_rst_busy;
  output rd_rst_busy;

  wire clk;
  wire [7:0]din;
  wire [7:0]dout;
  wire empty;
  wire full;
  wire rd_en;
  wire rd_rst_busy;
  wire srst;
  wire wr_en;
  wire wr_rst_busy;
  wire NLW_U0_almost_empty_UNCONNECTED;
  wire NLW_U0_almost_full_UNCONNECTED;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_empty_UNCONNECTED;
  wire NLW_U0_prog_full_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_valid_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [9:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [9:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [9:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "1" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "10" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "8" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "8" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_FULL_FLAGS_RST_VAL = "0" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "0" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "1" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "0" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "6" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "4" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "0" *) 
  (* C_PRELOAD_REGS = "1" *) 
  (* C_PRIM_FIFO_TYPE = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "4" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "5" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "1022" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "10" *) 
  (* C_RD_DEPTH = "1024" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "10" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "1" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "10" *) 
  (* C_WR_DEPTH = "1024" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "10" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  sync_fifo_8w_8r_fifo_generator_v13_2_11 U0
       (.almost_empty(NLW_U0_almost_empty_UNCONNECTED),
        .almost_full(NLW_U0_almost_full_UNCONNECTED),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(clk),
        .data_count(NLW_U0_data_count_UNCONNECTED[9:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(NLW_U0_prog_empty_UNCONNECTED),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(1'b0),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[9:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(rd_rst_busy),
        .rst(1'b0),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(srst),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(NLW_U0_valid_UNCONNECTED),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(1'b0),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[9:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(wr_rst_busy));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
md0AksSCeI3fOZtF7nrw91OgSzGoACBon4GH9ENTzaI4jlg22H1uTtXayX2Kz+g4ZH2j52rtMH8H
Xc49HVcThMzO1cRXu+SkL59MRQ87klGca4XtjrTtunJoQ+jyOKRwRBeIMHUdntbk2T1kbXHf9KkB
bNYGEMqSrbiDt7IJUx8=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
r6CzxR0T3O2wvZRQe25aX3/CWOx/3d/3vJvvS/XsrKr7v852GNQNqCBn+PKsunj0Ncep8DqHtVie
BE6tKIqZW+3txAUjrhSri5liuFWSnzAk+Drsb4RnvIy7BeOdAK6NhVhn8ZyplkJSHVwaGjN8gtPE
LeWEHPHf5qLnzqGKV7B6oIC7POGV6Vamos1p2z1xv2cEw4udvmtZ5EjzeyCMf+omtxEPxhPi6Z2h
ENlGOmuPMkWGMjP6HQCZ1Mi0uiST/zDo29UDIMmOGcsDMe97imU/z2ekKTPXXwjcV+9q+4zHRgJV
6JWWgjU9cztV5OMaEfpBgRBWae/ijWpPZaGuFA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
glFrHilvyO7nq7/OYhnyb9uU9d8UNGJruNnkmJWuTpgvyCDmtx7iVKPBPe1Bj9jUDT/HM9AGxvu0
g7b4TuMdVkegkVPeHhw31IW0HoTL8wPnrLEpzDVK+B7xl953hPKPe0vn+0EQh2UKeL5K8VLxmsSv
gbpEeToeR90yzlSUzDE=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
D4uBhES8Mkd0GCwY2aQOmEzTqz6hO5B9Wa2oyfVBEODkWyt+AHkIXn4tuBN05FcP2FVmgtVbvZX5
K6iog51IoPw5tv+pM5x8+bQBX/aZpf0c4to3qiX6RZuITpuSUWq/7sqQDqtMqDWOFMMnUBpTX+qI
t61NvyIZcfqRWo4yvIUV2Zh1etqYKDlhqRnMoBZKMeHFpVsp19nU4sf5Km7sSlPQ08vYD8qtJqgJ
ZDYC2KWFTHsnT+5anHvc80FgHt4zBHpPrGprgpltQmVmMZxUD6NRC9EvvXf+pBhgfwPHHePWIKUn
elLld/HEVeFw76SlVV8i4LsS4KWWOM+KmMprEg==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
EW9gHDqS12MVhy+y/xQVscLd4qOim+cNTepYzlas7WzqDJogZthddOuGjpm3a3fS/cMbF/h0O1Hb
Wjow664GIga0y96lkbkcJ3W8x/IGAsvgyrYT6ScsFhyq7tSd1HjvRG81BhhGM1mmpxfzh0Uqbfso
q+uVKPUmPnbQ/Gdu9YRoxmYVJdmUTpXJ5waYOdib8WNMPLdDfIo/FGrYrx2zYQBtpU5DwwVUTMrB
ZasEyxOj++icI5k5lR3Tx+3gdCFTy4XYQfcj2COm4gnVZ8FN/X1/+0ywsVGAc/OKL+mjMYH3NNH3
zfDO/TpYft+HaVl+CfF/U6IgJJeJs4qI4gB4FA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Myfv5Skg7QCxlNBoFiSTLAeIRYS0J0ArRihYk7dGAHZWAFlxJLgqo51W9P9zTVBurMJjZLtonoDJ
19RfxQj5GqhqN1A20s8xOFfLq6+uDG/V39xQFY32O626Kh4MMlH07hNJL5u1NjJWg1yze0XdFEe9
oLwKQz5lSKGMIh+VPXDuCGhShS+KhHwGEdS0lmA/IHPFNlRG1LsK0zQmUiNkG4kQ5OEVkQgvknNC
B6++ZDIYlT9WbZPs5giRY0zAhUepLPaO+N9F3fIBKVGw4ejbZOt0kXKixF86DDfLmF2+dov+PrTX
1MXJaea3YoQdR2c2MSHAk/TTkzg9ayjvxKaXpg==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ks9l+EPHXfDNnWd0exs1j0Q9iSNYaIExwQnpsi8TFJimjPtOkX050wFklsLBM83WyfuD+F2KLNnZ
Jg/aiIiGe9o424jOiEFdnAJuzrD0QL9WmhQ3W9iRJ7uPhha6NfR2WGTCCM4TpN8rTKLQDKxenVfv
6x83rnL5NQxvpp9cQh3zMma73qoEJjhTR9MD9cwA4VeKq2u/R0iTWBplX81vYFd9TW2qW5/Qyzzj
A0+pXzczcJKdggV8h8bYcO+PRC3t2XrufhnjvhjMLG2tPHSMW/soDH/v8KorXyWe5N/q12fo5auN
SXr3olNuB5kpiVS3mJAPV0z4UsFfu2A4hLH7MQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
e3AJKDEM9byJqwpkFZqMIMKMQPOR1VrLFkshor7HR0C+ol7Uv3XTGyvQrINdBEArX0eazF0cHWjC
9B4BhDnysAhT6SENcNHIYHUGQE7uiF7zgL7WhCxClwEnIAVj+PU9FmqlvbreEikHQfbeIDPyCLii
NAS97RDxWki/MfR33zvZX4eEolA/oTyRzr1MagBs7LN1UXyGPvnze8JzHxA3zHVedIIrBrZxkfoj
Loqe6tLYRlC45h1Yr3Wa2gh3LJGtOSji+m7E9Xua/pPh8A/CAD+TNBa5d/X7C3a4AWl2bYTi7HBY
Y8vaIjHiSosru5F2UOEQG9xekCbNRK1Apew1UIvntzCmDMMhlAgB78AUOE2YEWKd9GOl+aTZjMS3
GxAYzrtv/bDRkPOYbcG0SNT9xf+izRM3lX1E2vN3i3uU2Qrh73fjU1lk3PIe/A/H56UrNPDnGT9W
TvlJR47bLDtGyX2+dLvfTaZGRP8aepePOXXLIlvqwCJSMVhCB/hIbz7E

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TfuXOFQtE7YhtTL4354NvKETmBCLSVnb+pbrT8gtzjU7pERE1Hu2ZVzHgVQXwt5RvwG1R/z2je+U
PzszCBhPNqUaXEhuJ0A/q0S/vvOOa6h6tW9MhiB3gnuqEFVWz5pbHZNfgrwh2gT8XyqLI8f1CoJM
xpcB2TbREV/kAAFMxIfH1Dg0KSO2dCeVV1na6N0AiMOQPvXZOB7QpXwNDbYfarWLtF0/l0hi4Fxu
Kgho2ggrUhajP0aKlrCQ9mLsqOyqJELeJldeD+vuUUqhYq4K4RrwtQF+B67lYc4AjznwQ92tUvYJ
ZspFoHJEScNvdFoHFTA2TQ2KToepsqXRiOCL1A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
tmfbBpNtCYJ7zsgNxUzw7Dvn+hNn2PPUBeRfXSci/q2/OcQeF/eAAML8YIN1V+AEoAqZTE2/xRQz
+6zwVOLyAOLynMIBQ7EG7xReDJ9kEEiBjnMGO6NWdAsa/VcreVHrLD1PFtA1+WoVe6yOvNGK+Nbh
HjPkXyycyP6RQ4Rx/PtTxw31LOFVezddSgRlaKHTprKTP4LbjPG//onRBg3fAl8zwU1wYYNLzYCX
jwY7xfMkQyhUSpV2Tx3seqy2IYVl8jjxynFxfyxulvrJiqmc6aaKKBdkoOVbJ5eO2sCXFJB1mKEU
WR2Ee2ozisABzk9IcGILewCW7ghdLP82CRZv4A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
GfDCxx9db4ripD5mvQy16BVlwPYfeC7ZobZXaX1my6WUDiKwd69J5SreUXKYD9lvZfI7djLgHkYm
5G247T4NX7zoBwc88bUD+tNvGNmzWFfSVVZqu8hjgd31lZXjy9uYdXA/gsE+T+JqEfRYdV8YoGgm
sREyiJjWRPDbx6kc8um8vlAK/Rjwz0EGVkGUoi/+UvxcnjG1PqCl7GSMOQ3gFMEOaxIflShnF2/c
//ioADxl3WjUGyTstMK54XlP8G1Hk95sSe/7Y+SbaIyoG8t6gGDimDJNuGs4JjDUi1V7Gxfzxk9+
O2J++9clyLkMZ3rRyxSvR+Xyrmn3YxjVC68GXw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 51136)
`pragma protect data_block
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
kBKzrWbG1w==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
