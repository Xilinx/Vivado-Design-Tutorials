//Command     : generate_target design_GT_wrapper.bd
//Design      : design_GT_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module top
   (GT_Serial_grx_n_ext,
    GT_Serial_grx_p_ext,
    GT_Serial_gtx_n_ext,
    GT_Serial_gtx_p_ext,
    apb3clk_gt_bridge_ip_0_ext,
    apb3clk_quad_ext,
    gt_bridge_ip_0_diff_gt_ref_clock_clk_n_ext,
    gt_bridge_ip_0_diff_gt_ref_clock_clk_p_ext,
    gt_reset_gt_bridge_ip_0_ext,

    ddr4_dimm1_act_n_ext,
    ddr4_dimm1_adr_ext,
    ddr4_dimm1_ba_ext,
    ddr4_dimm1_bg_ext,
    ddr4_dimm1_ck_c_ext,
    ddr4_dimm1_ck_t_ext,
    ddr4_dimm1_cke_ext,
    ddr4_dimm1_cs_n_ext,
    ddr4_dimm1_dm_n_ext,
    ddr4_dimm1_dq_ext,
    ddr4_dimm1_dqs_c_ext,
    ddr4_dimm1_dqs_t_ext,
    ddr4_dimm1_odt_ext,
    ddr4_dimm1_reset_n_ext,
    ddr4_dimm1_sma_clk_clk_n_ext,
    ddr4_dimm1_sma_clk_clk_p_ext
    );
    
  input [3:0]GT_Serial_grx_n_ext;
  input [3:0]GT_Serial_grx_p_ext;
  output [3:0]GT_Serial_gtx_n_ext;
  output [3:0]GT_Serial_gtx_p_ext;
  input apb3clk_gt_bridge_ip_0_ext;
  input apb3clk_quad_ext;
  input [0:0]gt_bridge_ip_0_diff_gt_ref_clock_clk_n_ext;
  input [0:0]gt_bridge_ip_0_diff_gt_ref_clock_clk_p_ext;
  input gt_reset_gt_bridge_ip_0_ext;
//  output lcpll_lock_gt_bridge_ip_0_ext;
//  output link_status_gt_bridge_ip_0_ext;
//  input [3:0]rate_sel_gt_bridge_ip_0_ext;
//  output rpll_lock_gt_bridge_ip_0_ext;
//  output rx_resetdone_out_gt_bridge_ip_0_ext;
//  output rxusrclk_gt_bridge_ip_0_ext;
//  output tx_resetdone_out_gt_bridge_ip_0_ext;
//  output txusrclk_gt_bridge_ip_0_ext;
    output ddr4_dimm1_act_n_ext;
  output [16:0]ddr4_dimm1_adr_ext;
  output [1:0]ddr4_dimm1_ba_ext;
  output [1:0]ddr4_dimm1_bg_ext;
  output ddr4_dimm1_ck_c_ext;
  output ddr4_dimm1_ck_t_ext;
  output ddr4_dimm1_cke_ext;
  output ddr4_dimm1_cs_n_ext;
  inout [7:0]ddr4_dimm1_dm_n_ext;
  inout [63:0]ddr4_dimm1_dq_ext;
  inout [7:0]ddr4_dimm1_dqs_c_ext;
  inout [7:0]ddr4_dimm1_dqs_t_ext;
  output ddr4_dimm1_odt_ext;
  output ddr4_dimm1_reset_n_ext;
  input ddr4_dimm1_sma_clk_clk_n_ext;
  input ddr4_dimm1_sma_clk_clk_p_ext;

  wire [3:0]GT_Serial_grx_n_ext;
  wire [3:0]GT_Serial_grx_p_ext;
  wire [3:0]GT_Serial_gtx_n_ext;
  wire [3:0]GT_Serial_gtx_p_ext;
  wire apb3clk_gt_bridge_ip_0_ext;
  wire apb3clk_quad_ext;
  wire [0:0]gt_bridge_ip_0_diff_gt_ref_clock_clk_n_ext;
  wire [0:0]gt_bridge_ip_0_diff_gt_ref_clock_clk_p_ext;
  wire gt_reset_gt_bridge_ip_0_ext;
  wire lcpll_lock_gt_bridge_ip_0_ext;
  wire link_status_gt_bridge_ip_0_ext;
  wire [3:0]rate_sel_gt_bridge_ip_0_ext;
  wire rpll_lock_gt_bridge_ip_0_ext;
  wire rx_resetdone_out_gt_bridge_ip_0_ext;
  wire rxusrclk_gt_bridge_ip_0_ext;
  wire tx_resetdone_out_gt_bridge_ip_0_ext;
  wire txusrclk_gt_bridge_ip_0_ext;
    wire ddr4_dimm1_act_n_ext;
  wire [16:0]ddr4_dimm1_adr_ext;
  wire [1:0]ddr4_dimm1_ba_ext;
  wire [1:0]ddr4_dimm1_bg_ext;
  wire ddr4_dimm1_ck_c_ext;
  wire ddr4_dimm1_ck_t_ext;
  wire ddr4_dimm1_cke_ext;
  wire ddr4_dimm1_cs_n_ext;
  wire [7:0]ddr4_dimm1_dm_n_ext;
  wire [63:0]ddr4_dimm1_dq_ext;
  wire [7:0]ddr4_dimm1_dqs_c_ext;
  wire [7:0]ddr4_dimm1_dqs_t_ext;
  wire ddr4_dimm1_odt_ext;
  wire ddr4_dimm1_reset_n_ext;
  wire ddr4_dimm1_sma_clk_clk_n_ext;
  wire ddr4_dimm1_sma_clk_clk_p_ext;

  DDR_GT_top DDR_GT_top_i
       (.GT_Serial_grx_n(GT_Serial_grx_n_ext),
        .GT_Serial_grx_p(GT_Serial_grx_p_ext),
        .GT_Serial_gtx_n(GT_Serial_gtx_n_ext),
        .GT_Serial_gtx_p(GT_Serial_gtx_p_ext),
        .apb3clk_gt_bridge_ip_0(apb3clk_gt_bridge_ip_0_ext),
        .apb3clk_quad(apb3clk_quad_ext),
        .gt_bridge_ip_0_diff_gt_ref_clock_clk_n(gt_bridge_ip_0_diff_gt_ref_clock_clk_n_ext),
        .gt_bridge_ip_0_diff_gt_ref_clock_clk_p(gt_bridge_ip_0_diff_gt_ref_clock_clk_p_ext),
        .gt_reset_gt_bridge_ip_0(gt_reset_gt_bridge_ip_0_ext),
        .lcpll_lock_gt_bridge_ip_0(lcpll_lock_gt_bridge_ip_0_ext),
        .link_status_gt_bridge_ip_0(link_status_gt_bridge_ip_0_ext),
        .rate_sel_gt_bridge_ip_0(rate_sel_gt_bridge_ip_0_ext),
        .rpll_lock_gt_bridge_ip_0(rpll_lock_gt_bridge_ip_0_ext),
        .rx_resetdone_out_gt_bridge_ip_0(rx_resetdone_out_gt_bridge_ip_0_ext),
        .rxusrclk_gt_bridge_ip_0(rxusrclk_gt_bridge_ip_0_ext),
        .tx_resetdone_out_gt_bridge_ip_0(tx_resetdone_out_gt_bridge_ip_0_ext),
        .txusrclk_gt_bridge_ip_0(txusrclk_gt_bridge_ip_0_ext),
        .ddr4_dimm1_act_n(ddr4_dimm1_act_n_ext),
        .ddr4_dimm1_adr(ddr4_dimm1_adr_ext),
        .ddr4_dimm1_ba(ddr4_dimm1_ba_ext),
        .ddr4_dimm1_bg(ddr4_dimm1_bg_ext),
        .ddr4_dimm1_ck_c(ddr4_dimm1_ck_c_ext),
        .ddr4_dimm1_ck_t(ddr4_dimm1_ck_t_ext),
        .ddr4_dimm1_cke(ddr4_dimm1_cke_ext),
        .ddr4_dimm1_cs_n(ddr4_dimm1_cs_n_ext),
        .ddr4_dimm1_dm_n(ddr4_dimm1_dm_n_ext),
        .ddr4_dimm1_dq(ddr4_dimm1_dq_ext),
        .ddr4_dimm1_dqs_c(ddr4_dimm1_dqs_c_ext),
        .ddr4_dimm1_dqs_t(ddr4_dimm1_dqs_t_ext),
        .ddr4_dimm1_odt(ddr4_dimm1_odt_ext),
        .ddr4_dimm1_reset_n(ddr4_dimm1_reset_n_ext),
        .ddr4_dimm1_sma_clk_clk_n(ddr4_dimm1_sma_clk_clk_n_ext),
        .ddr4_dimm1_sma_clk_clk_p(ddr4_dimm1_sma_clk_clk_p_ext));      
        
endmodule


