//////////////////////////////////////////////////////////////////////////////////
// Copyright © Advanced Micro Devices, Inc., or its affiliates.
//
// SPDX-License-Identifier:  MIT
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns

module Command_Decode_DDR5(
input clk,
input CS,
input [13:0] CA,
output writePattern,
output writePatternAutoPre,
output write,
output writeAutoPre,
output modeRegWrite,
output modeRegRead,
output read,
output readAutoPre,
output prechargeSameBank,
output prechargeAll,
output precharge,
output refreshManagementAll,
output refreshAll,
output refreshSameBank,
output refreshManagementSameBank,
output activate,
output [1:0] BA,
output [2:0] BG,
output [17:0] row,
output [10:0] col,
output [7:0] OP,
output [16:0] write_c,
output [16:0] read_c,
output [16:0] precharge_c,
output [16:0] prechargeAll_c,
output [16:0] refresh_c,
output [16:0] refreshAll_c,
output [16:0] activate_c,
output [16:0] refreshManagement_c,
output [16:0] modeRegRead_c,
output [16:0] modeRegWrite_c
);

reg writePattern;
reg writePatternAutoPre;
reg write;
reg writeAutoPre;
reg modeRegWrite;
reg modeRegRead;
reg read;
reg readAutoPre;
reg prechargeSameBank;
reg prechargeAll;
reg precharge;
reg refreshManagementAll;
reg refreshAll;
reg refreshSameBank;
reg refreshManagementSameBank;
reg activate;
reg [1:0] BA;
reg [2:0] BG;
reg [17:0] row;
reg [10:0] col;
reg [7:0] OP;
reg [16:0] write_c;
reg [16:0] read_c;
reg [16:0] precharge_c;
reg [16:0] prechargeAll_c;
reg [16:0] refresh_c;
reg [16:0] refreshAll_c;
reg [16:0] activate_c;
reg [16:0] refreshManagement_c;
reg [16:0] modeRegRead_c;
reg [16:0] modeRegWrite_c;

reg pending_act_cycle2;
reg pending_mrw_cycle2;
reg pending_wrp_group_cycle2;
reg pending_wr_group_cycle2;
reg pending_rd_group_cycle2;

initial begin
	writePattern = 0;
	writePatternAutoPre = 0;
	write = 0;
	writeAutoPre = 0;
	modeRegWrite = 0;
	modeRegRead = 0;
	read = 0;
	readAutoPre = 0;
	prechargeSameBank = 0;
	prechargeAll = 0;
	precharge = 0;
	refreshManagementAll = 0;
	refreshAll = 0;
	refreshSameBank = 0;
	refreshManagementSameBank = 0;
	activate = 0;

	BA = 0;
	BG = 0;
	row = 0;
	col = 0;
	OP = 0;

	write_c = 0;
	read_c = 0;
	precharge_c = 0;
	prechargeAll_c = 0;
	refresh_c = 0;
	refreshAll_c = 0;
	activate_c = 0;
	refreshManagement_c = 0;
	modeRegRead_c = 0;
	modeRegWrite_c = 0;

	pending_act_cycle2 = 0;
	pending_mrw_cycle2 = 0;
	pending_wrp_group_cycle2 = 0;
	pending_wr_group_cycle2 = 0;
	pending_rd_group_cycle2 = 0;
end

always @(negedge CS) begin
	writePattern <= 0;
	writePatternAutoPre <= 0;
	write <= 0;
	writeAutoPre <= 0;
	modeRegWrite <= 0;
	modeRegRead <= 0;
	read <= 0;
	readAutoPre <= 0;
	prechargeSameBank <= 0;
	prechargeAll <= 0;
	precharge <= 0;
	refreshManagementAll <= 0;
	refreshAll <= 0;
	refreshSameBank <= 0;
	refreshManagementSameBank <= 0;
	activate <= 0;

	pending_act_cycle2 <= 0;
	pending_mrw_cycle2 <= 0;
	pending_wrp_group_cycle2 <= 0;
	pending_wr_group_cycle2 <= 0;
	pending_rd_group_cycle2 <= 0;

	// ACT (Cycle 1): CA1=0, CA0=0
	if (!CA[1] && !CA[0]) begin
		activate <= 1;
		activate_c <= activate_c + 1;

		row[0] <= CA[2];
		row[1] <= CA[3];
		row[2] <= CA[4];
		row[3] <= CA[5];

		BA[0] <= CA[6];
		BA[1] <= CA[7];
		BG[0] <= CA[8];
		BG[1] <= CA[9];
		BG[2] <= CA[10];

		pending_act_cycle2 <= 1;
	end
	// WRP/WRPA (Cycle 1): 1 0 0 1 0 1 on CA0..CA5
	else if (CA[5] && !CA[4] && CA[3] && !CA[2] && !CA[1] && CA[0]) begin
		BA[0] <= CA[6];
		BA[1] <= CA[7];
		BG[0] <= CA[8];
		BG[1] <= CA[9];
		BG[2] <= CA[10];
		pending_wrp_group_cycle2 <= 1;
	end
	// MRW (Cycle 1): 1 0 1 0 0 on CA0..CA4
	else if (!CA[4] && !CA[3] && CA[2] && !CA[1] && CA[0]) begin
		modeRegWrite <= 1;
		modeRegWrite_c <= modeRegWrite_c + 1;

		OP <= 0;
		pending_mrw_cycle2 <= 1;
	end
	// MRR (Cycle 1): 1 0 1 0 1 on CA0..CA4
	else if (CA[4] && !CA[3] && CA[2] && !CA[1] && CA[0]) begin
		modeRegRead <= 1;
		modeRegRead_c <= modeRegRead_c + 1;
	end
	// WR/WRA (Cycle 1): 1 0 1 1 0 BL* on CA0..CA5
	else if (!CA[4] && CA[3] && CA[2] && !CA[1] && CA[0]) begin
		BA[0] <= CA[6];
		BA[1] <= CA[7];
		BG[0] <= CA[8];
		BG[1] <= CA[9];
		BG[2] <= CA[10];
		pending_wr_group_cycle2 <= 1;
	end
	// RD/RDA (Cycle 1): 1 0 1 1 1 BL* on CA0..CA5
	else if (CA[4] && CA[3] && CA[2] && !CA[1] && CA[0]) begin
		BA[0] <= CA[6];
		BA[1] <= CA[7];
		BG[0] <= CA[8];
		BG[1] <= CA[9];
		BG[2] <= CA[10];
		pending_rd_group_cycle2 <= 1;
	end
	// Legacy one-cycle decodes retained from previous interface
	else if (CA[4] && !CA[3] && !CA[2] && CA[1] && CA[0]) begin
		refreshAll <= 1;
		refreshAll_c <= refreshAll_c + 1;
	end
	else if (!CA[4] && CA[3] && !CA[2] && CA[1] && CA[0]) begin
		prechargeAll <= 1;
		prechargeAll_c <= prechargeAll_c + 1;
	end
	else if (CA[4] && CA[3] && !CA[2] && CA[1] && CA[0]) begin
		precharge <= 1;
		precharge_c <= precharge_c + 1;
	end
end

// Capture Cycle-2 payload for multi-cycle commands when CS is high
always @(posedge clk) begin
	if (CS && pending_act_cycle2) begin
		row[4] <= CA[0];
		row[5] <= CA[1];
		row[6] <= CA[2];
		row[7] <= CA[3];
		row[8] <= CA[4];
		row[9] <= CA[5];
		row[10] <= CA[6];
		row[11] <= CA[7];
		row[12] <= CA[8];
		row[13] <= CA[9];
		row[14] <= CA[10];
		row[15] <= CA[11];
		row[16] <= CA[12];
		row[17] <= CA[13];
		pending_act_cycle2 <= 0;
	end

	if (CS && pending_mrw_cycle2) begin
		OP[0] <= CA[0];
		OP[1] <= CA[1];
		OP[2] <= CA[2];
		OP[3] <= CA[3];
		OP[4] <= CA[4];
		OP[5] <= CA[5];
		OP[6] <= CA[6];
		OP[7] <= CA[7];
		pending_mrw_cycle2 <= 0;
	end

	if (CS && pending_wrp_group_cycle2) begin
		col[2] <= CA[0];
		col[3] <= CA[1];
		col[4] <= CA[2];
		col[5] <= CA[3];
		col[6] <= CA[4];
		col[7] <= CA[5];
		col[8] <= CA[6];
		col[9] <= CA[7];
		col[10] <= CA[8];
		col[1:0] <= 2'b00;

		if (CA[10]) begin
			writePattern <= 1;
			writePatternAutoPre <= 0;
		end else begin
			writePattern <= 0;
			writePatternAutoPre <= 1;
		end
		write_c <= write_c + 1;
		pending_wrp_group_cycle2 <= 0;
	end

	if (CS && pending_wr_group_cycle2) begin
		col[2] <= CA[0];
		col[3] <= CA[1];
		col[4] <= CA[2];
		col[5] <= CA[3];
		col[6] <= CA[4];
		col[7] <= CA[5];
		col[8] <= CA[6];
		col[9] <= CA[7];
		col[10] <= CA[8];
		col[1:0] <= 2'b00;

		if (CA[10]) begin
			write <= 1;
			writeAutoPre <= 0;
		end else begin
			write <= 0;
			writeAutoPre <= 1;
		end
		write_c <= write_c + 1;
		pending_wr_group_cycle2 <= 0;
	end

	if (CS && pending_rd_group_cycle2) begin
		col[2] <= CA[0];
		col[3] <= CA[1];
		col[4] <= CA[2];
		col[5] <= CA[3];
		col[6] <= CA[4];
		col[7] <= CA[5];
		col[8] <= CA[6];
		col[9] <= CA[7];
		col[10] <= CA[8];
		col[1:0] <= 2'b00;

		if (CA[10]) begin
			read <= 1;
			readAutoPre <= 0;
		end else begin
			read <= 0;
			readAutoPre <= 1;
		end
		read_c <= read_c + 1;
		pending_rd_group_cycle2 <= 0;
	end
end

// Make command outputs one-cycle pulses
always @(negedge clk) begin
	writePattern <= 0;
	writePatternAutoPre <= 0;
	write <= 0;
	writeAutoPre <= 0;
	modeRegWrite <= 0;
	modeRegRead <= 0;
	read <= 0;
	readAutoPre <= 0;
	prechargeSameBank <= 0;
	prechargeAll <= 0;
	precharge <= 0;
	refreshManagementAll <= 0;
	refreshAll <= 0;
	refreshSameBank <= 0;
	refreshManagementSameBank <= 0;
	activate <= 0;
end

endmodule

