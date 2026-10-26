`timescale 1ns / 1ps

module top #(
    parameter BITS      = 48,
    parameter WIDTH     = 8
    ) 
    (
		input clk,
		input clk_n,
		
    
		inout   wire [BITS - 1 : 0] banka_data_pins                    ,
		input   wire [0 : 0]  banka_rxclk              ,
		input   wire [0 : 0]  banka_rxclk_n            ,
		output  wire [0 : 0]  banka_wrclk              ,
		output  wire [0 : 0]  banka_wrclk_n            ,
																		
		inout   wire [BITS - 1 : 0] bankb_data_pins                    ,
		input   wire [0 : 0] bankb_rxclk             ,
		input   wire [0 : 0] bankb_rxclk_n           ,
		output  wire [0 : 0]  bankb_wrclk             ,
		output  wire [0 : 0]  bankb_wrclk_n           ,
																		
		inout   wire [BITS - 1 : 0] bankc_data_pins                    ,
		input   wire [0 : 0]  bankc_rxclk            ,
		input   wire [0 : 0]  bankc_rxclk_n          ,
		output  wire [0 : 0]  bankc_wrclk            ,
		output  wire [0 : 0]  bankc_wrclk_n          ,

		inout   wire [BITS - 1 : 0] bankd_data_pins                    ,
		input   wire [0 : 0]  bankd_rxclk            ,
		input   wire [0 : 0]  bankd_rxclk_n          ,
		output  wire [0 : 0]  bankd_wrclk            ,
		output  wire [0 : 0]  bankd_wrclk_n          ,
																		
		inout   wire [BITS - 1 : 0] banke_data_pins                    ,
		input   wire [0 : 0]  banke_rxclk            ,
		input   wire [0 : 0]  banke_rxclk_n          ,
		output  wire [0 : 0]  banke_wrclk            ,
		output  wire [0 : 0]  banke_wrclk_n          ,
																		
		inout   wire [BITS - 1 : 0] bankf_data_pins                    ,
		input   wire [0 : 0]  bankf_rxclk            ,
		input   wire [0 : 0]  bankf_rxclk_n          ,
		output  wire [0 : 0]  bankf_wrclk            ,
		output  wire [0 : 0]  bankf_wrclk_n           
    );
    

    wire test_pass;
    wire ctrl_clk                                   ;
    wire en_vtc                                     ;
	assign en_vtc =1'b1;
	//per bank
    reg banka_rst_test_reg, bankb_rst_test_reg, bankc_rst_test_reg, bankd_rst_test_reg, banke_rst_test_reg, bankf_rst_test_reg;       
    reg banka_injer_reg   , bankb_injer_reg   , bankc_injer_reg   , bankd_injer_reg   , banke_injer_reg   , bankf_injer_reg   ;       
    reg banka_write_reg   , bankb_write_reg   , bankc_write_reg   , bankd_write_reg   , banke_write_reg   , bankf_write_reg   ;       


    wire 					banka_rst, 	bankb_rst, 	bankc_rst, 	bankd_rst, 	banke_rst, 	bankf_rst;
    wire 					banka_intf_rdy, 	bankb_intf_rdy, 	bankc_intf_rdy, 	bankd_intf_rdy, 	banke_intf_rdy, 	bankf_intf_rdy;
    reg 					banka_intf_rdy_reg, bankb_intf_rdy_reg, bankc_intf_rdy_reg, bankd_intf_rdy_reg, banke_intf_rdy_reg, bankf_intf_rdy_reg;
    reg [(BITS - 1) : 0] 	banka_injerr_reg, 	bankb_injerr_reg, 	bankc_injerr_reg, 	bankd_injerr_reg, 	banke_injerr_reg, 	bankf_injerr_reg 	 ;
    wire [8 : 0] 			banka_fifo_wr_clk,	bankb_fifo_wr_clk,	bankc_fifo_wr_clk,	bankd_fifo_wr_clk,	banke_fifo_wr_clk,	bankf_fifo_wr_clk;                        
    wire 					banka_fifo_rd_clk,                  bankb_fifo_rd_clk,                   bankc_fifo_rd_clk,                   bankd_fifo_rd_clk,                 banke_fifo_rd_clk,                   bankf_fifo_rd_clk                              ;
    wire 					banka_pll_clkout0,                  bankb_pll_clkout0,                   bankc_pll_clkout0,                   bankd_pll_clkout0,                 banke_pll_clkout0,                   bankf_pll_clkout0                             ;
    wire 					banka_pll_locked,                   bankb_pll_locked,                    bankc_pll_locked,                    bankd_pll_locked,                  banke_pll_locked,                    bankf_pll_locked                        ;
    wire 					banka_pll_rst_pll,                  bankb_pll_rst_pll,                   bankc_pll_rst_pll,                   bankd_pll_rst_pll,                 banke_pll_rst_pll,                   bankf_pll_rst_pll                        ;
    wire					banka_phy_rden_active_low, banka_phy_wren_active_low;
    wire					banka_phy_rden,                     bankb_phy_rden,                      bankc_phy_rden,                      bankd_phy_rden,                    banke_phy_rden,                      bankffe_phy_wren                            ;
    wire [8 : 0] 			banka_dly_rdy,                      bankb_dly_rdy,                       bankc_dly_rdy,                       bankd_dly_rdy,                     banke_dly_rdy,                       bankf_dly_rdy                          ;
    wire [8 : 0] 			banka_phy_rdy,                      bankb_phy_rdy,                       bankc_phy_rdy,                       bankd_phy_rdy,                     banke_phy_rdy,                       bankf_phy_rdy                          ;
    wire [8 : 0] 			banka_fifo_empty,                   bankb_fifo_empty,                    bankc_fifo_empty,                    bankd_fifo_empty,                  banke_fifo_empty,                    bankf_fifo_empty                       ;
    wire [8 : 0] 			banka_fifo_rd_en,                   bankb_fifo_rd_en,                    bankc_fifo_rd_en,                    bankd_fifo_rd_en,                  banke_fifo_rd_en,                    bankf_fifo_rd_en                       ;
    wire [8 : 0] 			banka_riu_wr_en,                    bankb_riu_wr_en,                     bankc_riu_wr_en,                     bankd_riu_wr_en,                   banke_riu_wr_en,                     bankf_riu_wr_en                        ;
    wire [143 : 0] 			banka_riu_wr_data,                  bankb_riu_wr_data,                   bankc_riu_wr_data,                   bankd_riu_wr_data,                 banke_riu_wr_data,                   bankf_riu_wr_data                    ;
    wire [7 : 0] 			banka_riu_addr,                     bankb_riu_addr,                      bankc_riu_addr,                      bankd_riu_addr,                    banke_riu_addr,                      bankf_riu_addr                        ;
    wire [8 : 0] 			banka_riu_nibble_sel,               bankb_riu_nibble_sel,                bankc_riu_nibble_sel,                bankd_riu_nibble_sel,              banke_riu_nibble_sel,                bankf_riu_nibble_sel                   ;
    wire [8 : 0] 			banka_riu_rd_valid,                 bankb_riu_rd_valid,                  bankc_riu_rd_valid,                  bankd_riu_rd_valid,                banke_riu_rd_valid,                  bankf_riu_rd_valid                     ;
    wire [143 : 0] 			banka_riu_rd_data,                  bankb_riu_rd_data,                   bankc_riu_rd_data,                   bankd_riu_rd_data,                 banke_riu_rd_data,                   bankf_riu_rd_data                    ;
    wire [423 : 0] 			banka_data_to_fabric_data_pins,  bankb_data_to_fabric_data_pins,   bankc_data_to_fabric_data_pins,   bankd_data_to_fabric_data_pins, banke_data_to_fabric_data_pins,   bankf_data_to_fabric_data_pins     ;
    wire  [7 : 0] 			banka_data_to_fabric_rxclk,      bankb_data_to_fabric_rxclk,       bankc_data_to_fabric_rxclk,       bankd_data_to_fabric_rxclk,     banke_data_to_fabric_rxclk,       bankf_data_to_fabric_rxclk          ;
    wire [423 : 0] 			banka_data_from_fabric_data_pins, bankb_data_from_fabric_data_pins,  bankc_data_from_fabric_data_pins,  bankd_data_from_fabric_data_pins,banke_data_from_fabric_data_pins,  bankf_data_from_fabric_data_pins     ;
    reg [7 : 0] 			banka_data_from_fabric_rxclk,    bankb_data_from_fabric_rxclk,     bankc_data_from_fabric_rxclk,     bankd_data_from_fabric_rxclk,   banke_data_from_fabric_rxclk,     bankf_data_from_fabric_rxclk          ;
    reg [7 : 0] 			banka_data_from_fabric_wrclk,    bankb_data_from_fabric_wrclk,     bankc_data_from_fabric_wrclk,     bankd_data_from_fabric_wrclk,   banke_data_from_fabric_wrclk,     bankf_data_from_fabric_wrclk          ;
    
   (* keep="true" *)    wire [(BITS - 1) * WIDTH +7 :0]	banka_fabric2xphy_prbs	, bankb_fabric2xphy_prbs, bankc_fabric2xphy_prbs, bankd_fabric2xphy_prbs, banke_fabric2xphy_prbs, bankf_fabric2xphy_prbs	;
   (* keep="true" *)    reg  [(BITS - 1) * WIDTH +7 :0]	banka_fabric2xphy_bli 	, bankb_fabric2xphy_bli , bankc_fabric2xphy_bli , bankd_fabric2xphy_bli , banke_fabric2xphy_bli , bankf_fabric2xphy_bli 	;
    reg [(BITS - 1) * WIDTH +7 :0] 	banka_fabric2xphy_d		, bankb_fabric2xphy_d	, bankc_fabric2xphy_d	, bankd_fabric2xphy_d	, banke_fabric2xphy_d	, bankf_fabric2xphy_d		;
    reg   [(BITS - 1)*WIDTH + 7:0]	banka_phy2fabric_q		, bankb_phy2fabric_q	, bankc_phy2fabric_q	, bankd_phy2fabric_q	, banke_phy2fabric_q	, bankf_phy2fabric_q		;
    (* keep="true" *) wire  [(BITS - 1)*WIDTH + 7:0]	banka_phy2fabric_bli    , bankb_phy2fabric_bli  , bankc_phy2fabric_bli  , bankd_phy2fabric_bli  , banke_phy2fabric_bli  , bankf_phy2fabric_bli  	;
    reg                     banka_prbs_gen_rst, bankb_prbs_gen_rst, bankc_prbs_gen_rst, bankd_prbs_gen_rst, banke_prbs_gen_rst, bankf_prbs_gen_rst;
    reg                     banka_prbs_chk_rst, bankb_prbs_chk_rst, bankc_prbs_chk_rst, bankd_prbs_chk_rst, banke_prbs_chk_rst, bankf_prbs_chk_rst;
    reg                     banka_int_test_startgen, bankb_int_test_startgen, bankc_int_test_startgen, bankd_int_test_startgen, banke_int_test_startgen, bankf_int_test_startgen;
    reg                     banka_int_test_startchk, bankb_int_test_startchk, bankc_int_test_startchk, bankd_int_test_startchk, banke_int_test_startchk, bankf_int_test_startchk;


    // Simulation or VIO signals
	wire  banka_rst_test, bankb_rst_test, bankc_rst_test, bankd_rst_test, banke_rst_test, bankf_rst_test                                         ;
	wire  banka_injerr,   bankb_injerr,   bankc_injerr,   bankd_injerr,   banke_injerr,   bankf_injerr                                           ;
	wire  banka_write,    bankb_write,    bankc_write,    bankd_write,    banke_write,    bankf_write                                            ;
	(* keep="true" *)    wire  [(BITS - 1)*WIDTH + 7:0]	 banka_prbs_error, bankb_prbs_error, bankc_prbs_error, bankd_prbs_error, banke_prbs_error, bankf_prbs_error  ;
    wire [BITS -1: 0] banka_vio_err, bankb_vio_err, bankc_vio_err, bankd_vio_err, banke_vio_err, bankf_vio_err;


    reg        int_test_done;
    reg        int_test_pass;
    reg toggle_fifo_wr_clk;
    reg toggle_fifo_wr_clk_deskewed;

    

///////////////////////// bank a ////////////////////////////////////////////////////////////////////////////
    design_block inst_wiz_dut ();
	
	axis_vio_bank_reset_controls inst_vio_bank_reset_controls (
        .clk              (clk_bufg),

		.probe_out0      (banka_pll_rst_pll),
		.probe_out1      (bankb_pll_rst_pll),
		.probe_out2      (bankc_pll_rst_pll),
		.probe_out3      (bankd_pll_rst_pll),
		.probe_out4      (banke_pll_rst_pll),
		.probe_out5      (bankf_pll_rst_pll)
	);
	

    always @ (posedge banka_fifo_wr_clk_deskewed_bufg) 
        begin
            banka_rst_test_reg   = banka_rst_test   ;
            banka_injerr_reg      = banka_injerr      ;
            banka_write_reg      = banka_write      ;
        end

	assign banka_vio_err = {banka_prbs_error[376], banka_prbs_error[368], banka_prbs_error[360], banka_prbs_error[352], banka_prbs_error[344], banka_prbs_error[336], banka_prbs_error[328], banka_prbs_error[320], banka_prbs_error[312], banka_prbs_error[304], banka_prbs_error[296], banka_prbs_error[288], banka_prbs_error[280], banka_prbs_error[272], banka_prbs_error[264], banka_prbs_error[256], banka_prbs_error[248], banka_prbs_error[240], banka_prbs_error[232], banka_prbs_error[224], banka_prbs_error[216], banka_prbs_error[208], banka_prbs_error[200], banka_prbs_error[192], banka_prbs_error[184], banka_prbs_error[176], banka_prbs_error[168], banka_prbs_error[160], banka_prbs_error[152], banka_prbs_error[144], banka_prbs_error[136], banka_prbs_error[128], banka_prbs_error[120], banka_prbs_error[112], banka_prbs_error[104], banka_prbs_error[96], banka_prbs_error[88], banka_prbs_error[80], banka_prbs_error[72], banka_prbs_error[64], banka_prbs_error[56], banka_prbs_error[48], banka_prbs_error[40], banka_prbs_error[32], banka_prbs_error[24], banka_prbs_error[16], banka_prbs_error[8], banka_prbs_error[0]};
	assign bankb_vio_err = {bankb_prbs_error[376], bankb_prbs_error[368], bankb_prbs_error[360], bankb_prbs_error[352], bankb_prbs_error[344], bankb_prbs_error[336], bankb_prbs_error[328], bankb_prbs_error[320], bankb_prbs_error[312], bankb_prbs_error[304], bankb_prbs_error[296], bankb_prbs_error[288], bankb_prbs_error[280], bankb_prbs_error[272], bankb_prbs_error[264], bankb_prbs_error[256], bankb_prbs_error[248], bankb_prbs_error[240], bankb_prbs_error[232], bankb_prbs_error[224], bankb_prbs_error[216], bankb_prbs_error[208], bankb_prbs_error[200], bankb_prbs_error[192], bankb_prbs_error[184], bankb_prbs_error[176], bankb_prbs_error[168], bankb_prbs_error[160], bankb_prbs_error[152], bankb_prbs_error[144], bankb_prbs_error[136], bankb_prbs_error[128], bankb_prbs_error[120], bankb_prbs_error[112], bankb_prbs_error[104], bankb_prbs_error[96], bankb_prbs_error[88], bankb_prbs_error[80], bankb_prbs_error[72], bankb_prbs_error[64], bankb_prbs_error[56], bankb_prbs_error[48], bankb_prbs_error[40], bankb_prbs_error[32], bankb_prbs_error[24], bankb_prbs_error[16], bankb_prbs_error[8], bankb_prbs_error[0]};
	assign bankc_vio_err = {bankc_prbs_error[376], bankc_prbs_error[368], bankc_prbs_error[360], bankc_prbs_error[352], bankc_prbs_error[344], bankc_prbs_error[336], bankc_prbs_error[328], bankc_prbs_error[320], bankc_prbs_error[312], bankc_prbs_error[304], bankc_prbs_error[296], bankc_prbs_error[288], bankc_prbs_error[280], bankc_prbs_error[272], bankc_prbs_error[264], bankc_prbs_error[256], bankc_prbs_error[248], bankc_prbs_error[240], bankc_prbs_error[232], bankc_prbs_error[224], bankc_prbs_error[216], bankc_prbs_error[208], bankc_prbs_error[200], bankc_prbs_error[192], bankc_prbs_error[184], bankc_prbs_error[176], bankc_prbs_error[168], bankc_prbs_error[160], bankc_prbs_error[152], bankc_prbs_error[144], bankc_prbs_error[136], bankc_prbs_error[128], bankc_prbs_error[120], bankc_prbs_error[112], bankc_prbs_error[104], bankc_prbs_error[96], bankc_prbs_error[88], bankc_prbs_error[80], bankc_prbs_error[72], bankc_prbs_error[64], bankc_prbs_error[56], bankc_prbs_error[48], bankc_prbs_error[40], bankc_prbs_error[32], bankc_prbs_error[24], bankc_prbs_error[16], bankc_prbs_error[8], bankc_prbs_error[0]};
	assign bankd_vio_err = {bankd_prbs_error[376], bankd_prbs_error[368], bankd_prbs_error[360], bankd_prbs_error[352], bankd_prbs_error[344], bankd_prbs_error[336], bankd_prbs_error[328], bankd_prbs_error[320], bankd_prbs_error[312], bankd_prbs_error[304], bankd_prbs_error[296], bankd_prbs_error[288], bankd_prbs_error[280], bankd_prbs_error[272], bankd_prbs_error[264], bankd_prbs_error[256], bankd_prbs_error[248], bankd_prbs_error[240], bankd_prbs_error[232], bankd_prbs_error[224], bankd_prbs_error[216], bankd_prbs_error[208], bankd_prbs_error[200], bankd_prbs_error[192], bankd_prbs_error[184], bankd_prbs_error[176], bankd_prbs_error[168], bankd_prbs_error[160], bankd_prbs_error[152], bankd_prbs_error[144], bankd_prbs_error[136], bankd_prbs_error[128], bankd_prbs_error[120], bankd_prbs_error[112], bankd_prbs_error[104], bankd_prbs_error[96], bankd_prbs_error[88], bankd_prbs_error[80], bankd_prbs_error[72], bankd_prbs_error[64], bankd_prbs_error[56], bankd_prbs_error[48], bankd_prbs_error[40], bankd_prbs_error[32], bankd_prbs_error[24], bankd_prbs_error[16], bankd_prbs_error[8], bankd_prbs_error[0]};
	assign banke_vio_err = {banke_prbs_error[376], banke_prbs_error[368], banke_prbs_error[360], banke_prbs_error[352], banke_prbs_error[344], banke_prbs_error[336], banke_prbs_error[328], banke_prbs_error[320], banke_prbs_error[312], banke_prbs_error[304], banke_prbs_error[296], banke_prbs_error[288], banke_prbs_error[280], banke_prbs_error[272], banke_prbs_error[264], banke_prbs_error[256], banke_prbs_error[248], banke_prbs_error[240], banke_prbs_error[232], banke_prbs_error[224], banke_prbs_error[216], banke_prbs_error[208], banke_prbs_error[200], banke_prbs_error[192], banke_prbs_error[184], banke_prbs_error[176], banke_prbs_error[168], banke_prbs_error[160], banke_prbs_error[152], banke_prbs_error[144], banke_prbs_error[136], banke_prbs_error[128], banke_prbs_error[120], banke_prbs_error[112], banke_prbs_error[104], banke_prbs_error[96], banke_prbs_error[88], banke_prbs_error[80], banke_prbs_error[72], banke_prbs_error[64], banke_prbs_error[56], banke_prbs_error[48], banke_prbs_error[40], banke_prbs_error[32], banke_prbs_error[24], banke_prbs_error[16], banke_prbs_error[8], banke_prbs_error[0]};
	assign bankf_vio_err = {bankf_prbs_error[376], bankf_prbs_error[368], bankf_prbs_error[360], bankf_prbs_error[352], bankf_prbs_error[344], bankf_prbs_error[336], bankf_prbs_error[328], bankf_prbs_error[320], bankf_prbs_error[312], bankf_prbs_error[304], bankf_prbs_error[296], bankf_prbs_error[288], bankf_prbs_error[280], bankf_prbs_error[272], bankf_prbs_error[264], bankf_prbs_error[256], bankf_prbs_error[248], bankf_prbs_error[240], bankf_prbs_error[232], bankf_prbs_error[224], bankf_prbs_error[216], bankf_prbs_error[208], bankf_prbs_error[200], bankf_prbs_error[192], bankf_prbs_error[184], bankf_prbs_error[176], bankf_prbs_error[168], bankf_prbs_error[160], bankf_prbs_error[152], bankf_prbs_error[144], bankf_prbs_error[136], bankf_prbs_error[128], bankf_prbs_error[120], bankf_prbs_error[112], bankf_prbs_error[104], bankf_prbs_error[96], bankf_prbs_error[88], bankf_prbs_error[80], bankf_prbs_error[72], bankf_prbs_error[64], bankf_prbs_error[56], bankf_prbs_error[48], bankf_prbs_error[40], bankf_prbs_error[32], bankf_prbs_error[24], bankf_prbs_error[16], bankf_prbs_error[8], bankf_prbs_error[0]};


    
	axis_vio_singlebank      inst_vio_banka (
        .clk             (banka_pll_clkout0),
		.probe_in0       (banka_vio_err),

		.probe_out0      (banka_rst_test),
		.probe_out1      (banka_injerr),                  
		.probe_out2      (banka_write)                  
	);

	// ----Bank B---- //
    always @ (posedge bankb_fifo_wr_clk_deskewed_bufg) 
        begin
            bankb_rst_test_reg   = bankb_rst_test   ;
            bankb_injerr_reg     = bankb_injerr      ;
            bankb_write_reg      = bankb_write      ;
        end


    axis_vio_singlebank		inst_vio_bankb (
        .clk             (bankb_pll_clkout0),
		.probe_in0       (bankb_vio_err),

		.probe_out0      (bankb_rst_test),
		.probe_out1      (bankb_injerr),                
		.probe_out2      (bankb_write)               
	);
	
							
	// ----Bank C---- //
    always @ (posedge bankc_fifo_wr_clk_deskewed_bufg) 
        begin
            bankc_rst_test_reg   = bankc_rst_test   ;
            bankc_injer_reg      = bankc_injerr      ;
            bankc_write_reg      = bankc_write      ;
        end



    axis_vio_singlebank		inst_vio_bankc (
        .clk             (bankc_pll_clkout0),  
		.probe_in0       (bankc_vio_err),

		.probe_out0      (bankc_rst_test),
		.probe_out1      (bankc_injerr),       
		.probe_out2      (bankc_write)         
	);

							
		// ----Bank D---- //
    always @ (posedge bankd_fifo_wr_clk_deskewed_bufg) 
        begin
            bankd_rst_test_reg   = bankd_rst_test   ;
            bankd_injerr_reg     = bankd_injerr      ;
            bankd_write_reg      = bankd_write      ;
        end
            
            
 
    axis_vio_singlebank		inst_vio_bankd (
        .clk             (bankd_pll_clkout0),  
		.probe_in0       (bankd_vio_err),

		.probe_out0      (bankd_rst_test),
		.probe_out1      (bankd_injerr),       
		.probe_out2      (bankd_write)         
	);
						
		// ----Bank E---- //
    always @ (posedge banke_fifo_wr_clk_deskewed_bufg) 
        begin
            banke_rst_test_reg   = banke_rst_test   ;
            banke_injerr_reg     = banke_injerr      ;
            banke_write_reg      = banke_write      ;
        end

    axis_vio_singlebank		inst_vio_banke (
        .clk             (banke_pll_clkout0),  
		.probe_in0       (banke_vio_err),

		.probe_out0      (banke_rst_test),
		.probe_out1      (banke_injerr),       
		.probe_out2      (banke_write)         
	);

						
		// ----Bank F---- /
    always @ (posedge bankf_fifo_wr_clk_deskewed_bufg) 
        begin
            bankf_rst_test_reg   = bankf_rst_test   ;
            bankf_injerr_reg     = bankf_injerr      ;
            bankf_write_reg      = bankf_write      ;
        end


            
    axis_vio_singlebank		inst_vio_bankf (
        .clk             (bankf_pll_clkout0),  
		.probe_in0       (bankf_vio_err),

		.probe_out0      (bankf_rst_test),
		.probe_out1      (bankf_injerr),       
		.probe_out2      (bankf_write)         
	);



    
    
    IBUFDS inst_ibufds_clk (.I(clk), .IB(clk_n), .O(clk_ibuf) );
    BUFG inst_bufg_clk (.I(clk_ibuf), .O(clk_bufg) );

   always @ (posedge bankb_fifo_wr_clk_bufg)
   	toggle_fifo_wr_clk = ! toggle_fifo_wr_clk;
   
   always @ (posedge bankb_fifo_wr_clk_deskewed_bufg)
   	toggle_fifo_wr_clk_deskewed = ! toggle_fifo_wr_clk_deskewed;

///////////////////////// bank a ////////////////////////////////////////////////////////////////////////////
	advanced_io_wizard_bidir_singlebank inst_banka (
		.fifo_wr_clk	(banka_fifo_wr_clk),                      // output wire [8 : 0] fifo_wr_clk
		.intf_rdy		(banka_intf_rdy),                         // output wire intf_rdyodule
		.ctrl_clk       ( clk_bufg),                              //  input wire ctrl_clk
		.en_vtc		    (en_vtc),                                 //  input wire en_vtc
		.rst			(banka_pll_rst_pll ),                     //  input wire rst
		.bank0_pll_clkout0	(banka_pll_clkout0),                  // output wire bank0_pll_clkout0
		.bank0_pll_clkout2    (),                                 // output wire bank0_pll_clkout2
		.pll0_clkout0         (),                                 // output wire pll0_clkout0
		.bank0_pll_clkout3	(banka_pll_clkout3),                  // output wire bank0_pll_clkout3
		.bank0_pll_clkoutphy	(banka_pll_clkoutphy),            // output wire bank0_pll_clkoutphy
		.bank0_pll_locked		(banka_pll_locked),               // output wire bank0_pll_locked
		.bank0_pll_clkin        (clk_bufg),                       //  input wire bank0_pll_clkin
		.bank0_pll_rst_pll	(banka_pll_rst_pll),                  //  input wire bank0_pll_rst_pll
		.phy_rden           ({36{banka_intf_rdy}}),               // input wire [35 : 0] phy_rden
		.t_data_pins     ({2'b00, {49 { ! banka_write}} }),       // input wire [51 : 0] t_data_pins
		.t_rxclk	     (1),                                     // input wire [0 : 0] t_rxclk
		.t_wrclk	     (0),                                     // input wire [0 : 0] t_wrclk  
		.dly_rdy				(banka_dly_rdy),                  // output wire [8 : 0] dly_rdy
		.phy_rdy				(banka_phy_rdy),                  // output wire [8 : 0] phy_rdy
		.fifo_empty			(banka_fifo_empty),                   // output wire [8 : 0] fifo_empty
		.fifo_rd_en			( ~ banka_fifo_empty ),               //  input wire [8 : 0] fifo_rd_en
		.data_pins			(banka_data_pins),                    //  input wire [52 : 0] data_pins
		.data_from_fabric_data_pins		(banka_fabric2xphy_bli ), //({banka_fabric2xphy_d } ),  // input wire [415 : 0] data_from_fabric_data_pins              
		.data_to_fabric_data_pins   (banka_phy2fabric_bli),       // output wire [423 : 0] data_to_fabric_data_pins
		.rxclk_p				(banka_rxclk),                    //  input wire [0 : 0] rxclk
		.rxclk_n				(banka_rxclk_n),                  //  input wire [0 : 0] rxclk
		.data_to_fabric_rxclk(banka_data_to_fabric_rxclk),        // output wire [7 : 0] data_to_fabric_rxclk
		.wrclk_p              (banka_wrclk),                      // output wire [0 : 0] wrclk
		.wrclk_n              (banka_wrclk_n),                    // output wire [0 : 0] wrclk
		.data_from_fabric_wrclk   (banka_data_from_fabric_wrclk)  // input wire [7 : 0] data_from_fabric_wrclk		  
	);


    always @ (posedge banka_fifo_wr_clk_deskewed_bufg ) 
        begin
            banka_phy2fabric_q = banka_phy2fabric_bli;
            banka_int_test_startchk <= banka_intf_rdy_reg;           
            banka_prbs_chk_rst <= ! banka_intf_rdy_reg;
        end

	always @ (posedge banka_pll_clkout0)
	   begin
	        banka_intf_rdy_reg <= banka_intf_rdy;
            banka_fabric2xphy_bli  <= banka_fabric2xphy_prbs;
    		banka_int_test_startgen <= banka_intf_rdy_reg; 
    		banka_data_from_fabric_wrclk = banka_int_test_startgen ? 8'h55:8'h00; // Using a continuous clock for bypass/sync deskewing to work
    	end


	XPLL #(
		.CLKFBOUT_MULT(16),               //400*8/2 = 3200 MHz vcolimits are: 2160 to 4320             // Multiply value for all CLKOUT, (4-43)
		.CLKFBOUT_PHASE(0.0),             // Phase offset in degrees of CLKFB
		.CLKIN_PERIOD(2.500),             //400mhz              // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
		.CLKOUT0_DIVIDE(8),               //3200/8= 400 MHz               // Divide amount for CLKOUT0 (2-128)
		.CLKOUT0_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT0
		.CLKOUT0_PHASE(0.0),              // Phase offset for CLKOUT0
		.CLKOUT0_PHASE_CTRL(2'b01),       // CLKOUT0 fine phase shift or deskew select (0-11)
		.CLKOUT1_DIVIDE(8),               //demo (16),               // Divide amount for CLKOUT1 (2-128)
		.CLKOUT1_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT1
		.CLKOUT1_PHASE(-  84.375),        //xpll_est 400 8 550 //(- 146.25), //-146.25 based on xpll_est 400 8 1000 //188.4375 //xpll_est 400 16 1300 to reduce setup slack violations              // Phase offset for CLKOUT1
		.CLKOUT1_PHASE_CTRL(2'b00),       // CLKOUT1 fine phase shift or deskew select (0-11)
		.CLKOUT2_DIVIDE(2),               // Divide amount for CLKOUT2 (2-128)
		.CLKOUT2_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT2
		.CLKOUT2_PHASE(0.0),              // Phase offset for CLKOUT2
		.CLKOUT2_PHASE_CTRL(2'b00),       // CLKOUT2 fine phase shift or deskew select (0-11)
		.CLKOUT3_DIVIDE(2),               // Divide amount for CLKOUT3 (2-128)
		.CLKOUT3_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT3
		.CLKOUT3_PHASE(0.0),              // Phase offset for CLKOUT3
		.CLKOUT3_PHASE_CTRL(2'b00),       // CLKOUT3 fine phase shift or deskew select (0-11)
		.CLKOUTPHY_CASCIN_EN(1'b0),       // XPLL CLKOUTPHY cascade input enable
		.CLKOUTPHY_CASCOUT_EN(1'b0),      // XPLL CLKOUTPHY cascade output enable
		.DESKEW2_MUXIN_SEL(1'b0),         // Deskew mux selection
		.DESKEW_DELAY1( 0),                // Deskew optional programmable delay
		.DESKEW_DELAY2(0),                // Deskew optional programmable delay
		.DESKEW_DELAY_EN1("TRUE"),        // Enable deskew optional programmable delay
		.DESKEW_DELAY_EN2("FALSE"),       // Enable deskew optional programmable delay
		.DESKEW_DELAY_PATH1("TRUE"),      // Select CLKIN1_DESKEW (TRUE) or CLKFB1_DESKEW (FALSE)
		.DESKEW_DELAY_PATH2("FALSE"),     // Select CLKIN2_DESKEW (TRUE) or CLKFB2_DESKEW (FALSE)
		.DESKEW_MUXIN_SEL(1'b0),          // Deskew mux selection
		.DIVCLK_DIVIDE(2), //demo (1),                // Master division value
		.LOCK_WAIT("FALSE"),              // Lock wait
		.REF_JITTER(0.0),                 // Reference input jitter in UI (0.000-0.200).
		.SIM_ADJ_CLK0_CASCADE("FALSE"),   // Simulation only attribute to reduce CLKOUT0 skew when cascading
										  // (FALSE, TRUE)
		.XPLL_CONNECT_TO_NOCMC("NONE")    // XPLL driving the DDRMC
	)
	XPLL_banka_inst (
		.CLKOUT0(banka_clk0),             // 1-bit output: CLKOUT0
		.CLKOUT1(banka_clk1),             // 1-bit output: CLKOUT1
		.CLKOUT2	(),                   // 1-bit output: CLKOUT2
		.CLKOUT3	(),                   // 1-bit output: CLKOUT3
		.CLKOUTPHY	(),                   // 1-bit output: XPHY Logic clock
		.CLKOUTPHY_CASC_OUT(),            //1-bit output: XPLL CLKOUTPHY cascade output
		.DO		(),                       // 16-bit output: DRP data output
		.DRDY	(),                       // 1-bit output: DRP ready
		.LOCKED(banka_deskew_pll_locked), // 1-bit output: LOCK
		.LOCKED1_DESKEW(),                // 1-bit output: LOCK DESKEW PD1
		.LOCKED2_DESKEW(),                // 1-bit output: LOCK DESKEW PD2
		.LOCKED_FB(),                     // 1-bit output: LOCK FEEDBACK
		.PSDONE	(),                       // 1-bit output: Phase shift done
		.CLKFB1_DESKEW  (banka_fifo_wr_clk_deskewed_bufg), // 1-bit input: Secondary clock input to PD1
		.CLKFB2_DESKEW(),                 // 1-bit input: Secondary clock input to PD2
		.CLKIN   (banka_fifo_wr_clk[2]),  // 1-bit input: Primary clock
		.CLKIN1_DESKEW  (banka_clk1),     // 1-bit input: Primary clock input to PD1
		.CLKIN2_DESKEW(),                 // 1-bit input: Primary clock input to PD2
		.CLKOUTPHYEN(),                   // 1-bit input: CLKOUTPHY enable
		.CLKOUTPHY_CASC_IN(),             // 1-bit input: XPLL CLKOUTPHY cascade input
		.DADDR(),                         // 7-bit input: DRP address
		.DCLK    (1'b0),                  // 1-bit input: DRP clock
		.DEN(1'b0),                       // 1-bit input: DRP enable
		.DI(),                            // 16-bit input: DRP data input
		.DWE(),                           // 1-bit input: DRP write enable
		.PSCLK (),                        // 1-bit input: Phase shift clock
		.PSEN(1'b0),                      // 1-bit input: Phase shift enable
		.PSINCDEC(),                      // 1-bit input: Phase shift increment/decrement
		.PWRDWN(1'b0),                    // 1-bit input: Power-down
		.RST(! banka_intf_rdy_reg)        // 1-bit input: Reset
	);
	
	BUFG insta_deskewpll_wr_clk_bufg (.I(banka_fifo_wr_clk[2]), .O(banka_fifo_wr_clk_bufg) );
	BUFG insta_deskewpll_clk0_bufg   (.I(banka_clk0), 			.O(banka_fifo_wr_clk_deskewed_bufg) );


    
    

///////////////////////// bank b ////////////////////////////////////////////////////////////////////////////
	advanced_io_wizard_bidir_singlebank inst_bankb (
		.fifo_wr_clk      (bankb_fifo_wr_clk),                     // output wire [8 : 0] fifo_wr_clk
		.intf_rdy         (bankb_intf_rdy),                        // output wire intf_rdyodule
		.ctrl_clk         ( clk_bufg ),                            //  input wire ctrl_clk
		.en_vtc           (en_vtc),                                //  input wire en_vtc
		.rst              (bankb_pll_rst_pll ),                    //  input wire rst
		.bank0_pll_clkout0	(bankb_pll_clkout0),                   // output wire bank0_pll_clkout0
		.bank0_pll_clkout3	(bankb_pll_clkout3),                   // output wire bank0_pll_clkout3
		.bank0_pll_clkoutphy	(bankb_pll_clkoutphy),             // output wire bank0_pll_clkoutphy
		.bank0_pll_locked		(bankb_pll_locked),                // output wire bank0_pll_locked
		.bank0_pll_clkin        (clk_bufg),                        //  input wire bank0_pll_clkin
		.bank0_pll_rst_pll	(bankb_pll_rst_pll),                   //  input wire bank0_pll_rst_pll
		.phy_rden           ({36{bankb_intf_rdy}}),                // input wire [35 : 0] phy_rden
		.t_data_pins        ({2'b00, {49 { ! bankb_write}} }),     // input wire [51 : 0] t_data_pins
		.t_rxclk	        (1),                                   // input wire [0 : 0] t_rxclk
		.t_wrclk		    (0),                                   // input wire [0 : 0] t_wrclk  
		.dly_rdy			(bankb_dly_rdy),                       // output wire [8 : 0] dly_rdy
		.phy_rdy			(bankb_phy_rdy),                       // output wire [8 : 0] phy_rdy
		.fifo_empty			(bankb_fifo_empty),                    // output wire [8 : 0] fifo_empty
		.fifo_rd_en			( ~ bankb_fifo_empty ),                //  input wire [8 : 0] fifo_rd_en
		.data_pins			(bankb_data_pins),                     //  input wire [52 : 0] data_pins
		.data_from_fabric_data_pins	    (bankb_fabric2xphy_bli ),  // input wire [415 : 0] data_from_fabric_data_pins              
		.data_to_fabric_data_pins   (bankb_phy2fabric_bli),        // output wire [423 : 0] data_to_fabric_data_pins
		.rxclk_p				(bankb_rxclk),                     //  input wire [0 : 0] rxclk
		.rxclk_n				(bankb_rxclk_n),                   //  input wire [0 : 0] rxclk
		.data_to_fabric_rxclk(bankb_data_to_fabric_rxclk),         // output wire [7 : 0] data_to_fabric_rxclk
		.wrclk_p(bankb_wrclk),                                     // output wire [0 : 0] wrclk
		.wrclk_n(bankb_wrclk_n),                                   // output wire [0 : 0] wrclk
		.data_from_fabric_wrclk(bankb_data_from_fabric_wrclk)      // input wire [7 : 0] data_from_fabric_wrclk		  
	);

    always @ (posedge bankb_fifo_wr_clk_deskewed_bufg ) 
		begin
			bankb_phy2fabric_q      <= bankb_phy2fabric_bli;
			bankb_int_test_startchk <= bankb_intf_rdy_reg;       
            bankb_prbs_chk_rst      <= ! bankb_intf_rdy_reg;
		end
		
	always @ (posedge bankb_pll_clkout0)
		begin
			bankb_intf_rdy_reg       <= bankb_intf_rdy;          
			bankb_int_test_startgen  <= bankb_intf_rdy_reg;      
			bankb_data_from_fabric_wrclk     <= bankb_int_test_startgen  ? 8'h55:8'h00; //Using continuous wrclk to support Rx Sync/Bypass deskew circuits
            bankb_fabric2xphy_bli   <= bankb_fabric2xphy_prbs;
		end
			
	XPLL #(
		.CLKFBOUT_MULT(16),               //400*8/2 = 3200 MHz vcolimits are: 2160 to 4320             // Multiply value for all CLKOUT, (4-43)
		.CLKFBOUT_PHASE(0.0),             // Phase offset in degrees of CLKFB
		.CLKIN_PERIOD(2.500),             //400mhz              // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
		.CLKOUT0_DIVIDE(8),               //3200/8= 400 MHz               // Divide amount for CLKOUT0 (2-128)
		.CLKOUT0_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT0
		.CLKOUT0_PHASE(0.0),              // Phase offset for CLKOUT0
		.CLKOUT0_PHASE_CTRL(2'b01),       // CLKOUT0 fine phase shift or deskew select (0-11)
		.CLKOUT1_DIVIDE(8),               //demo (16),               // Divide amount for CLKOUT1 (2-128)
		.CLKOUT1_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT1
		.CLKOUT1_PHASE(-  84.375),        //xpll_est 400 8 550 //(- 146.25), //188.4375 //xpll_est 400 16 1300 to reduce setup slack violations              // Phase offset for CLKOUT1
		.CLKOUT1_PHASE_CTRL(2'b00),       // CLKOUT1 fine phase shift or deskew select (0-11)
		.CLKOUT2_DIVIDE(2),               // Divide amount for CLKOUT2 (2-128)
		.CLKOUT2_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT2
		.CLKOUT2_PHASE(0.0),              // Phase offset for CLKOUT2
		.CLKOUT2_PHASE_CTRL(2'b00),       // CLKOUT2 fine phase shift or deskew select (0-11)
		.CLKOUT3_DIVIDE(2),               // Divide amount for CLKOUT3 (2-128)
		.CLKOUT3_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT3
		.CLKOUT3_PHASE(0.0),              // Phase offset for CLKOUT3
		.CLKOUT3_PHASE_CTRL(2'b00),       // CLKOUT3 fine phase shift or deskew select (0-11)
		.CLKOUTPHY_CASCIN_EN(1'b0),       // XPLL CLKOUTPHY cascade input enable
		.CLKOUTPHY_CASCOUT_EN(1'b0),      // XPLL CLKOUTPHY cascade output enable
		.DESKEW2_MUXIN_SEL(1'b0),         // Deskew mux selection
		.DESKEW_DELAY2(0),                // Deskew optional programmable delay
		.DESKEW_DELAY_EN1("TRUE"),        // Enable deskew optional programmable delay
		.DESKEW_DELAY_EN2("FALSE"),       // Enable deskew optional programmable delay
		.DESKEW_DELAY_PATH1("TRUE"),      // Select CLKIN1_DESKEW (TRUE) or CLKFB1_DESKEW (FALSE)
		.DESKEW_DELAY_PATH2("FALSE"),     // Select CLKIN2_DESKEW (TRUE) or CLKFB2_DESKEW (FALSE)
		.DESKEW_MUXIN_SEL(1'b0),          // Deskew mux selection
		.DIVCLK_DIVIDE(2),                // Master division value
		.LOCK_WAIT("FALSE"),              // Lock wait
		.REF_JITTER(0.0),                 // Reference input jitter in UI (0.000-0.200).
		.SIM_ADJ_CLK0_CASCADE("FALSE"),   // Simulation only attribute to reduce CLKOUT0 skew when cascading
										  // (FALSE, TRUE)
		.XPLL_CONNECT_TO_NOCMC("NONE")    // XPLL driving the DDRMC
	)

	XPLL_bankb_inst (
		.CLKOUT0(bankb_clk0),             // 1-bit output: CLKOUT0
		.CLKOUT1(bankb_clk1),             // 1-bit output: CLKOUT1
		.CLKOUT2(),                       // 1-bit output: CLKOUT2
		.CLKOUT3(),                       // 1-bit output: CLKOUT3
		.CLKOUTPHY(),                     // 1-bit output: XPHY Logic clock
		.CLKOUTPHY_CASC_OUT(),            // 1-bit output: XPLL CLKOUTPHY cascade output
		.DO(),                            // 1-bit output: LOCK DESKEW PD1
		.LOCKED2_DESKEW(),                // 1-bit output: LOCK DESKEW PD2 
		.LOCKED_FB(),                     // 1-bit output: LOCK FEEDBACK
		.PSDONE(),                         // 1-bit output: Phase shift done
		.CLKFB1_DESKEW(bankb_fifo_wr_clk_deskewed_bufg),           // 1-bit input: Secondary clock input to PD1
		.CLKFB2_DESKEW(),                 // 1-bit input: Secondary clock input to PD2
		.CLKIN	(bankb_fifo_wr_clk[2]),   // 1-bit input: Primary clock
		.CLKIN1_DESKEW(bankb_clk1),       // 1-bit input: Primary clock input to PD1
		.CLKIN2_DESKEW(),                 // 1-bit input: Primary clock input to PD2
		.CLKOUTPHYEN(),                   // 1-bit input: CLKOUTPHY enable
		.CLKOUTPHY_CASC_IN(),             // 1-bit input: XPLL CLKOUTPHY cascade input
		.DADDR(),                         // 7-bit input: DRP address
		.DCLK    (1'b0),                  // 1-bit input: DRP clock
		.DEN(1'b0),                       // 1-bit input: DRP enable
		.DI(),                            // 16-bit input: DRP data input
		.DWE(),                           // 1-bit input: DRP write enable
		.PSCLK (),                        // 1-bit input: Phase shift clock
		.PSEN(1'b0),                      // 1-bit input: Phase shift enable
		.PSINCDEC(),                      // 1-bit input: Phase shift increment/decrement
		.PWRDWN(1'b0),                    // 1-bit input: Power-down
		.RST(! bankb_intf_rdy_reg)        // 1-bit input: Reset
	);
	BUFG instb_deskewpll_wr_clk_bufg (.I(bankb_fifo_wr_clk[2]), .O(bankb_fifo_wr_clk_bufg) );
	BUFG instb_deskewpll_clk0_bufg   (.I(bankb_clk0), .O(bankb_fifo_wr_clk_deskewed_bufg) );
   

            


///////////////////////// bank c ////////////////////////////////////////////////////////////////////////////
	advanced_io_wizard_bidir_singlebank inst_bankc (
		.fifo_wr_clk	(bankc_fifo_wr_clk),                      // output wire [8 : 0] fifo_wr_clk
		.intf_rdy		(bankc_intf_rdy),                         // output wire intf_rdyodule
		.ctrl_clk 	( clk_bufg ),                                 //  input wire ctrl_clk
		.en_vtc		(en_vtc),                                     //  input wire en_vtc
		.rst			(bankc_pll_rst_pll ),                     //  input wire rst
		.bank0_pll_clkout0	(bankc_pll_clkout0),                  // output wire bank0_pll_clkout0
		.bank0_pll_clkout2(),                                     // output wire bank0_pll_clkout2
		.pll0_clkout0(),                                          // output wire pll0_clkout0
		.bank0_pll_clkout3	(bankc_pll_clkout3),                  // output wire bank0_pll_clkout3
		.bank0_pll_clkoutphy	(bankc_pll_clkoutphy),            // output wire bank0_pll_clkoutphy
		.bank0_pll_locked		(bankc_pll_locked),               // output wire bank0_pll_locked
		.bank0_pll_clkin        (clk_bufg),                       //  input wire bank0_pll_clkin
		.bank0_pll_rst_pll	(bankc_pll_rst_pll),                  //  input wire bank0_pll_rst_pll
		.phy_rden               ({36{bankc_intf_rdy}}),           // input wire [35 : 0] phy_rden
		.t_data_pins  ({2'b00, {49 { ! bankc_write}} }),          // input wire [51 : 0] t_data_pins
		.t_rxclk	(1),                                          // input wire [0 : 0] t_rxclk
		.t_wrclk		(0),                                      // input wire [0 : 0] t_wrclk  
		.dly_rdy				(bankc_dly_rdy),                  // output wire [8 : 0] dly_rdy
		.phy_rdy				(bankc_phy_rdy),                  // output wire [8 : 0] phy_rdy
		.fifo_empty			(bankc_fifo_empty),                   // output wire [8 : 0] fifo_empty
		.fifo_rd_en			( ~ bankc_fifo_empty ),               //  input wire [8 : 0] fifo_rd_en
		.data_pins			(bankc_data_pins),                    //  input wire [52 : 0] data_pins
		.data_from_fabric_data_pins	    (bankc_fabric2xphy_bli ), // input wire [415 : 0] data_from_fabric_data_pins              
		.data_to_fabric_data_pins   (bankc_phy2fabric_bli),       // output wire [423 : 0] data_to_fabric_data_pins
		.rxclk_p				(bankc_rxclk),                    //  input wire [0 : 0] rxclk
		.rxclk_n				(bankc_rxclk_n),                  //  input wire [0 : 0] rxclk
		.data_to_fabric_rxclk(bankc_data_to_fabric_rxclk)  ,      // output wire [7 : 0] data_to_fabric_rxclk
		.wrclk_p(bankc_wrclk),                                    // output wire [0 : 0] wrclk
		.wrclk_n(bankc_wrclk_n),                                  // output wire [0 : 0] wrclk
		.data_from_fabric_wrclk(bankc_data_from_fabric_wrclk)     // input wire [7 : 0] data_from_fabric_wrclk		  
	);
	
    always @ (posedge bankc_fifo_wr_clk_deskewed_bufg ) 
		begin
			bankc_phy2fabric_q      <= bankc_phy2fabric_bli;
			bankc_int_test_startchk <= bankc_intf_rdy_reg;   
            bankc_prbs_chk_rst      <= ! bankc_intf_rdy_reg;
		end
		
	always @ (posedge bankc_pll_clkout0)
		begin
			bankc_intf_rdy_reg       <= bankc_intf_rdy; 
			bankc_int_test_startgen  <= bankc_intf_rdy_reg; 
			bankc_data_from_fabric_wrclk     <= bankc_int_test_startgen  ? 8'h55:8'h00; 
            bankc_fabric2xphy_bli    = bankc_fabric2xphy_prbs;
		end
			
	XPLL #(
		.CLKFBOUT_MULT(16),               //400*8/2 = 3200 MHz vcolimits are: 2160 to 4320             // Multiply value for all CLKOUT, (4-43)
		.CLKFBOUT_PHASE(0.0),             // Phase offset in degrees of CLKFB
		.CLKIN_PERIOD(2.500),             //400mhz              // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
		.CLKOUT0_DIVIDE(8),               //3200/8= 400 MHz               // Divide amount for CLKOUT0 (2-128)
		.CLKOUT0_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT0
		.CLKOUT0_PHASE(0.0),              // Phase offset for CLKOUT0
		.CLKOUT0_PHASE_CTRL(2'b01),       // CLKOUT0 fine phase shift or deskew select (0-11)
		.CLKOUT1_DIVIDE(8),               //demo (16),               // Divide amount for CLKOUT1 (2-128)
		.CLKOUT1_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT1
		.CLKOUT1_PHASE(-  84.375),        //xpll_est 400 8 550 //(- 146.25), //188.4375 //xpll_est 400 16 1300 to reduce setup slack violations              // Phase offset for CLKOUT1
		.CLKOUT1_PHASE_CTRL(2'b00),       // CLKOUT1 fine phase shift or deskew select (0-11)
		.CLKOUT2_DIVIDE(2),               // Divide amount for CLKOUT2 (2-128)
		.CLKOUT2_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT2
		.CLKOUT2_PHASE(0.0),              // Phase offset for CLKOUT2
		.CLKOUT2_PHASE_CTRL(2'b00),       // CLKOUT2 fine phase shift or deskew select (0-11)
		.CLKOUT3_DIVIDE(2),               // Divide amount for CLKOUT3 (2-128)
		.CLKOUT3_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT3
		.CLKOUT3_PHASE(0.0),              // Phase offset for CLKOUT3
		.CLKOUT3_PHASE_CTRL(2'b00),       // CLKOUT3 fine phase shift or deskew select (0-11)
		.CLKOUTPHY_CASCIN_EN(1'b0),       // XPLL CLKOUTPHY cascade input enable
		.CLKOUTPHY_CASCOUT_EN(1'b0),      // XPLL CLKOUTPHY cascade output enable
		.DESKEW2_MUXIN_SEL(1'b0),         // Deskew mux selection
		.DESKEW_DELAY1( 0),               // Deskew optional programmable delay
		.DESKEW_DELAY2(0),                // Deskew optional programmable delay
		.DESKEW_DELAY_EN1("TRUE"),        // Enable deskew optional programmable delay
		.DESKEW_DELAY_EN2("FALSE"),       // Enable deskew optional programmable delay
		.DESKEW_DELAY_PATH1("TRUE"),      // Select CLKIN1_DESKEW (TRUE) or CLKFB1_DESKEW (FALSE)
		.DESKEW_DELAY_PATH2("FALSE"),     // Select CLKIN2_DESKEW (TRUE) or CLKFB2_DESKEW (FALSE)
		.DESKEW_MUXIN_SEL(1'b0),          // Deskew mux selection
		.DIVCLK_DIVIDE(2), //demo (1),                // Master division value
		.LOCK_WAIT("FALSE"),              // Lock wait
		.REF_JITTER(0.0),                 // Reference input jitter in UI (0.000-0.200).
		.SIM_ADJ_CLK0_CASCADE("FALSE"),   // Simulation only attribute to reduce CLKOUT0 skew when cascading
										  // (FALSE, TRUE)
		.XPLL_CONNECT_TO_NOCMC("NONE")    // XPLL driving the DDRMC
	)	XPLL_bankc_inst (
		.CLKOUT0(bankc_clk0),             // 1-bit output: CLKOUT0
		.CLKOUT1(bankc_clk1),             // 1-bit output: CLKOUT1
		.CLKOUT2(),                       // 1-bit output: CLKOUT2
		.CLKOUT3(),                       // 1-bit output: CLKOUT3
		.CLKOUTPHY(),                     // 1-bit output: XPHY Logic clock
		.CLKOUTPHY_CASC_OUT(),            // 1-bit output: XPLL CLKOUTPHY cascade output
		.DO(),                            // 16-bit output: DRP data output
		.DRDY(),                          // 1-bit output: DRP ready
		.LOCKED(bankc_deskew_pll_locked),                         // 1-bit output: LOCK
		.LOCKED1_DESKEW(),                // 1-bit output: LOCK DESKEW PD1
		.LOCKED2_DESKEW(),                // 1-bit output: LOCK DESKEW PD2
		.LOCKED_FB(),                     // 1-bit output: LOCK FEEDBACK
		.PSDONE(),                        // 1-bit output: Phase shift done
		.CLKFB1_DESKEW(bankc_fifo_wr_clk_deskewed_bufg),           // 1-bit input: Secondary clock input to PD1
		.CLKFB2_DESKEW(),                 // 1-bit input: Secondary clock input to PD2
		.CLKIN	(bankc_fifo_wr_clk[2]),   // (bankc_fifo_wr_clk[8]),                           // 1-bit input: Primary clock
		.CLKIN1_DESKEW(bankc_clk1),       // 1-bit input: Primary clock input to PD1
		.CLKIN2_DESKEW(),                 // 1-bit input: Primary clock input to PD2
		.CLKOUTPHYEN(),                   // 1-bit input: CLKOUTPHY enable
		.CLKOUTPHY_CASC_IN(),             // 1-bit input: XPLL CLKOUTPHY cascade input
		.DADDR(),                         // 7-bit input: DRP address
		.DCLK    (1'b0),                  // (bankc_fifo_wr_clk[8]),                             // 1-bit input: DRP clock
		.DEN(1'b0),                       // 1-bit input: DRP enable
		.DI(),                            // 16-bit input: DRP data input
		.DWE(),                           // 1-bit input: DRP write enable
		.PSCLK (),                        //   (bankc_fifo_wr_clk_bufg), // (bankc_fifo_wr_clk[8]),                           // 1-bit input: Phase shift clock
		.PSEN(1'b0),                      // 1-bit input: Phase shift enable
		.PSINCDEC(),                      // 1-bit input: Phase shift increment/decrement
		.PWRDWN(1'b0),                    // 1-bit input: Power-down
		.RST(! bankc_intf_rdy_reg)        // 1-bit input: Reset
	);
	BUFG instc_deskewpll_wr_clk_bufg (.I(bankc_fifo_wr_clk[2]), .O(bankc_fifo_wr_clk_bufg) );
	BUFG instc_deskewpll_clk0_bufg   (.I(bankc_clk0), .O(bankc_fifo_wr_clk_deskewed_bufg) );
	

            


///////////////////////// bank d ////////////////////////////////////////////////////////////////////////////
	advanced_io_wizard_bidir_singlebank inst_bankd (
		.fifo_wr_clk	(bankd_fifo_wr_clk),                      // output wire [8 : 0] fifo_wr_clk
		.intf_rdy		(bankd_intf_rdy),                         // output wire intf_rdyodule
		.ctrl_clk 	( clk_bufg ),                                 //  input wire ctrl_clk
		.en_vtc		(en_vtc),                                     //  input wire en_vtc
		.rst			(bankd_pll_rst_pll ),                     //  input wire rst
		.bank0_pll_clkout0	(bankd_pll_clkout0),                  // output wire bank0_pll_clkout0
		.bank0_pll_clkout2(),                                     // output wire bank0_pll_clkout2
		.pll0_clkout0(),                                          // output wire pll0_clkout0
		.bank0_pll_clkout3	(bankd_pll_clkout3),                  // output wire bank0_pll_clkout3
		.bank0_pll_clkoutphy	(bankd_pll_clkoutphy),            // output wire bank0_pll_clkoutphy
		.bank0_pll_locked		(bankd_pll_locked),               // output wire bank0_pll_locked
		.bank0_pll_clkin        (clk_bufg),                       //  input wire bank0_pll_clkin
		.bank0_pll_rst_pll	(bankd_pll_rst_pll),                  //  input wire bank0_pll_rst_pll
		.phy_rden               ({36{bankd_intf_rdy}}),           // input wire [35 : 0] phy_rden
		.t_data_pins  ({2'b00, {49 { ! bankd_write}}}),           // input wire [51 : 0] t_data_pins
		.t_rxclk	(1),                                          // input wire [0 : 0] t_rxclk
		.t_wrclk		(0),                                      // input wire [0 : 0] t_wrclk  
		.dly_rdy				(bankd_dly_rdy),                  // output wire [8 : 0] dly_rdy
		.phy_rdy				(bankd_phy_rdy),                  // output wire [8 : 0] phy_rdy
		.fifo_empty			(bankd_fifo_empty),                   // output wire [8 : 0] fifo_empty
		.fifo_rd_en			( ~ bankd_fifo_empty),                //  input wire [8 : 0] fifo_rd_en
		.data_pins			(bankd_data_pins),                    //  input wire [52 : 0] data_pins
		.data_from_fabric_data_pins	   (bankd_fabric2xphy_bli ),  // input wire [415 : 0] data_from_fabric_data_pins              
		.data_to_fabric_data_pins   (bankd_phy2fabric_bli),       // output wire [423 : 0] data_to_fabric_data_pins
		.rxclk_p				(bankd_rxclk),                    //  input wire [0 : 0] rxclk
		.rxclk_n				(bankd_rxclk_n),                  //  input wire [0 : 0] rxclk
		.data_to_fabric_rxclk(bankd_data_to_fabric_rxclk) ,       // output wire [7 : 0] data_to_fabric_rxclk
		.wrclk_p(bankd_wrclk),                                    // output wire [0 : 0] wrclk
		.wrclk_n(bankd_wrclk_n),                                  // output wire [0 : 0] wrclk
		.data_from_fabric_wrclk(bankd_data_from_fabric_wrclk)     // input wire [7 : 0] data_from_fabric_wrclk		  
    );
   
	always @ (posedge bankd_fifo_wr_clk_deskewed_bufg ) 
		begin
			bankd_phy2fabric_q      <= bankd_phy2fabric_bli;
			bankd_int_test_startchk <= bankd_intf_rdy_reg;        
            bankd_prbs_chk_rst      <= ! bankd_intf_rdy_reg;
		end
    
	always @ (posedge bankd_pll_clkout0)
		begin
		    bankd_intf_rdy_reg       <= bankd_intf_rdy;         
			bankd_int_test_startgen  <= bankd_intf_rdy_reg;     
			bankd_data_from_fabric_wrclk <= bankd_int_test_startgen  ? 8'h55:8'h00; //Using continuous wrclk to support Rx Sync/Bypass deskew circuits
            bankd_fabric2xphy_bli  = bankd_fabric2xphy_prbs;
		end
		
	XPLL #(
		.CLKFBOUT_MULT(16),               //400*8/2 = 3200 MHz vcolimits are: 2160 to 4320             // Multiply value for all CLKOUT, (4-43)
		.CLKFBOUT_PHASE(0.0),             // Phase offset in degrees of CLKFB
		.CLKIN_PERIOD(2.500),             //400mhz              // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
		.CLKOUT0_DIVIDE(8),               //3200/8= 400 MHz               // Divide amount for CLKOUT0 (2-128)
		.CLKOUT0_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT0
		.CLKOUT0_PHASE(0.0),              // Phase offset for CLKOUT0
		.CLKOUT0_PHASE_CTRL(2'b01),       // CLKOUT0 fine phase shift or deskew select (0-11)
		.CLKOUT1_DIVIDE(8),               //demo (16),               // Divide amount for CLKOUT1 (2-128)
		.CLKOUT1_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT1
		.CLKOUT1_PHASE(-  84.375),        //xpll_est 400 8 550 //(- 146.25), //188.4375 //xpll_est 400 16 1300 to reduce setup slack violations              // Phase offset for CLKOUT1
		.CLKOUT1_PHASE_CTRL(2'b00),       // CLKOUT1 fine phase shift or deskew select (0-11)
		.CLKOUT2_DIVIDE(2),               // Divide amount for CLKOUT2 (2-128)
		.CLKOUT2_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT2
		.CLKOUT2_PHASE(0.0),              // Phase offset for CLKOUT2
		.CLKOUT2_PHASE_CTRL(2'b00),       // CLKOUT2 fine phase shift or deskew select (0-11)
		.CLKOUT3_DIVIDE(2),               // Divide amount for CLKOUT3 (2-128)
		.CLKOUT3_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT3
		.CLKOUT3_PHASE(0.0),              // Phase offset for CLKOUT3
		.CLKOUT3_PHASE_CTRL(2'b00),       // CLKOUT3 fine phase shift or deskew select (0-11)
		.CLKOUTPHY_CASCIN_EN(1'b0),       // XPLL CLKOUTPHY cascade input enable
		.CLKOUTPHY_CASCOUT_EN(1'b0),      // XPLL CLKOUTPHY cascade output enable
		.DESKEW2_MUXIN_SEL(1'b0),         // Deskew mux selection
		.DESKEW_DELAY1( 0),               // Deskew optional programmable delay
		.DESKEW_DELAY2(0),                // Deskew optional programmable delay
		.DESKEW_DELAY_EN1("TRUE"),        // Enable deskew optional programmable delay
		.DESKEW_DELAY_EN2("FALSE"),       // Enable deskew optional programmable delay
		.DESKEW_DELAY_PATH1("TRUE"),      // Select CLKIN1_DESKEW (TRUE) or CLKFB1_DESKEW (FALSE)
		.DESKEW_DELAY_PATH2("FALSE"),     // Select CLKIN2_DESKEW (TRUE) or CLKFB2_DESKEW (FALSE)
		.DESKEW_MUXIN_SEL(1'b0),          // Deskew mux selection
		.DIVCLK_DIVIDE(2),                //demo (1),                // Master division value
		.LOCK_WAIT("FALSE"),              // Lock wait
		.REF_JITTER(0.0),                 // Reference input jitter in UI (0.000-0.200).
		.SIM_ADJ_CLK0_CASCADE("FALSE"),   // Simulation only attribute to reduce CLKOUT0 skew when cascading
										  // (FALSE, TRUE)
		.XPLL_CONNECT_TO_NOCMC("NONE")    // XPLL driving the DDRMC
	)
	XPLL_bankd_inst (
		.CLKOUT0(bankd_clk0),             // 1-bit output: CLKOUT0
		.CLKOUT1(bankd_clk1),             // 1-bit output: CLKOUT1
		.CLKOUT2(),                       // 1-bit output: CLKOUT2
		.CLKOUT3(),                       // 1-bit output: CLKOUT3
		.CLKOUTPHY(),                     // 1-bit output: XPHY Logic clock
		.CLKOUTPHY_CASC_OUT(),            // 1-bit output: XPLL CLKOUTPHY cascade output
		.DO(),                            // 16-bit output: DRP data output
		.DRDY(),                          // 1-bit output: DRP ready
		.LOCKED(bankd_deskew_pll_locked), // 1-bit output: LOCK
		.LOCKED1_DESKEW(),                // 1-bit output: LOCK DESKEW PD1
		.LOCKED2_DESKEW(),                // 1-bit output: LOCK DESKEW PD2
		.LOCKED_FB(),                     // 1-bit output: LOCK FEEDBACK
		.PSDONE(),                        // 1-bit output: Phase shift done
		.CLKFB1_DESKEW(bankd_fifo_wr_clk_deskewed_bufg),           // 1-bit input: Secondary clock input to PD1
		.CLKFB2_DESKEW(),                 // 1-bit input: Secondary clock input to PD2
		.CLKIN	(bankd_fifo_wr_clk[2]),   // 1-bit input: Primary clock
		.CLKIN1_DESKEW(bankd_clk1),       // 1-bit input: Primary clock input to PD1
		.CLKIN2_DESKEW(),                 // 1-bit input: Primary clock input to PD2
		.CLKOUTPHYEN(),                   // 1-bit input: CLKOUTPHY enable
		.CLKOUTPHY_CASC_IN(),             // 1-bit input: XPLL CLKOUTPHY cascade input
		.DADDR(),                         // 7-bit input: DRP address
		.DCLK    (1'b0),                  // 1-bit input: DRP clock
		.DEN(1'b0),                       // 1-bit input: DRP enable
		.DI(),                            // 16-bit input: DRP data input
		.DWE(),                           // 1-bit input: DRP write enable
		.PSCLK (),                        // 1-bit input: Phase shift clock
		.PSEN(1'b0),                      // 1-bit input: Phase shift enable
		.PSINCDEC(),                      // 1-bit input: Phase shift increment/decrement
		.PWRDWN(1'b0),                    // 1-bit input: Power-down
		.RST(! bankd_intf_rdy_reg)        // 1-bit input: Reset
	);
	BUFG instd_deskewpll_wr_clk_bufg (.I(bankd_fifo_wr_clk[2]), .O(bankd_fifo_wr_clk_bufg) );
	BUFG instd_deskewpll_clk0_bufg   (.I(bankd_clk0), .O(bankd_fifo_wr_clk_deskewed_bufg) );
	

            



///////////////////////// bank e ////////////////////////////////////////////////////////////////////////////
	advanced_io_wizard_bidir_singlebank inst_banke (
		.fifo_wr_clk	(banke_fifo_wr_clk),                      // output wire [8 : 0] fifo_wr_clk
		.intf_rdy		(banke_intf_rdy),                         // output wire intf_rdyodule
		.ctrl_clk 	( clk_bufg ),                                 //  input wire ctrl_clk
		.en_vtc		(en_vtc),                                     //  input wire en_vtc
		.rst			(banke_pll_rst_pll ),                     //  input wire rst
		.bank0_pll_clkout0	(banke_pll_clkout0),                  // output wire bank0_pll_clkout0
		.bank0_pll_clkout2(),                                     // output wire bank0_pll_clkout2
		.pll0_clkout0(),                                          // output wire pll0_clkout0
		.bank0_pll_clkout3	(banke_pll_clkout3),                  // output wire bank0_pll_clkout3
		.bank0_pll_clkoutphy	(banke_pll_clkoutphy),            // output wire bank0_pll_clkoutphy
		.bank0_pll_locked		(banke_pll_locked),               // output wire bank0_pll_locked
		.bank0_pll_clkin        (clk_bufg),                       //  input wire bank0_pll_clkin
		.bank0_pll_rst_pll	(banke_pll_rst_pll),                  //  input wire bank0_pll_rst_pll
		.phy_rden               ({36{banke_intf_rdy}}),           // input wire [35 : 0] phy_rden
		.t_data_pins  ({2'b00, {49 { ! banke_write}}}),           // input wire [51 : 0] t_data_pins
		.t_rxclk	(1),                                          // input wire [0 : 0] t_rxclk
		.t_wrclk		(0),                                      // input wire [0 : 0] t_wrclk  
		.dly_rdy				(banke_dly_rdy),                  // output wire [8 : 0] dly_rdy
		.phy_rdy				(banke_phy_rdy),                  // output wire [8 : 0] phy_rdy
		.fifo_empty			(banke_fifo_empty),                   // output wire [8 : 0] fifo_empty
		.fifo_rd_en			( ~ banke_fifo_empty ),               //  input wire [8 : 0] fifo_rd_en
		.data_pins			(banke_data_pins),                    //  input wire [52 : 0] data_pins
		.data_from_fabric_data_pins	   (banke_fabric2xphy_bli ),  // input wire [415 : 0] data_from_fabric_data_pins              
		.data_to_fabric_data_pins   (banke_phy2fabric_bli),       // output wire [423 : 0] data_to_fabric_data_pins
		.rxclk_p				(banke_rxclk),                    //  input wire [0 : 0] rxclk
		.rxclk_n				(banke_rxclk_n),                  //  input wire [0 : 0] rxclk
		.data_to_fabric_rxclk(banke_data_to_fabric_rxclk),        // output wire [7 : 0] data_to_fabric_rxclk
		.wrclk_p(banke_wrclk),                                    // output wire [0 : 0] wrclk
		.wrclk_n(banke_wrclk_n),                                  // output wire [0 : 0] wrclk
		.data_from_fabric_wrclk(banke_data_from_fabric_wrclk)     // input wire [7 : 0] data_from_fabric_wrclk		  
    );

    always @ (posedge banke_fifo_wr_clk_deskewed_bufg ) 
        begin
			banke_phy2fabric_q      <= banke_phy2fabric_bli;
			banke_int_test_startchk <= banke_intf_rdy_reg; 
            banke_prbs_chk_rst      <= ! banke_intf_rdy_reg;
		end

	always @ (posedge banke_pll_clkout0)
		begin
			banke_intf_rdy_reg       <= banke_intf_rdy; 
			banke_int_test_startgen  <= banke_intf_rdy_reg; 
			banke_data_from_fabric_wrclk <=  banke_int_test_startgen  ? 8'h55:8'h00; 
            banke_fabric2xphy_bli  = banke_fabric2xphy_prbs;
		end
	
	XPLL #(
		.CLKFBOUT_MULT(16),               //400*8/2 = 3200 MHz vcolimits are: 2160 to 4320             // Multiply value for all CLKOUT, (4-43)
		.CLKFBOUT_PHASE(0.0),             // Phase offset in degrees of CLKFB
		.CLKIN_PERIOD(2.500),             //400mhz              // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
		.CLKOUT0_DIVIDE(8),               //3200/8= 400 MHz               // Divide amount for CLKOUT0 (2-128)
		.CLKOUT0_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT0
		.CLKOUT0_PHASE(0.0),              // Phase offset for CLKOUT0
		.CLKOUT0_PHASE_CTRL(2'b01),       // CLKOUT0 fine phase shift or deskew select (0-11)
		.CLKOUT1_DIVIDE(8),               //demo (16),               // Divide amount for CLKOUT1 (2-128)
		.CLKOUT1_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT1
		.CLKOUT1_PHASE(-  84.375),        //xpll_est 400 8 550 //(- 146.25), //188.4375 //xpll_est 400 16 1300 to reduce setup slack violations              // Phase offset for CLKOUT1
		.CLKOUT1_PHASE_CTRL(2'b00),       // CLKOUT1 fine phase shift or deskew select (0-11)
		.CLKOUT2_DIVIDE(2),               // Divide amount for CLKOUT2 (2-128)
		.CLKOUT2_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT2
		.CLKOUT2_PHASE(0.0),              // Phase offset for CLKOUT2
		.CLKOUT2_PHASE_CTRL(2'b00),       // CLKOUT2 fine phase shift or deskew select (0-11)
		.CLKOUT3_DIVIDE(2),               // Divide amount for CLKOUT3 (2-128)
		.CLKOUT3_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT3
		.CLKOUT3_PHASE(0.0),              // Phase offset for CLKOUT3
		.CLKOUT3_PHASE_CTRL(2'b00),       // CLKOUT3 fine phase shift or deskew select (0-11)
		.CLKOUTPHY_CASCIN_EN(1'b0),       // XPLL CLKOUTPHY cascade input enable
		.CLKOUTPHY_CASCOUT_EN(1'b0),      // XPLL CLKOUTPHY cascade output enable
		.DESKEW2_MUXIN_SEL(1'b0),         // Deskew mux selection
		.DESKEW_DELAY1( 0),               // Deskew optional programmable delay
		.DESKEW_DELAY2(0),                // Deskew optional programmable delay
		.DESKEW_DELAY_EN1("TRUE"),        // Enable deskew optional programmable delay
		.DESKEW_DELAY_EN2("FALSE"),       // Enable deskew optional programmable delay
		.DESKEW_DELAY_PATH1("TRUE"),      // Select CLKIN1_DESKEW (TRUE) or CLKFB1_DESKEW (FALSE)
		.DESKEW_DELAY_PATH2("FALSE"),     // Select CLKIN2_DESKEW (TRUE) or CLKFB2_DESKEW (FALSE)
		.DESKEW_MUXIN_SEL(1'b0),          // Deskew mux selection
		.DIVCLK_DIVIDE(2),                // Master division value
		.LOCK_WAIT("FALSE"),              // Lock wait
		.REF_JITTER(0.0),                 // Reference input jitter in UI (0.000-0.200).
		.SIM_ADJ_CLK0_CASCADE("FALSE"),   // Simulation only attribute to reduce CLKOUT0 skew when cascading
										  // (FALSE, TRUE)
		.XPLL_CONNECT_TO_NOCMC("NONE")    // XPLL driving the DDRMC
	)
	XPLL_banke_inst (
		.CLKOUT0(banke_clk0),             // 1-bit output: CLKOUT0
		.CLKOUT1(banke_clk1),             // 1-bit output: CLKOUT1
		.CLKOUT2(),                       // 1-bit output: CLKOUT2
		.CLKOUT3(),                       // 1-bit output: CLKOUT3
		.CLKOUTPHY(),                     // 1-bit output: XPHY Logic clock
		.CLKOUTPHY_CASC_OUT(),            // 1-bit output: XPLL CLKOUTPHY cascade output
		.DO(),                            // 16-bit output: DRP data output
		.DRDY(),                          // 1-bit output: DRP ready
		.LOCKED(banke_deskew_pll_locked), // 1-bit output: LOCK
		.LOCKED1_DESKEW(),                // 1-bit output: LOCK DESKEW PD1
		.LOCKED2_DESKEW(),                // 1-bit output: LOCK DESKEW PD2
		.LOCKED_FB(),                     // 1-bit output: LOCK FEEDBACK
		.PSDONE(),                        // 1-bit output: Phase shift done
		.CLKFB1_DESKEW(banke_fifo_wr_clk_deskewed_bufg),           // 1-bit input: Secondary clock input to PD1
		.CLKFB2_DESKEW(),                 // 1-bit input: Secondary clock input to PD2
		.CLKIN	(banke_fifo_wr_clk[2]),   // (banke_fifo_wr_clk[8]),                           // 1-bit input: Primary clock
		.CLKIN1_DESKEW(banke_clk1 ),      // 1-bit input: Primary clock input to PD1
		.CLKIN2_DESKEW(),                 // 1-bit input: Primary clock input to PD2
		.CLKOUTPHYEN(),                   // 1-bit input: CLKOUTPHY enable
		.CLKOUTPHY_CASC_IN(),             // 1-bit input: XPLL CLKOUTPHY cascade input
		.DADDR(),                         // 7-bit input: DRP address
		.DCLK    (1'b0),                  // 1-bit input: DRP clock
		.DEN(1'b0),                       // 1-bit input: DRP enable
		.DI(),                            // 16-bit input: DRP data input
		.DWE(),                           // 1-bit input: DRP write enable
		.PSCLK (),                        // (banke_fifo_wr_clk[8]),                           // 1-bit input: Phase shift clock
		.PSEN(1'b0),                      // 1-bit input: Phase shift enable
		.PSINCDEC(PSINCDEC),              // 1-bit input: Phase shift increment/decrement
		.PWRDWN(1'b0),                    // 1-bit input: Power-down
		.RST(! banke_intf_rdy_reg)        // 1-bit input: Reset
	);
	BUFG inste_deskewpll_wr_clk_bufg (.I(banke_fifo_wr_clk[2]), .O(banke_fifo_wr_clk_bufg) );
	BUFG inste_deskewpll_clk0_bufg   (.I(banke_clk0), .O(banke_fifo_wr_clk_deskewed_bufg) );		
	

            



///////////////////////// bank f ////////////////////////////////////////////////////////////////////////////
    advanced_io_wizard_bidir_singlebank inst_bankf (
		.fifo_wr_clk	(bankf_fifo_wr_clk),                      // output wire [8 : 0] fifo_wr_clk
		.intf_rdy		(bankf_intf_rdy),                         // output wire intf_rdyodule
		.ctrl_clk 	( clk_bufg ),                                 //  input wire ctrl_clk
		.en_vtc		(en_vtc),                                     //  input wire en_vtc
		.rst			(bankf_pll_rst_pll ),                     //  input wire rst
		.bank0_pll_clkout0	(bankf_pll_clkout0),                  // output wire bank0_pll_clkout0
		.bank0_pll_clkout3	(bankf_pll_clkout3),                  // output wire bank0_pll_clkout3
		.bank0_pll_clkoutphy	(bankf_pll_clkoutphy),            // output wire bank0_pll_clkoutphy
		.bank0_pll_locked		(bankf_pll_locked),               // output wire bank0_pll_locked
		.bank0_pll_clkin        (clk_bufg),                       //  input wire bank0_pll_clkin
		.bank0_pll_rst_pll	(bankf_pll_rst_pll),                  //  input wire bank0_pll_rst_pll
		.phy_rden               ({36{bankf_intf_rdy}}),           // input wire [35 : 0] phy_rden
		.t_data_pins  ({2'b00, {49 { ! bankf_write}}}),           // input wire [51 : 0] t_data_pins
		.t_rxclk	(1),                                          // input wire [0 : 0] t_rxclk
		.t_wrclk		(0),                                      // input wire [0 : 0] t_wrclk  
		.dly_rdy				(bankf_dly_rdy),                  // output wire [8 : 0] dly_rdy
		.phy_rdy				(bankf_phy_rdy),                  // output wire [8 : 0] phy_rdy
		.fifo_empty			(bankf_fifo_empty),                   // output wire [8 : 0] fifo_empty
		.fifo_rd_en			( ~ bankf_fifo_empty ),               //  input wire [8 : 0] fifo_rd_en
		.data_pins			         (bankf_data_pins),           //  input wire [52 : 0] data_pins
		.data_from_fabric_data_pins	   (bankf_fabric2xphy_bli ),  // input wire [415 : 0] data_from_fabric_data_pins              
		.data_to_fabric_data_pins     (bankf_phy2fabric_bli),     // output wire [423 : 0] data_to_fabric_data_pins
		.rxclk_p				      (bankf_rxclk),              //  input wire [0 : 0] rxclk
		.rxclk_n				      (bankf_rxclk_n),            //  input wire [0 : 0] rxclk
		.data_to_fabric_rxclk(bankf_data_to_fabric_rxclk)  ,      // output wire [7 : 0] data_to_fabric_rxclk
		.wrclk_p(bankf_wrclk),                                    // output wire [0 : 0] wrclk
		.wrclk_n(bankf_wrclk_n),                                  // output wire [0 : 0] wrclk
		.data_from_fabric_wrclk(bankf_data_from_fabric_wrclk)     // input wire [7 : 0] data_from_fabric_wrclk		  
	);
	
    always @ (posedge bankf_fifo_wr_clk_deskewed_bufg ) 
		begin
			bankf_phy2fabric_q       <= bankf_phy2fabric_bli;
			bankf_int_test_startchk  <= bankf_deskew_pll_locked;    
            bankf_prbs_chk_rst       <= ! bankf_intf_rdy_reg;
		end
	
	always @ (posedge bankf_pll_clkout0)
		begin
		    bankf_intf_rdy_reg            <= bankf_intf_rdy;           
			bankf_int_test_startgen       <= bankf_intf_rdy_reg;
			bankf_data_from_fabric_wrclk  <= bankf_int_test_startgen  ? 8'h55:8'h00; //Using continuous wrclk to support Rx Sync/Bypass deskew circuits
            bankf_fabric2xphy_bli         <= bankf_fabric2xphy_prbs;
		end
		
	XPLL #(
		.CLKFBOUT_MULT(16),               //400*8/2 = 3200 MHz vcolimits are: 2160 to 4320             // Multiply value for all CLKOUT, (4-43)
		.CLKFBOUT_PHASE(0.0),             // Phase offset in degrees of CLKFB
		.CLKIN_PERIOD(2.500),             //400mhz              // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
		.CLKOUT0_DIVIDE(8),               //3200/8= 400 MHz               // Divide amount for CLKOUT0 (2-128)
		.CLKOUT0_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT0
		.CLKOUT0_PHASE(0.0),              // Phase offset for CLKOUT0
		.CLKOUT0_PHASE_CTRL(2'b01),       // CLKOUT0 fine phase shift or deskew select (0-11)
		.CLKOUT1_DIVIDE(8),               //demo (16),               // Divide amount for CLKOUT1 (2-128)
		.CLKOUT1_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT1
		.CLKOUT1_PHASE(-  84.375),        //xpll_est 400 8 550 //(- 146.25), //188.4375 //xpll_est 400 16 1300 to reduce setup slack violations              // Phase offset for CLKOUT1
		.CLKOUT1_PHASE_CTRL(2'b00),       // CLKOUT1 fine phase shift or deskew select (0-11)
		.CLKOUT2_DIVIDE(2),               // Divide amount for CLKOUT2 (2-128)
		.CLKOUT2_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT2
		.CLKOUT2_PHASE(0.0),              // Phase offset for CLKOUT2
		.CLKOUT2_PHASE_CTRL(2'b00),       // CLKOUT2 fine phase shift or deskew select (0-11)
		.CLKOUT3_DIVIDE(2),               // Divide amount for CLKOUT3 (2-128)
		.CLKOUT3_DUTY_CYCLE(0.5),         // Duty cycle for CLKOUT3
		.CLKOUT3_PHASE(0.0),              // Phase offset for CLKOUT3
		.CLKOUT3_PHASE_CTRL(2'b00),       // CLKOUT3 fine phase shift or deskew select (0-11)
		.CLKOUTPHY_CASCIN_EN(1'b0),       // XPLL CLKOUTPHY cascade input enable
		.CLKOUTPHY_CASCOUT_EN(1'b0),      // XPLL CLKOUTPHY cascade output enable
		.DESKEW2_MUXIN_SEL(1'b0),         // Deskew mux selection
		.DESKEW_DELAY1( 0),               // Deskew optional programmable delay
		.DESKEW_DELAY2(0),                // Deskew optional programmable delay
		.DESKEW_DELAY_EN1("TRUE"),        // Enable deskew optional programmable delay
		.DESKEW_DELAY_EN2("FALSE"),       // Enable deskew optional programmable delay
		.DESKEW_DELAY_PATH1("TRUE"),      // Select CLKIN1_DESKEW (TRUE) or CLKFB1_DESKEW (FALSE)
		.DESKEW_DELAY_PATH2("FALSE"),     // Select CLKIN2_DESKEW (TRUE) or CLKFB2_DESKEW (FALSE)
		.DESKEW_MUXIN_SEL(1'b0),          // Deskew mux selection
		.DIVCLK_DIVIDE(2),                // Master division value
		.LOCK_WAIT("FALSE"),              // Lock wait
		.REF_JITTER(0.0),                 // Reference input jitter in UI (0.000-0.200).
		.SIM_ADJ_CLK0_CASCADE("FALSE"),   // Simulation only attribute to reduce CLKOUT0 skew when cascading
									      // (FALSE, TRUE)
		.XPLL_CONNECT_TO_NOCMC("NONE")    // XPLL driving the DDRMC
	)	XPLL_bankf_inst (
		.CLKOUT0(bankf_clk0),             // 1-bit output: CLKOUT0
		.CLKOUT1(bankf_clk1),             // 1-bit output: CLKOUT1
		.CLKOUT2(),                       // 1-bit output: CLKOUT2
		.CLKOUT3(),                       // 1-bit output: CLKOUT3
		.CLKOUTPHY(),                     // 1-bit output: XPHY Logic clock
		.CLKOUTPHY_CASC_OUT(),            // 1-bit output: XPLL CLKOUTPHY cascade output
		.DO(),                            // 16-bit output: DRP data output
		.DRDY(),                          // 1-bit output: DRP ready
		.LOCKED(bankf_deskew_pll_locked),                         // 1-bit output: LOCK
		.LOCKED1_DESKEW(),                // 1-bit output: LOCK DESKEW PD1
		.LOCKED2_DESKEW(),                // 1-bit output: LOCK DESKEW PD2
		.LOCKED_FB(),                     // 1-bit output: LOCK FEEDBACK
		.PSDONE(),                        // 1-bit output: Phase shift done
		.CLKFB1_DESKEW(bankf_fifo_wr_clk_deskewed_bufg),           // 1-bit input: Secondary clock input to PD1
		  .CLKFB2_DESKEW(),               // 1-bit input: Secondary clock input to PD2
		.CLKIN	(bankf_fifo_wr_clk[2]),   // (bankf_fifo_wr_clk[8]),                           // 1-bit input: Primary clock
		.CLKIN1_DESKEW(bankf_clk1 ),      // 1-bit input: Primary clock input to PD1
		.CLKIN2_DESKEW(),                 // 1-bit input: Primary clock input to PD2
		.CLKOUTPHYEN(),                   // 1-bit input: CLKOUTPHY enable
		.CLKOUTPHY_CASC_IN(),             // 1-bit input: XPLL CLKOUTPHY cascade input
		.DADDR(),                         // 7-bit input: DRP address
		.DCLK    (1'b0),                  // (bankf_fifo_wr_clk[8]),                             // 1-bit input: DRP clock
		.DEN(1'b0),                       // 1-bit input: DRP enable
		.DI(),                            // 16-bit input: DRP data input
		.DWE(),                           // 1-bit input: DRP write enable
		.PSCLK (),                        //   (bankf_fifo_wr_clk_bufg), // (bankf_fifo_wr_clk[8]),                           // 1-bit input: Phase shift clock
		.PSEN(1'b0),                      // 1-bit input: Phase shift enable
		.PSINCDEC(1'b0),                  // 1-bit input: Phase shift increment/decrement
		.PWRDWN(1'b0),                    // 1-bit input: Power-down
		.RST(! bankf_intf_rdy_reg)        // 1-bit input: Reset
	);
	BUFG instf_deskewpll_wr_clk_bufg (.I(bankf_fifo_wr_clk[2]), .O(bankf_fifo_wr_clk_bufg) );
	BUFG instf_deskewpll_clk0_bufg   (.I(bankf_clk0), .O(bankf_fifo_wr_clk_deskewed_bufg) );
			

 ///////////////////////// PRBS Generator (TX) and PRBS Checker (RX) /////////////////////////////////////////////////////////////
    always @ (posedge banka_pll_clkout0)                banka_prbs_gen_rst = banka_rst_test || ! banka_pll_locked;
    always @ (posedge bankb_pll_clkout0)                bankb_prbs_gen_rst = bankb_rst_test || ! bankb_pll_locked;
    always @ (posedge bankc_pll_clkout0)                bankc_prbs_gen_rst = bankc_rst_test || ! bankc_pll_locked;
    always @ (posedge bankd_pll_clkout0)                bankd_prbs_gen_rst = bankd_rst_test || ! bankd_pll_locked;
    always @ (posedge banke_pll_clkout0)                banke_prbs_gen_rst = banke_rst_test || ! banke_pll_locked;
    always @ (posedge bankf_pll_clkout0)                bankf_prbs_gen_rst = bankf_rst_test || ! bankf_pll_locked;


    genvar j;
    generate for (j=0; j< BITS; j=j+1) 
        begin
            //prbs generator setup as PRBS8 as per cmphy_pgc.sv
            PRBS_ANY /*usingxapp884 cmphy_prbs_any*/ # (
				.CHK_MODE 		(0),
				.INV_PATTERN 	(0),
				.POLY_LENGHT 	(7),
				.POLY_TAP 		(6),
				.NBITS 			(8) 
			) inst_banka_prbs_generator (
				.CLK		(banka_pll_clkout0),      
				.RST		(banka_prbs_gen_rst), 
				.EN			(banka_int_test_startgen),
				.DATA_IN    ({7'b000_0000, banka_injerr }),         
				.DATA_OUT	(banka_fabric2xphy_prbs[(j*8)+7 : j*8] ) 
			);

            //prbs checker setup as PRBS8 as per cmphy_pgc.sv
            PRBS_ANY /*usingxapp884 cmphy_prbs_any*/ # (
				.CHK_MODE 		(1),
				.INV_PATTERN 	(0),
				.POLY_LENGHT 	(7),
				.POLY_TAP 		(6),
				.NBITS 			(8) 
			) inst_banka_prbs_checker ( 
				.CLK		(banka_fifo_wr_clk_deskewed_bufg),    //Using deskewed clock only for Rx side	(banka_pll_clkout0),
				.RST		(banka_prbs_chk_rst),                 
				.EN			(banka_int_test_startchk),            
				.DATA_IN    (banka_phy2fabric_q [(j*8)+7 : j*8] ),
				.DATA_OUT	(banka_prbs_error[(j*8)+7 : j*8] )     
			);
			
                
            // //// bank b ////
            PRBS_ANY /*usingxapp884 cmphy_prbs_any*/ # (
				.CHK_MODE 		(0),
				.INV_PATTERN 	(0),
				.POLY_LENGHT 	(7),
				.POLY_TAP 		(6),
				.NBITS 			(8) 
            ) inst_bankb_prbs_generator (
                .CLK		(bankb_pll_clkout0), 
                .RST		(bankb_prbs_gen_rst), 
                .EN			(bankb_int_test_startgen),
                .DATA_IN    ({7'b000_0000, bankb_injerr }),
                .DATA_OUT	(bankb_fabric2xphy_prbs[(j*8)+7 : j*8] ) 
            );

            //prbs checker setup as PRBS8 as per cmphy_pgc.sv
            PRBS_ANY  # (
               	.CHK_MODE 		(1),  
               	.INV_PATTERN 	(0), 
               	.POLY_LENGHT 	(7), 
				.POLY_TAP 		(6), 
               	.NBITS 			(8) 
            ) inst_bankb_prbs_checker ( 
				.CLK		(bankb_fifo_wr_clk_deskewed_bufg), //Using deskewed clock only for Rx side(bankb_pll_clkout0),
				.RST		(bankb_prbs_chk_rst), 
				.EN			(bankb_int_test_startchk),            
				.DATA_IN    (bankb_phy2fabric_q [(j*8)+7 : j*8] ),
				.DATA_OUT	(bankb_prbs_error[(j*8)+7 : j*8] )   
			);
                
            // //// bank c ////
            PRBS_ANY /*usingxapp884 cmphy_prbs_any*/ # (
               	.CHK_MODE 		(0),  
               	.INV_PATTERN 	(0),  
               	.POLY_LENGHT 	(7),  
				.POLY_TAP 		(6), 
               	.NBITS 			(8) 
            ) inst_bankc_prbs_generator (
                .CLK			(bankc_pll_clkout0), 
                .RST		(bankc_prbs_gen_rst), 
                .EN			(bankc_int_test_startgen ),
                .DATA_IN  ( {7'b000_0000, bankc_injerr }),
                .DATA_OUT	(bankc_fabric2xphy_prbs[(j*8)+7 : j*8] ) 
            );

            //prbs checker setup as PRBS8 as per cmphy_pgc.sv
            PRBS_ANY /*usingxapp884 cmphy_prbs_any*/ # (
               	.CHK_MODE 		(1),  
               	.INV_PATTERN 	(0),  
               	.POLY_LENGHT 	(7),  
				.POLY_TAP 		(6),  
               	.NBITS 			(8) 
            ) inst_bankc_prbs_checker ( 
				.CLK		(bankc_fifo_wr_clk_deskewed_bufg), //Using deskewed clock only for Rx side	(bankc_pll_clkout0),
				.RST		(bankc_prbs_chk_rst), 
				.EN			(bankc_int_test_startchk),          
				.DATA_IN    (bankc_phy2fabric_q [(j*8)+7 : j*8] ),
				.DATA_OUT	(bankc_prbs_error[(j*8)+7 : j*8] ) 
			);        
                
            // //// bank d ////
            PRBS_ANY /*usingxapp884 cmphy_prbs_any*/ # (
               	.CHK_MODE 		(0), 
               	.INV_PATTERN 	(0),  
               	.POLY_LENGHT 	(7),  
				.POLY_TAP 		(6),  
               	.NBITS 			(8) 
            ) inst_bankd_prbs_generator (
                .CLK		(bankd_pll_clkout0), 
                .RST		(bankd_prbs_gen_rst), 
                .EN			( bankd_int_test_startgen),
                .DATA_IN    ({7'b000_0000, bankd_injerr }),
                .DATA_OUT	(bankd_fabric2xphy_prbs[(j*8)+7 : j*8] )
            );

            //prbs checker setup as PRBS8 as per cmphy_pgc.sv
            PRBS_ANY /*usingxapp884 cmphy_prbs_any*/ # (
               	.CHK_MODE 		(1), 
               	.INV_PATTERN 	(0), 
               	.POLY_LENGHT 	(7), 
				.POLY_TAP 		(6), 
               	.NBITS 			(8)  
            ) inst_bankd_prbs_checker ( 
				.CLK		(bankd_fifo_wr_clk_deskewed_bufg), //Using deskewed clock only for Rx side	(bankd_pll_clkout0),
				.RST		(bankd_prbs_chk_rst), 
				.EN			(bankd_int_test_startchk),         
				.DATA_IN    (bankd_phy2fabric_q [(j*8)+7 : j*8] ),
				.DATA_OUT	(bankd_prbs_error[(j*8)+7 : j*8] )  
			);        
                
            // //// bank e ////
            PRBS_ANY /*usingxapp884 cmphy_prbs_any*/ # (
				.CHK_MODE 		(0), 
				.INV_PATTERN 	(0), 
				.POLY_LENGHT 	(7), 
				.POLY_TAP 		(6), 
				.NBITS 			(8) 
            ) inst_banke_prbs_generator (
                .CLK		(banke_pll_clkout0), 
                .RST		(banke_prbs_gen_rst), 
                .EN			(banke_int_test_startgen),
                .DATA_IN    ({7'b000_0000, banke_injerr}),
                .DATA_OUT	(banke_fabric2xphy_prbs[(j*8)+7 : j*8] ) 
            );

            //prbs checker setup as PRBS8 as per cmphy_pgc.sv
            PRBS_ANY /*usingxapp884 cmphy_prbs_any*/ # (
				.CHK_MODE 		(1), 
				.INV_PATTERN 	(0), 
				.POLY_LENGHT 	(7), 
				.POLY_TAP 		(6), 
				.NBITS 			(8) //= 16;
            ) inst_banke_prbs_checker ( 
				.CLK		(banke_fifo_wr_clk_deskewed_bufg), 
				.RST		(banke_prbs_chk_rst), 
				.EN			(banke_int_test_startchk),         
				.DATA_IN    (banke_phy2fabric_q [(j*8)+7 : j*8] ),
				.DATA_OUT	(banke_prbs_error[(j*8)+7 : j*8] )  
            );        
                
            // //// bank f ////
            PRBS_ANY /*usingxapp884 cmphy_prbs_any*/ # (
				.CHK_MODE 		(0), 
				.INV_PATTERN 	(0), 
				.POLY_LENGHT 	(7), 
				.POLY_TAP 		(6), 
				.NBITS 			(8) 
            ) inst_bankf_prbs_generator (
				.CLK			(bankf_pll_clkout0), 
				.RST		(bankf_prbs_gen_rst), 
				.EN			(bankf_int_test_startgen), 
				.DATA_IN    ({7'b000_0000, bankf_injerr }),
				.DATA_OUT	(bankf_fabric2xphy_prbs[(j*8)+7 : j*8] ) 
            );

            //prbs checker setup as PRBS8 as per cmphy_pgc.sv
            PRBS_ANY /*usingxapp884 cmphy_prbs_any*/ # (
				.CHK_MODE 		(1), 
				.INV_PATTERN 	(0), 
				.POLY_LENGHT 	(7), 
				.POLY_TAP 		(6), 
				.NBITS 			(8) 
            ) inst_bankf_prbs_checker ( 
				.CLK		(bankf_fifo_wr_clk_deskewed_bufg),        //Using deskewed clock only for Rx side	(bankf_pll_clkout0),
				.RST		(bankf_prbs_chk_rst),                     
				.EN			(bankf_int_test_startchk),         
				.DATA_IN    (bankf_phy2fabric_q [(j*8)+7 : j*8] ),    
				.DATA_OUT	(bankf_prbs_error[(j*8)+7 : j*8] )        
            );        
		end
    endgenerate





endmodule



