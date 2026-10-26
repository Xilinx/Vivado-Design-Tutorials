/*
Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
SPDX-License-Identifier: MIT
*/


`timescale 1ns / 1ps


module rtl_block(

    input clk,
    output [31:0] Q

    );
    
(* MARK_DEBUG = "TRUE" *) wire [31:0] Q;
(* MARK_DEBUG = "TRUE" *) wire CE;
(* MARK_DEBUG = "TRUE" *) wire SCLR;
(* MARK_DEBUG = "TRUE" *) wire UP;
(* MARK_DEBUG = "TRUE" *) wire LOAD;
(* MARK_DEBUG = "TRUE" *) wire [31:0] L;

    
rtlcounter rtl_counter (
	.clk(clk),
	.CE(CE),
	.SCLR(SCLR),
	.UP(UP),
	.LOAD(LOAD),
	.L(L),
	.Q(Q)
);    


axis_vio_0 u_rtl_vio (
  .probe_in0(Q),    // input wire [31 : 0] probe_in0
  .probe_out0(CE),  // output wire [0 : 0] probe_out0
  .probe_out1(SCLR),  // output wire [0 : 0] probe_out1
  .probe_out2(UP),  // output wire [0 : 0] probe_out2
  .probe_out3(LOAD),  // output wire [0 : 0] probe_out3
  .probe_out4(L),  // output wire [31 : 0] probe_out4
  .clk(clk)                // input wire clk
);   

    
    
endmodule
