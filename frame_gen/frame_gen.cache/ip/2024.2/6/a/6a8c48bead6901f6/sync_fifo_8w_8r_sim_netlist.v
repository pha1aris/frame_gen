// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Oct  9 15:10:39 2025
// Host        : FSO-A running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ sync_fifo_8w_8r_sim_netlist.v
// Design      : sync_fifo_8w_8r
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "sync_fifo_8w_8r,fifo_generator_v13_2_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_11,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_fifo_generator_v13_2_11 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 51472)
`pragma protect data_block
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
/w==
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
