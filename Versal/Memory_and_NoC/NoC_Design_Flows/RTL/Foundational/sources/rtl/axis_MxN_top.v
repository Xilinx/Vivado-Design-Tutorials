//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//

`timescale 1 ns / 1 ps

module axis_MxN_top 
   (
   input wire clk,
   input wire rstb
   );

  // Number of axis transfers x 32
  parameter AXIS_BURST_TXNS = 1;
  // AXIS datawidth - Increments of 32
  parameter DATA_WIDTH = 128;
  // Number of clock cycles between streaming bursts
  parameter M_START_COUNT = 4;
  parameter PRBS_DATA = 0;
  parameter INCR_DATA = 1;
  parameter NUM_S_AXIS = 2; //1 - 16
  parameter NUM_M_AXIS = 2; //1 - 16
  
  wire vio_rst_n;
  (* MARK_DEBUG="true" *) wire [NUM_S_AXIS-1:0] data_error;
  wire [15:0] tx_done;

  
///////////////////////////////////////////////
/////
///////////////////////////////////////////////

`ifdef SIM_ENABLED
    assign vio_rst_n = rstb;
`else
     axis_MxN_vio axis_MxN_vio_inst (
      .probe_in0(data_error),    // input wire [15 : 0] probe_in0
      .probe_in1(tx_done),       // input wire [15 : 0] probe_in0
      .probe_out0(vio_rst_n),    // output wire [0 : 0] probe_out0
      .clk(clk)                  // input wire clk
    );    
`endif

///////////////////////////////////////////////
/////
///////////////////////////////////////////////

genvar m_axis_num;
    generate
    for (m_axis_num=0; m_axis_num < NUM_M_AXIS; m_axis_num=m_axis_num+1) 
        begin
        
        wire [DATA_WIDTH-1:0]AXIS_0_tdata;
        wire [3:0]AXIS_0_tdest;
        wire [(DATA_WIDTH/8)-1:0]AXIS_0_tkeep;
        wire [0:0]AXIS_0_tlast;
        wire [0:0]AXIS_0_tready;
        wire [0:0]AXIS_0_tvalid;
        wire [3:0]AXIS_0_tid;
           
        validate_ip_M_AXIS 
            #(.C_M_AXIS_TDATA_WIDTH(DATA_WIDTH),
              .C_M_START_COUNT(M_START_COUNT),
              .C_NUM_OF_AXIS_BURST_TXNS(AXIS_BURST_TXNS),
              .NUM_S_AXIS(NUM_S_AXIS),
              .M_AXIS_INST(m_axis_num)
            ) u_M_AXIS
            (
            .M_AXIS_ACLK(clk),
            .M_AXIS_ARESETN(vio_rst_n),
            .M_AXIS_TVALID(AXIS_0_tvalid),
            .M_AXIS_TDATA(AXIS_0_tdata),
            .M_AXIS_TDEST(AXIS_0_tdest),
            .M_AXIS_TKEEP(AXIS_0_tkeep),
            .M_AXIS_TLAST(AXIS_0_tlast),
            .M_AXIS_TREADY(AXIS_0_tready),
            .M_AXIS_TID(AXIS_0_tid),
            .tx_done(tx_done[m_axis_num])
            );

        xpm_nmu_strm  #(
            .NOC_FABRIC("VNOC"),          // VNOC/BLI
            .DATA_WIDTH(DATA_WIDTH),      // 128/256/512
            .ID_WIDTH(4),                 // 1 to 16
            .DST_ID_WIDTH(4)              // 1 to 4
            ) xpm_nmu_strm_pl_to_pl 
            (
            .s_axis_aclk(clk),
            .s_axis_tid(AXIS_0_tid),
            .s_axis_tdata(AXIS_0_tdata),
            .s_axis_tkeep(AXIS_0_tkeep),
            .s_axis_tlast(AXIS_0_tlast),
            .s_axis_tvalid(AXIS_0_tvalid),
            .s_axis_tready(AXIS_0_tready),
            .s_axis_tdest(AXIS_0_tdest),
            .dst_id_err ()
            );
        end
    endgenerate

///////////////////////////////////////////////
/////
///////////////////////////////////////////////
genvar s_axis_num;
    generate

    
    for (s_axis_num=0; s_axis_num < NUM_S_AXIS; s_axis_num=s_axis_num+1) 
        begin
    
        wire [DATA_WIDTH-1:0]AXIS_0_tdata;
        wire [3:0]AXIS_0_tdest;
        wire [(DATA_WIDTH/8)-1:0]AXIS_0_tkeep;
        wire [0:0]AXIS_0_tlast;
        wire [0:0]AXIS_0_tready;
        wire [0:0]AXIS_0_tvalid;
        wire [3:0]AXIS_0_tid;
                        
        validate_ip_S_AXIS 
            #(.C_S_AXIS_TDATA_WIDTH(DATA_WIDTH),
              .C_S_DATA_TYPE(PRBS_DATA),
              .C_NUM_OF_AXIS_BURST_TXNS(AXIS_BURST_TXNS),
              .NUM_M_AXIS(NUM_M_AXIS),
              .S_AXIS_INST(s_axis_num)
            ) u_S_AXIS
            (.S_AXIS_ACLK(clk),
             .S_AXIS_ARESETN(vio_rst_n),
             .S_AXIS_TVALID(AXIS_0_tvalid),
             .S_AXIS_TDATA(AXIS_0_tdata),
             .S_AXIS_TDEST(AXIS_0_tdest),
             .S_AXIS_TKEEP(AXIS_0_tkeep),
             .S_AXIS_TLAST(AXIS_0_tlast),
             .S_AXIS_TREADY(AXIS_0_tready),
             .S_AXIS_TID(AXIS_0_tid),
             .error(data_error[s_axis_num])
             );        
    
        xpm_nsu_strm 
            #(
            .NOC_FABRIC("VNOC"),          // VNOC/BLI
            .DATA_WIDTH(DATA_WIDTH),      // 128/256/512
            .ID_WIDTH(4),                 // 1 to 6
            .DST_ID_WIDTH (4)             // 1 to 4
            ) xpm_nsu_strm_pl_to_pl
            (
            .m_axis_aclk(clk),
            .m_axis_tid(AXIS_0_tid),
            .m_axis_tdata(AXIS_0_tdata),
            .m_axis_tkeep(AXIS_0_tkeep),
            .m_axis_tlast(AXIS_0_tlast),
            .m_axis_tvalid(AXIS_0_tvalid),
            .m_axis_tdest(AXIS_0_tdest),
            .m_axis_tready(AXIS_0_tready)
            );
        end
    endgenerate
    
endmodule
