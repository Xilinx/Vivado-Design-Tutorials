// ------------------------------------------------------------------------------
//   (c) Copyright 2020-2021 Advanced Micro Devices, Inc. All rights reserved.
// 
//   This file contains confidential and proprietary information
//   of Advanced Micro Devices, Inc. and is protected under U.S. and
//   international copyright and other intellectual property
//   laws.
// 
//   DISCLAIMER
//   This disclaimer is not a license and does not grant any
//   rights to the materials distributed herewith. Except as
//   otherwise provided in a valid license issued to you by
//   AMD, and to the maximum extent permitted by applicable
//   law: (1) THESE MATERIALS ARE MADE AVAILABLE \"AS IS\" AND
//   WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
//   AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
//   BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
//   INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
//   (2) AMD shall not be liable (whether in contract or tort,
//   including negligence, or under any other theory of
//   liability) for any loss or damage of any kind or nature
//   related to, arising under or in connection with these
//   materials, including for any direct, or any indirect,
//   special, incidental, or consequential loss or damage
//   (including loss of data, profits, goodwill, or any type of
//   loss or damage suffered as a result of any action brought
//   by a third party) even if such damage or loss was
//   reasonably foreseeable or AMD had been advised of the
//   possibility of the same.
// 
//   CRITICAL APPLICATIONS
//   AMD products are not designed or intended to be fail-
//   safe, or for use in any application requiring fail-safe
//   performance, such as life-support or safety devices or
//   systems, Class III medical devices, nuclear facilities,
//   applications related to the deployment of airbags, or any
//   other applications that could lead to death, personal
//   injury, or severe property or environmental damage
//   (individually and collectively, \"Critical
//   Applications\"). Customer assumes the sole risk and
//   liability of any use of AMD products in Critical
//   Applications, subject only to applicable laws and
//   regulations governing limitations on product liability.
// 
//   THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
//   PART OF THIS FILE AT ALL TIMES.
// ------------------------------------------------------------------------------
////------------------------------------------------------------------------------


`timescale 1ps/1ps

(* DowngradeIPIdentifiedWarnings="yes" *)
module dcmac_0_ts_context_mem_v2 (
  clk,
  rst,
  ts_rst,
  i_rd_id,
  i_ena,
  i_dat,
  i_rd_during_wr,
  o_dat,
  o_init
);

parameter NUM_ID       = 6;
parameter DW           = 1;      // data width in bits
parameter INIT_VALUE   = 0;      // init value
parameter DISABLE_INIT = 0;
parameter ENABLE_RD_DURING_WR = 0;

localparam ID_W = (NUM_ID == 1) ? 1 : $clog2(NUM_ID);

input                    clk;
input                    rst;
input                    ts_rst;
input      [ID_W-1:0]    i_rd_id;
input                    i_ena;
input      [DW-1:0]      i_dat;
input                    i_rd_during_wr;
output reg [DW-1:0]      o_dat;
output                   o_init;

logic                    init_global;
reg   [1:1]              init_global_p;
logic [1:0]              init_ts;
wire  [DW-1:0]           mem_din;
reg   [ID_W-1:0]         wr_id;
logic                    rd_during_wr;
wire  [1:1]              wr_ena;
wire  [1:1]              init_wr;

(* ram_style = "distributed" *) reg [DW-1:0] mem [NUM_ID-1:0];


assign o_init = init_global;

always @(posedge clk) begin
  init_ts[1] <= init_ts[0];
  init_global_p[1] <= init_global;

  // write
  if(wr_ena[1]) mem[wr_id] <= mem_din;

  o_dat <= rd_during_wr? mem_din : mem[i_rd_id];
end


logic ts_rst_tmp; // workaround for tool problem

always @* begin
  ts_rst_tmp = ts_rst;
end

assign init_ts[0] = init_global? 1'b1: ts_rst_tmp? 1'b1 : 1'b0;
assign init_wr[1] = init_ts[1];


generate

  if (DISABLE_INIT) begin : GEN_DISABLE_GLOBAL_INIT
    assign init_global = 1'b0;

    always @(posedge clk) begin
      wr_id <= i_rd_id;
    end
  end
  else begin : GEN_USE_INT_INIT
    reg [ID_W-1:0] init_id;


    always @( posedge clk or posedge rst )
    begin
      if ( rst == 1'b1 ) begin
        init_global <= 1'b1;
        init_id <= '0;
        wr_id <= '0;
      end
      else begin
        if (init_global) begin
          init_global <= init_id < NUM_ID - 1;
          init_id <= init_id + 1'b1;
        end
        wr_id <= init_global? (wr_id < NUM_ID - 1)? wr_id + 1'b1 : '0 : i_rd_id;
      end
    end
  end

  if (ENABLE_RD_DURING_WR) begin
    assign rd_during_wr = i_rd_during_wr;
  end
  else begin
    if (DISABLE_INIT) begin
      assign rd_during_wr = i_rd_id == wr_id & i_ena;
    end
    else begin
      assign rd_during_wr = (init_global_p[1] | i_rd_id == wr_id & (i_ena | init_wr[1]));
    end
  end



  if (DISABLE_INIT)  begin : GEN_DISABLE_INIT
    assign mem_din = i_dat;
    assign wr_ena[1] = i_ena;
  end
  else begin : GEN_ENABLE_INIT
    assign mem_din = init_wr[1]? INIT_VALUE : i_dat;
    assign wr_ena[1] = i_ena | init_wr[1];
  end

endgenerate

endmodule
