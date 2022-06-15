// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.1 (lin64) Build 1201938 Fri Apr 10 17:09:40 MDT 2015
// Date        : Sat Apr 11 13:58:07 2015
// Host        : xsjjoshg40 running 64-bit Red Hat Enterprise Linux Client release 5.9 (Tikanga)
// Command     : write_verilog -force -mode synth_stub
//               /wrk/hdstaff/joshg/scratch/tutorial/ug1119-vivado-packaging-design/lab_2/project_wave_gen/project_wave_gen.srcs/sources_1/ip/char_fifo/char_fifo_stub.v
// Design      : char_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k70tfbg676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
// module char_fifo(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, empty);
  // input rst;
  // input wr_clk;
  // input rd_clk;
  // input [7:0]din;
  // input wr_en;
  // input rd_en;
  // output [7:0]dout;
  // output full;
  // output empty;
  


module char_fifo (data_out, wr_full, rd_empty, 
				data_in, rd_clk, wr_clk, reset);

parameter WIDTH = 8;
parameter POINTER = 4;
output [WIDTH-1 : 0] data_out;
output wr_full;
output rd_empty;
input [WIDTH-1 : 0] data_in;
input rd_clk, wr_clk;
input reset;

reg [POINTER-1 : 0] rd_pointer, rd_sync_1, rd_sync_2;
reg [POINTER-1 : 0] wr_pointer, wr_sync_1, wr_sync_2;
wire [POINTER-1 : 0] rd_pointer_g;
wire [POINTER-1 : 0] wr_pointer_g;

parameter DEPTH = 1 << POINTER;

reg [WIDTH-1 : 0] mem [DEPTH-1 : 0];

wire [POINTER-1 : 0] rd_pointer_sync;
wire [POINTER-1 : 0] wr_pointer_sync;

//--write logic--//
always @(posedge wr_clk or posedge reset) begin
	if (reset) begin
		// reset
		wr_pointer <= 0;
	end
	else if (wr_full == 1'b0) begin
		wr_pointer <= wr_pointer + 1;
		mem[wr_pointer[POINTER-1 : 0]] <= data_in;
	end
end
//--read pointer synchronizer controled by write clock--//
always @(posedge wr_clk) begin
	rd_sync_1 <= rd_pointer_g;
	rd_sync_2 <= rd_sync_1;
end
//--read logic--//
always @(posedge rd_clk or posedge reset) begin
	if (reset) begin
		// reset
		rd_pointer <= 0;
	end
	else if (rd_empty == 1'b0) begin
		rd_pointer <= rd_pointer + 1;
	end
end

//--write pointer synchronizer controled by read clock--//
always @(posedge rd_clk) begin
	wr_sync_1 <= wr_pointer_g;
	wr_sync_2 <= wr_sync_1;
end

//--Combinational logic--//
//--Binary pointer--//
assign wr_full  = ((wr_pointer[POINTER-1 : 0] == rd_pointer_sync[POINTER-1 : 0]) && 
				(wr_pointer[POINTER] != rd_pointer_sync[POINTER] ));
//-- Gray pointer--//
//assign wr_full  = ((wr_pointer[POINTER-2 : 0] == rd_pointer_sync[POINTER-2 : 0]) && 
//				(wr_pointer[POINTER-1] != rd_pointer_sync[POINTER-1]) &&
//				(wr_pointer[POINTER] != rd_pointer_sync[POINTER]));
assign rd_empty = ((wr_pointer_sync == rd_pointer) == 0) ? 1'b1 : 1'b0;

assign data_out = mem[rd_pointer[POINTER-1 : 0]];

//--binary code to gray code--//
assign wr_pointer_g = wr_pointer ^ (wr_pointer >> 1);
assign rd_pointer_g = rd_pointer ^ (rd_pointer >> 1);
//--gray code to binary code--//
assign wr_pointer_sync = wr_sync_2 ^ (wr_sync_2 >> 1) ^ 
						(wr_sync_2 >> 2) ^ (wr_sync_2 >> 3);
assign rd_pointer_sync = rd_sync_2 ^ (rd_sync_2 >> 1) ^ 
						(rd_sync_2 >> 2) ^ (rd_sync_2 >> 3);

				
				  
endmodule
