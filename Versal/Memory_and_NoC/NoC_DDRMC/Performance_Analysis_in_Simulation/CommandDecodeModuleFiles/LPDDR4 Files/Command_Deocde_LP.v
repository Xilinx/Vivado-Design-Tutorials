`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2022 02:51:12 PM
// Design Name: 
// Module Name: Command_Deocde_LP
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

module Command_Decode_LP(
input clk,
input CS,
// input ACT,
input [5:0] CA,
//input [16:0] adr,
//input [1:0] bg,
//input [1:0] ba,
output write,
output read,
//output cas_2,
output precharge,
output prechargeAll,
output refresh,
output refreshAll,
output activate,
//output activate_2,
output [16:0] write_c,
output [16:0] read_c,
//output [16:0] cas_2_c,
output [16:0] precharge_c,
output [16:0] prechargeAll_c,
output [16:0] refresh_c,
output [16:0] refreshAll_c,
output [16:0] activate_c,
output [9:0]  colAddrOut,
output [18:0] rowAddrOut,
output [2:0] BA
);





reg write;
reg read;
reg cas_2;
reg precharge;
reg prechargeAll;
reg refresh;
reg refreshAll;
reg activate;
//reg activate_2;
reg [16:0] write_c;
reg [16:0] read_c;
reg [16:0] precharge_c;
reg [16:0] prechargeAll_c;
//reg [16:0] cas_2_c;
reg [16:0] refresh_c;
reg [16:0] refreshAll_c;
reg [16:0] activate_c;
reg [9:0]  colAddr;
reg [9:0]  colAddrOut;
reg [18:0] rowAddr;
reg [18:0] rowAddrOut;
reg [2:0] BA;
reg [18:0] rowAddrSave [7:0];





reg nextCommandKnown;





initial
begin
write_c = 0;
read_c = 0;
precharge_c = 0;
prechargeAll_c =0;
//cas_2_c = 0;
refresh_c = 0;
refreshAll_c = 0; 
activate_c = 0;
nextCommandKnown = 0;
end






always@(posedge clk)
begin





if(CS && !nextCommandKnown)
begin
    if(CA[4] && !CA[3]&& !CA[2]&& !CA[1]&& !CA[0])
    begin
        if(CA[5]) 
        begin 
        //precharge All     
        prechargeAll <= 1;
        refresh <= 0;
        write <= 0;
        read <= 0;
        cas_2 <= 0;
        activate <=0;
       // activate_2 <=0;
        precharge <= 0;
        refreshAll <= 0; 
        prechargeAll_c <= prechargeAll_c + 1;         
        end 
        else
        begin 
        //precharge     
        precharge <= 1;
        prechargeAll <= 0; 
        refresh <= 0;
        refreshAll <= 0; 
        write <= 0;
        read <= 0;
        cas_2 <= 0;
        activate <=0;
      //  activate_2 <=0;
        precharge_c <= precharge_c + 1;
        end 
    end
    else if(!CA[4] && CA[3]&& !CA[2]&& !CA[1]&& !CA[0])
    begin
        if(CA[5])
        begin
        //refresh all     
        precharge <= 0;
        prechargeAll <= 0; 
        refresh <= 0;
        refreshAll <= 1; 
        write <= 0;
        read <= 0;
        cas_2 <= 0;
        activate <=0;
        //activate_2 <=0;
        refreshAll_c <= refreshAll_c + 1;   
        end
        else
        begin
        //refresh
        refresh <= 1;
        refreshAll <= 0;
        write <= 0;
        read <= 0;
        cas_2 <= 0;
        activate <=0;
        //activate_2 <=0;
        precharge  <=0;
        prechargeAll <= 0;
        refresh_c <= refresh_c + 1;
        end
    end
    else if((!CA[4] && !CA[3]&& CA[2]&& !CA[1]&& !CA[0]) || (!CA[5] && !CA[4] && CA[3]&& CA[2]&& !CA[1]&& !CA[0]))
    begin
        //write
        write <= 1;
        read <= 0;
        cas_2 <= 0;
        activate  <=0;
        //activate_2 <=0;
        precharge  <=0;
        prechargeAll <= 0;
        refresh <= 0;
        refreshAll <= 0;
        write_c <= write_c + 1;
    end
    else if(!CA[4] && !CA[3]&& !CA[2]&& CA[1]&& !CA[0])
    begin
        //read
        read <= 1;
        write <= 0;
        cas_2 <= 0;
        activate <= 0;
        //activate_2 <=0;
        precharge  <=0;
        prechargeAll <= 0;
        refresh <= 0;
        refreshAll <= 0;
        read_c <= read_c + 1;
    end
    else if(CA[4] && !CA[3]&& !CA[2]&& CA[1]&& !CA[0])
    begin
        //cas_2
        cas_2 <= 1;
        colAddr[8] <= CA[5];
      //  activate_1 <= 0;
      //  activate_2 <=0;
      //  precharge  <=0;
      // refresh <= 0;
      // read <= 0;
      //  write <= 0;
      //  cas_2_c <= cas_2_c + 1;
    end
    else if(!CA[1]&& CA[0])
    begin
        //activate_1
        //capture command and row bits during CS high cycle
        //nextCommandKnown set to high because activate_2 doesn't have unique ID and bits in high cycle must be stored
        activate <= 1;
        rowAddr[15] <= CA[5];
        rowAddr[14] <= CA[4];
        rowAddr[13] <= CA[3];
        rowAddr[12] <= CA[2];
        //nextCommandKnown <= 1;
      //  activate_2 <=0;
        precharge  <=0;
        prechargeAll <= 0;
        refresh <= 0;
        refreshAll <= 0;
        read <= 0;
        write <= 0;  
        cas_2 <= 0;
        activate_c <= activate_c + 1;
    end
end
else if(CS && nextCommandKnown)
begin
    //activate_2 and store necessary bits
    //activate_2 <= 1;
    rowAddr[9] <= CA[5];
    rowAddr[8] <= CA[4];
    rowAddr[7] <= CA[3];
    rowAddr[6] <= CA[2];
    rowAddr[18] <= CA[1];
    rowAddr[17] <= CA[0];
    //nextCommandKnown <= 0;
end
else if(!CS)
begin
    //based on command -> store the bits
    if(precharge || prechargeAll)
    begin
        BA[0] <= CA[0];
        BA[1] <= CA[1];
        BA[2] <= CA[2];
        precharge <= 0;
        prechargeAll <= 0;
    end
    else if(refresh || refreshAll)
    begin
        BA[0] <= CA[0];
        BA[1] <= CA[1];
        BA[2] <= CA[2];
        refresh <= 0;
        refreshAll <= 0; 
    end
    else if(write && !cas_2)
    begin
        BA[0] <= CA[0];
        BA[1] <= CA[1];
        BA[2] <= CA[2];
        colAddr[9] <= CA[4];
        //write <= 0;
    end
    else if(read && !cas_2)
    begin
        BA[0] <= CA[0];
        BA[1] <= CA[1];
        BA[2] <= CA[2];
        colAddr[9] <= CA[4];
        //read <= 0;
    end
    else if(cas_2)
    begin
        colAddrOut[9] <= colAddr[9];
        colAddrOut[8] <= colAddr[8];
        colAddrOut[7] <= CA[5];
        colAddrOut[6] <= CA[4];
        colAddrOut[5] <= CA[3];
        colAddrOut[4] <= CA[2];
        colAddrOut[3] <= CA[1];
        colAddrOut[2] <= CA[0];
        colAddrOut[1] <= 0;
        colAddrOut[0] <= 0;
        rowAddrOut <= rowAddrSave[BA];
        cas_2 <= 0;
        if(read)
            read <= 0; 
        else if(write)
            write <= 0; 
    end
    else if(activate && nextCommandKnown)
    begin
        rowAddrSave[BA][5:0] <= CA[5:0];
        rowAddrSave[BA][18:6] <= rowAddr[18:6];
        activate <= 0;
        nextCommandKnown <= 0;
  end
    else if(activate)
    begin
        rowAddr[11] <= CA[5];
        rowAddr[10] <= CA[4];
        rowAddr[16] <= CA[3];
        BA[0] <= CA[0];
        BA[1] <= CA[1];
        BA[2] <= CA[2];
        nextCommandKnown <= 1;
        //activate_1 <= 0;
    end
    
      
end
end
endmodule
