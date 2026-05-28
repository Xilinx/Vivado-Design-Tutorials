//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2023 10:17:23 AM
// Design Name: 
// Module Name: axis_vio_pl_master_to_ddr_sim
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

module axis_vio_sim(
    input clk,
    input [1:0] probe_in0,
    input rstn,
    output [1:0]probe_out0
        );
    
    reg  axi_tg_start;
    reg axi_tg_resetn;
    
    assign probe_out0[0] = axi_tg_start;
    assign probe_out0[1] = axi_tg_resetn;


    initial
		begin
		axi_tg_start <= 0;
	    repeat (100) begin @(posedge clk);end
	    axi_tg_resetn <= 0;
	    repeat (100) begin @(posedge clk);end
	    axi_tg_resetn <= 1;
         while (rstn != 1) begin
	    end
	    repeat (100) begin @(posedge clk);end
		axi_tg_start <= 1;
	    repeat (50000000) begin @(posedge clk);end

		end

endmodule
