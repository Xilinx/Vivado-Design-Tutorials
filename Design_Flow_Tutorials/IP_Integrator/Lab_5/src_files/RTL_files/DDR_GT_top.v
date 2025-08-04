//Command     : generate_target design_GT_wrapper.bd
//Design      : design_GT_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module DDR_GT_top
   (GT_Serial_grx_n,
    GT_Serial_grx_p,
    GT_Serial_gtx_n,
    GT_Serial_gtx_p,
    apb3clk_gt_bridge_ip_0,
    apb3clk_quad,
    gt_bridge_ip_0_diff_gt_ref_clock_clk_n,
    gt_bridge_ip_0_diff_gt_ref_clock_clk_p,
    gt_reset_gt_bridge_ip_0,
    lcpll_lock_gt_bridge_ip_0,
    link_status_gt_bridge_ip_0,
    rate_sel_gt_bridge_ip_0,
    rpll_lock_gt_bridge_ip_0,
    rx_resetdone_out_gt_bridge_ip_0,
    rxusrclk_gt_bridge_ip_0,
    tx_resetdone_out_gt_bridge_ip_0,
    txusrclk_gt_bridge_ip_0,
    ddr4_dimm1_act_n,
    ddr4_dimm1_adr,
    ddr4_dimm1_ba,
    ddr4_dimm1_bg,
    ddr4_dimm1_ck_c,
    ddr4_dimm1_ck_t,
    ddr4_dimm1_cke,
    ddr4_dimm1_cs_n,
    ddr4_dimm1_dm_n,
    ddr4_dimm1_dq,
    ddr4_dimm1_dqs_c,
    ddr4_dimm1_dqs_t,
    ddr4_dimm1_odt,
    ddr4_dimm1_reset_n,
    ddr4_dimm1_sma_clk_clk_n,
    ddr4_dimm1_sma_clk_clk_p
    );
  input [3:0]GT_Serial_grx_n;
  input [3:0]GT_Serial_grx_p;
  output [3:0]GT_Serial_gtx_n;
  output [3:0]GT_Serial_gtx_p;
  input apb3clk_gt_bridge_ip_0;
  input apb3clk_quad;
  input [0:0]gt_bridge_ip_0_diff_gt_ref_clock_clk_n;
  input [0:0]gt_bridge_ip_0_diff_gt_ref_clock_clk_p;
  input gt_reset_gt_bridge_ip_0;
  output lcpll_lock_gt_bridge_ip_0;
  output link_status_gt_bridge_ip_0;
  input [3:0]rate_sel_gt_bridge_ip_0;
  output rpll_lock_gt_bridge_ip_0;
  output rx_resetdone_out_gt_bridge_ip_0;
  output rxusrclk_gt_bridge_ip_0;
  output tx_resetdone_out_gt_bridge_ip_0;
  output txusrclk_gt_bridge_ip_0;
    output ddr4_dimm1_act_n;
  output [16:0]ddr4_dimm1_adr;
  output [1:0]ddr4_dimm1_ba;
  output [1:0]ddr4_dimm1_bg;
  output ddr4_dimm1_ck_c;
  output ddr4_dimm1_ck_t;
  output ddr4_dimm1_cke;
  output ddr4_dimm1_cs_n;
  inout [7:0]ddr4_dimm1_dm_n;
  inout [63:0]ddr4_dimm1_dq;
  inout [7:0]ddr4_dimm1_dqs_c;
  inout [7:0]ddr4_dimm1_dqs_t;
  output ddr4_dimm1_odt;
  output ddr4_dimm1_reset_n;
  input ddr4_dimm1_sma_clk_clk_n;
  input ddr4_dimm1_sma_clk_clk_p;

  wire [3:0]GT_Serial_grx_n;
  wire [3:0]GT_Serial_grx_p;
  wire [3:0]GT_Serial_gtx_n;
  wire [3:0]GT_Serial_gtx_p;
  wire apb3clk_gt_bridge_ip_0;
  wire apb3clk_quad;
  wire [0:0]gt_bridge_ip_0_diff_gt_ref_clock_clk_n;
  wire [0:0]gt_bridge_ip_0_diff_gt_ref_clock_clk_p;
  wire gt_reset_gt_bridge_ip_0;
  wire lcpll_lock_gt_bridge_ip_0;
  wire link_status_gt_bridge_ip_0;
  wire [3:0]rate_sel_gt_bridge_ip_0;
  wire rpll_lock_gt_bridge_ip_0;
  wire rx_resetdone_out_gt_bridge_ip_0;
  wire rxusrclk_gt_bridge_ip_0;
  wire tx_resetdone_out_gt_bridge_ip_0;
  wire txusrclk_gt_bridge_ip_0;
    wire ddr4_dimm1_act_n;
  wire [16:0]ddr4_dimm1_adr;
  wire [1:0]ddr4_dimm1_ba;
  wire [1:0]ddr4_dimm1_bg;
  wire ddr4_dimm1_ck_c;
  wire ddr4_dimm1_ck_t;
  wire ddr4_dimm1_cke;
  wire ddr4_dimm1_cs_n;
  wire [7:0]ddr4_dimm1_dm_n;
  wire [63:0]ddr4_dimm1_dq;
  wire [7:0]ddr4_dimm1_dqs_c;
  wire [7:0]ddr4_dimm1_dqs_t;
  wire ddr4_dimm1_odt;
  wire ddr4_dimm1_reset_n;
  wire ddr4_dimm1_sma_clk_clk_n;
  wire ddr4_dimm1_sma_clk_clk_p;

  design_GT_wrapper design_GT_wrapper_i
       (.GT_Serial_grx_n(GT_Serial_grx_n),
        .GT_Serial_grx_p(GT_Serial_grx_p),
        .GT_Serial_gtx_n(GT_Serial_gtx_n),
        .GT_Serial_gtx_p(GT_Serial_gtx_p),
        .apb3clk_gt_bridge_ip_0(apb3clk_gt_bridge_ip_0),
        .apb3clk_quad(apb3clk_quad),
        .gt_bridge_ip_0_diff_gt_ref_clock_clk_n(gt_bridge_ip_0_diff_gt_ref_clock_clk_n),
        .gt_bridge_ip_0_diff_gt_ref_clock_clk_p(gt_bridge_ip_0_diff_gt_ref_clock_clk_p),
        .gt_reset_gt_bridge_ip_0(gt_reset_gt_bridge_ip_0),
        .lcpll_lock_gt_bridge_ip_0(lcpll_lock_gt_bridge_ip_0),
        .link_status_gt_bridge_ip_0(link_status_gt_bridge_ip_0),
        .rate_sel_gt_bridge_ip_0(rate_sel_gt_bridge_ip_0),
        .rpll_lock_gt_bridge_ip_0(rpll_lock_gt_bridge_ip_0),
        .rx_resetdone_out_gt_bridge_ip_0(rx_resetdone_out_gt_bridge_ip_0),
        .rxusrclk_gt_bridge_ip_0(rxusrclk_gt_bridge_ip_0),
        .tx_resetdone_out_gt_bridge_ip_0(tx_resetdone_out_gt_bridge_ip_0),
        .txusrclk_gt_bridge_ip_0(txusrclk_gt_bridge_ip_0));
  
  DDR_top DDR_top_i
       (.ddr4_dimm1_act_n(ddr4_dimm1_act_n),
        .ddr4_dimm1_adr(ddr4_dimm1_adr),
        .ddr4_dimm1_ba(ddr4_dimm1_ba),
        .ddr4_dimm1_bg(ddr4_dimm1_bg),
        .ddr4_dimm1_ck_c(ddr4_dimm1_ck_c),
        .ddr4_dimm1_ck_t(ddr4_dimm1_ck_t),
        .ddr4_dimm1_cke(ddr4_dimm1_cke),
        .ddr4_dimm1_cs_n(ddr4_dimm1_cs_n),
        .ddr4_dimm1_dm_n(ddr4_dimm1_dm_n),
        .ddr4_dimm1_dq(ddr4_dimm1_dq),
        .ddr4_dimm1_dqs_c(ddr4_dimm1_dqs_c),
        .ddr4_dimm1_dqs_t(ddr4_dimm1_dqs_t),
        .ddr4_dimm1_odt(ddr4_dimm1_odt),
        .ddr4_dimm1_reset_n(ddr4_dimm1_reset_n),
        .ddr4_dimm1_sma_clk_clk_n(ddr4_dimm1_sma_clk_clk_n),
        .ddr4_dimm1_sma_clk_clk_p(ddr4_dimm1_sma_clk_clk_p));      
        
endmodule

