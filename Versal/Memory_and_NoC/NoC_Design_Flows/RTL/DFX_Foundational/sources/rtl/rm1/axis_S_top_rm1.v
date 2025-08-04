//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//


module axis_S_top_rm1 #(
      parameter NUM_S_AXIS = 1, 
      parameter NUM_M_AXIS = 1, 
      parameter DATA_WIDTH = 128, 
      parameter AXIS_BURST_TXNS = 1
      )
      (
      input wire clk,
      input wire rstb,
      (* MARK_DEBUG="true" *) output [NUM_S_AXIS-1:0] error
      );

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

        validate_ip_S_AXIS_rm1
            #(.C_S_AXIS_TDATA_WIDTH(DATA_WIDTH),
              .C_NUM_OF_AXIS_BURST_TXNS(AXIS_BURST_TXNS),
              .NUM_M_AXIS(NUM_M_AXIS),
              .S_AXIS_INST(s_axis_num)
            ) u_S_AXIS
            (.S_AXIS_ACLK(clk),
             .S_AXIS_ARESETN(rstb),
             .S_AXIS_TVALID(AXIS_0_tvalid),
             .S_AXIS_TDATA(AXIS_0_tdata),
             .S_AXIS_TDEST(AXIS_0_tdest),
             .S_AXIS_TKEEP(AXIS_0_tkeep),
             .S_AXIS_TLAST(AXIS_0_tlast),
             .S_AXIS_TREADY(AXIS_0_tready),
             .S_AXIS_TID(AXIS_0_tid),
             .error(error[s_axis_num])
             );

        xpm_nsu_strm
            #(
            .NOC_FABRIC("VNOC"),                // VNOC/BLI
            .DATA_WIDTH(DATA_WIDTH),            // 128/256/512
            .ID_WIDTH(4),                       // 1 to 6
            .DST_ID_WIDTH (4)                   // 1 to 4
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
