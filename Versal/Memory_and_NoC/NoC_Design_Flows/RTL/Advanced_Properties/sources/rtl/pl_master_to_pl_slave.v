//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2023 10:52:30 PM
// Design Name: 
// Module Name: pl_master_to_pl_slave
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


module pl_master_to_pl_slave(
  input clk,
  input rstn
    );
  pl_to_pl_slave pl_to_pl_slave_inst (.clk(clk), .rstn(rstn));
  pl_to_pl_master pl_to_pl_master_inst (.clk(clk),.rstn(rstn));  
endmodule
