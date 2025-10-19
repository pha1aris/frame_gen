// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Fri Oct 10 15:00:10 2025
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
  (* C_PRELOAD_LATENCY = "2" *) 
  (* C_PRELOAD_REGS = "1" *) 
  (* C_PRIM_FIFO_TYPE = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) 
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
gg==
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
