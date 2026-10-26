//////////////////////////////////////////////////////////////////////////////////
// Copyright © Advanced Micro Devices, Inc., or its affiliates.
//
// SPDX-License-Identifier:  MIT
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps

module Command_Decode_LP5(
input clk,
input CS,
// input ACT,
input [6:0] CA,
//input [16:0] adr,
//input [1:0] bg,
//input [1:0] ba,
output reg nop,
output reg write16,
output reg write32,
output reg read16,
output reg read32,
output reg cas,
output reg precharge,
output reg prechargeAll,
output reg refresh,
output reg refreshAll,
output reg activate1,
output reg activate2,
output reg modeRegister1,
output reg modeRegister2,
output reg refreshManagement,
output reg autoPrecharge,
output reg maskWrite,
//output activate_2,
output reg [16:0] write_c,
output reg [16:0] read_c,
output reg [16:0] cas_c,
output reg [16:0] precharge_c,
output reg [16:0] prechargeAll_c,
output reg [16:0] refresh_c,
output reg [16:0] refreshAll_c,
output reg [16:0] activate1_c,
output reg [16:0] activate2_c,
output reg [16:0] refreshManagement_c,
output reg [16:0] modeRegister1_c,
output reg [16:0] modeRegister2_c,
output reg [6:0] MA,
output reg [6:0] OP,
output reg [1:0] BA,
output reg [1:0] BA_BG,
output reg [17:0] row,
output reg [5:0] col
//output [9:0]  colAddrOut, commented for now
//output [18:0] rowAddrOut, commented for now
//output [2:0] BA commented for now
);





/*reg write16;
reg write32;
reg read16;
reg read32;
reg cas;
reg precharge;
reg prechargeAll;
reg refresh;
reg refreshAll;
reg activate1;
reg activate2;
reg modeRegister1;
reg modeRegister2;
reg refreshManagement;
reg nextCycleKnown;
reg autoPrecharge;
reg maskWrite;
reg [16:0] cas_c;
reg [16:0] write_c;
reg [16:0] read_c;
reg [16:0] precharge_c;
reg [16:0] prechargeAll_c;
reg [16:0] refresh_c;
reg [16:0] refreshAll_c;
reg [16:0] activate1_c;
reg [16:0] activate2_c;
reg [16:0] modeRegister1_c;
reg [16:0] modeRegister2_c;
reg [6:0] MA;
reg [6:0] OP;
reg [1:0] BA;
reg [1:0] BA_BG;
reg [17:0] row;
reg [5:0] col;*/
//Commenting for now
//reg [9:0]  colAddr;
//reg [9:0]  colAddrOut;
//reg [18:0] rowAddr;
//reg [18:0] rowAddrOut;
//reg [2:0] BA;
//reg [18:0] rowAddrSave [7:0];
//reg [1:0] bankArchitecture;

reg nextCycleKnown;



initial
begin
cas_c = 0;
write_c = 0;
read_c = 0;
precharge_c = 0;
prechargeAll_c =0;
refresh_c = 0;
refreshAll_c = 0; 
activate1_c = 0;
activate2_c = 0;
modeRegister1_c = 0;
modeRegister2_c = 0;
nextCycleKnown = 0;
maskWrite = 0;

//$monitor("Monitor: write_c = %d read_c = %d precharge_c = %d prechargeAll_c = %d refresh_c = %d refreshAll_c = %d activate1_c = %d activate2_c = %d modeRegister1_c= %d modeRegister2_c = %d", write_c, read_c, precharge_c, prechargeAll_c, refresh_c, refreshAll_c, activate1_c, activate2_c, modeRegister1_c, modeRegister2_c);


end





//Find command on posedge of clk 
always@(posedge clk)
begin
if(CS && !nextCycleKnown)
begin
    if(!CA[6] && !CA[5] && !CA[4] && !CA[3] && !CA[2] && !CA[1] && !CA[0]) //NOP
    begin
        nop <= 1;
        write16 <= 0;
		write32 <= 0;
		read16 <= 0;
		read32 <= 0;
		cas <= 0;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 0;
		modeRegister1 <= 0;
		modeRegister2 <= 0;
		refreshManagement <= 0; 
		nextCycleKnown <= 0;
		maskWrite <= 0;
		autoPrecharge <= 0;
    end
    else if(CA[6] && !CA[5] && CA[4] && CA[3] && !CA[2] && !CA[1] && !CA[0]) //MODE REGISTER 1
	begin
		//Mode Register 1
		write16 <= 0;
		write32 <= 0;
		read16 <= 0;
		read32 <= 0;
		cas <= 0;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 0;
		modeRegister1 <= 1;
		modeRegister2 <= 0;
		refreshManagement <= 0; 
		nextCycleKnown <= 1;
		maskWrite <= 0;
		autoPrecharge <= 0;
		nop <= 0;
		modeRegister1_c <= modeRegister1_c + 1;
	end
	else if(!CA[5] && !CA[4] && CA[3] && !CA[2] && !CA[1] && !CA[0]) //MODE REGISTER 2
	begin
		//Mode Register 2
		nop <= 0;
		write16 <= 0;
		write32 <= 0;
		read16 <= 0;
		read32 <= 0;
		cas <= 0;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 0;
		modeRegister1 <= 0;
		modeRegister2 <= 1;
		refreshManagement <= 0; 
		nextCycleKnown <= 1;
		maskWrite <= 0;
		autoPrecharge <= 0;
		modeRegister2_c <= modeRegister2_c + 1;
	end
    else if(CA[6] && CA[5] && CA[4] && CA[3]&& !CA[2]&& !CA[1]&& !CA[0]) //PRECHARGE
    begin
        //Precharge
        nop <= 0;
		write16 <= 0;
		write32 <= 0;
		read16 <= 0;
		read32 <= 0;
		cas <= 0;
		precharge <= 1;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 0;
		modeRegister1 <= 0;
		modeRegister2 <= 0;
		refreshManagement <= 0;
		maskWrite <= 0;
		autoPrecharge <= 0;
		nextCycleKnown <= 1;
		precharge_c <= precharge_c + 1;
    end
    else if(!CA[6] && CA[5] && CA[4] && CA[3] && !CA[2] && !CA[1] && !CA[0]) //REFRESH
    begin
        //Refresh
        nop <= 0;
		write16 <= 0;
		write32 <= 0;
		read16 <= 0;
		read32 <= 0;
		cas <= 0;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 1;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 0;
		modeRegister1 <= 0;
		modeRegister2 <= 0;
		refreshManagement <= 0; 
		maskWrite <= 0;
		autoPrecharge <= 0;
		nextCycleKnown <= 1;  
    end
    else if(CA[2] && CA[1] && !CA[0]) //WRITE16
    begin
        //Write16
        nop <= 0;
		write16 <= 1;
		write32 <= 0;
		read16 <= 0;
		read32 <= 0;
		cas <= 0;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 0;
		modeRegister1 <= 0;
		modeRegister2 <= 0;
		refreshManagement <= 0; 
		nextCycleKnown <= 1;
		maskWrite <= 0;
		autoPrecharge <= 0;
		write_c <= write_c + 1;
		col[0] <= CA[3];
		col[3] <= CA[4];
		col[4] <= CA[5];
		col[5] <= CA[6];
		$display("Display: write_c = %d read_c = %d precharge_c = %d prechargeAll_c = %d refresh_c = %d refreshAll_c = %d activate1_c = %d activate2_c = %d modeRegister1_c= %d modeRegister2_c = %d", write_c, read_c, precharge_c, prechargeAll_c, refresh_c, refreshAll_c, activate1_c, activate2_c, modeRegister1_c, modeRegister2_c);
    end
	else if(!CA[3] && CA[2] && !CA[1] && !CA[0]) //WRITE32
	begin
		//Write32
		nop <= 0;
		write16 <= 0;
		write32 <= 1;
		read16 <= 0;
		read32 <= 0;
		cas <= 0;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 0;
		modeRegister1 <= 0;
		modeRegister2 <= 0;
		refreshManagement <= 0;
		maskWrite <= 0;
		autoPrecharge <= 0;
		nextCycleKnown <= 1;
		write_c <= write_c + 1;
		col[3] <= CA[4];
		col[4] <= CA[5];
		col[5] <= CA[6];
	end
    else if(!CA[2]&& !CA[1]&& CA[0]) //READ16
    begin
		//Read16
		nop <= 0;
		write16 <= 0;
		write32 <= 0;
		read16 <= 1;
		read32 <= 0;
		cas <= 0;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 0;
		modeRegister1 <= 0;
		modeRegister2 <= 0;
		refreshManagement <= 0;
		maskWrite <= 0;
		autoPrecharge <= 0;
		nextCycleKnown <= 1;
		read_c <= read_c + 1;
		col[0] <= CA[3];
		col[3] <= CA[4];
		col[4] <= CA[5];
		col[5] <= CA[6];
    end
	else if(CA[2] && !CA[1] && CA[0]) //READ32
	begin
		//Read32
		nop <= 0;
		write16 <= 0;
		write32 <= 0;
		read16 <= 0;
		read32 <= 1;
		cas <= 0;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 0;
		modeRegister1 <= 0;
		modeRegister2 <= 0;
		refreshManagement <= 0;
		maskWrite <= 0;
		autoPrecharge <= 0;
		nextCycleKnown <= 1;
		read_c <= read_c + 1;
		col[0] <= CA[3];
		col[3] <= CA[4];
		col[4] <= CA[5];
		col[5] <= CA[6];
	end
    else if(CA[3]&& CA[2]&& !CA[1]&& !CA[0]) //CAS
    begin
        //Cas
        nop <= 0;
   		write16 <= 0;
		write32 <= 0;
		read16 <= 0;
		read32 <= 0;
		cas <= 1;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 0;
		modeRegister1 <= 0;
		modeRegister2 <= 0;
		refreshManagement <= 0; 
		maskWrite <= 0;
		autoPrecharge <= 0;
		nextCycleKnown <= 1;
		cas_c <= cas_c + 1;
    end
    else if(CA[2] && CA[1]&& CA[0]) //ACTIVATE1
    begin
        //Activate1
        nop <= 0;
   		write16 <= 0;
		write32 <= 0;
		read16 <= 0;
		read32 <= 0;
		cas <= 0;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 1;
		activate2 <= 0;
		modeRegister1 <= 0;
		modeRegister2 <= 0;
		refreshManagement <= 0;
		maskWrite <= 0;
		autoPrecharge <= 0;
		nextCycleKnown <= 1;   
		activate1_c <= activate1_c + 1;
		row[14] <= CA[3];
		row[15] <= CA[4];
		row[16] <= CA[5];
		row[17] <= CA[6];
    end
	else if(!CA[2] && CA[1] && CA[0]) //ACTIVATE2
	begin 
        //Activate2
        nop <= 0;
   		write16 <= 0;
		write32 <= 0;
		read16 <= 0;
		read32 <= 0;
		cas <= 0;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 1;
		modeRegister1 <= 0;
		modeRegister2 <= 0;
		refreshManagement <= 0; 
		autoPrecharge <= 0;
		nextCycleKnown <= 1;
		maskWrite <= 0;
		activate2_c <= activate2_c + 1;
		row[7] <= CA[3];
		row[8] <= CA[4];
		row[9] <= CA[5];
		row[10] <= CA[6];
	end
	else if(!CA[6] && CA[5] && CA[4] && CA[3] && !CA[2] && !CA[1] && !CA[0]) //REFRESH MANAGEMENT
	begin
	    //Refresh Management
	    nop <= 0;
   		write16 <= 0;
		write32 <= 0;
		read16 <= 0;
		read32 <= 0;
		cas <= 0;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 0;
		modeRegister1 <= 0;
		modeRegister2 <= 0;
		maskWrite <= 0;
		autoPrecharge <= 0;
		refreshManagement <= 1; 
		nextCycleKnown <= 1;
	end
	else if(!CA[2] && CA[1] && !CA[0]) //MASK WRITE
	begin
		//Mask write
		nop <= 0;
		write16 <= 0;
		write32 <= 0;
		read16 <= 0;
		read32 <= 0;
		cas <= 0;
		precharge <= 0;
		prechargeAll <= 0;
		refresh <= 0;
		refreshAll <= 0;
		activate1 <= 0;
		activate2 <= 0;
		modeRegister1 <= 0;
		modeRegister2 <= 0;
		maskWrite <= 1;
		refreshManagement <= 1; 
		autoPrecharge <= 0;
		nextCycleKnown <= 1;
		write_c <= write_c + 1;
	end
end
end
//Command is known and store necessary bits on falling edge of cycle
always@(negedge clk)
begin
if(nextCycleKnown)
begin
	if(modeRegister1)
	begin
		MA[6] <= CA[6];
		MA[5] <= CA[5];
		MA[4] <= CA[4];
		MA[3] <= CA[3];
		MA[2] <= CA[2];
		MA[1] <= CA[1];
		MA[0] <= CA[0];
		nextCycleKnown <= 0;
	end
	else if(maskWrite)
	begin
		nextCycleKnown <= 0;
	end
	else if(modeRegister2) 
	begin 
		MA[6] <= CA[6];
		OP[5] <= CA[5];
		OP[4] <= CA[4];
		OP[3] <= CA[3];
		OP[2] <= CA[2];
		OP[1] <= CA[1];
		OP[0] <= CA[0];
		nextCycleKnown <= 0;
	end 
	else if(activate1)
	begin
		BA[0] <= CA[0];
		BA[1] <= CA[1];
		BA_BG[0] <= CA[2];
		BA_BG[1] <= CA[3];
		row[11] <= CA[4];
		row[12] <= CA[5];
		row[13] <= CA[6];
		nextCycleKnown <= 0;
	end
	else if(activate2)
	begin
		row[6] <= CA[6];
		row[5] <= CA[5];
		row[4] <= CA[4];
		row[3] <= CA[3];
		row[2] <= CA[2];
		row[1] <= CA[1];
		row[0] <= CA[0];
		nextCycleKnown <= 0;
	end
	else if(write16)
	begin
		col[1] <= CA[4];
		col[2] <= CA[5];
		BA[0] <= CA[0];
		BA[1] <= CA[1];
		BA_BG[0] <= CA[2]; 
		BA_BG[1] <= CA[3];
		nextCycleKnown <= 0;
		if(CA[6])
		begin
			autoPrecharge <= 1;
		end
	end
	else if(write32)
	begin
		col[1] <= CA[4];
		col[2] <= CA[5];
		BA[0] <= CA[0];
		BA[1] <= CA[1];
		BA_BG[0] <= CA[2];
		BA_BG[1] <= CA[3];
		nextCycleKnown <= 0;
		if(CA[6])
		begin
			autoPrecharge <= 1;
		end
	end
	else if(read16)
	begin
		col[1] <= CA[4];
		col[2] <= CA[5];
		BA[0] <= CA[0];
		BA[1] <= CA[1];
		BA_BG[0] <= CA[2];
		BA_BG[1] <= CA[3];
		nextCycleKnown <= 0;
		if(CA[6])
		begin
			autoPrecharge <= 1;
		end
	end
	else if(read32)
	begin 
		col[1] <= CA[4];
		col[2] <= CA[5];
		BA[0] <= CA[0];
		BA[1] <= CA[1];
		BA_BG[0] <= CA[2];
		BA_BG[1] <= CA[3];
		nextCycleKnown <= 0;
		if(CA[6])
		begin
			autoPrecharge <= 1;
		end
	end
	else if(refreshManagement)
	begin
		nextCycleKnown <= 0;
		BA[0] <= CA[0];
		BA[1] <= CA[1];
		BA_BG[0] <= CA[3];
	end
	else if(cas)
	begin
		nextCycleKnown <= 0; 
	end
	else if(refresh)
	begin
		if(CA[6])
		begin
			refreshAll <= 1;
		end
		else
		begin
			BA[0] <= CA[0];
			BA[1] <= CA[1];
			BA_BG[0] <= CA[2];
		end
		nextCycleKnown <= 0;
	end
	else if(precharge) 
	begin
		nextCycleKnown <= 0;
	end
	
end 
end


endmodule


