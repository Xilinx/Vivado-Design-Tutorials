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
module dcmac_0_core_sniffer (
  clk_apb3,
  rstn_apb3,
  clk_tx_axi,
  i_disable_tvalid_mask,
  i_wait_time,
  i_set_time,
  apb3_wr_ena,
  apb3_wr_addr,
  apb3_wr_dat,
  o_independent_mode,
  o_data_rate,
  o_emu_tx_rst,
  o_emu_rx_rst,
  o_tx_axi_vld_mask,
  o_tx_axi_req_id
);

  parameter R_400G = 2'b10,
            R_200G = 2'b01,
            R_100G = 2'b00;

  parameter IDLE            = 2'd0,
            WAIT_FOR_CHANGE = 2'd1,
            ASSERT_TVLID    = 2'd2;


  input                         clk_apb3;
  input                         rstn_apb3;
  input                         clk_tx_axi;
  input                         i_disable_tvalid_mask;
  input           [3:0]         i_wait_time;
  input           [3:0]         i_set_time;
  input                         apb3_wr_ena;
  input           [31:0]        apb3_wr_addr;
  input           [31:0]        apb3_wr_dat;
  output   reg                  o_independent_mode;
  output   wire   [5:0][1:0]    o_data_rate;
  output   reg    [5:0]         o_emu_tx_rst;
  output   reg    [5:0]         o_emu_rx_rst;
  output   reg    [5:0]         o_tx_axi_vld_mask;
  output   reg    [2:0]         o_tx_axi_req_id;

  reg             [5:0][1:0]    client_data_rate_apb3;
  reg             [5:0][2:0]    fixe_calender, fixe_calender_axi;
  reg             [2:0]         cal_cnt;
  reg                           port0_from_400_apb3;
  reg                           port0_to_400_apb3;
  reg                           port0_to_200_apb3;
  reg                           port2_to_200_apb3;
  reg                           port4_to_200_apb3;
  reg             [1:0]         rate_change_cnt;
  reg             [2:0]         port0_from_400_axi;
  reg             [2:0]         port0_to_400_axi;
  reg             [2:0]         port0_to_200_axi;
  reg             [2:0]         port2_to_200_axi;
  reg             [2:0]         port4_to_200_axi;
  reg                           port0_from_400_axi_pulse;
  reg                           port0_to_400_axi_pulse;
  reg                           port0_to_200_axi_pulse;
  reg                           port2_to_200_axi_pulse;
  reg                           port4_to_200_axi_pulse;
  reg             [3:0]         axi_cnt;
  reg             [5:0]         vld_mask;
  reg             [1:0]         state;




  assign o_data_rate = client_data_rate_apb3;

  always @(posedge clk_tx_axi) begin
    fixe_calender_axi <= fixe_calender;
    cal_cnt <= rstn_apb3? (cal_cnt == 3'd5)? 3'd0 : cal_cnt + 1'b1 : 3'd0;
    o_tx_axi_req_id <= fixe_calender_axi[cal_cnt];

    port0_from_400_axi <= {port0_from_400_axi[1:0], port0_from_400_apb3};
    port0_from_400_axi_pulse <= !port0_from_400_axi[2] & port0_from_400_axi[1];

    port0_to_400_axi <= {port0_to_400_axi[1:0], port0_to_400_apb3};
    port0_to_200_axi <= {port0_to_200_axi[1:0], port0_to_200_apb3};
    port2_to_200_axi <= {port2_to_200_axi[1:0], port2_to_200_apb3};
    port4_to_200_axi <= {port4_to_200_axi[1:0], port4_to_200_apb3};

    port0_to_400_axi_pulse <= !port0_to_400_axi[2] & port0_to_400_axi[1];
    port0_to_200_axi_pulse <= !port0_to_200_axi[2] & port0_to_200_axi[1];
    port2_to_200_axi_pulse <= !port2_to_200_axi[2] & port2_to_200_axi[1];
    port4_to_200_axi_pulse <= !port4_to_200_axi[2] & port4_to_200_axi[1];

    if (!rstn_apb3) begin
      state <= IDLE;
      axi_cnt <= '0;
      vld_mask <= '0;
      o_tx_axi_vld_mask <= '0;
    end
    else begin
      if (|axi_cnt) axi_cnt <= axi_cnt - 1'b1;

      case (state)
        IDLE: begin
          if (port0_to_400_axi_pulse | port0_to_200_axi_pulse | port2_to_200_axi_pulse | port4_to_200_axi_pulse) begin
            if (!i_disable_tvalid_mask) state <= WAIT_FOR_CHANGE;
            axi_cnt <= i_wait_time;
            vld_mask <= '0;
            o_tx_axi_vld_mask <= '0;
            if (port0_to_400_axi_pulse | port0_from_400_axi_pulse) vld_mask[3:0] <= '1;
            if (port0_to_200_axi_pulse) vld_mask[1:0] <= '1;
            if (port2_to_200_axi_pulse) vld_mask[3:2] <= '1;
            if (port4_to_200_axi_pulse) vld_mask[5:4] <= '1;
          end
        end
        WAIT_FOR_CHANGE: begin
          if (axi_cnt == '0) begin
            state <= ASSERT_TVLID;
            axi_cnt <= i_set_time;
            o_tx_axi_vld_mask <= vld_mask;
          end
        end
        ASSERT_TVLID: begin
          if (axi_cnt == '0) begin
            state <= IDLE;
            o_tx_axi_vld_mask <= '0;
          end
        end
        default: begin
          state <= IDLE;
        end
      endcase
    end

  end

  always @(posedge clk_apb3) begin
    if (!rstn_apb3) begin
      o_independent_mode <= 1'b0;
      o_emu_tx_rst <= 6'd0;
      o_emu_rx_rst <= 6'd0;
      client_data_rate_apb3 <= '0;
      fixe_calender <= '1;
      rate_change_cnt <= '1;
      port0_from_400_apb3 <= 1'b0;
      port0_to_400_apb3 <= 1'b0;
      port0_to_200_apb3 <= 1'b0;
      port2_to_200_apb3 <= 1'b0;
      port4_to_200_apb3 <= 1'b0;
    end
    else begin
      if (&rate_change_cnt) begin
        port0_from_400_apb3 <= 1'b0;
        port0_to_400_apb3 <= 1'b0;
        port0_to_200_apb3 <= 1'b0;
        port2_to_200_apb3 <= 1'b0;
        port4_to_200_apb3 <= 1'b0;
      end
      else rate_change_cnt <= rate_change_cnt + 1'b1;

      if (apb3_wr_ena) begin // APB3 write to DCMAC core

        if (apb3_wr_addr[17:0] == 18'h00004) o_independent_mode <= apb3_wr_dat[0];

        if (apb3_wr_addr[11:0] == 12'h038) begin // tx per-ch flush
          for (int i=0; i<6; i++) begin
            if (apb3_wr_addr[19:12] == i[7:0] + 1) o_emu_tx_rst[i] <= apb3_wr_dat[0];
          end
        end

        if (apb3_wr_addr[11:0] == 12'h030) begin // rx per-ch flush
          for (int i=0; i<6; i++) begin
            if (apb3_wr_addr[17:12] == i[7:0] + 1) o_emu_rx_rst[i] <= apb3_wr_dat[0];
          end
        end

        if (apb3_wr_addr[11:0] == 12'h040) begin // data rate
          if (|apb3_wr_dat[1:0]) rate_change_cnt <= '0; // not 100G, start to count

          for (int i=0; i<6; i++) begin
            if (apb3_wr_addr[17:12] == i[7:0] + 1) begin // write-rate
              client_data_rate_apb3[i] <= apb3_wr_dat[1:0];
              case (i)
                0: begin
                  case (apb3_wr_dat[1:0])
                    R_400G: begin
                      port0_to_400_apb3 <= 1'b1;
                      fixe_calender[0] <= 3'd0;
                      fixe_calender[1] <= 3'd0;
                      fixe_calender[3] <= 3'd0;
                      fixe_calender[4] <= 3'd0;
                    end
                    R_200G: begin
                      port0_to_200_apb3 <= 1'b1;
                      fixe_calender[0] <= 3'd0;
                      fixe_calender[3] <= 3'd0;
                      if (client_data_rate_apb3[0] == R_400G) begin
                        port0_from_400_apb3 <= 1'b1;
                        fixe_calender[1] <= 3'd2;
                        fixe_calender[4] <= 3'd3;
                      end
                    end
                    R_100G: begin
                      fixe_calender[0] <= 3'd0;
                      fixe_calender[3] <= 3'd1;
                      if (client_data_rate_apb3[0] == R_400G) begin
                        fixe_calender[1] <= 3'd2;
                        fixe_calender[4] <= 3'd3;
                      end
                    end
                  endcase
                end
                1: begin
                  if (client_data_rate_apb3[0] != R_400G & client_data_rate_apb3[0] != R_200G & apb3_wr_dat[1:0] == R_100G) fixe_calender[3] <= 3'd1;
                end
                2: begin
                  if (client_data_rate_apb3[0] != R_400G) begin
                    if (apb3_wr_dat[1:0] == R_200G) begin
                      fixe_calender[1] <= 3'd2;
                      fixe_calender[4] <= 3'd2;
                      port2_to_200_apb3 <= 1'b1;
                    end
                    else if (apb3_wr_dat[1:0] == R_100G) begin
                      fixe_calender[1] <= 3'd2;
                      fixe_calender[4] <= 3'd3;
                    end
                  end
                end
                3: begin
                  if (client_data_rate_apb3[0] != R_400G & client_data_rate_apb3[2] != R_200G & apb3_wr_dat[1:0] == R_100G) fixe_calender[4] <= 3'd3;
                end
                4: begin
                  if (apb3_wr_dat[1:0] == R_200G) begin
                    fixe_calender[2] <= 3'd4;
                    fixe_calender[5] <= 3'd4;
                    port4_to_200_apb3 <= 1'b1;
                  end
                  else if (apb3_wr_dat[1:0] == R_100G) begin
                    fixe_calender[2] <= 3'd4;
                    fixe_calender[5] <= 3'd5;
                  end
                end
                5: begin
                  if (client_data_rate_apb3[4] != R_200G & apb3_wr_dat[1:0] == R_100G) fixe_calender[5] <= 3'd5;
                end
              endcase
            end // end write-rate
          end // end i-loop
        end
      end // end APB3 write
    end
  end
endmodule

