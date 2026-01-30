//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2023 04:03:36 PM
// Design Name: 
// Module Name: sim_clk_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define SIM_ENABLED

module sim_clk_gen(
    input clk
    );


    reg clk_p;
    wire clk_n;
    
    assign clk_n = !clk_p;
    always #2.5 clk_p <= !clk_p;

    initial
		begin
		clk_p <= 0;
		force design_1_wrapper_sim_wrapper.ddr4_dimm1_sma_clk_clk_p = clk_p;
		force design_1_wrapper_sim_wrapper.ddr4_dimm1_sma_clk_clk_n = clk_n;
		//Setting the clock out frequency of PL clock from CIPS to 100 MHz
        design_1_wrapper_sim_wrapper.design_1_wrapper_i.design_1_i.versal_cips_0.inst.pspmc_0.inst.PS9_VIP_inst.inst.pl_gen_clock(0,100);
        //Connecting the PL clock to CIPS VIP clk
		force design_1_wrapper_sim_wrapper.design_1_wrapper_i.design_1_i.versal_cips_0.inst.pspmc_0.inst.PS9_VIP_inst.inst.versal_cips_ps_vip_clk = clk;
       //Setting the reset for PS VIP block
        design_1_wrapper_sim_wrapper.design_1_wrapper_i.design_1_i.versal_cips_0.inst.pspmc_0.inst.PS9_VIP_inst.inst.por_reset(0);
        repeat(20)@(posedge clk); 
        //Disabling the reset of PS VIP block
        design_1_wrapper_sim_wrapper.design_1_wrapper_i.design_1_i.versal_cips_0.inst.pspmc_0.inst.PS9_VIP_inst.inst.por_reset(1);
		force design_1_wrapper_sim_wrapper.design_1_wrapper_i._5_pl_axis_MxN_top_inst.vio_rst_n = 1;

		end 

endmodule
