/*
Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
SPDX-License-Identifier: MIT
*/

`timescale 1ns / 1ps

module rtlcounter (
	input clk,
	input CE,
	input SCLR,
	input UP,
	input LOAD,
	input [31:0] L,
	output [31:0] Q
);

reg [31:0] Q;


always @(posedge clk)
	begin
		if (CE) 
			begin
				if (SCLR) 
					begin
						Q <= 32'd0;
					end
				else if (LOAD)
					begin
						Q <= L;			
					end
				else if (UP)
					begin
						Q <= Q + 1'b1;
					end
				else if (!UP)
					begin
						Q <= Q - 1'b1;
					end
			end
	end	 




endmodule
