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
module dcmac_0_emu_register
  (
  input   wire                        apb3_clk,
  input   wire                        apb3_rstn,
  input   wire                        hard_rstn,

  output  logic [31:0]                APB_M_prdata,
  output  logic [0:0]                 APB_M_pready,
  output  logic [0:0]                 APB_M_pslverr,
  input   wire  [31:0]                APB_M_paddr,
  input   wire                        APB_M_penable,
  input   wire  [0:0]                 APB_M_psel,
  input   wire  [31:0]                APB_M_pwdata,
  input   wire                        APB_M_pwrite,

  // packet gen control
  output  reg     [6:0]               tx_pkt_gen_ena,
  output  reg     [15:0]              tx_pkt_gen_min_len,
  output  reg     [15:0]              tx_pkt_gen_max_len,
  output  reg     [39:0]              clear_tx_counters,
  output  reg     [39:0]              clear_rx_counters,

  // pause
  output  reg     [5:0][8:0]          tx_pause_req,
  output  reg     [5:0]               tx_resend_pause,

  // PTP enable
  output  reg     [5:0]               tx_ptp_ena,
  output  reg     [1:0]               tx_ptp_opt,
  output  reg     [11:0]              tx_ptp_cf_offset,
  output  reg                         tx_ptp_upd_chksum,

  // calendar to drive macif tx
  input                               tx_macif_clk,
  input   wire                        tx_macif_ts_id_req_rdy,
  output  wire    [5:0]               tx_macif_ts_id_req,
  output  wire                        tx_macif_ts_id_req_vld,

  // packets/error count from packet gen/mon
  input   wire    [5:0][63:0]        client_tx_frames_transmitted_latched,
  input   wire    [5:0][63:0]        client_rx_frames_received_latched,
  input   wire    [5:0][63:0]        client_tx_bytes_transmitted_latched,
  input   wire    [5:0][63:0]        client_rx_bytes_received_latched,
  input   wire    [5:0][31:0]         client_rx_preamble_err_cnt,
  input   wire    [5:0]              client_rx_prbs_locked,
  input   wire    [5:0][31:0]        client_rx_prbs_err,

  // FIXE mode, gearbox FIFO error
  input   wire    [5:0]               gearbox_unf,
  input   wire    [5:0]               gearbox_ovf,

  output  wire                        apb3_rstn_out,
  output  reg      [31:0]             scratch
  );


/////////////////////////////////////////////////////////////////////////////
// signals
/////////////////////////////////////////////////////////////////////////////

  reg   [31:0]          APB_M_paddr_r;
  reg                   APB_M_penable_r;
  reg   [0:0]           APB_M_psel_r;
  reg   [31:0]          APB_M_pwdata_r;
  reg                   APB_M_pwrite_r;
  reg   [1:0]           client_apb_state;


  reg                   memcel_apb3_reset;
  reg   [9:0]           memcel_apb3_reset_d;

  reg    [31:0]         wdata;
  reg                   id_done;
  reg    [2:0]          id_cnt;
  reg                   axi_id_wea;
  reg    [9:0]          axi_id_addra;
  reg    [5:0]          axi_id_dina;
  wire   [5:0]          axi_id_douta;
  reg                   id_ae, id_ae_reg;
  reg    [9:0]          addrb;
  wire   [5:0]          mem_out_id;
  reg                   mem_out_id_vld;

  wire  [31:0]          version;
  wire                  abp3_hard_rst;

  wire  [39:0]          gearbox_unf_39_0, gearbox_ovf_39_0;
  logic [39:0][31:0]    rx_preamble_err_cnt;

  logic [5:0][31:0] tx_byte_cnt_upper, tx_byte_cnt_lower,
                               tx_pkt_cnt_upper, tx_pkt_cnt_lower,
                               rx_byte_cnt_upper, rx_byte_cnt_lower,
                               rx_pkt_cnt_upper, rx_pkt_cnt_lower;

/////////////////////////////////////////////////////////////////////////////
// DCMAC register
/////////////////////////////////////////////////////////////////////////////
  assign version[0] = 1;
  assign version[1] = 0;
  assign version[2] = 1;
  assign version[3] = 0 | 0;
  assign version[4] = 0;

  assign version[31:8] = 0;


  assign gearbox_unf_39_0[39:0] = {34'd0, gearbox_unf};
  assign gearbox_ovf_39_0[39:0] = {34'd0, gearbox_ovf};



  always @* begin
    for (int i=0; i<6; i++) rx_preamble_err_cnt[i] = client_rx_preamble_err_cnt[i];
    for (int i=6; i<40; i++) rx_preamble_err_cnt[i] = '0;

    for (int i=0; i<6; i++) begin
      {tx_byte_cnt_upper[i], tx_byte_cnt_lower[i]} = client_tx_bytes_transmitted_latched[i];
      {tx_pkt_cnt_upper[i],  tx_pkt_cnt_lower[i]}  = client_tx_frames_transmitted_latched[i];

      {rx_byte_cnt_upper[i], rx_byte_cnt_lower[i]} = client_rx_bytes_received_latched[i];
      {rx_pkt_cnt_upper[i],  rx_pkt_cnt_lower[i]}  = client_rx_frames_received_latched[i];
    end
  end

  always @(posedge  apb3_clk) begin
    if ( abp3_hard_rst ) begin
      APB_M_paddr_r <= 32'h0;
      APB_M_penable_r <= 1'h0;
      APB_M_prdata <= 32'h0;
      APB_M_pready <= 1'h0;
      APB_M_psel_r <= 1'h0;
      APB_M_pslverr <= 1'h0;
      APB_M_pwdata_r <= 32'h0;
      APB_M_pwrite_r <= 1'h0;

      memcel_apb3_reset <= 1'b0;

      scratch  <= 32'h0;

      tx_pkt_gen_ena        <= '0;
      tx_pkt_gen_min_len    <= 64;
      tx_pkt_gen_max_len    <= 9596;
      clear_tx_counters     <= '0;
      clear_rx_counters     <= '0;


      tx_pause_req    <= '0;
      tx_resend_pause <= '0;
      tx_ptp_ena <= '0;
      tx_ptp_opt <= '0;
      tx_ptp_upd_chksum <= 1'b0;
      // the minimum offset to the correction field should be 22 (Ethernet header + PTP header).
      tx_ptp_cf_offset <= 22;


      id_cnt <= '0;
      axi_id_wea <= 1'b0;
      id_done <= 1'b0;

    end//rst
    else begin

      APB_M_pready <= 1'b0;
      APB_M_pslverr <= 1'b0;

      APB_M_paddr_r <= APB_M_paddr;
      APB_M_penable_r <= APB_M_penable;
      APB_M_psel_r <= APB_M_psel;
      APB_M_pwdata_r <= APB_M_pwdata;
      APB_M_pwrite_r <= APB_M_pwrite;

      clear_tx_counters <= '0;
      clear_rx_counters <= '0;

      axi_id_wea <= 1'b0;

      case(client_apb_state)
        2'd0: begin
          if (APB_M_psel_r && APB_M_penable_r) begin

            if (APB_M_pwrite_r) begin
              //write
              if (APB_M_paddr_r[10:2] < 120) begin
                axi_id_wea <= 1'b1;
                axi_id_addra <= (APB_M_paddr_r[10:2] << 2) + APB_M_paddr_r[10:2] + id_cnt;

                if (id_cnt == 0) begin
                  wdata <= APB_M_pwdata_r;
                end

                case (id_cnt)
                  0: axi_id_dina <= APB_M_pwdata_r[(6*0)+:6];
                  1: axi_id_dina <= wdata[(6*1)+:6];
                  2: axi_id_dina <= wdata[(6*2)+:6];
                  3: axi_id_dina <= wdata[(6*3)+:6];
                  4: axi_id_dina <= wdata[(6*4)+:6];
                endcase

                id_cnt <= id_cnt + 1'b1;
                if (id_cnt == 3'd4) begin
                  client_apb_state <= 2'd1;
                  APB_M_pready <= 1'b1;
                  id_cnt <= 3'd0;
                  if (APB_M_paddr_r[10:2] == 119) id_done <= 1'b1;
                end
              end
              else begin // >= 120
                id_cnt <= 3'd0;
                client_apb_state <= 2'd1;
                APB_M_pready <= 1'b1;

                case (APB_M_paddr_r[10:2])

                  9'h80: begin   //0x200
                    memcel_apb3_reset  <= APB_M_pwdata_r[0];
                  end

                  9'h81: begin    //0x204
                    tx_pkt_gen_ena <= APB_M_pwdata_r[30:24];
                  end

                  9'h82: begin    //0x208
                    tx_pkt_gen_max_len <= APB_M_pwdata_r[31:16];
                    tx_pkt_gen_min_len <= APB_M_pwdata_r[15: 0];
                  end

                  9'h83: begin    //0x20C
                    clear_tx_counters[31:0] <= APB_M_pwdata_r;
                  end

                  9'h84: begin    //0x210
                    clear_tx_counters[39:32] <= APB_M_pwdata_r[7:0];
                  end

                  9'h85: begin    //0x214
                    clear_rx_counters[31:0] <= APB_M_pwdata_r;
                  end

                  9'h86: begin    //0x218
                    clear_rx_counters[39:32] <= APB_M_pwdata_r[7:0];
                  end

                  9'h87: begin    //0x21C
                    tx_ptp_opt[1:0] <= APB_M_pwdata_r[1:0];
                    tx_ptp_cf_offset[11:0] <= APB_M_pwdata_r[19:8];
                    tx_ptp_upd_chksum <= APB_M_pwdata_r[24];
                  end

                  9'h90: begin // 0x240
                    tx_pause_req[0][8:0] <= APB_M_pwdata_r[8:0];
                    tx_resend_pause[0] <= APB_M_pwdata_r[9];
                    tx_ptp_ena[0] <= APB_M_pwdata_r[16];
                  end

                  9'ha0: begin // 0x280
                    tx_pause_req[1][8:0] <= APB_M_pwdata_r[8:0];
                    tx_resend_pause[1] <= APB_M_pwdata_r[9];
                    tx_ptp_ena[1] <= APB_M_pwdata_r[16];
                  end

                  9'hb0: begin // 0x2c0
                    tx_pause_req[2][8:0] <= APB_M_pwdata_r[8:0];
                    tx_resend_pause[2] <= APB_M_pwdata_r[9];
                    tx_ptp_ena[2] <= APB_M_pwdata_r[16];
                  end

                  9'hc0: begin // 0x300
                    tx_pause_req[3][8:0] <= APB_M_pwdata_r[8:0];
                    tx_resend_pause[3] <= APB_M_pwdata_r[9];
                    tx_ptp_ena[3] <= APB_M_pwdata_r[16];
                  end

                  9'hd0: begin // 0x340
                    tx_pause_req[4][8:0] <= APB_M_pwdata_r[8:0];
                    tx_resend_pause[4] <= APB_M_pwdata_r[9];
                    tx_ptp_ena[4] <= APB_M_pwdata_r[16];
                  end

                  9'he0: begin // 0x380
                    tx_pause_req[5][8:0] <= APB_M_pwdata_r[8:0];
                    tx_resend_pause[5] <= APB_M_pwdata_r[9];
                    tx_ptp_ena[5] <= APB_M_pwdata_r[16];
                  end




                  9'hfe: begin    //0x3f8
                    scratch <= APB_M_pwdata_r[31:0];
                  end


                endcase
              end // end >= 120
            end //if write

            //read
            else begin
              APB_M_prdata[31:30] <= 2'd0;
              if (APB_M_paddr_r[11:2] < 120) begin
                axi_id_addra <= (APB_M_paddr_r[10:2] << 2) + APB_M_paddr_r[10:2] + id_cnt;
                case (id_cnt) // read delay = 2 clock cycles
                  3: APB_M_prdata[(6*0)+:6] <= axi_id_douta;
                  4: APB_M_prdata[(6*1)+:6] <= axi_id_douta;
                  5: APB_M_prdata[(6*2)+:6] <= axi_id_douta;
                  6: APB_M_prdata[(6*3)+:6] <= axi_id_douta;
                  7: APB_M_prdata[(6*4)+:6] <= axi_id_douta;
                endcase

                id_cnt <= id_cnt + 1'b1;
                if (id_cnt == 3'd7) begin
                  APB_M_pready <= 1'b1;
                  client_apb_state <= 2'd1;
                  id_cnt <= 3'd0;
                end
              end
              else begin
                APB_M_prdata <= 32'd0;

                client_apb_state <= 2'd1;
                APB_M_pready <= 1'b1;
                id_cnt <= 3'd0;
                case (APB_M_paddr_r[11:2])
                  10'h80: begin   //0x200
                    APB_M_prdata[0] <= memcel_apb3_reset;
                  end

                  10'h81: begin    //0x204
                    APB_M_prdata[30:24] <= tx_pkt_gen_ena;
                  end

                  10'h82: begin    //0x208
                    APB_M_prdata[31:16] <= tx_pkt_gen_max_len;
                    APB_M_prdata[15: 0] <= tx_pkt_gen_min_len;
                  end

                  10'h87: begin    //0x21C
                    APB_M_prdata[1:0] <= tx_ptp_opt[1:0];
                    APB_M_prdata[19:8] <= tx_ptp_cf_offset[11:0];
                    APB_M_prdata[24] <= tx_ptp_upd_chksum;
                  end

                  10'h90: begin // 0x240
                    APB_M_prdata[8:0] <= tx_pause_req[0][8:0];
                    APB_M_prdata[9] <= tx_resend_pause[0];
                    APB_M_prdata[16] <= tx_ptp_ena[0];
                  end

                  10'ha0: begin // 0x280
                    APB_M_prdata[8:0] <= tx_pause_req[1][8:0];
                    APB_M_prdata[9] <= tx_resend_pause[1];
                    APB_M_prdata[16] <= tx_ptp_ena[1];
                  end

                  10'hb0: begin // 0x2c0
                    APB_M_prdata[8:0] <= tx_pause_req[2][8:0];
                    APB_M_prdata[9] <= tx_resend_pause[2];
                    APB_M_prdata[16] <= tx_ptp_ena[2];
                  end

                  10'hc0: begin // 0x300
                    APB_M_prdata[8:0] <= tx_pause_req[3][8:0];
                    APB_M_prdata[9] <= tx_resend_pause[3];
                    APB_M_prdata[16] <= tx_ptp_ena[3];
                  end

                  10'hd0: begin // 0x340
                    APB_M_prdata[8:0] <= tx_pause_req[4][8:0];
                    APB_M_prdata[9] <= tx_resend_pause[4];
                    APB_M_prdata[16] <= tx_ptp_ena[4];
                  end

                  10'he0: begin // 0x380
                    APB_M_prdata[8:0] <= tx_pause_req[5][8:0];
                    APB_M_prdata[9] <= tx_resend_pause[5];
                    APB_M_prdata[16] <= tx_ptp_ena[5];
                  end




                  10'hfe: begin    //0x3f8
                    APB_M_prdata[31:0] <= scratch;
                  end

                  10'hff: begin    //0x3fc
                    APB_M_prdata[31:0] <= version[31:0];
                  end

                  10'h100: begin // 0x400
                    APB_M_prdata <= tx_pkt_cnt_lower[0];
                  end
                  10'h101: begin // 0x404
                    APB_M_prdata <= tx_pkt_cnt_upper[0];
                  end
                  10'h102: begin // 0x408
                    APB_M_prdata <= tx_byte_cnt_lower[0];
                  end
                  10'h103: begin // 0x40c
                    APB_M_prdata <= tx_byte_cnt_upper[0];
                  end
                  10'h104: begin // 0x410
                    APB_M_prdata <= rx_pkt_cnt_lower[0];
                  end
                  10'h105: begin // 0x414
                    APB_M_prdata <= rx_pkt_cnt_upper[0];
                  end
                  10'h106: begin // 0x418
                    APB_M_prdata <= rx_byte_cnt_lower[0];
                  end
                  10'h107: begin // 0x41c
                    APB_M_prdata <= rx_byte_cnt_upper[0];
                  end
                  10'h108: begin // 0x420
                    APB_M_prdata <= client_rx_prbs_locked[0];
                  end
                  10'h109: begin // 0x424
                    APB_M_prdata <= client_rx_prbs_err[0];
                  end
                  10'h10a: begin // 0x428
                    APB_M_prdata <= rx_preamble_err_cnt[0];
                  end
                  10'h10b: begin // 0x42c
                    APB_M_prdata <= gearbox_unf_39_0[0];
                  end
                  10'h10c: begin // 0x430
                    APB_M_prdata <= gearbox_ovf_39_0[0];
                  end
                  10'h110: begin // 0x440
                    APB_M_prdata <= tx_pkt_cnt_lower[1];
                  end
                  10'h111: begin // 0x444
                    APB_M_prdata <= tx_pkt_cnt_upper[1];
                  end
                  10'h112: begin // 0x448
                    APB_M_prdata <= tx_byte_cnt_lower[1];
                  end
                  10'h113: begin // 0x44c
                    APB_M_prdata <= tx_byte_cnt_upper[1];
                  end
                  10'h114: begin // 0x450
                    APB_M_prdata <= rx_pkt_cnt_lower[1];
                  end
                  10'h115: begin // 0x454
                    APB_M_prdata <= rx_pkt_cnt_upper[1];
                  end
                  10'h116: begin // 0x458
                    APB_M_prdata <= rx_byte_cnt_lower[1];
                  end
                  10'h117: begin // 0x45c
                    APB_M_prdata <= rx_byte_cnt_upper[1];
                  end
                  10'h118: begin // 0x460
                    APB_M_prdata <= client_rx_prbs_locked[1];
                  end
                  10'h119: begin // 0x464
                    APB_M_prdata <= client_rx_prbs_err[1];
                  end
                  10'h11a: begin // 0x468
                    APB_M_prdata <= rx_preamble_err_cnt[1];
                  end
                  10'h11b: begin // 0x46c
                    APB_M_prdata <= gearbox_unf_39_0[1];
                  end
                  10'h11c: begin // 0x470
                    APB_M_prdata <= gearbox_ovf_39_0[1];
                  end
                  10'h120: begin // 0x480
                    APB_M_prdata <= tx_pkt_cnt_lower[2];
                  end
                  10'h121: begin // 0x484
                    APB_M_prdata <= tx_pkt_cnt_upper[2];
                  end
                  10'h122: begin // 0x488
                    APB_M_prdata <= tx_byte_cnt_lower[2];
                  end
                  10'h123: begin // 0x48c
                    APB_M_prdata <= tx_byte_cnt_upper[2];
                  end
                  10'h124: begin // 0x490
                    APB_M_prdata <= rx_pkt_cnt_lower[2];
                  end
                  10'h125: begin // 0x494
                    APB_M_prdata <= rx_pkt_cnt_upper[2];
                  end
                  10'h126: begin // 0x498
                    APB_M_prdata <= rx_byte_cnt_lower[2];
                  end
                  10'h127: begin // 0x49c
                    APB_M_prdata <= rx_byte_cnt_upper[2];
                  end
                  10'h128: begin // 0x4a0
                    APB_M_prdata <= client_rx_prbs_locked[2];
                  end
                  10'h129: begin // 0x4a4
                    APB_M_prdata <= client_rx_prbs_err[2];
                  end
                  10'h12a: begin // 0x4a8
                    APB_M_prdata <= rx_preamble_err_cnt[2];
                  end
                  10'h12b: begin // 0x4ac
                    APB_M_prdata <= gearbox_unf_39_0[2];
                  end
                  10'h12c: begin // 0x4b0
                    APB_M_prdata <= gearbox_ovf_39_0[2];
                  end
                  10'h130: begin // 0x4c0
                    APB_M_prdata <= tx_pkt_cnt_lower[3];
                  end
                  10'h131: begin // 0x4c4
                    APB_M_prdata <= tx_pkt_cnt_upper[3];
                  end
                  10'h132: begin // 0x4c8
                    APB_M_prdata <= tx_byte_cnt_lower[3];
                  end
                  10'h133: begin // 0x4cc
                    APB_M_prdata <= tx_byte_cnt_upper[3];
                  end
                  10'h134: begin // 0x4d0
                    APB_M_prdata <= rx_pkt_cnt_lower[3];
                  end
                  10'h135: begin // 0x4d4
                    APB_M_prdata <= rx_pkt_cnt_upper[3];
                  end
                  10'h136: begin // 0x4d8
                    APB_M_prdata <= rx_byte_cnt_lower[3];
                  end
                  10'h137: begin // 0x4dc
                    APB_M_prdata <= rx_byte_cnt_upper[3];
                  end
                  10'h138: begin // 0x4e0
                    APB_M_prdata <= client_rx_prbs_locked[3];
                  end
                  10'h139: begin // 0x4e4
                    APB_M_prdata <= client_rx_prbs_err[3];
                  end
                  10'h13a: begin // 0x4e8
                    APB_M_prdata <= rx_preamble_err_cnt[3];
                  end
                  10'h13b: begin // 0x4ec
                    APB_M_prdata <= gearbox_unf_39_0[3];
                  end
                  10'h13c: begin // 0x4f0
                    APB_M_prdata <= gearbox_ovf_39_0[3];
                  end
                  10'h140: begin // 0x500
                    APB_M_prdata <= tx_pkt_cnt_lower[4];
                  end
                  10'h141: begin // 0x504
                    APB_M_prdata <= tx_pkt_cnt_upper[4];
                  end
                  10'h142: begin // 0x508
                    APB_M_prdata <= tx_byte_cnt_lower[4];
                  end
                  10'h143: begin // 0x50c
                    APB_M_prdata <= tx_byte_cnt_upper[4];
                  end
                  10'h144: begin // 0x510
                    APB_M_prdata <= rx_pkt_cnt_lower[4];
                  end
                  10'h145: begin // 0x514
                    APB_M_prdata <= rx_pkt_cnt_upper[4];
                  end
                  10'h146: begin // 0x518
                    APB_M_prdata <= rx_byte_cnt_lower[4];
                  end
                  10'h147: begin // 0x51c
                    APB_M_prdata <= rx_byte_cnt_upper[4];
                  end
                  10'h148: begin // 0x520
                    APB_M_prdata <= client_rx_prbs_locked[4];
                  end
                  10'h149: begin // 0x524
                    APB_M_prdata <= client_rx_prbs_err[4];
                  end
                  10'h14a: begin // 0x528
                    APB_M_prdata <= rx_preamble_err_cnt[4];
                  end
                  10'h14b: begin // 0x52c
                    APB_M_prdata <= gearbox_unf_39_0[4];
                  end
                  10'h14c: begin // 0x530
                    APB_M_prdata <= gearbox_ovf_39_0[4];
                  end
                  10'h150: begin // 0x540
                    APB_M_prdata <= tx_pkt_cnt_lower[5];
                  end
                  10'h151: begin // 0x544
                    APB_M_prdata <= tx_pkt_cnt_upper[5];
                  end
                  10'h152: begin // 0x548
                    APB_M_prdata <= tx_byte_cnt_lower[5];
                  end
                  10'h153: begin // 0x54c
                    APB_M_prdata <= tx_byte_cnt_upper[5];
                  end
                  10'h154: begin // 0x550
                    APB_M_prdata <= rx_pkt_cnt_lower[5];
                  end
                  10'h155: begin // 0x554
                    APB_M_prdata <= rx_pkt_cnt_upper[5];
                  end
                  10'h156: begin // 0x558
                    APB_M_prdata <= rx_byte_cnt_lower[5];
                  end
                  10'h157: begin // 0x55c
                    APB_M_prdata <= rx_byte_cnt_upper[5];
                  end
                  10'h158: begin // 0x560
                    APB_M_prdata <= client_rx_prbs_locked[5];
                  end
                  10'h159: begin // 0x564
                    APB_M_prdata <= client_rx_prbs_err[5];
                  end
                  10'h15a: begin // 0x568
                    APB_M_prdata <= rx_preamble_err_cnt[5];
                  end
                  10'h15b: begin // 0x56c
                    APB_M_prdata <= gearbox_unf_39_0[5];
                  end
                  10'h15c: begin // 0x570
                    APB_M_prdata <= gearbox_ovf_39_0[5];
                  end

                  default: begin
                    APB_M_prdata <= 32'd0;
                  end
                endcase
              end
            end // if read
          end //if valid access
        end //state 0

        2'd1: begin
          client_apb_state <= 2'd2;
        end

        default: begin
          client_apb_state <= 2'd0;
        end
      endcase
    end //!rst

  end//always

  dcmac_0_syncer_reset #(
    .RESET_PIPE_LEN (3)
  ) i_dcmac_0_abp3_hard_rst_syncer (
    .clk            (apb3_clk),
    .reset_async    (~apb3_rstn | ~hard_rstn),
    .reset          (abp3_hard_rst)
  );

  always @(posedge apb3_clk) begin
    if (!hard_rstn) begin
      memcel_apb3_reset_d <= {10{1'b1}}; //changed for without 7t sim
    end else begin
      if (memcel_apb3_reset) begin
        memcel_apb3_reset_d <= {10{1'b1}};
      end else begin
        memcel_apb3_reset_d <= {memcel_apb3_reset_d[8:0],1'b0};
      end
    end
  end

  assign apb3_rstn_out =  !memcel_apb3_reset_d[9];


endmodule

