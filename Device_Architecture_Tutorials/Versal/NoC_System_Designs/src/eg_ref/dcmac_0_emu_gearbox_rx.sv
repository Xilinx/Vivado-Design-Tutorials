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
module dcmac_0_emu_gearbox_rx (
  clk,
  rst,
  i_clear_counters,
  i_data_rate,
  i_valid,
  i_preamble,
  i_slice,
  o_preamble_err_cnt,
  o_pkt
);

  parameter R_400G = 2'b10,
            R_200G = 2'b01,
            R_100G = 2'b00;

  typedef struct packed {
    logic [2:0]               id;
    logic [11:0]              ena;
    logic [11:0]              sop;
    logic [11:0]              eop;
    logic [11:0]              err;
    logic [11:0][3:0]         mty;
    logic [11:0][127:0]       dat;
  } axis_rx_pkt_t;

  typedef struct packed {
    logic [1:0]              ena;
    logic [1:0]              sop;
    logic [1:0]              eop;
    logic [1:0]              err;
    logic [1:0][3:0]         mty;
    logic [1:0][127:0]       dat;
  } slice_t;



  input                               clk;
  input                [5:0]          rst;
  input                [5:0]          i_clear_counters;
  input                [5:0][1:0]     i_data_rate;
  input                [5:0]          i_valid;
  input                [5:0][55:0]    i_preamble;
  input  slice_t       [5:0]          i_slice;
  output reg           [5:0][31:0]    o_preamble_err_cnt;
  output axis_rx_pkt_t                o_pkt;


  reg                             p0_400, p0_200, p2_200, p4_200;
  reg             [2:0]           phase = 0;
  reg             [1:1][5:0][2:0] dmux;
  reg             [2:1][2:0]      sel;
  slice_t         [1:1][5:0]      slice_reg;
  logic           [1:1][5:0][1:0] din_ena;
  axis_rx_pkt_t   [2:2][5:0]      pkt, pkt_select;



  always @(posedge clk) begin
    p0_400 <= i_data_rate[0] == R_400G;
    p0_200 <= i_data_rate[0] == R_200G;
    p2_200 <= !p0_400 & i_data_rate[2] == R_200G;
    p4_200 <= i_data_rate[4] == R_200G;

    for (int i=0; i<6; i++) begin
      pkt[2][i].id <= i[5:0];
      din_ena[1][i] <= i_slice[i].ena;

      slice_reg[1][i].ena <= i_slice[i].ena;
      slice_reg[1][i].sop <= i_slice[i].sop;
      slice_reg[1][i].eop <= i_slice[i].eop;
      slice_reg[1][i].err <= i_slice[i].err;
      slice_reg[1][i].mty <= i_slice[i].mty;
      slice_reg[1][i].dat <= i_slice[i].dat;
    end


    dmux[1] <= '0;

    if (i_data_rate[0] == R_400G) begin
      if (!i_valid[0]) din_ena[1][3:0] <= '0;
      case (phase)
        3'd0: begin sel[1] <= 3'd0; dmux[1][0] <= 1; end // fill o[11:8], r[3:0] - full
        3'd1: begin sel[1] <= 3'd0; dmux[1][0] <= 2; end // fill o[11:4] full
        3'd2: begin                 dmux[1][0] <= 0; end
        3'd3: begin sel[1] <= 3'd0; dmux[1][0] <= 1; end // full
        3'd4: begin sel[1] <= 3'd0; dmux[1][0] <= 2; end // full
        3'd5: begin                 dmux[1][0] <= 0; end // fill r[7:0]
      endcase
    end // end i_data_rate[0] == R_400G
    else if (i_data_rate[0] == R_200G) begin
      if (!i_valid[0]) din_ena[1][1:0] <= '0;
      case (phase)
        3'd0: begin dmux[1][0] <= 1;  sel[1] <= 3'd0; end // - full
        3'd1: begin dmux[1][0] <= 0;                  end
        3'd2: begin dmux[1][0] <= 3;                  end
        3'd3: begin dmux[1][0] <= 1;  sel[1] <= 3'd0; end // - full
        3'd4: begin dmux[1][0] <= 0;                  end
        3'd5: begin dmux[1][0] <= 3;                  end
      endcase
    end // end i_data_rate[0] == R_200G
    else begin
      if (!i_valid[0]) din_ena[1][0] <= '0;
      case (phase)
        3'd0: begin dmux[1][0] <= 7;   sel[1] <= 3'd0; end// - full
        3'd1: begin dmux[1][0] <= 0;   end
        3'd2: begin dmux[1][0] <= 4;   end
        3'd3: begin dmux[1][0] <= 3;   end
        3'd4: begin dmux[1][0] <= 5;   end
        3'd5: begin dmux[1][0] <= 6;   end
      endcase
    end // end i_data_rate[0] == R_100G


    if (i_data_rate[0] != R_400G & i_data_rate[0] != R_200G) begin // [1]: 100G
      if (!i_valid[1]) din_ena[1][1] <= '0;
      case (phase)
        3'd0: begin dmux[1][1] <= 3;  end
        3'd1: begin dmux[1][1] <= 5;  end
        3'd2: begin dmux[1][1] <= 6;  end
        3'd3: begin dmux[1][1] <= 7;  sel[1] <= 3'd1; end // - full
        3'd4: begin dmux[1][1] <= 0;  end
        3'd5: begin dmux[1][1] <= 4;  end
      endcase
    end

    if (i_data_rate[0] != R_400G) begin
      if (i_data_rate[2] == R_200G) begin // [2]: 200G
        if (!i_valid[2]) din_ena[1][3:2] <= '0;
        case (phase)
          3'd0: begin dmux[1][2] <= 3;  end
          3'd1: begin dmux[1][2] <= 1;  sel[1] <= 3'd2; end // - full
          3'd2: begin dmux[1][2] <= 0;  end
          3'd3: begin dmux[1][2] <= 3;  end
          3'd4: begin dmux[1][2] <= 1;  sel[1] <= 3'd2; end // - full
          3'd5: begin dmux[1][2] <= 0;  end
        endcase
      end
      else begin // [2]: 100G
        if (!i_valid[2]) din_ena[1][2] <= '0;
        case (phase)
          3'd0: begin dmux[1][2] <= 6; end
          3'd1: begin dmux[1][2] <= 7; sel[1] <= 3'd2; end // - full
          3'd2: begin dmux[1][2] <= 0; end
          3'd3: begin dmux[1][2] <= 4; end
          3'd4: begin dmux[1][2] <= 3; end
          3'd5: begin dmux[1][2] <= 5; end
        endcase
      end
    end

    if (i_data_rate[0] != R_400G & i_data_rate[2] != R_200G) begin // [3]: 100G
      if (!i_valid[3]) din_ena[1][3] <= '0;
      case (phase)
        3'd0: begin dmux[1][3] <= 4;  end
        3'd1: begin dmux[1][3] <= 3;  end
        3'd2: begin dmux[1][3] <= 5;  end
        3'd3: begin dmux[1][3] <= 6;  end
        3'd4: begin dmux[1][3] <= 7;  sel[1] <= 3'd3; end // - full
        3'd5: begin dmux[1][3] <= 0;  end
      endcase
    end


    if (i_data_rate[4] == R_200G) begin // [4]: 200G
      if (!i_valid[4]) din_ena[1][5:4] <= '0;
      case (phase)
        3'd0: begin dmux[1][4] <= 0;  end
        3'd1: begin dmux[1][4] <= 3;  end
        3'd2: begin dmux[1][4] <= 1;  sel[1] <= 3'd4; end // - full
        3'd3: begin dmux[1][4] <= 0;  end
        3'd4: begin dmux[1][4] <= 3;  end
        3'd5: begin dmux[1][4] <= 1;  sel[1] <= 3'd4; end // - full
      endcase
    end
    else begin // [4]: 100G
      if (!i_valid[4]) din_ena[1][4] <= '0;
      case (phase)
        3'd0: begin dmux[1][4] <= 5; end
        3'd1: begin dmux[1][4] <= 6; end
        3'd2: begin dmux[1][4] <= 7; sel[1] <= 3'd4; end // - full
        3'd3: begin dmux[1][4] <= 0; end
        3'd4: begin dmux[1][4] <= 4; end
        3'd5: begin dmux[1][4] <= 3; end
      endcase
    end


    if (i_data_rate[4] != R_200G) begin // [5]: 100G
      if (!i_valid[5]) din_ena[1][5] <= '0;
      case (phase)
        3'd0: begin dmux[1][5] <= 0;  end
        3'd1: begin dmux[1][5] <= 4;  end
        3'd2: begin dmux[1][5] <= 3;  end
        3'd3: begin dmux[1][5] <= 5;  end
        3'd4: begin dmux[1][5] <= 6;  end
        3'd5: begin dmux[1][5] <= 7; sel[1] <= 3'd5;  end // - full
      endcase
    end

    sel[2] <= sel[1];
    phase <= (phase == 3'd5)? 3'd0 : phase + 1'b1;
    for (int i=0; i<6; i++) pkt_select[2][i].ena <= '0;

    o_pkt.id  <= pkt_select[2][sel[2]].id;
    o_pkt.ena <= pkt_select[2][sel[2]].ena;
    o_pkt.sop <= pkt_select[2][sel[2]].sop;
    o_pkt.eop <= pkt_select[2][sel[2]].eop;
    o_pkt.err <= pkt_select[2][sel[2]].err;
    o_pkt.mty <= pkt_select[2][sel[2]].mty;
    o_pkt.dat <= pkt_select[2][sel[2]].dat;

    case (dmux[1][0])
      0: begin
        for (int i=0; i<4; i++) begin  // fill r[7:0]
          if (0 + i < 6) begin
            for (int j=0; j<2; j++) begin
              pkt[2][0].ena[i*2+j] <= din_ena[1][i][j];
              pkt[2][0].sop[i*2+j] <= slice_reg[1][i].sop[j];
              pkt[2][0].eop[i*2+j] <= slice_reg[1][i].eop[j];
              pkt[2][0].err[i*2+j] <= slice_reg[1][i].err[j];
              pkt[2][0].mty[i*2+j] <= slice_reg[1][i].mty[j];
              pkt[2][0].dat[i*2+j] <= slice_reg[1][i].dat[j];
            end
          end
        end
      end
      1: begin
        pkt_select[2][0] <= pkt[2][0];  // 200G or 400G
        pkt[2][0].ena <= '0;
        for (int i=0; i<0+2; i++) begin // fill o[11:8]
          for (int j=0; j<2; j++) begin
            pkt_select[2][0].ena[8+i*2+j] <= din_ena[1][i][j];
            pkt_select[2][0].sop[8+i*2+j] <= slice_reg[1][i].sop[j];
            pkt_select[2][0].eop[8+i*2+j] <= slice_reg[1][i].eop[j];
            pkt_select[2][0].err[8+i*2+j] <= slice_reg[1][i].err[j];
            pkt_select[2][0].mty[8+i*2+j] <= slice_reg[1][i].mty[j];
            pkt_select[2][0].dat[8+i*2+j] <= slice_reg[1][i].dat[j];
          end
        end
        for (int i=0; i<2; i++) begin // fill r[3:0]
          for (int j=0; j<2; j++) begin
            pkt[2][0].ena[i*2+j] <= din_ena[1][2+i][j];
            pkt[2][0].sop[i*2+j] <= slice_reg[1][2+i].sop[j];
            pkt[2][0].eop[i*2+j] <= slice_reg[1][2+i].eop[j];
            pkt[2][0].err[i*2+j] <= slice_reg[1][2+i].err[j];
            pkt[2][0].mty[i*2+j] <= slice_reg[1][2+i].mty[j];
            pkt[2][0].dat[i*2+j] <= slice_reg[1][2+i].dat[j];
          end
        end
      end
      2: begin
        pkt_select[2][0] <= pkt[2][0]; // 400G only
        pkt[2][0].ena <= '0;
        for (int i=0; i<4; i++) begin // fill [11:4]
          for (int j=0; j<2; j++) begin
            pkt_select[2][0].ena[4+i*2+j] <= din_ena[1][i][j];
            pkt_select[2][0].sop[4+i*2+j] <= slice_reg[1][i].sop[j];
            pkt_select[2][0].eop[4+i*2+j] <= slice_reg[1][i].eop[j];
            pkt_select[2][0].err[4+i*2+j] <= slice_reg[1][i].err[j];
            pkt_select[2][0].mty[4+i*2+j] <= slice_reg[1][i].mty[j];
            pkt_select[2][0].dat[4+i*2+j] <= slice_reg[1][i].dat[j];
          end
        end
      end
      3: begin
        for (int i=0; i<2; i++) begin // fill [7:4]
          for (int j=0; j<2; j++) begin
            if (i < 6) begin
              pkt[2][0].ena[4+i*2+j] <= din_ena[1][i][j];
              pkt[2][0].sop[4+i*2+j] <= slice_reg[1][i].sop[j];
              pkt[2][0].eop[4+i*2+j] <= slice_reg[1][i].eop[j];
              pkt[2][0].err[4+i*2+j] <= slice_reg[1][i].err[j];
              pkt[2][0].mty[4+i*2+j] <= slice_reg[1][i].mty[j];
              pkt[2][0].dat[4+i*2+j] <= slice_reg[1][i].dat[j];
            end
          end
        end
      end
      4: begin
        for (int j=0; j<2; j++) begin // fill [3:2]
          pkt[2][0].ena[2+j] <= din_ena[1][0][j];
          pkt[2][0].sop[2+j] <= slice_reg[1][0].sop[j];
          pkt[2][0].eop[2+j] <= slice_reg[1][0].eop[j];
          pkt[2][0].err[2+j] <= slice_reg[1][0].err[j];
          pkt[2][0].mty[2+j] <= slice_reg[1][0].mty[j];
          pkt[2][0].dat[2+j] <= slice_reg[1][0].dat[j];
        end
      end
      5: begin
        for (int j=0; j<2; j++) begin // fill [7:6]
          pkt[2][0].ena[6+j] <= din_ena[1][0][j];
          pkt[2][0].sop[6+j] <= slice_reg[1][0].sop[j];
          pkt[2][0].eop[6+j] <= slice_reg[1][0].eop[j];
          pkt[2][0].err[6+j] <= slice_reg[1][0].err[j];
          pkt[2][0].mty[6+j] <= slice_reg[1][0].mty[j];
          pkt[2][0].dat[6+j] <= slice_reg[1][0].dat[j];
        end
      end
      6: begin
        for (int j=0; j<2; j++) begin // fill [9:8]
          pkt[2][0].ena[8+j] <= din_ena[1][0][j];
          pkt[2][0].sop[8+j] <= slice_reg[1][0].sop[j];
          pkt[2][0].eop[8+j] <= slice_reg[1][0].eop[j];
          pkt[2][0].err[8+j] <= slice_reg[1][0].err[j];
          pkt[2][0].mty[8+j] <= slice_reg[1][0].mty[j];
          pkt[2][0].dat[8+j] <= slice_reg[1][0].dat[j];
        end
      end
      7: begin
        pkt_select[2][0] <= pkt[2][0]; // 100G only
        for (int j=0; j<2; j++) begin // fill [11:10]
          pkt_select[2][0].ena[10+j] <= din_ena[1][0][j];
          pkt_select[2][0].sop[10+j] <= slice_reg[1][0].sop[j];
          pkt_select[2][0].eop[10+j] <= slice_reg[1][0].eop[j];
          pkt_select[2][0].err[10+j] <= slice_reg[1][0].err[j];
          pkt_select[2][0].mty[10+j] <= slice_reg[1][0].mty[j];
          pkt_select[2][0].dat[10+j] <= slice_reg[1][0].dat[j];
        end
      end
    endcase
    case (dmux[1][1])
      0: begin
        for (int i=0; i<4; i++) begin  // fill r[7:0]
          if (1 + i < 6) begin
            for (int j=0; j<2; j++) begin
              pkt[2][1].ena[i*2+j] <= din_ena[1][1+i][j];
              pkt[2][1].sop[i*2+j] <= slice_reg[1][1+i].sop[j];
              pkt[2][1].eop[i*2+j] <= slice_reg[1][1+i].eop[j];
              pkt[2][1].err[i*2+j] <= slice_reg[1][1+i].err[j];
              pkt[2][1].mty[i*2+j] <= slice_reg[1][1+i].mty[j];
              pkt[2][1].dat[i*2+j] <= slice_reg[1][1+i].dat[j];
            end
          end
        end
      end
      3: begin
        for (int i=0; i<2; i++) begin // fill [7:4]
          for (int j=0; j<2; j++) begin
            if (1+i < 6) begin
              pkt[2][1].ena[4+i*2+j] <= din_ena[1][1+i][j];
              pkt[2][1].sop[4+i*2+j] <= slice_reg[1][1+i].sop[j];
              pkt[2][1].eop[4+i*2+j] <= slice_reg[1][1+i].eop[j];
              pkt[2][1].err[4+i*2+j] <= slice_reg[1][1+i].err[j];
              pkt[2][1].mty[4+i*2+j] <= slice_reg[1][1+i].mty[j];
              pkt[2][1].dat[4+i*2+j] <= slice_reg[1][1+i].dat[j];
            end
          end
        end
      end
      4: begin
        for (int j=0; j<2; j++) begin // fill [3:2]
          pkt[2][1].ena[2+j] <= din_ena[1][1][j];
          pkt[2][1].sop[2+j] <= slice_reg[1][1].sop[j];
          pkt[2][1].eop[2+j] <= slice_reg[1][1].eop[j];
          pkt[2][1].err[2+j] <= slice_reg[1][1].err[j];
          pkt[2][1].mty[2+j] <= slice_reg[1][1].mty[j];
          pkt[2][1].dat[2+j] <= slice_reg[1][1].dat[j];
        end
      end
      5: begin
        for (int j=0; j<2; j++) begin // fill [7:6]
          pkt[2][1].ena[6+j] <= din_ena[1][1][j];
          pkt[2][1].sop[6+j] <= slice_reg[1][1].sop[j];
          pkt[2][1].eop[6+j] <= slice_reg[1][1].eop[j];
          pkt[2][1].err[6+j] <= slice_reg[1][1].err[j];
          pkt[2][1].mty[6+j] <= slice_reg[1][1].mty[j];
          pkt[2][1].dat[6+j] <= slice_reg[1][1].dat[j];
        end
      end
      6: begin
        for (int j=0; j<2; j++) begin // fill [9:8]
          pkt[2][1].ena[8+j] <= din_ena[1][1][j];
          pkt[2][1].sop[8+j] <= slice_reg[1][1].sop[j];
          pkt[2][1].eop[8+j] <= slice_reg[1][1].eop[j];
          pkt[2][1].err[8+j] <= slice_reg[1][1].err[j];
          pkt[2][1].mty[8+j] <= slice_reg[1][1].mty[j];
          pkt[2][1].dat[8+j] <= slice_reg[1][1].dat[j];
        end
      end
      7: begin
        pkt_select[2][1] <= pkt[2][1]; // 100G only
        for (int j=0; j<2; j++) begin // fill [11:10]
          pkt_select[2][1].ena[10+j] <= din_ena[1][1][j];
          pkt_select[2][1].sop[10+j] <= slice_reg[1][1].sop[j];
          pkt_select[2][1].eop[10+j] <= slice_reg[1][1].eop[j];
          pkt_select[2][1].err[10+j] <= slice_reg[1][1].err[j];
          pkt_select[2][1].mty[10+j] <= slice_reg[1][1].mty[j];
          pkt_select[2][1].dat[10+j] <= slice_reg[1][1].dat[j];
        end
      end
    endcase
    case (dmux[1][2])
      0: begin
        for (int i=0; i<4; i++) begin  // fill r[7:0]
          if (2 + i < 6) begin
            for (int j=0; j<2; j++) begin
              pkt[2][2].ena[i*2+j] <= din_ena[1][2+i][j];
              pkt[2][2].sop[i*2+j] <= slice_reg[1][2+i].sop[j];
              pkt[2][2].eop[i*2+j] <= slice_reg[1][2+i].eop[j];
              pkt[2][2].err[i*2+j] <= slice_reg[1][2+i].err[j];
              pkt[2][2].mty[i*2+j] <= slice_reg[1][2+i].mty[j];
              pkt[2][2].dat[i*2+j] <= slice_reg[1][2+i].dat[j];
            end
          end
        end
      end
      1: begin
        pkt_select[2][2] <= pkt[2][2];  // 200G or 400G
        pkt[2][2].ena <= '0;
        for (int i=2; i<2+2; i++) begin // fill o[11:8]
          for (int j=0; j<2; j++) begin
            pkt_select[2][2].ena[8+(i-2)*2+j] <= din_ena[1][i][j];
            pkt_select[2][2].sop[8+(i-2)*2+j] <= slice_reg[1][i].sop[j];
            pkt_select[2][2].eop[8+(i-2)*2+j] <= slice_reg[1][i].eop[j];
            pkt_select[2][2].err[8+(i-2)*2+j] <= slice_reg[1][i].err[j];
            pkt_select[2][2].mty[8+(i-2)*2+j] <= slice_reg[1][i].mty[j];
            pkt_select[2][2].dat[8+(i-2)*2+j] <= slice_reg[1][i].dat[j];
          end
        end
      end
      3: begin
        for (int i=0; i<2; i++) begin // fill [7:4]
          for (int j=0; j<2; j++) begin
            if (2+i < 6) begin
              pkt[2][2].ena[4+i*2+j] <= din_ena[1][2+i][j];
              pkt[2][2].sop[4+i*2+j] <= slice_reg[1][2+i].sop[j];
              pkt[2][2].eop[4+i*2+j] <= slice_reg[1][2+i].eop[j];
              pkt[2][2].err[4+i*2+j] <= slice_reg[1][2+i].err[j];
              pkt[2][2].mty[4+i*2+j] <= slice_reg[1][2+i].mty[j];
              pkt[2][2].dat[4+i*2+j] <= slice_reg[1][2+i].dat[j];
            end
          end
        end
      end
      4: begin
        for (int j=0; j<2; j++) begin // fill [3:2]
          pkt[2][2].ena[2+j] <= din_ena[1][2][j];
          pkt[2][2].sop[2+j] <= slice_reg[1][2].sop[j];
          pkt[2][2].eop[2+j] <= slice_reg[1][2].eop[j];
          pkt[2][2].err[2+j] <= slice_reg[1][2].err[j];
          pkt[2][2].mty[2+j] <= slice_reg[1][2].mty[j];
          pkt[2][2].dat[2+j] <= slice_reg[1][2].dat[j];
        end
      end
      5: begin
        for (int j=0; j<2; j++) begin // fill [7:6]
          pkt[2][2].ena[6+j] <= din_ena[1][2][j];
          pkt[2][2].sop[6+j] <= slice_reg[1][2].sop[j];
          pkt[2][2].eop[6+j] <= slice_reg[1][2].eop[j];
          pkt[2][2].err[6+j] <= slice_reg[1][2].err[j];
          pkt[2][2].mty[6+j] <= slice_reg[1][2].mty[j];
          pkt[2][2].dat[6+j] <= slice_reg[1][2].dat[j];
        end
      end
      6: begin
        for (int j=0; j<2; j++) begin // fill [9:8]
          pkt[2][2].ena[8+j] <= din_ena[1][2][j];
          pkt[2][2].sop[8+j] <= slice_reg[1][2].sop[j];
          pkt[2][2].eop[8+j] <= slice_reg[1][2].eop[j];
          pkt[2][2].err[8+j] <= slice_reg[1][2].err[j];
          pkt[2][2].mty[8+j] <= slice_reg[1][2].mty[j];
          pkt[2][2].dat[8+j] <= slice_reg[1][2].dat[j];
        end
      end
      7: begin
        pkt_select[2][2] <= pkt[2][2]; // 100G only
        for (int j=0; j<2; j++) begin // fill [11:10]
          pkt_select[2][2].ena[10+j] <= din_ena[1][2][j];
          pkt_select[2][2].sop[10+j] <= slice_reg[1][2].sop[j];
          pkt_select[2][2].eop[10+j] <= slice_reg[1][2].eop[j];
          pkt_select[2][2].err[10+j] <= slice_reg[1][2].err[j];
          pkt_select[2][2].mty[10+j] <= slice_reg[1][2].mty[j];
          pkt_select[2][2].dat[10+j] <= slice_reg[1][2].dat[j];
        end
      end
    endcase
    case (dmux[1][3])
      0: begin
        for (int i=0; i<4; i++) begin  // fill r[7:0]
          if (3 + i < 6) begin
            for (int j=0; j<2; j++) begin
              pkt[2][3].ena[i*2+j] <= din_ena[1][3+i][j];
              pkt[2][3].sop[i*2+j] <= slice_reg[1][3+i].sop[j];
              pkt[2][3].eop[i*2+j] <= slice_reg[1][3+i].eop[j];
              pkt[2][3].err[i*2+j] <= slice_reg[1][3+i].err[j];
              pkt[2][3].mty[i*2+j] <= slice_reg[1][3+i].mty[j];
              pkt[2][3].dat[i*2+j] <= slice_reg[1][3+i].dat[j];
            end
          end
        end
      end
      3: begin
        for (int i=0; i<2; i++) begin // fill [7:4]
          for (int j=0; j<2; j++) begin
            if (3+i < 6) begin
              pkt[2][3].ena[4+i*2+j] <= din_ena[1][3+i][j];
              pkt[2][3].sop[4+i*2+j] <= slice_reg[1][3+i].sop[j];
              pkt[2][3].eop[4+i*2+j] <= slice_reg[1][3+i].eop[j];
              pkt[2][3].err[4+i*2+j] <= slice_reg[1][3+i].err[j];
              pkt[2][3].mty[4+i*2+j] <= slice_reg[1][3+i].mty[j];
              pkt[2][3].dat[4+i*2+j] <= slice_reg[1][3+i].dat[j];
            end
          end
        end
      end
      4: begin
        for (int j=0; j<2; j++) begin // fill [3:2]
          pkt[2][3].ena[2+j] <= din_ena[1][3][j];
          pkt[2][3].sop[2+j] <= slice_reg[1][3].sop[j];
          pkt[2][3].eop[2+j] <= slice_reg[1][3].eop[j];
          pkt[2][3].err[2+j] <= slice_reg[1][3].err[j];
          pkt[2][3].mty[2+j] <= slice_reg[1][3].mty[j];
          pkt[2][3].dat[2+j] <= slice_reg[1][3].dat[j];
        end
      end
      5: begin
        for (int j=0; j<2; j++) begin // fill [7:6]
          pkt[2][3].ena[6+j] <= din_ena[1][3][j];
          pkt[2][3].sop[6+j] <= slice_reg[1][3].sop[j];
          pkt[2][3].eop[6+j] <= slice_reg[1][3].eop[j];
          pkt[2][3].err[6+j] <= slice_reg[1][3].err[j];
          pkt[2][3].mty[6+j] <= slice_reg[1][3].mty[j];
          pkt[2][3].dat[6+j] <= slice_reg[1][3].dat[j];
        end
      end
      6: begin
        for (int j=0; j<2; j++) begin // fill [9:8]
          pkt[2][3].ena[8+j] <= din_ena[1][3][j];
          pkt[2][3].sop[8+j] <= slice_reg[1][3].sop[j];
          pkt[2][3].eop[8+j] <= slice_reg[1][3].eop[j];
          pkt[2][3].err[8+j] <= slice_reg[1][3].err[j];
          pkt[2][3].mty[8+j] <= slice_reg[1][3].mty[j];
          pkt[2][3].dat[8+j] <= slice_reg[1][3].dat[j];
        end
      end
      7: begin
        pkt_select[2][3] <= pkt[2][3]; // 100G only
        for (int j=0; j<2; j++) begin // fill [11:10]
          pkt_select[2][3].ena[10+j] <= din_ena[1][3][j];
          pkt_select[2][3].sop[10+j] <= slice_reg[1][3].sop[j];
          pkt_select[2][3].eop[10+j] <= slice_reg[1][3].eop[j];
          pkt_select[2][3].err[10+j] <= slice_reg[1][3].err[j];
          pkt_select[2][3].mty[10+j] <= slice_reg[1][3].mty[j];
          pkt_select[2][3].dat[10+j] <= slice_reg[1][3].dat[j];
        end
      end
    endcase
    case (dmux[1][4])
      0: begin
        for (int i=0; i<4; i++) begin  // fill r[7:0]
          if (4 + i < 6) begin
            for (int j=0; j<2; j++) begin
              pkt[2][4].ena[i*2+j] <= din_ena[1][4+i][j];
              pkt[2][4].sop[i*2+j] <= slice_reg[1][4+i].sop[j];
              pkt[2][4].eop[i*2+j] <= slice_reg[1][4+i].eop[j];
              pkt[2][4].err[i*2+j] <= slice_reg[1][4+i].err[j];
              pkt[2][4].mty[i*2+j] <= slice_reg[1][4+i].mty[j];
              pkt[2][4].dat[i*2+j] <= slice_reg[1][4+i].dat[j];
            end
          end
        end
      end
      1: begin
        pkt_select[2][4] <= pkt[2][4];  // 200G or 400G
        pkt[2][4].ena <= '0;
        for (int i=4; i<4+2; i++) begin // fill o[11:8]
          for (int j=0; j<2; j++) begin
            pkt_select[2][4].ena[8+(i-4)*2+j] <= din_ena[1][i][j];
            pkt_select[2][4].sop[8+(i-4)*2+j] <= slice_reg[1][i].sop[j];
            pkt_select[2][4].eop[8+(i-4)*2+j] <= slice_reg[1][i].eop[j];
            pkt_select[2][4].err[8+(i-4)*2+j] <= slice_reg[1][i].err[j];
            pkt_select[2][4].mty[8+(i-4)*2+j] <= slice_reg[1][i].mty[j];
            pkt_select[2][4].dat[8+(i-4)*2+j] <= slice_reg[1][i].dat[j];
          end
        end
      end
      3: begin
        for (int i=0; i<2; i++) begin // fill [7:4]
          for (int j=0; j<2; j++) begin
            if (4+i < 6) begin
              pkt[2][4].ena[4+i*2+j] <= din_ena[1][4+i][j];
              pkt[2][4].sop[4+i*2+j] <= slice_reg[1][4+i].sop[j];
              pkt[2][4].eop[4+i*2+j] <= slice_reg[1][4+i].eop[j];
              pkt[2][4].err[4+i*2+j] <= slice_reg[1][4+i].err[j];
              pkt[2][4].mty[4+i*2+j] <= slice_reg[1][4+i].mty[j];
              pkt[2][4].dat[4+i*2+j] <= slice_reg[1][4+i].dat[j];
            end
          end
        end
      end
      4: begin
        for (int j=0; j<2; j++) begin // fill [3:2]
          pkt[2][4].ena[2+j] <= din_ena[1][4][j];
          pkt[2][4].sop[2+j] <= slice_reg[1][4].sop[j];
          pkt[2][4].eop[2+j] <= slice_reg[1][4].eop[j];
          pkt[2][4].err[2+j] <= slice_reg[1][4].err[j];
          pkt[2][4].mty[2+j] <= slice_reg[1][4].mty[j];
          pkt[2][4].dat[2+j] <= slice_reg[1][4].dat[j];
        end
      end
      5: begin
        for (int j=0; j<2; j++) begin // fill [7:6]
          pkt[2][4].ena[6+j] <= din_ena[1][4][j];
          pkt[2][4].sop[6+j] <= slice_reg[1][4].sop[j];
          pkt[2][4].eop[6+j] <= slice_reg[1][4].eop[j];
          pkt[2][4].err[6+j] <= slice_reg[1][4].err[j];
          pkt[2][4].mty[6+j] <= slice_reg[1][4].mty[j];
          pkt[2][4].dat[6+j] <= slice_reg[1][4].dat[j];
        end
      end
      6: begin
        for (int j=0; j<2; j++) begin // fill [9:8]
          pkt[2][4].ena[8+j] <= din_ena[1][4][j];
          pkt[2][4].sop[8+j] <= slice_reg[1][4].sop[j];
          pkt[2][4].eop[8+j] <= slice_reg[1][4].eop[j];
          pkt[2][4].err[8+j] <= slice_reg[1][4].err[j];
          pkt[2][4].mty[8+j] <= slice_reg[1][4].mty[j];
          pkt[2][4].dat[8+j] <= slice_reg[1][4].dat[j];
        end
      end
      7: begin
        pkt_select[2][4] <= pkt[2][4]; // 100G only
        for (int j=0; j<2; j++) begin // fill [11:10]
          pkt_select[2][4].ena[10+j] <= din_ena[1][4][j];
          pkt_select[2][4].sop[10+j] <= slice_reg[1][4].sop[j];
          pkt_select[2][4].eop[10+j] <= slice_reg[1][4].eop[j];
          pkt_select[2][4].err[10+j] <= slice_reg[1][4].err[j];
          pkt_select[2][4].mty[10+j] <= slice_reg[1][4].mty[j];
          pkt_select[2][4].dat[10+j] <= slice_reg[1][4].dat[j];
        end
      end
    endcase
    case (dmux[1][5])
      0: begin
        for (int i=0; i<4; i++) begin  // fill r[7:0]
          if (5 + i < 6) begin
            for (int j=0; j<2; j++) begin
              pkt[2][5].ena[i*2+j] <= din_ena[1][5+i][j];
              pkt[2][5].sop[i*2+j] <= slice_reg[1][5+i].sop[j];
              pkt[2][5].eop[i*2+j] <= slice_reg[1][5+i].eop[j];
              pkt[2][5].err[i*2+j] <= slice_reg[1][5+i].err[j];
              pkt[2][5].mty[i*2+j] <= slice_reg[1][5+i].mty[j];
              pkt[2][5].dat[i*2+j] <= slice_reg[1][5+i].dat[j];
            end
          end
        end
      end
      3: begin
        for (int i=0; i<2; i++) begin // fill [7:4]
          for (int j=0; j<2; j++) begin
            if (5+i < 6) begin
              pkt[2][5].ena[4+i*2+j] <= din_ena[1][5+i][j];
              pkt[2][5].sop[4+i*2+j] <= slice_reg[1][5+i].sop[j];
              pkt[2][5].eop[4+i*2+j] <= slice_reg[1][5+i].eop[j];
              pkt[2][5].err[4+i*2+j] <= slice_reg[1][5+i].err[j];
              pkt[2][5].mty[4+i*2+j] <= slice_reg[1][5+i].mty[j];
              pkt[2][5].dat[4+i*2+j] <= slice_reg[1][5+i].dat[j];
            end
          end
        end
      end
      4: begin
        for (int j=0; j<2; j++) begin // fill [3:2]
          pkt[2][5].ena[2+j] <= din_ena[1][5][j];
          pkt[2][5].sop[2+j] <= slice_reg[1][5].sop[j];
          pkt[2][5].eop[2+j] <= slice_reg[1][5].eop[j];
          pkt[2][5].err[2+j] <= slice_reg[1][5].err[j];
          pkt[2][5].mty[2+j] <= slice_reg[1][5].mty[j];
          pkt[2][5].dat[2+j] <= slice_reg[1][5].dat[j];
        end
      end
      5: begin
        for (int j=0; j<2; j++) begin // fill [7:6]
          pkt[2][5].ena[6+j] <= din_ena[1][5][j];
          pkt[2][5].sop[6+j] <= slice_reg[1][5].sop[j];
          pkt[2][5].eop[6+j] <= slice_reg[1][5].eop[j];
          pkt[2][5].err[6+j] <= slice_reg[1][5].err[j];
          pkt[2][5].mty[6+j] <= slice_reg[1][5].mty[j];
          pkt[2][5].dat[6+j] <= slice_reg[1][5].dat[j];
        end
      end
      6: begin
        for (int j=0; j<2; j++) begin // fill [9:8]
          pkt[2][5].ena[8+j] <= din_ena[1][5][j];
          pkt[2][5].sop[8+j] <= slice_reg[1][5].sop[j];
          pkt[2][5].eop[8+j] <= slice_reg[1][5].eop[j];
          pkt[2][5].err[8+j] <= slice_reg[1][5].err[j];
          pkt[2][5].mty[8+j] <= slice_reg[1][5].mty[j];
          pkt[2][5].dat[8+j] <= slice_reg[1][5].dat[j];
        end
      end
      7: begin
        pkt_select[2][5] <= pkt[2][5]; // 100G only
        for (int j=0; j<2; j++) begin // fill [11:10]
          pkt_select[2][5].ena[10+j] <= din_ena[1][5][j];
          pkt_select[2][5].sop[10+j] <= slice_reg[1][5].sop[j];
          pkt_select[2][5].eop[10+j] <= slice_reg[1][5].eop[j];
          pkt_select[2][5].err[10+j] <= slice_reg[1][5].err[j];
          pkt_select[2][5].mty[10+j] <= slice_reg[1][5].mty[j];
          pkt_select[2][5].dat[10+j] <= slice_reg[1][5].dat[j];
        end
      end
    endcase


    for (int i=0; i<6; i++) begin
      if (rst[i]) begin
        pkt[2][i].ena <= '0;
      end
    end
  end

  // synthesis translate_off
  // custom preamble check
  reg    [1:0][5:0]    clear_counter_reg;
  reg    [5:0]         clear_counter_pulse;
  reg    [5:0]         preamble_err;
  reg    [5:0][31:0]   preamble_err_cnt;
  reg    [5:0]         p_100;
  reg    [5:0][1:0]    preamble_match;
  reg    [1:0]         preamble_match_0_1, preamble_match_2_3, preamble_match_4_5;

  always @(posedge clk) begin
    p0_400 <= i_data_rate[0] == R_400G;
    p0_200 <= i_data_rate[0] == R_200G;
    p2_200 <= !p0_400 & i_data_rate[2] == R_200G;
    p4_200 <= i_data_rate[4] == R_200G;

    p_100[0] <= i_data_rate[0] == R_100G;
    p_100[1] <= i_data_rate[1] == R_100G & !p0_400 & !p0_200;
    p_100[2] <= i_data_rate[2] == R_100G & !p0_400;
    p_100[3] <= i_data_rate[3] == R_100G & !p0_400 & !p2_200;
    p_100[4] <= i_data_rate[4] == R_100G;
    p_100[5] <= i_data_rate[5] == R_100G & !p4_200;


    clear_counter_reg <= {clear_counter_reg, i_clear_counters};
    clear_counter_pulse <= clear_counter_reg[0] & ~clear_counter_reg[1];

    for (int i=0; i<6; i++) begin
      preamble_match[i][0] <= i_preamble[i] == i_slice[i].dat[0][55:0];
      preamble_match[i][1] <= i_preamble[i] == i_slice[i].dat[1][55:0];
    end

    preamble_match_0_1[0] <= i_preamble[0] == i_slice[1].dat[0][55:0];
    preamble_match_0_1[1] <= i_preamble[0] == i_slice[1].dat[1][55:0];

    preamble_match_2_3[0] <= i_preamble[2] == i_slice[3].dat[0][55:0];
    preamble_match_2_3[1] <= i_preamble[2] == i_slice[3].dat[1][55:0];

    preamble_match_4_5[0] <= i_preamble[4] == i_slice[5].dat[0][55:0];
    preamble_match_4_5[1] <= i_preamble[4] == i_slice[5].dat[1][55:0];

    preamble_err <= 6'd0;


    for (int i=0; i<6; i++) begin
      if (p_100[i] | i == 0 | i == 2 & p2_200 | i == 4 & p4_200)
        if (slice_reg[1][i].sop[0] & din_ena[1][i][0] & !preamble_match[i][0]
          | slice_reg[1][i].sop[1] & din_ena[1][i][1] & !preamble_match[i][1]) preamble_err[i] <= 1'b1;
    end

    if (p0_400 | p0_200) begin
      if (slice_reg[1][1].sop[0] & din_ena[1][1][0] & !preamble_match_0_1[0]
        | slice_reg[1][1].sop[1] & din_ena[1][1][1] & !preamble_match_0_1[1]
        )
        preamble_err[0] <= 1'b1;
    end


    if (p0_400 &
        ( slice_reg[1][3].sop[0] & din_ena[1][3][0] & !preamble_match_2_3[0]
        | slice_reg[1][3].sop[1] & din_ena[1][3][1] & !preamble_match_2_3[1]
        )
    ) preamble_err[0] <= 1'b1;


    if (p2_200 &
        ( slice_reg[1][3].sop[0] & din_ena[1][3][0] & !preamble_match_2_3[0]
        | slice_reg[1][3].sop[1] & din_ena[1][3][1] & !preamble_match_2_3[1]
        )
    ) preamble_err[2] <= 1'b1;


    if (p4_200 &
        ( slice_reg[1][5].sop[0] & din_ena[1][5][0] & !preamble_match_4_5[0]
        | slice_reg[1][5].sop[1] & din_ena[1][5][1] & !preamble_match_4_5[1]
        )
    )  preamble_err[4] <= 1'b1;


    for (int i=0; i<6; i++) begin
      if(clear_counter_pulse[i]) begin
        preamble_err_cnt[i] <= '0;
        preamble_err_cnt[i][0] <= preamble_err[i];
        o_preamble_err_cnt[i] <= preamble_err_cnt[i];
      end
      else begin
        preamble_err_cnt[i] <= preamble_err_cnt[i] + preamble_err[i];
      end
    end
  end
  // synthesis translate_on



endmodule
