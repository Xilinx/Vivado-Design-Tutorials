////////////////////////////////////////////////////////////////////////////
//-- (c) Copyright 2012 - 2013 Xilinx, Inc. All rights reserved.
//--
//-- This file contains confidential and proprietary information
//-- of Xilinx, Inc. and is protected under U.S. and
//-- international copyright and other intellectual property
//-- laws.
//--
//-- DISCLAIMER
//-- This disclaimer is not a license and does not grant any
//-- rights to the materials distributed herewith. Except as
//-- otherwise provided in a valid license issued to you by
//-- Xilinx, and to the maximum extent permitted by applicable
//-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
//-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
//-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//-- (2) Xilinx shall not be liable (whether in contract or tort,
//-- including negligence, or under any other theory of
//-- liability) for any loss or damage of any kind or nature
//-- related to, arising under or in connection with these
//-- materials, including for any direct, or any indirect,
//-- special, incidental, or consequential loss or damage
//-- (including loss of data, profits, goodwill, or any type of
//-- loss or damage suffered as a result of any action brought
//-- by a third party) even if such damage or loss was
//-- reasonably foreseeable or Xilinx had been advised of the
//-- possibility of the same.
//--
//-- CRITICAL APPLICATIONS
//-- Xilinx products are not designed or intended to be fail-
//-- safe, or for use in any application requiring fail-safe
//-- performance, such as life-support or safety devices or
//-- systems, Class III medical devices, nuclear facilities,
//-- applications related to the deployment of airbags, or any
//-- other applications that could lead to death, personal
//-- injury, or severe property or environmental damage
//-- (individually and collectively, "Critical
//-- Applications"). Customer assumes the sole risk and
//-- liability of any use of Xilinx products in Critical
//-- Applications, subject only to applicable laws and
//-- regulations governing limitations on product liability.
//--
//-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//-- PART OF THIS FILE AT ALL TIMES.
////////////////////////////////////////////////////////////////////////////
//
// AXI4 Slave interface example
//
// The purpose of this design is to provide a AXI4 burst capable Slave interface.
//
// The example slave design implements multiple memory ranges 256 words each . A
// master can write burst data to the example slave and read the data back. The
// slave supports INCR and WRAP type of bursts with variable burst lengths.
//
////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

////////////////////////////////////////////////////////////////////////////
// Width of S_AXI address bus. The slave accepts the read and write addresses
// of width C_S_AXI_ADDR_WIDTH.
`define C_S_AXI_ADDR_WIDTH 14

module axi_slave #(
  parameter integer C_S_AXI_ID_WIDTH = 2,
  ////////////////////////////////////////////////////////////////////////////
  // Width of S_AXI data bus. The slave accepts write data and issues read data
  // of width C_S_AXI_DATA_WIDTH
  parameter integer C_S_AXI_DATA_WIDTH = 64
) (
  ////////////////////////////////////////////////////////////////////////////
  // System Signals
  input  wire S_AXI_ACLK,
  input  wire S_AXI_ARESETN,

  ////////////////////////////////////////////////////////////////////////////
  // Slave Interface Write Address Ports

  ////////////////////////////////////////////////////////////////////////////
  // Write address ID. This signal is the identification tag
  // for the write address group ofsignals.
  input  wire [C_S_AXI_ID_WIDTH-1:0] S_AXI_AWID,
  ////////////////////////////////////////////////////////////////////////////
  // Write address. The write address bus gives the address
  // of the first transfer in a write burst transaction.
  input  wire [`C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
  ////////////////////////////////////////////////////////////////////////////
  // Burst length. The burst length gives the exact number
  // of transfers in a burst. This information determines
  // the number of data transfers associated with the address.
  input  wire [7:0] S_AXI_AWLEN,
  ////////////////////////////////////////////////////////////////////////////
  // Burst size. This signal indicates the size of each
  // transfer in the burst.
  input  wire [2:0] S_AXI_AWSIZE,
  ////////////////////////////////////////////////////////////////////////////
  // Burst type. The burst type and the size information,
  // determine how the address for each transfer within the
  // burst is calculated.
  input  wire [1:0] S_AXI_AWBURST,
  ////////////////////////////////////////////////////////////////////////////
  // Write address valid. This signal indicates that
  // the channel is signaling valid write address and
  // control information.
  input  wire S_AXI_AWVALID,
  ////////////////////////////////////////////////////////////////////////////
  // Write address ready. This signal indicates that
  // the slave is ready to accept an address and associated
  // control signals.
  output wire S_AXI_AWREADY,

  ////////////////////////////////////////////////////////////////////////////
  // Slave Interface Write Data Ports

  ////////////////////////////////////////////////////////////////////////////
  // Write data.
  input  wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
  ////////////////////////////////////////////////////////////////////////////
  // Write strobes. This signal indicates which byte
  // lanes hold valid data. There is one write strobe
  // bit for each eight bits of the write data bus.
  input  wire [C_S_AXI_DATA_WIDTH/8-1:0] S_AXI_WSTRB,
  ////////////////////////////////////////////////////////////////////////////
  // Write last. This signal indicates the last transfer
  // in a write burst.
  input  wire S_AXI_WLAST,
  ////////////////////////////////////////////////////////////////////////////
  // Write valid. This signal indicates that valid write
  // data and strobes are available.
  input  wire S_AXI_WVALID,
  ////////////////////////////////////////////////////////////////////////////
  // Write ready. This signal indicates that the slave
  // can accept the write data.
  output wire S_AXI_WREADY,

  ////////////////////////////////////////////////////////////////////////////
  // Slave Interface Write Response Ports

  ////////////////////////////////////////////////////////////////////////////
  // Response ID tag. This signal is the ID tag of the
  // write response.
  output wire [C_S_AXI_ID_WIDTH-1:0] S_AXI_BID,
  ////////////////////////////////////////////////////////////////////////////
  // Write response. This signal indicates the status
  // of the write transaction.
  output wire [1:0] S_AXI_BRESP,
  ////////////////////////////////////////////////////////////////////////////
  // Write response valid. This signal indicates that the
  // channel is signaling a valid write response.
  output wire S_AXI_BVALID,
  ////////////////////////////////////////////////////////////////////////////
  // Response ready. This signal indicates that the master
  // can accept a write response.
  input  wire S_AXI_BREADY,

  ////////////////////////////////////////////////////////////////////////////
  // Slave Interface Read Address Ports

  ////////////////////////////////////////////////////////////////////////////
  // Read address ID. This signal is the identification
  // tag for the read address group of signals.
  input  wire [C_S_AXI_ID_WIDTH-1:0] S_AXI_ARID,
  ////////////////////////////////////////////////////////////////////////////
  // Read address. This signal indicates the initial
  // address of a read burst transaction.
  input  wire [`C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
  ////////////////////////////////////////////////////////////////////////////
  // Burst length. This signal indicates the exact number
  // of transfers in a burst.
  input  wire [7:0] S_AXI_ARLEN,
  ////////////////////////////////////////////////////////////////////////////
  // Burst size. This signal indicates the size of each
  // transfer in the burst.
  input  wire [2:0] S_AXI_ARSIZE,
  ////////////////////////////////////////////////////////////////////////////
  // Burst type. The burst type and the size information
  // determine how the address for each transfer within
  // the burst is calculated.
  input  wire [1:0] S_AXI_ARBURST,
  ////////////////////////////////////////////////////////////////////////////
  // Read address valid. This signal indicates that the
  // channel is signaling valid read address and control
  // information.
  input  wire S_AXI_ARVALID,
  ////////////////////////////////////////////////////////////////////////////
  // Read address ready. This signal indicates that the
  // slave is ready to accept an address and associated
  // control signals.
  output wire S_AXI_ARREADY,

  ////////////////////////////////////////////////////////////////////////////
  // Slave Interface Read Data Ports

  ////////////////////////////////////////////////////////////////////////////
  // Read ID tag. This signal is the identification tag
  // for the read data group of signals generated by the slave.
  output wire [C_S_AXI_ID_WIDTH-1:0] S_AXI_RID,
  ////////////////////////////////////////////////////////////////////////////
  // Read data.
  output wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
  ////////////////////////////////////////////////////////////////////////////
  // Read response. This signal indicates the status of
  // the read transfer.
  output wire [1:0] S_AXI_RRESP,
  ////////////////////////////////////////////////////////////////////////////
  // Read last. This signal indicates the last transfer
  // in a read burst.
  output wire S_AXI_RLAST,
  ////////////////////////////////////////////////////////////////////////////
  // Read valid. This signal indicates that the channel
  // is signaling the required read data.
  output wire S_AXI_RVALID,
  ////////////////////////////////////////////////////////////////////////////
  // Read ready. This signal indicates that the master can
  // accept the read data and response information.
  input  wire S_AXI_RREADY
);

////////////////////////////////////////////////////////////////////////////
// AXI4 internal signals

////////////////////////////////////////////////////////////////////////////
// read response
reg [1 :0] axi_rresp;
////////////////////////////////////////////////////////////////////////////
// write response
reg [1 :0] axi_bresp;
////////////////////////////////////////////////////////////////////////////
// write strobes
reg [C_S_AXI_DATA_WIDTH/8-1:0]  axi_wstrb;
////////////////////////////////////////////////////////////////////////////
// write address ready
reg axi_awready;
////////////////////////////////////////////////////////////////////////////
// write data ready
reg axi_wready;
////////////////////////////////////////////////////////////////////////////
// write respose valid
reg axi_bvalid;
////////////////////////////////////////////////////////////////////////////
// read data valid
reg axi_rvalid;
////////////////////////////////////////////////////////////////////////////
// write address
reg [`C_S_AXI_ADDR_WIDTH-1:0] axi_awaddr;
reg [7:0]                     axi_awlen;
reg [2:0]                     axi_awsize;
reg [`C_S_AXI_ADDR_WIDTH-1:0] awaddr_wrap_boundary;
reg [C_S_AXI_ID_WIDTH-1:0]    axi_awid;
reg [1:0]                     axi_awburst;
////////////////////////////////////////////////////////////////////////////
// read address
reg [`C_S_AXI_ADDR_WIDTH-1:0] axi_araddr;
reg [7:0]                     axi_arlen;
reg [2:0]                     axi_arsize;
reg [C_S_AXI_ID_WIDTH-1:0]    axi_arid;
reg [1:0]                     axi_arburst;
reg [`C_S_AXI_ADDR_WIDTH-1:0] araddr_wrap_boundary;
////////////////////////////////////////////////////////////////////////////
// read data
reg [C_S_AXI_DATA_WIDTH-1:0] axi_rdata;
////////////////////////////////////////////////////////////////////////////
// read address ready
reg axi_arready;
////////////////////////////////////////////////////////////////////////////
// last read
reg axi_rlast;

////////////////////////////////////////////////////////////////////////////
// Example-specific design signals
reg axi_awv_awr_flag;
reg axi_arv_arr_flag;
reg [7:0] axi_awlen_cntr;
reg [7:0] axi_arlen_cntr;

////////////////////////////////////////////////////////////////////////////
// function called clogb2 that returns an integer which has the
// value of the ceiling of the log base 2.
function integer clogb2 (input integer bd);
integer bit_depth;
begin
  bit_depth = bd;
  for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
    bit_depth = bit_depth >> 1;
  end
endfunction

localparam integer LP_ADDR_LSB = clogb2(C_S_AXI_DATA_WIDTH/8)-1;
localparam integer LP_ADDR_MSB = `C_S_AXI_ADDR_WIDTH;

////////////////////////////////////////////////////////////////////////////
// Signals for user logic memory space example
wire [7:0] mem_address;
reg [C_S_AXI_DATA_WIDTH-1:0] mem_data_out;

genvar i;
genvar j;
genvar mem_byte_index;

////////////////////////////////////////////////////////////////////////////
//I/O Connections assignments

////////////////////////////////////////////////////////////////////////////
//Write Address Ready (AWREADY)
assign S_AXI_AWREADY = axi_awready;

////////////////////////////////////////////////////////////////////////////
//Write Data Ready(WREADY)
assign S_AXI_WREADY  = axi_wready;

////////////////////////////////////////////////////////////////////////////
//Write Response (BResp)and response valid (BVALID)
assign S_AXI_BRESP  = axi_bresp;
assign S_AXI_BVALID = axi_bvalid;
assign S_AXI_BID    = axi_awid;

////////////////////////////////////////////////////////////////////////////
//Read Address Ready(AREADY)
assign S_AXI_ARREADY = axi_arready;

////////////////////////////////////////////////////////////////////////////
//Read and Read Data (RDATA), Read Valid (RVALID) and Response (RRESP)
assign S_AXI_RDATA  = mem_data_out;
assign S_AXI_RVALID = axi_rvalid;
assign S_AXI_RRESP  = axi_rresp;
assign S_AXI_RLAST  = axi_rlast;
assign S_AXI_RID    = S_AXI_ARID;

////////////////////////////////////////////////////////////////////////////
// Implement axi_awready generation
//axi_awready is asserted for one S_AXI_ACLK clock cycle when both
//S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
//de-asserted when reset is low.
always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_awready <= 1'b0;
    axi_awv_awr_flag <= 1'b0;
  end else begin
    if (~axi_awready && S_AXI_AWVALID && ~axi_awv_awr_flag && ~axi_arv_arr_flag) begin
      // slave is ready to accept an address and
      // associated control signals
      axi_awready <= 1'b1;
      axi_awv_awr_flag  <= 1'b1; // used for generation of bresp() and bvalid
    end else if (S_AXI_WLAST && axi_wready) begin // preparing to accept next address after current write completion
      axi_awv_awr_flag  <= 1'b0;
    end else begin
      axi_awready <= 1'b0;
    end
  end
end

wire [3:0]                  awaddr_offset;
reg  [4:0]                  aw_wrap_cnt;

assign awaddr_offset = S_AXI_AWADDR[S_AXI_AWSIZE +: 4] & S_AXI_AWLEN[3:0];
////////////////////////////////////////////////////////////////////////////
// Implement axi_awaddr latching
// 
// This process is used to latch the address when both
// S_AXI_AWVALID and S_AXI_WVALID are valid.
always @( posedge S_AXI_ACLK )  begin
  if (~axi_awready && S_AXI_AWVALID && ~axi_awv_awr_flag) begin
    axi_awsize <= S_AXI_AWSIZE;
    axi_awlen  <= S_AXI_AWLEN;
    axi_awid   <= S_AXI_AWID;
    axi_awburst <= S_AXI_AWBURST;
    aw_wrap_cnt <= {1'b0, ((awaddr_offset >0) ? awaddr_offset - 1 : 0) + {3'b000, (|awaddr_offset)}};

    awaddr_wrap_boundary <= S_AXI_AWADDR & ~(S_AXI_AWLEN[3:0] << S_AXI_AWSIZE);
  end
end

always @( posedge S_AXI_ACLK )  begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_awaddr <= {`C_S_AXI_ADDR_WIDTH{1'b0}};
    axi_awlen_cntr <= 8'h00;
  end else begin
    if (~axi_awready && S_AXI_AWVALID && ~axi_awv_awr_flag) begin
      // address latching
      axi_awaddr <= S_AXI_AWADDR[`C_S_AXI_ADDR_WIDTH - 1:0];

      axi_awlen_cntr <= S_AXI_AWLEN;
    end else if((axi_awlen_cntr > 0) && axi_wready && S_AXI_WVALID) begin
      axi_awlen_cntr <= axi_awlen_cntr - 1;

      case (axi_awburst)
        2'b00: begin // fixed burst
          axi_awaddr <= axi_awaddr;
        end
        2'b01: begin //incremental burst
          axi_awaddr <= (axi_awaddr & ~((1 << axi_awsize) - 1)) + (1 << axi_awsize);
        end
        2'b10: begin //Wrapping burst
          if (axi_awlen_cntr == aw_wrap_cnt) begin
            axi_awaddr <= awaddr_wrap_boundary;
          end else begin
            axi_awaddr <= (axi_awaddr & ~((1 << axi_awsize) - 1)) + (1 << axi_awsize);
          end
        end

        default: begin //reserved (incremental burst for example)
          axi_awaddr <= axi_awaddr & ~((1 << axi_awsize) - 1) + (1 << axi_awsize);
        end
      endcase
    end
  end
end

////////////////////////////////////////////////////////////////////////////
// Implement axi_wready generation
//
//  axi_wready is asserted for full burst when both
//  S_AXI_AWVALID and S_AXI_WVALID are asserted. The
//  slave is always ready to accept wdata. axi_wready is
//  de-asserted when reset is low and write burst is completed.

always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
      axi_wready <= 1'b0;
  end else begin
    if ( ~axi_wready && S_AXI_WVALID && axi_awv_awr_flag) begin
      // slave can accept the write data
      axi_wready <= 1'b1;
    end else if (S_AXI_WLAST && axi_wready) begin
      //else if (~axi_awv_awr_flag)
      axi_wready <= 1'b0;
    end
  end
end

////////////////////////////////////////////////////////////////////////////
// Implement write response logic generation
//
//  The write response and response valid signals are asserted by the slave
//  when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.
//  This marks the acceptance of address and indicates the status of
//  write transaction.
always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_bvalid <= 0;
    axi_bresp <= 2'b0;
  end else begin
    if (axi_awv_awr_flag && axi_wready && S_AXI_WVALID && ~axi_bvalid && S_AXI_WLAST ) begin
      axi_bvalid <= 1'b1;
      axi_bresp  <= 2'b00; // 'OKAY' response
    end else begin         // need to work more on the responses
      if (S_AXI_BREADY && axi_bvalid) begin //check if bready is asserted while bvalid is high)
                                            //(there is a possibility that bready is always asserted high)
        axi_bvalid <= 1'b0;
      end
    end
  end
end

////////////////////////////////////////////////////////////////////////////
// // Implement axi_arready generation
//
// axi_arready is asserted for one S_AXI_ACLK clock cycle when
// S_AXI_ARVALID is asserted. axi_awready is
// de-asserted when reset (active low) is asserted.
// The read address is also latched when S_AXI_ARVALID is
// asserted. axi_araddr is reset to zero on reset assertion.

always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_arready <= 1'b0;
    axi_arv_arr_flag <= 1'b0;
  end else begin
    if (~axi_arready && S_AXI_ARVALID && ~axi_awv_awr_flag && ~axi_arv_arr_flag) begin
      axi_arready <= 1'b1;
      axi_arv_arr_flag <= 1'b1;
    end else if (axi_rvalid && S_AXI_RREADY && (axi_arlen_cntr == 0)) begin // preparing to accept next address after current write completion begin
      axi_arv_arr_flag  <= 1'b0;
    end else begin
      axi_arready <= 1'b0;
    end
  end
end

wire [3:0]                  araddr_offset;
reg  [4:0]                  ar_wrap_cnt;

assign araddr_offset = S_AXI_ARADDR[S_AXI_ARSIZE +: 4] & S_AXI_ARLEN[3:0];

always @( posedge S_AXI_ACLK )  begin
  if (~axi_arready && S_AXI_ARVALID && ~axi_arv_arr_flag) begin
    axi_arsize <= S_AXI_ARSIZE;
    axi_arlen  <= S_AXI_ARLEN;
    axi_arid   <= S_AXI_ARID;
    axi_arburst <= S_AXI_ARBURST;
    araddr_wrap_boundary <= S_AXI_ARADDR & ~(S_AXI_ARLEN[3:0] << S_AXI_ARSIZE);
    ar_wrap_cnt <= {1'b0, ((araddr_offset >0) ? araddr_offset - 1 : 0) + {3'b000, (|araddr_offset)}};
  end
end

always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_araddr <= {`C_S_AXI_ADDR_WIDTH{1'b0}};
    axi_arlen_cntr <= 8'h00;
    axi_rlast <= 1'b0;
  end else begin
    if (~axi_arready && S_AXI_ARVALID && ~axi_arv_arr_flag) begin
      // address latching
      axi_araddr <= S_AXI_ARADDR[`C_S_AXI_ADDR_WIDTH - 1:0]; //// start address of transfer
      axi_arlen_cntr <= S_AXI_ARLEN;
      axi_rlast <= 1'b0;
    end else if((axi_arlen_cntr > 0) && axi_rvalid && S_AXI_RREADY) begin
      axi_arlen_cntr <= axi_arlen_cntr - 1;
      axi_rlast <= 1'b0;

      case (axi_arburst)
        2'b00: begin// fixed burst
          axi_araddr       <= axi_araddr;
        end
        2'b01: begin//incremental burst
          axi_araddr <= (axi_araddr & ~((1 << axi_arsize) - 1)) + (1 << axi_arsize);
        end
        2'b10: begin//Wrapping burst
          if (axi_arlen_cntr == ar_wrap_cnt) begin
            axi_araddr <= araddr_wrap_boundary;
          end else begin
            axi_araddr <= (axi_araddr & ~((1 << axi_arsize) - 1)) + (1 << axi_arsize);
          end
        end
        default: begin //reserved (incremental burst for example)
          axi_araddr <= (axi_araddr & ~((1 << axi_arsize) - 1)) + (1 << axi_arsize);
        end
      endcase
    end else if((axi_arlen_cntr == 0) && ~axi_rlast && axi_arv_arr_flag ) begin
      axi_rlast <= 1'b1;
    end else if (S_AXI_RREADY) begin
      axi_rlast <= 1'b0;
    end
  end
end

////////////////////////////////////////////////////////////////////////////
// Implement memory mapped register select and read logic generation
//
//  axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both
//  S_AXI_ARVALID and axi_arready are asserted. The slave registers
//  data are available on the axi_rdata bus at this instance. The
//  assertion of axi_rvalid marks the validity of read data on the
//  bus and axi_rresp indicates the status of read transaction.axi_rvalid
//  is deasserted on reset (active low). axi_rresp and axi_rdata are
//  cleared to zero on reset (active low).
always @( posedge S_AXI_ACLK ) begin
  if ( S_AXI_ARESETN == 1'b0 ) begin
    axi_rvalid <= 0;
    axi_rresp  <= 0;
  end else begin
    if (axi_arv_arr_flag && ~axi_rvalid) begin
      axi_rvalid <= 1'b1;
      axi_rresp  <= 2'b00; // 'OKAY' response
    end else if (axi_rvalid && S_AXI_RREADY) begin
      axi_rvalid <= 1'b0;
    end
  end
end

////////////////////////////////////////////////////////////////////////////
// Example code to access user logic memory region
//
// Note:
// The example code presented here is to show you one way of using
// the user logic memory space features. The S_AXI_AWADDR, S_AXI_ARADDR,
// S_AXI_WDATA are used to these user logic memory
// spaces. Each user logic memory space has its own address range
// and is allocated one bit on the valid signal to indicated
// selection of that memory space.
assign mem_address = axi_arv_arr_flag ? axi_araddr[LP_ADDR_LSB+7:LP_ADDR_LSB]:
                     axi_awv_awr_flag ? axi_awaddr[LP_ADDR_LSB+7:LP_ADDR_LSB]: 8'h00;

////////////////////////////////////////////////////////////////////////////
// implement Block RAM(s)
wire mem_rden;
wire mem_wren;

assign mem_wren = axi_wready && S_AXI_WVALID;

assign mem_rden = axi_arv_arr_flag;
  
generate
  for(mem_byte_index=0; mem_byte_index<= (C_S_AXI_DATA_WIDTH/8)-1; mem_byte_index=mem_byte_index+1) begin:BYTE_BRAM_GEN
    wire [(C_S_AXI_DATA_WIDTH/8)-1:0] data_in ;
    wire [(C_S_AXI_DATA_WIDTH/8)-1:0] data_out;
    reg  [(C_S_AXI_DATA_WIDTH/8)-1:0] byte_ram [0 : 255];
    integer  j;
  
    //assigning 8 bit data
    assign data_in  = S_AXI_WDATA[(mem_byte_index*8+7) -: 8];
    assign data_out = byte_ram[mem_address];
  
    always @( posedge S_AXI_ACLK ) begin
      if (mem_wren && S_AXI_WSTRB[mem_byte_index])  begin
        byte_ram[mem_address] <= data_in;
      end
      if (mem_rden) begin
        mem_data_out[(mem_byte_index*8+7) -: 8] <= data_out;
      end
    end
  end
endgenerate

endmodule
