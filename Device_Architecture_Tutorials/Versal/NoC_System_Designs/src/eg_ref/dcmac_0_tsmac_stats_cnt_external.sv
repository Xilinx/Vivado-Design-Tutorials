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
module tsmac_rx_stats_cnt_external (
  clk,
  rst,
  ts_rst,
  ts_rst_id,
  i_stats_id_valid,
  i_stats_id,
  i_stat_rx_total_bytes,
  i_stat_rx_total_good_bytes,
  i_stat_rx_total_packets,
  i_stat_rx_total_good_packets,
  i_stat_rx_packet_small,
  i_stat_rx_bad_code,
  i_stat_rx_bad_fcs,
  i_stat_rx_packet_bad_fcs,
  i_stat_rx_stomped_fcs,
  i_stat_rx_truncated,
  i_stat_rx_packet_64_bytes,
  i_stat_rx_packet_65_127_bytes,
  i_stat_rx_packet_128_255_bytes,
  i_stat_rx_packet_256_511_bytes,
  i_stat_rx_packet_512_1023_bytes,
  i_stat_rx_packet_1024_1518_bytes,
  i_stat_rx_packet_1519_1522_bytes,
  i_stat_rx_packet_1523_1548_bytes,
  i_stat_rx_packet_1549_2047_bytes,
  i_stat_rx_packet_2048_4095_bytes,
  i_stat_rx_packet_4096_8191_bytes,
  i_stat_rx_packet_8192_9215_bytes,
  i_stat_rx_toolong,
  i_stat_rx_packet_large,
  i_stat_rx_jabber,
  i_stat_rx_oversize,
  i_stat_rx_unicast,
  i_stat_rx_multicast,
  i_stat_rx_broadcast,
  i_stat_rx_vlan,
  i_stat_rx_pause,
  i_stat_rx_user_pause,
  i_stat_rx_inrangeerr,
  rd_clk,
  i_pm_tick,
  i_rd_id,
  i_rd_index,
  i_rd_h,       // 1 : read the upper 32 bits; 0 : read the lower 32 bits
  i_rd_en,      // read enable
  o_init,       // indicate that the memory is being intialized
  o_cnt,
  o_cnt_vld     // o_cnt is valid
);


input              clk;
input              rst;
input              ts_rst;
input [5:0]        ts_rst_id;
input              i_stats_id_valid;
input [5:0]        i_stats_id;
input [7:0]        i_stat_rx_total_bytes;
input [7:0]        i_stat_rx_total_good_bytes;
input [3:0]        i_stat_rx_total_packets;
input [1:0]        i_stat_rx_total_good_packets;
input [3:0]        i_stat_rx_packet_small;
input [4:0]        i_stat_rx_bad_code;
input [2:0]        i_stat_rx_bad_fcs;
input [2:0]        i_stat_rx_packet_bad_fcs;
input [2:0]        i_stat_rx_stomped_fcs;
input              i_stat_rx_truncated;
input [1:0]        i_stat_rx_packet_64_bytes;
input [1:0]        i_stat_rx_packet_65_127_bytes;
input [1:0]        i_stat_rx_packet_128_255_bytes;
input              i_stat_rx_packet_256_511_bytes;
input              i_stat_rx_packet_512_1023_bytes;
input              i_stat_rx_packet_1024_1518_bytes;
input              i_stat_rx_packet_1519_1522_bytes;
input              i_stat_rx_packet_1523_1548_bytes;
input              i_stat_rx_packet_1549_2047_bytes;
input              i_stat_rx_packet_2048_4095_bytes;
input              i_stat_rx_packet_4096_8191_bytes;
input              i_stat_rx_packet_8192_9215_bytes;
input              i_stat_rx_toolong;
input              i_stat_rx_packet_large;
input              i_stat_rx_jabber;
input              i_stat_rx_oversize;
input [1:0]        i_stat_rx_unicast;
input [1:0]        i_stat_rx_multicast;
input [1:0]        i_stat_rx_broadcast;
input [1:0]        i_stat_rx_vlan;
input [1:0]        i_stat_rx_pause;
input [1:0]        i_stat_rx_user_pause;
input [1:0]        i_stat_rx_inrangeerr;
input              rd_clk;
input [39:0]       i_pm_tick;
input [5:0]        i_rd_id;
input [5:0]        i_rd_index;
input              i_rd_h;
input              i_rd_en;
output             o_init;
output reg [31:0]  o_cnt;
output reg         o_cnt_vld;


wire  [1:1][17:0] stat_rx_total_bytes_sum_narrow;
wire  [1:1][17:0] stat_rx_total_good_bytes_sum_narrow;
wire  [1:1][12:0] stat_rx_total_packets_sum_narrow;
wire  [1:1][10:0] stat_rx_total_good_packets_sum_narrow;
wire  [1:1][12:0] stat_rx_packet_small_sum_narrow;
wire  [1:1][13:0] stat_rx_bad_code_sum_narrow;
wire  [1:1][10:0] stat_rx_bad_fcs_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_bad_fcs_sum_narrow;
wire  [1:1][12:0] stat_rx_stomped_fcs_sum_narrow;
wire  [1:1][10:0] stat_rx_truncated_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_64_bytes_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_65_127_bytes_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_128_255_bytes_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_256_511_bytes_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_512_1023_bytes_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_1024_1518_bytes_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_1519_1522_bytes_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_1523_1548_bytes_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_1549_2047_bytes_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_2048_4095_bytes_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_4096_8191_bytes_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_8192_9215_bytes_sum_narrow;
wire  [1:1][10:0] stat_rx_toolong_sum_narrow;
wire  [1:1][10:0] stat_rx_packet_large_sum_narrow;
wire  [1:1][10:0] stat_rx_jabber_sum_narrow;
wire  [1:1][10:0] stat_rx_oversize_sum_narrow;
wire  [1:1][10:0] stat_rx_unicast_sum_narrow;
wire  [1:1][10:0] stat_rx_multicast_sum_narrow;
wire  [1:1][10:0] stat_rx_broadcast_sum_narrow;
wire  [1:1][10:0] stat_rx_vlan_sum_narrow;
wire  [1:1][10:0] stat_rx_pause_sum_narrow;
wire  [1:1][10:0] stat_rx_pause_sum_narrow_tmp;
wire  [1:1][10:0] stat_rx_user_pause_sum_narrow;
wire  [1:1][10:0] stat_rx_user_pause_sum_narrow_tmp;
wire  [1:1][10:0] stat_rx_inrangeerr_sum_narrow;

reg   [0:0] rd_narrow_cnt_en;
reg   [2:0][5:0] rd_id;
reg   [6:0][4:0] addr;
reg   [3:2][1:0][17:0] add_in;
logic [4:4][1:0][52:0] sum_pre;
wire  [4:4][63:0] sum_wide_o;
wire  [6:6][1:0][52:0] sum_new;
logic [6:6][63:0] sum_wide_i;


  always @( posedge clk or posedge rst )
    begin
      if ( rst == 1'b1 ) begin
        addr[0] <= 30;
        rd_id[0] <= 39;
        rd_narrow_cnt_en[0] <= 1'b0;
      end
      else begin
        addr[0] <= (addr[0] < 30)? addr[0] + 1'b1 : '0;
        if (addr[0] == 30) rd_id[0] <= (rd_id[0] < 39)? rd_id[0] + 1'b1 : '0;
        rd_narrow_cnt_en[0] <= addr[0] == 30; // a new channel load starts
      end
    end

always @(posedge clk) begin
  rd_id[2:1] <= rd_id[1:0];
  addr[6:1] <= addr[5:0];
  add_in[3] <= add_in[2];

  add_in[2] <= '0;

  case (addr[1])
    5'd0: begin
        add_in[2][0] <= {stat_rx_total_bytes_sum_narrow[1]};
    end
    5'd1: begin
        add_in[2][0] <= {stat_rx_total_good_bytes_sum_narrow[1]};
    end
    5'd2: begin
        add_in[2][0] <= {5'd0, stat_rx_total_packets_sum_narrow[1]};
    end
    5'd3: begin
        add_in[2][0] <= {7'd0, stat_rx_total_good_packets_sum_narrow[1]};
    end
    5'd4: begin
        add_in[2][0] <= {5'd0, stat_rx_packet_small_sum_narrow[1]};
    end
    5'd5: begin
        add_in[2][0] <= {4'd0, stat_rx_bad_code_sum_narrow[1]};
    end
    5'd6: begin
        add_in[2][0] <= {7'd0, stat_rx_bad_fcs_sum_narrow[1]};
    end
    5'd7: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_bad_fcs_sum_narrow[1]};
    end
    5'd8: begin
        add_in[2][0] <= {5'd0, stat_rx_stomped_fcs_sum_narrow[1]};
    end
    5'd9: begin
        add_in[2][0] <= {7'd0, stat_rx_truncated_sum_narrow[1]};
    end
    5'd10: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_64_bytes_sum_narrow[1]};
    end
    5'd11: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_65_127_bytes_sum_narrow[1]};
    end
    5'd12: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_128_255_bytes_sum_narrow[1]};
    end
    5'd13: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_256_511_bytes_sum_narrow[1]};
    end
    5'd14: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_512_1023_bytes_sum_narrow[1]};
    end
    5'd15: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_1024_1518_bytes_sum_narrow[1]};
    end
    5'd16: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_1519_1522_bytes_sum_narrow[1]};
    end
    5'd17: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_1523_1548_bytes_sum_narrow[1]};
    end
    5'd18: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_1549_2047_bytes_sum_narrow[1]};
    end
    5'd19: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_2048_4095_bytes_sum_narrow[1]};
    end
    5'd20: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_4096_8191_bytes_sum_narrow[1]};
    end
    5'd21: begin
        add_in[2][0] <= {7'd0, stat_rx_packet_8192_9215_bytes_sum_narrow[1]};
    end
    5'd22: begin
        add_in[2][0] <= {7'd0, stat_rx_toolong_sum_narrow[1]};
        add_in[2][1] <= {7'd0, stat_rx_packet_large_sum_narrow[1]};
    end
    5'd23: begin
        add_in[2][0] <= {7'd0, stat_rx_jabber_sum_narrow[1]};
        add_in[2][1] <= {7'd0, stat_rx_oversize_sum_narrow[1]};
    end
    5'd24: begin
        add_in[2][0] <= {7'd0, stat_rx_unicast_sum_narrow[1]};
    end
    5'd25: begin
        add_in[2][0] <= {7'd0, stat_rx_multicast_sum_narrow[1]};
    end
    5'd26: begin
        add_in[2][0] <= {7'd0, stat_rx_broadcast_sum_narrow[1]};
    end
    5'd27: begin
        add_in[2][0] <= {7'd0, stat_rx_vlan_sum_narrow[1]};
    end
    5'd28: begin
        add_in[2][0] <= {7'd0, stat_rx_pause_sum_narrow[1]};
    end
    5'd29: begin
        add_in[2][0] <= {7'd0, stat_rx_user_pause_sum_narrow[1]};
    end
    5'd30: begin
        add_in[2][0] <= {7'd0, stat_rx_inrangeerr_sum_narrow[1]};
    end
  endcase
end


always @* begin
  sum_pre[4] = '0;
  sum_wide_i[6] = '0;
  case (addr[6])
    5'd0: begin
        sum_pre[4][0] = sum_wide_o[4][52:0];               sum_wide_i[6][52:0]       = sum_new[6][0][52:0];
    end
    5'd1: begin
        sum_pre[4][0] = sum_wide_o[4][52:0];               sum_wide_i[6][52:0]       = sum_new[6][0][52:0];
    end
    5'd2: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd3: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd4: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd5: begin
        sum_pre[4][0] = {{3{1'b1}}, sum_wide_o[4][49:0]};  sum_wide_i[6][49:0]       = sum_new[6][0][49:0];
    end
    5'd6: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd7: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd8: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd9: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd10: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd11: begin
        sum_pre[4][0] = {{7{1'b1}}, sum_wide_o[4][45:0]};  sum_wide_i[6][45:0]       = sum_new[6][0][45:0];
    end
    5'd12: begin
        sum_pre[4][0] = {{8{1'b1}}, sum_wide_o[4][44:0]};  sum_wide_i[6][44:0]       = sum_new[6][0][44:0];
    end
    5'd13: begin
        sum_pre[4][0] = {{9{1'b1}}, sum_wide_o[4][43:0]};  sum_wide_i[6][43:0]       = sum_new[6][0][43:0];
    end
    5'd14: begin
        sum_pre[4][0] = {{10{1'b1}}, sum_wide_o[4][42:0]}; sum_wide_i[6][42:0]       = sum_new[6][0][42:0];
    end
    5'd15: begin
        sum_pre[4][0] = {{11{1'b1}}, sum_wide_o[4][41:0]}; sum_wide_i[6][41:0]       = sum_new[6][0][41:0];
    end
    5'd16: begin
        sum_pre[4][0] = {{11{1'b1}}, sum_wide_o[4][41:0]}; sum_wide_i[6][41:0]       = sum_new[6][0][41:0];
    end
    5'd17: begin
        sum_pre[4][0] = {{11{1'b1}}, sum_wide_o[4][41:0]}; sum_wide_i[6][41:0]       = sum_new[6][0][41:0];
    end
    5'd18: begin
        sum_pre[4][0] = {{12{1'b1}}, sum_wide_o[4][40:0]}; sum_wide_i[6][40:0]       = sum_new[6][0][40:0];
    end
    5'd19: begin
        sum_pre[4][0] = {{13{1'b1}}, sum_wide_o[4][39:0]}; sum_wide_i[6][39:0]       = sum_new[6][0][39:0];
    end
    5'd20: begin
        sum_pre[4][0] = {{14{1'b1}}, sum_wide_o[4][38:0]}; sum_wide_i[6][38:0]       = sum_new[6][0][38:0];
    end
    5'd21: begin
        sum_pre[4][0] = {{14{1'b1}}, sum_wide_o[4][38:0]}; sum_wide_i[6][38:0]       = sum_new[6][0][38:0];
    end
    5'd22: begin
        sum_pre[4][0] = {{21{1'b1}}, sum_wide_o[4][31:0]}; sum_wide_i[6][31:0]       = sum_new[6][0][31:0];
        sum_pre[4][1] = {{21{1'b1}}, sum_wide_o[4][63:32]}; sum_wide_i[6][63:32]      = sum_new[6][1][31:0];
    end
    5'd23: begin
        sum_pre[4][0] = {{21{1'b1}}, sum_wide_o[4][31:0]}; sum_wide_i[6][31:0]       = sum_new[6][0][31:0];
        sum_pre[4][1] = {{21{1'b1}}, sum_wide_o[4][63:32]}; sum_wide_i[6][63:32]      = sum_new[6][1][31:0];
    end
    5'd24: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd25: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd26: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd27: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd28: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd29: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    default: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
  endcase
end

reg   [39:0] pm_tick_hold;
reg   [1:0][39:0] pm_tick_hold_sync;
reg   [1:1] pm_tick_done;
reg   [6:2] pm_tick;
logic [4:0] rd_addr;
reg   [1:1][5:0] rd_idx;
reg   [1:1] rd_h, rd_en;
logic  [2:2][10:0] rd_global_addr_for_update;
logic  [10:0] rd_global_addr_for_usr;
wire  [63:0] sum_wide_usr;

reg [1:0][39:0] pm_tick_reg;
wire [39:0] pm_tick_pulse;
reg [39:0][45:0] pm_tick_cnt, pm_tick_cnt_hold;

always @* begin
  case (rd_id[2])
    6'd0    : rd_global_addr_for_update[2] = 0 + addr[2];
    6'd1    : rd_global_addr_for_update[2] = 31 + addr[2];
    6'd2    : rd_global_addr_for_update[2] = 62 + addr[2];
    6'd3    : rd_global_addr_for_update[2] = 93 + addr[2];
    6'd4    : rd_global_addr_for_update[2] = 124 + addr[2];
    6'd5    : rd_global_addr_for_update[2] = 155 + addr[2];
    6'd6    : rd_global_addr_for_update[2] = 186 + addr[2];
    6'd7    : rd_global_addr_for_update[2] = 217 + addr[2];
    6'd8    : rd_global_addr_for_update[2] = 248 + addr[2];
    6'd9    : rd_global_addr_for_update[2] = 279 + addr[2];
    6'd10   : rd_global_addr_for_update[2] = 310 + addr[2];
    6'd11   : rd_global_addr_for_update[2] = 341 + addr[2];
    6'd12   : rd_global_addr_for_update[2] = 372 + addr[2];
    6'd13   : rd_global_addr_for_update[2] = 403 + addr[2];
    6'd14   : rd_global_addr_for_update[2] = 434 + addr[2];
    6'd15   : rd_global_addr_for_update[2] = 465 + addr[2];
    6'd16   : rd_global_addr_for_update[2] = 496 + addr[2];
    6'd17   : rd_global_addr_for_update[2] = 527 + addr[2];
    6'd18   : rd_global_addr_for_update[2] = 558 + addr[2];
    6'd19   : rd_global_addr_for_update[2] = 589 + addr[2];
    6'd20   : rd_global_addr_for_update[2] = 620 + addr[2];
    6'd21   : rd_global_addr_for_update[2] = 651 + addr[2];
    6'd22   : rd_global_addr_for_update[2] = 682 + addr[2];
    6'd23   : rd_global_addr_for_update[2] = 713 + addr[2];
    6'd24   : rd_global_addr_for_update[2] = 744 + addr[2];
    6'd25   : rd_global_addr_for_update[2] = 775 + addr[2];
    6'd26   : rd_global_addr_for_update[2] = 806 + addr[2];
    6'd27   : rd_global_addr_for_update[2] = 837 + addr[2];
    6'd28   : rd_global_addr_for_update[2] = 868 + addr[2];
    6'd29   : rd_global_addr_for_update[2] = 899 + addr[2];
    6'd30   : rd_global_addr_for_update[2] = 930 + addr[2];
    6'd31   : rd_global_addr_for_update[2] = 961 + addr[2];
    6'd32   : rd_global_addr_for_update[2] = 992 + addr[2];
    6'd33   : rd_global_addr_for_update[2] = 1023 + addr[2];
    6'd34   : rd_global_addr_for_update[2] = 1054 + addr[2];
    6'd35   : rd_global_addr_for_update[2] = 1085 + addr[2];
    6'd36   : rd_global_addr_for_update[2] = 1116 + addr[2];
    6'd37   : rd_global_addr_for_update[2] = 1147 + addr[2];
    6'd38   : rd_global_addr_for_update[2] = 1178 + addr[2];
    default : rd_global_addr_for_update[2] = 1209 + addr[2];
  endcase

  case (i_rd_id)
    6'd0    : rd_global_addr_for_usr = 0 + rd_addr;
    6'd1    : rd_global_addr_for_usr = 31 + rd_addr;
    6'd2    : rd_global_addr_for_usr = 62 + rd_addr;
    6'd3    : rd_global_addr_for_usr = 93 + rd_addr;
    6'd4    : rd_global_addr_for_usr = 124 + rd_addr;
    6'd5    : rd_global_addr_for_usr = 155 + rd_addr;
    6'd6    : rd_global_addr_for_usr = 186 + rd_addr;
    6'd7    : rd_global_addr_for_usr = 217 + rd_addr;
    6'd8    : rd_global_addr_for_usr = 248 + rd_addr;
    6'd9    : rd_global_addr_for_usr = 279 + rd_addr;
    6'd10   : rd_global_addr_for_usr = 310 + rd_addr;
    6'd11   : rd_global_addr_for_usr = 341 + rd_addr;
    6'd12   : rd_global_addr_for_usr = 372 + rd_addr;
    6'd13   : rd_global_addr_for_usr = 403 + rd_addr;
    6'd14   : rd_global_addr_for_usr = 434 + rd_addr;
    6'd15   : rd_global_addr_for_usr = 465 + rd_addr;
    6'd16   : rd_global_addr_for_usr = 496 + rd_addr;
    6'd17   : rd_global_addr_for_usr = 527 + rd_addr;
    6'd18   : rd_global_addr_for_usr = 558 + rd_addr;
    6'd19   : rd_global_addr_for_usr = 589 + rd_addr;
    6'd20   : rd_global_addr_for_usr = 620 + rd_addr;
    6'd21   : rd_global_addr_for_usr = 651 + rd_addr;
    6'd22   : rd_global_addr_for_usr = 682 + rd_addr;
    6'd23   : rd_global_addr_for_usr = 713 + rd_addr;
    6'd24   : rd_global_addr_for_usr = 744 + rd_addr;
    6'd25   : rd_global_addr_for_usr = 775 + rd_addr;
    6'd26   : rd_global_addr_for_usr = 806 + rd_addr;
    6'd27   : rd_global_addr_for_usr = 837 + rd_addr;
    6'd28   : rd_global_addr_for_usr = 868 + rd_addr;
    6'd29   : rd_global_addr_for_usr = 899 + rd_addr;
    6'd30   : rd_global_addr_for_usr = 930 + rd_addr;
    6'd31   : rd_global_addr_for_usr = 961 + rd_addr;
    6'd32   : rd_global_addr_for_usr = 992 + rd_addr;
    6'd33   : rd_global_addr_for_usr = 1023 + rd_addr;
    6'd34   : rd_global_addr_for_usr = 1054 + rd_addr;
    6'd35   : rd_global_addr_for_usr = 1085 + rd_addr;
    6'd36   : rd_global_addr_for_usr = 1116 + rd_addr;
    6'd37   : rd_global_addr_for_usr = 1147 + rd_addr;
    6'd38   : rd_global_addr_for_usr = 1178 + rd_addr;
    default : rd_global_addr_for_usr = 1209 + rd_addr;
  endcase
end

assign pm_tick_pulse[0] = pm_tick_reg[0][0] & !pm_tick_reg[1][0];
assign pm_tick_pulse[1] = pm_tick_reg[0][1] & !pm_tick_reg[1][1];
assign pm_tick_pulse[2] = pm_tick_reg[0][2] & !pm_tick_reg[1][2];
assign pm_tick_pulse[3] = pm_tick_reg[0][3] & !pm_tick_reg[1][3];
assign pm_tick_pulse[4] = pm_tick_reg[0][4] & !pm_tick_reg[1][4];
assign pm_tick_pulse[5] = pm_tick_reg[0][5] & !pm_tick_reg[1][5];
assign pm_tick_pulse[6] = pm_tick_reg[0][6] & !pm_tick_reg[1][6];
assign pm_tick_pulse[7] = pm_tick_reg[0][7] & !pm_tick_reg[1][7];
assign pm_tick_pulse[8] = pm_tick_reg[0][8] & !pm_tick_reg[1][8];
assign pm_tick_pulse[9] = pm_tick_reg[0][9] & !pm_tick_reg[1][9];
assign pm_tick_pulse[10] = pm_tick_reg[0][10] & !pm_tick_reg[1][10];
assign pm_tick_pulse[11] = pm_tick_reg[0][11] & !pm_tick_reg[1][11];
assign pm_tick_pulse[12] = pm_tick_reg[0][12] & !pm_tick_reg[1][12];
assign pm_tick_pulse[13] = pm_tick_reg[0][13] & !pm_tick_reg[1][13];
assign pm_tick_pulse[14] = pm_tick_reg[0][14] & !pm_tick_reg[1][14];
assign pm_tick_pulse[15] = pm_tick_reg[0][15] & !pm_tick_reg[1][15];
assign pm_tick_pulse[16] = pm_tick_reg[0][16] & !pm_tick_reg[1][16];
assign pm_tick_pulse[17] = pm_tick_reg[0][17] & !pm_tick_reg[1][17];
assign pm_tick_pulse[18] = pm_tick_reg[0][18] & !pm_tick_reg[1][18];
assign pm_tick_pulse[19] = pm_tick_reg[0][19] & !pm_tick_reg[1][19];
assign pm_tick_pulse[20] = pm_tick_reg[0][20] & !pm_tick_reg[1][20];
assign pm_tick_pulse[21] = pm_tick_reg[0][21] & !pm_tick_reg[1][21];
assign pm_tick_pulse[22] = pm_tick_reg[0][22] & !pm_tick_reg[1][22];
assign pm_tick_pulse[23] = pm_tick_reg[0][23] & !pm_tick_reg[1][23];
assign pm_tick_pulse[24] = pm_tick_reg[0][24] & !pm_tick_reg[1][24];
assign pm_tick_pulse[25] = pm_tick_reg[0][25] & !pm_tick_reg[1][25];
assign pm_tick_pulse[26] = pm_tick_reg[0][26] & !pm_tick_reg[1][26];
assign pm_tick_pulse[27] = pm_tick_reg[0][27] & !pm_tick_reg[1][27];
assign pm_tick_pulse[28] = pm_tick_reg[0][28] & !pm_tick_reg[1][28];
assign pm_tick_pulse[29] = pm_tick_reg[0][29] & !pm_tick_reg[1][29];
assign pm_tick_pulse[30] = pm_tick_reg[0][30] & !pm_tick_reg[1][30];
assign pm_tick_pulse[31] = pm_tick_reg[0][31] & !pm_tick_reg[1][31];
assign pm_tick_pulse[32] = pm_tick_reg[0][32] & !pm_tick_reg[1][32];
assign pm_tick_pulse[33] = pm_tick_reg[0][33] & !pm_tick_reg[1][33];
assign pm_tick_pulse[34] = pm_tick_reg[0][34] & !pm_tick_reg[1][34];
assign pm_tick_pulse[35] = pm_tick_reg[0][35] & !pm_tick_reg[1][35];
assign pm_tick_pulse[36] = pm_tick_reg[0][36] & !pm_tick_reg[1][36];
assign pm_tick_pulse[37] = pm_tick_reg[0][37] & !pm_tick_reg[1][37];
assign pm_tick_pulse[38] = pm_tick_reg[0][38] & !pm_tick_reg[1][38];
assign pm_tick_pulse[39] = pm_tick_reg[0][39] & !pm_tick_reg[1][39];

always @* begin
  case (i_rd_index)
    6'd0    : rd_addr = 5'd0;
    6'd1    : rd_addr = 5'd1;
    6'd2    : rd_addr = 5'd2;
    6'd3    : rd_addr = 5'd3;
    6'd4    : rd_addr = 5'd4;
    6'd5    : rd_addr = 5'd5;
    6'd6    : rd_addr = 5'd6;
    6'd7    : rd_addr = 5'd7;
    6'd8    : rd_addr = 5'd8;
    6'd9    : rd_addr = 5'd9;
    6'd10   : rd_addr = 5'd10;
    6'd11   : rd_addr = 5'd11;
    6'd12   : rd_addr = 5'd12;
    6'd13   : rd_addr = 5'd13;
    6'd14   : rd_addr = 5'd14;
    6'd15   : rd_addr = 5'd15;
    6'd16   : rd_addr = 5'd16;
    6'd17   : rd_addr = 5'd17;
    6'd18   : rd_addr = 5'd18;
    6'd19   : rd_addr = 5'd19;
    6'd20   : rd_addr = 5'd20;
    6'd21   : rd_addr = 5'd21;
    6'd22   : rd_addr = 5'd22;
    6'd23   : rd_addr = 5'd22;
    6'd24   : rd_addr = 5'd23;
    6'd25   : rd_addr = 5'd23;
    6'd26   : rd_addr = 5'd24;
    6'd27   : rd_addr = 5'd25;
    6'd28   : rd_addr = 5'd26;
    6'd29   : rd_addr = 5'd27;
    6'd30   : rd_addr = 5'd28;
    6'd31   : rd_addr = 5'd29;
    6'd32   : rd_addr = 5'd30;
    default : rd_addr = 5'd0;
  endcase
end

  always @( posedge clk or posedge rst )
    begin
      if ( rst == 1'b1 ) begin
        pm_tick <= '0;
        pm_tick_hold <= '0;
        pm_tick_cnt <= '0;
        pm_tick_cnt_hold <= '0;
      end
      else begin

        if (addr[1] == 0) begin
          pm_tick[2] <= pm_tick_hold[rd_id[1]];
        end
        else if (addr[1] == 30 & pm_tick[2]) begin
          pm_tick_hold[rd_id[1]] <= 1'b0;
        end

        // overwrite pm_tick_hold
        for (int i=0; i<40; i++) begin
          if (!(&pm_tick_cnt[i])) pm_tick_cnt[i] <= pm_tick_cnt[i] + 1'b1;

          if (pm_tick_pulse[i]) begin
            pm_tick_hold[i] <= 1'b1;
            pm_tick_cnt_hold[i] <= pm_tick_cnt[i];
            pm_tick_cnt[i] <= 1;
          end
        end

        // per channel reset
        if (ts_rst) pm_tick_hold[ts_rst_id] <= 1'b1;

        pm_tick[6:3] <= pm_tick[6-1:2];
      end
    end


always @(posedge clk) begin
  pm_tick_reg[0] <= i_pm_tick;
  pm_tick_reg[1] <= pm_tick_reg[0];
end




always @(posedge rd_clk) begin
  rd_idx[1] <= i_rd_index;
  rd_h[1] <= i_rd_h;
  pm_tick_hold_sync[0] <= pm_tick_hold;
  pm_tick_hold_sync[1] <= pm_tick_hold_sync[0];
  pm_tick_done[1] <= ~pm_tick_hold_sync[1][i_rd_id];

  o_cnt <= rd_h[1]? sum_wide_usr[63:32] : sum_wide_usr[31:0];
  o_cnt_vld <= rd_en[1] & pm_tick_done[1];

  if (i_rd_en) begin
    rd_en[1] <= 1'b1;
  end
  else if (pm_tick_done[1]) begin
    rd_en[1] <= 1'b0;
  end

end


wire [1:0] rd_cnt_mem_en;
assign rd_cnt_mem_en[0] = 1'b1;
assign rd_cnt_mem_en[1] = i_rd_en;

rx_stats_cnt_mem_external stats_cnt_mem (
  .clk                   (clk),
  .rst                   (rst),
  .ts_rst                (1'b0),
  .i_rd_addr_for_update  (rd_global_addr_for_update[2]),
  .i_pm_tick             (pm_tick[4]),
  .i_dat                 (sum_wide_i[6]),
  .o_dat_for_update      (sum_wide_o[4]),
  .i_rd_addr_for_usr     (rd_global_addr_for_usr),
  .o_init                (o_init),
  .usr_rd_clk            (rd_clk),
  .i_rd_en               (rd_cnt_mem_en),
  .o_dat_for_usr         (sum_wide_usr)
);

genvar z;
generate
  for(z=0; z<2; z++) begin : GEN_COUNTERS
    ts_adder_external #(
      .ADD_WIDTH      (18),
      .SUM_WIDTH      (53)
    ) ts_adder        (
      .clk            (clk),
      .i_clear_p1     (pm_tick[4]),
      .i_add_num      (add_in[3][z]),
      .i_sum_old_p1   (sum_pre[4][z]),
      .o_sum          (sum_new[6][z])
    );
  end
endgenerate

wire add_id_valid = i_stats_id_valid & i_stats_id < 6;


stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (8),
  .SUM_WIDTH         (18)
) stat_rx_total_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_total_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_total_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (8),
  .SUM_WIDTH         (18)
) stat_rx_total_good_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_total_good_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_total_good_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (4),
  .SUM_WIDTH         (13)
) stat_rx_total_packets_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_total_packets),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_total_packets_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_rx_total_good_packets_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_total_good_packets),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_total_good_packets_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (4),
  .SUM_WIDTH         (13)
) stat_rx_packet_small_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_small),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_small_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (5),
  .SUM_WIDTH         (14)
) stat_rx_bad_code_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_bad_code),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_bad_code_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (3),
  .SUM_WIDTH         (11)
) stat_rx_bad_fcs_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_bad_fcs),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_bad_fcs_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (3),
  .SUM_WIDTH         (11)
) stat_rx_packet_bad_fcs_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_bad_fcs),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_bad_fcs_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (3),
  .SUM_WIDTH         (13)
) stat_rx_stomped_fcs_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_stomped_fcs),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_stomped_fcs_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_truncated_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_truncated),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_truncated_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_rx_packet_64_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_64_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_64_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_rx_packet_65_127_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_65_127_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_65_127_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_rx_packet_128_255_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_128_255_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_128_255_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_packet_256_511_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_256_511_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_256_511_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_packet_512_1023_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_512_1023_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_512_1023_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_packet_1024_1518_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_1024_1518_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_1024_1518_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_packet_1519_1522_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_1519_1522_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_1519_1522_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_packet_1523_1548_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_1523_1548_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_1523_1548_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_packet_1549_2047_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_1549_2047_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_1549_2047_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_packet_2048_4095_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_2048_4095_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_2048_4095_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_packet_4096_8191_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_4096_8191_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_4096_8191_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_packet_8192_9215_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_8192_9215_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_8192_9215_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_toolong_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_toolong),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_toolong_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_packet_large_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_packet_large),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_packet_large_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_jabber_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_jabber),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_jabber_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_rx_oversize_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_oversize),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_oversize_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_rx_unicast_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_unicast),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_unicast_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_rx_multicast_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_multicast),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_multicast_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_rx_broadcast_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_broadcast),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_broadcast_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_rx_vlan_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_vlan),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_vlan_sum_narrow[1])
);
wire rd_en_stat_rx_pause = rd_narrow_cnt_en[0] & rd_id[0] < 6;

assign stat_rx_pause_sum_narrow[1] = (rd_id[1] < 6)? stat_rx_pause_sum_narrow_tmp[1] : '0;

stats_cnt_narrow_external #(
  .NUM_ID            (6),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_rx_pause_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (add_id_valid),
  .i_add_id          (i_stats_id[2:0]),
  .i_add_num         (i_stat_rx_pause),
  .i_rd_en           (rd_en_stat_rx_pause),
  .i_rd_id           (rd_id[0][2:0]),
  .o_rd_data         (stat_rx_pause_sum_narrow_tmp[1])
);
wire rd_en_stat_rx_user_pause = rd_narrow_cnt_en[0] & rd_id[0] < 6;

assign stat_rx_user_pause_sum_narrow[1] = (rd_id[1] < 6)? stat_rx_user_pause_sum_narrow_tmp[1] : '0;

stats_cnt_narrow_external #(
  .NUM_ID            (6),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_rx_user_pause_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (add_id_valid),
  .i_add_id          (i_stats_id[2:0]),
  .i_add_num         (i_stat_rx_user_pause),
  .i_rd_en           (rd_en_stat_rx_user_pause),
  .i_rd_id           (rd_id[0][2:0]),
  .o_rd_data         (stat_rx_user_pause_sum_narrow_tmp[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_rx_inrangeerr_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_rx_inrangeerr),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_rx_inrangeerr_sum_narrow[1])
);

endmodule
module rx_stats_cnt_mem_external (
  clk,
  rst,
  ts_rst,
  i_pm_tick,
  i_rd_addr_for_update,
  i_dat,
  o_dat_for_update,
  o_init,
  usr_rd_clk,
  i_rd_addr_for_usr,
  i_rd_en,
  o_dat_for_usr
);

input  clk;
input  rst;
input  ts_rst;
input  i_pm_tick;
input  [10:0] i_rd_addr_for_update;
input  [63:0] i_dat;
input  usr_rd_clk;
input  [10:0] i_rd_addr_for_usr;
input  [1:0] i_rd_en;
output [63:0] o_dat_for_update;
output [63:0] o_dat_for_usr;
output  o_init;

logic  init_global;
logic [2:0] init_ts;
wire  [1:0][63:0] mem_din;
logic [1:0] wr_en;
wire  [1:0] rd_en;
reg   [1:0][10:0] wr_addr_ram;
logic [2+1:0][10:0] rd_addr_p;
logic [1:0][63:0] mem_dout_tmp, mem_dout;
reg   [63:0] dat_p1;

assign init_ts[0] = init_global | ts_rst;
assign mem_din[0] = init_ts[2]? {64{1'b0}} : i_dat;
assign mem_din[1] = o_dat_for_update;
assign wr_en[0] = 1'b1;
assign wr_en[1] = init_ts[2] | i_pm_tick;

assign rd_addr_p[0] = i_rd_addr_for_update;
assign o_dat_for_update = init_ts[2]? {64{1'b0}} : mem_dout[0];
assign o_dat_for_usr = mem_dout[1];
assign o_init = init_global;


reg [10:0] init_addr;


  always @( posedge clk or posedge rst )
    begin
      if ( rst == 1'b1 ) begin
        init_global <= 1'b1;
        init_addr <= '0;
        wr_addr_ram[0] <= '0;
      end
      else if(init_global) begin
        init_global <= init_addr < 1240 - 1;
        init_addr <= init_addr + 1'b1;
        wr_addr_ram[0] <= wr_addr_ram[0] + 1'b1;
      end
      else begin
        wr_addr_ram[0] <= rd_addr_p[2+1];
        wr_addr_ram[1] <= rd_addr_p[1];
      end
    end


always @(posedge clk) begin
  init_ts[2:1] <= init_ts[1:0];
  dat_p1 <= i_dat;
  rd_addr_p[2+1:1] <= rd_addr_p[2:0];
end

(* ram_style = "block" *) reg [64-1:0] mem_0 [1240-1:0];
(* ram_style = "block" *) reg [64-1:0] mem_1 [1240-1:0];

always @(posedge clk) begin
  if (wr_en[0])  mem_0[wr_addr_ram[0]] <= mem_din[0];
  if (wr_en[1])  mem_1[wr_addr_ram[1]] <= mem_din[1];
  mem_dout_tmp[0] <= mem_0[i_rd_addr_for_update];
  mem_dout[0] <= mem_dout_tmp[0]; // two stages RAM dout for timing
end

always @(posedge usr_rd_clk) begin
  mem_dout[1] <= mem_1[i_rd_addr_for_usr];
end


endmodule
module tsmac_tx_stats_cnt_external (
  clk,
  rst,
  ts_rst,
  ts_rst_id,
  i_stats_id_valid,
  i_stats_id,
  i_stat_tx_total_bytes,
  i_stat_tx_total_good_bytes,
  i_stat_tx_total_packets,
  i_stat_tx_total_good_packets,
  i_stat_tx_frame_error,
  i_stat_tx_bad_fcs,
  i_stat_tx_packet_64_bytes,
  i_stat_tx_packet_65_127_bytes,
  i_stat_tx_packet_128_255_bytes,
  i_stat_tx_packet_256_511_bytes,
  i_stat_tx_packet_512_1023_bytes,
  i_stat_tx_packet_1024_1518_bytes,
  i_stat_tx_packet_1519_1522_bytes,
  i_stat_tx_packet_1523_1548_bytes,
  i_stat_tx_packet_1549_2047_bytes,
  i_stat_tx_packet_2048_4095_bytes,
  i_stat_tx_packet_4096_8191_bytes,
  i_stat_tx_packet_8192_9215_bytes,
  i_stat_tx_packet_large,
  i_stat_tx_unicast,
  i_stat_tx_multicast,
  i_stat_tx_broadcast,
  i_stat_tx_vlan,
  i_stat_tx_pause,
  i_stat_tx_user_pause,
  i_stat_tx_ecc_err0,
  i_stat_tx_ecc_err1,
  i_ecc_tick,
  rd_clk,
  i_pm_tick,
  i_rd_id,
  i_rd_index,
  i_rd_h,       // 1 : read the upper 32 bits; 0 : read the lower 32 bits
  i_rd_en,      // read enable
  o_init,       // indicate that the memory is being intialized
  o_cnt,
  o_cnt_vld     // o_cnt is valid
);


input              clk;
input              rst;
input              ts_rst;
input [5:0]        ts_rst_id;
input              i_stats_id_valid;
input [5:0]        i_stats_id;
input [7:0]        i_stat_tx_total_bytes;
input [7:0]        i_stat_tx_total_good_bytes;
input [3:0]        i_stat_tx_total_packets;
input [1:0]        i_stat_tx_total_good_packets;
input [1:0]        i_stat_tx_frame_error;
input [1:0]        i_stat_tx_bad_fcs;
input [1:0]        i_stat_tx_packet_64_bytes;
input [1:0]        i_stat_tx_packet_65_127_bytes;
input [1:0]        i_stat_tx_packet_128_255_bytes;
input              i_stat_tx_packet_256_511_bytes;
input              i_stat_tx_packet_512_1023_bytes;
input              i_stat_tx_packet_1024_1518_bytes;
input              i_stat_tx_packet_1519_1522_bytes;
input              i_stat_tx_packet_1523_1548_bytes;
input              i_stat_tx_packet_1549_2047_bytes;
input              i_stat_tx_packet_2048_4095_bytes;
input              i_stat_tx_packet_4096_8191_bytes;
input              i_stat_tx_packet_8192_9215_bytes;
input              i_stat_tx_packet_large;
input [1:0]        i_stat_tx_unicast;
input [1:0]        i_stat_tx_multicast;
input [1:0]        i_stat_tx_broadcast;
input [1:0]        i_stat_tx_vlan;
input [1:0]        i_stat_tx_pause;
input [1:0]        i_stat_tx_user_pause;
input              i_ecc_tick;
input [1:0]        i_stat_tx_ecc_err0;
input [1:0]        i_stat_tx_ecc_err1;
input              rd_clk;
input [39:0]       i_pm_tick;
input [5:0]        i_rd_id;
input [4:0]        i_rd_index;
input              i_rd_h;
input              i_rd_en;
output             o_init;
output reg [31:0]  o_cnt;
output reg         o_cnt_vld;


wire  [1:1][16:0] stat_tx_total_bytes_sum_narrow;
wire  [1:1][16:0] stat_tx_total_good_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_total_packets_sum_narrow;
wire  [1:1][10:0] stat_tx_total_good_packets_sum_narrow;
wire  [1:1][10:0] stat_tx_frame_error_sum_narrow;
wire  [1:1][10:0] stat_tx_bad_fcs_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_64_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_65_127_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_128_255_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_256_511_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_512_1023_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_1024_1518_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_1519_1522_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_1523_1548_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_1549_2047_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_2048_4095_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_4096_8191_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_8192_9215_bytes_sum_narrow;
wire  [1:1][10:0] stat_tx_packet_large_sum_narrow;
wire  [1:1][10:0] stat_tx_unicast_sum_narrow;
wire  [1:1][10:0] stat_tx_multicast_sum_narrow;
wire  [1:1][10:0] stat_tx_broadcast_sum_narrow;
wire  [1:1][10:0] stat_tx_vlan_sum_narrow;
wire  [1:1][10:0] stat_tx_pause_sum_narrow;
wire  [1:1][10:0] stat_tx_pause_sum_narrow_tmp;
wire  [1:1][10:0] stat_tx_user_pause_sum_narrow;
wire  [1:1][10:0] stat_tx_user_pause_sum_narrow_tmp;

reg   [0:0] rd_narrow_cnt_en;
reg   [2:0][5:0] rd_id;
reg   [6:0][4:0] addr;
reg   [3:2][0:0][16:0] add_in;
logic [4:4][0:0][52:0] sum_pre;
wire  [4:4][63:0] sum_wide_o;
wire  [6:6][0:0][52:0] sum_new;
logic [6:6][63:0] sum_wide_i;


  always @( posedge clk or posedge rst )
    begin
      if ( rst == 1'b1 ) begin
        addr[0] <= 24;
        rd_id[0] <= 39;
        rd_narrow_cnt_en[0] <= 1'b0;
      end
      else begin
        addr[0] <= (addr[0] < 24)? addr[0] + 1'b1 : '0;
        if (addr[0] == 24) rd_id[0] <= (rd_id[0] < 39)? rd_id[0] + 1'b1 : '0;
        rd_narrow_cnt_en[0] <= addr[0] == 24; // a new channel load starts
      end
    end

always @(posedge clk) begin
  rd_id[2:1] <= rd_id[1:0];
  addr[6:1] <= addr[5:0];
  add_in[3] <= add_in[2];

  add_in[2] <= '0;

  case (addr[1])
    5'd0: begin
        add_in[2][0] <= {stat_tx_total_bytes_sum_narrow[1]};
    end
    5'd1: begin
        add_in[2][0] <= {stat_tx_total_good_bytes_sum_narrow[1]};
    end
    5'd2: begin
        add_in[2][0] <= {6'd0, stat_tx_total_packets_sum_narrow[1]};
    end
    5'd3: begin
        add_in[2][0] <= {6'd0, stat_tx_total_good_packets_sum_narrow[1]};
    end
    5'd4: begin
        add_in[2][0] <= {6'd0, stat_tx_frame_error_sum_narrow[1]};
    end
    5'd5: begin
        add_in[2][0] <= {6'd0, stat_tx_bad_fcs_sum_narrow[1]};
    end
    5'd6: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_64_bytes_sum_narrow[1]};
    end
    5'd7: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_65_127_bytes_sum_narrow[1]};
    end
    5'd8: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_128_255_bytes_sum_narrow[1]};
    end
    5'd9: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_256_511_bytes_sum_narrow[1]};
    end
    5'd10: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_512_1023_bytes_sum_narrow[1]};
    end
    5'd11: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_1024_1518_bytes_sum_narrow[1]};
    end
    5'd12: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_1519_1522_bytes_sum_narrow[1]};
    end
    5'd13: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_1523_1548_bytes_sum_narrow[1]};
    end
    5'd14: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_1549_2047_bytes_sum_narrow[1]};
    end
    5'd15: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_2048_4095_bytes_sum_narrow[1]};
    end
    5'd16: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_4096_8191_bytes_sum_narrow[1]};
    end
    5'd17: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_8192_9215_bytes_sum_narrow[1]};
    end
    5'd18: begin
        add_in[2][0] <= {6'd0, stat_tx_packet_large_sum_narrow[1]};
    end
    5'd19: begin
        add_in[2][0] <= {6'd0, stat_tx_unicast_sum_narrow[1]};
    end
    5'd20: begin
        add_in[2][0] <= {6'd0, stat_tx_multicast_sum_narrow[1]};
    end
    5'd21: begin
        add_in[2][0] <= {6'd0, stat_tx_broadcast_sum_narrow[1]};
    end
    5'd22: begin
        add_in[2][0] <= {6'd0, stat_tx_vlan_sum_narrow[1]};
    end
    5'd23: begin
        add_in[2][0] <= {6'd0, stat_tx_pause_sum_narrow[1]};
    end
    5'd24: begin
        add_in[2][0] <= {6'd0, stat_tx_user_pause_sum_narrow[1]};
    end
  endcase
end


always @* begin
  sum_pre[4] = '0;
  sum_wide_i[6] = '0;
  case (addr[6])
    5'd0: begin
        sum_pre[4][0] = sum_wide_o[4][52:0];               sum_wide_i[6][52:0]       = sum_new[6][0][52:0];
    end
    5'd1: begin
        sum_pre[4][0] = sum_wide_o[4][52:0];               sum_wide_i[6][52:0]       = sum_new[6][0][52:0];
    end
    5'd2: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd3: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd4: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd5: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd6: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd7: begin
        sum_pre[4][0] = {{7{1'b1}}, sum_wide_o[4][45:0]};  sum_wide_i[6][45:0]       = sum_new[6][0][45:0];
    end
    5'd8: begin
        sum_pre[4][0] = {{8{1'b1}}, sum_wide_o[4][44:0]};  sum_wide_i[6][44:0]       = sum_new[6][0][44:0];
    end
    5'd9: begin
        sum_pre[4][0] = {{9{1'b1}}, sum_wide_o[4][43:0]};  sum_wide_i[6][43:0]       = sum_new[6][0][43:0];
    end
    5'd10: begin
        sum_pre[4][0] = {{10{1'b1}}, sum_wide_o[4][42:0]}; sum_wide_i[6][42:0]       = sum_new[6][0][42:0];
    end
    5'd11: begin
        sum_pre[4][0] = {{11{1'b1}}, sum_wide_o[4][41:0]}; sum_wide_i[6][41:0]       = sum_new[6][0][41:0];
    end
    5'd12: begin
        sum_pre[4][0] = {{11{1'b1}}, sum_wide_o[4][41:0]}; sum_wide_i[6][41:0]       = sum_new[6][0][41:0];
    end
    5'd13: begin
        sum_pre[4][0] = {{11{1'b1}}, sum_wide_o[4][41:0]}; sum_wide_i[6][41:0]       = sum_new[6][0][41:0];
    end
    5'd14: begin
        sum_pre[4][0] = {{12{1'b1}}, sum_wide_o[4][40:0]}; sum_wide_i[6][40:0]       = sum_new[6][0][40:0];
    end
    5'd15: begin
        sum_pre[4][0] = {{13{1'b1}}, sum_wide_o[4][39:0]}; sum_wide_i[6][39:0]       = sum_new[6][0][39:0];
    end
    5'd16: begin
        sum_pre[4][0] = {{14{1'b1}}, sum_wide_o[4][38:0]}; sum_wide_i[6][38:0]       = sum_new[6][0][38:0];
    end
    5'd17: begin
        sum_pre[4][0] = {{14{1'b1}}, sum_wide_o[4][38:0]}; sum_wide_i[6][38:0]       = sum_new[6][0][38:0];
    end
    5'd18: begin
        sum_pre[4][0] = {{21{1'b1}}, sum_wide_o[4][31:0]}; sum_wide_i[6][31:0]       = sum_new[6][0][31:0];
    end
    5'd19: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd20: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd21: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd22: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    5'd23: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
    default: begin
        sum_pre[4][0] = {{6{1'b1}}, sum_wide_o[4][46:0]};  sum_wide_i[6][46:0]       = sum_new[6][0][46:0];
    end
  endcase
end

reg   [39:0] pm_tick_hold;
reg   [1:0][39:0] pm_tick_hold_sync;
reg   [1:1] pm_tick_done;
reg   [6:2] pm_tick;
logic [4:0] rd_addr;
reg   [1:1][4:0] rd_idx;
reg   [1:1] rd_h, rd_en;
logic  [2:2][9:0] rd_global_addr_for_update;
logic  [9:0] rd_global_addr_for_usr;
wire  [63:0] sum_wide_usr;

reg [1:0][39:0] pm_tick_reg;
wire [39:0] pm_tick_pulse;
reg [39:0][45:0] pm_tick_cnt, pm_tick_cnt_hold;
reg [15:0] ecc_err0_cnt, ecc_err1_cnt, ecc_err0_cnt_hold, ecc_err1_cnt_hold;
reg ecc_err0_overflow, ecc_err1_overflow;

always @* begin
  case (rd_id[2])
    6'd0    : rd_global_addr_for_update[2] = 0 + addr[2];
    6'd1    : rd_global_addr_for_update[2] = 25 + addr[2];
    6'd2    : rd_global_addr_for_update[2] = 50 + addr[2];
    6'd3    : rd_global_addr_for_update[2] = 75 + addr[2];
    6'd4    : rd_global_addr_for_update[2] = 100 + addr[2];
    6'd5    : rd_global_addr_for_update[2] = 125 + addr[2];
    6'd6    : rd_global_addr_for_update[2] = 150 + addr[2];
    6'd7    : rd_global_addr_for_update[2] = 175 + addr[2];
    6'd8    : rd_global_addr_for_update[2] = 200 + addr[2];
    6'd9    : rd_global_addr_for_update[2] = 225 + addr[2];
    6'd10   : rd_global_addr_for_update[2] = 250 + addr[2];
    6'd11   : rd_global_addr_for_update[2] = 275 + addr[2];
    6'd12   : rd_global_addr_for_update[2] = 300 + addr[2];
    6'd13   : rd_global_addr_for_update[2] = 325 + addr[2];
    6'd14   : rd_global_addr_for_update[2] = 350 + addr[2];
    6'd15   : rd_global_addr_for_update[2] = 375 + addr[2];
    6'd16   : rd_global_addr_for_update[2] = 400 + addr[2];
    6'd17   : rd_global_addr_for_update[2] = 425 + addr[2];
    6'd18   : rd_global_addr_for_update[2] = 450 + addr[2];
    6'd19   : rd_global_addr_for_update[2] = 475 + addr[2];
    6'd20   : rd_global_addr_for_update[2] = 500 + addr[2];
    6'd21   : rd_global_addr_for_update[2] = 525 + addr[2];
    6'd22   : rd_global_addr_for_update[2] = 550 + addr[2];
    6'd23   : rd_global_addr_for_update[2] = 575 + addr[2];
    6'd24   : rd_global_addr_for_update[2] = 600 + addr[2];
    6'd25   : rd_global_addr_for_update[2] = 625 + addr[2];
    6'd26   : rd_global_addr_for_update[2] = 650 + addr[2];
    6'd27   : rd_global_addr_for_update[2] = 675 + addr[2];
    6'd28   : rd_global_addr_for_update[2] = 700 + addr[2];
    6'd29   : rd_global_addr_for_update[2] = 725 + addr[2];
    6'd30   : rd_global_addr_for_update[2] = 750 + addr[2];
    6'd31   : rd_global_addr_for_update[2] = 775 + addr[2];
    6'd32   : rd_global_addr_for_update[2] = 800 + addr[2];
    6'd33   : rd_global_addr_for_update[2] = 825 + addr[2];
    6'd34   : rd_global_addr_for_update[2] = 850 + addr[2];
    6'd35   : rd_global_addr_for_update[2] = 875 + addr[2];
    6'd36   : rd_global_addr_for_update[2] = 900 + addr[2];
    6'd37   : rd_global_addr_for_update[2] = 925 + addr[2];
    6'd38   : rd_global_addr_for_update[2] = 950 + addr[2];
    default : rd_global_addr_for_update[2] = 975 + addr[2];
  endcase

  case (i_rd_id)
    6'd0    : rd_global_addr_for_usr = 0 + rd_addr;
    6'd1    : rd_global_addr_for_usr = 25 + rd_addr;
    6'd2    : rd_global_addr_for_usr = 50 + rd_addr;
    6'd3    : rd_global_addr_for_usr = 75 + rd_addr;
    6'd4    : rd_global_addr_for_usr = 100 + rd_addr;
    6'd5    : rd_global_addr_for_usr = 125 + rd_addr;
    6'd6    : rd_global_addr_for_usr = 150 + rd_addr;
    6'd7    : rd_global_addr_for_usr = 175 + rd_addr;
    6'd8    : rd_global_addr_for_usr = 200 + rd_addr;
    6'd9    : rd_global_addr_for_usr = 225 + rd_addr;
    6'd10   : rd_global_addr_for_usr = 250 + rd_addr;
    6'd11   : rd_global_addr_for_usr = 275 + rd_addr;
    6'd12   : rd_global_addr_for_usr = 300 + rd_addr;
    6'd13   : rd_global_addr_for_usr = 325 + rd_addr;
    6'd14   : rd_global_addr_for_usr = 350 + rd_addr;
    6'd15   : rd_global_addr_for_usr = 375 + rd_addr;
    6'd16   : rd_global_addr_for_usr = 400 + rd_addr;
    6'd17   : rd_global_addr_for_usr = 425 + rd_addr;
    6'd18   : rd_global_addr_for_usr = 450 + rd_addr;
    6'd19   : rd_global_addr_for_usr = 475 + rd_addr;
    6'd20   : rd_global_addr_for_usr = 500 + rd_addr;
    6'd21   : rd_global_addr_for_usr = 525 + rd_addr;
    6'd22   : rd_global_addr_for_usr = 550 + rd_addr;
    6'd23   : rd_global_addr_for_usr = 575 + rd_addr;
    6'd24   : rd_global_addr_for_usr = 600 + rd_addr;
    6'd25   : rd_global_addr_for_usr = 625 + rd_addr;
    6'd26   : rd_global_addr_for_usr = 650 + rd_addr;
    6'd27   : rd_global_addr_for_usr = 675 + rd_addr;
    6'd28   : rd_global_addr_for_usr = 700 + rd_addr;
    6'd29   : rd_global_addr_for_usr = 725 + rd_addr;
    6'd30   : rd_global_addr_for_usr = 750 + rd_addr;
    6'd31   : rd_global_addr_for_usr = 775 + rd_addr;
    6'd32   : rd_global_addr_for_usr = 800 + rd_addr;
    6'd33   : rd_global_addr_for_usr = 825 + rd_addr;
    6'd34   : rd_global_addr_for_usr = 850 + rd_addr;
    6'd35   : rd_global_addr_for_usr = 875 + rd_addr;
    6'd36   : rd_global_addr_for_usr = 900 + rd_addr;
    6'd37   : rd_global_addr_for_usr = 925 + rd_addr;
    6'd38   : rd_global_addr_for_usr = 950 + rd_addr;
    default : rd_global_addr_for_usr = 975 + rd_addr;
  endcase
end

assign pm_tick_pulse[0] = pm_tick_reg[0][0] & !pm_tick_reg[1][0];
assign pm_tick_pulse[1] = pm_tick_reg[0][1] & !pm_tick_reg[1][1];
assign pm_tick_pulse[2] = pm_tick_reg[0][2] & !pm_tick_reg[1][2];
assign pm_tick_pulse[3] = pm_tick_reg[0][3] & !pm_tick_reg[1][3];
assign pm_tick_pulse[4] = pm_tick_reg[0][4] & !pm_tick_reg[1][4];
assign pm_tick_pulse[5] = pm_tick_reg[0][5] & !pm_tick_reg[1][5];
assign pm_tick_pulse[6] = pm_tick_reg[0][6] & !pm_tick_reg[1][6];
assign pm_tick_pulse[7] = pm_tick_reg[0][7] & !pm_tick_reg[1][7];
assign pm_tick_pulse[8] = pm_tick_reg[0][8] & !pm_tick_reg[1][8];
assign pm_tick_pulse[9] = pm_tick_reg[0][9] & !pm_tick_reg[1][9];
assign pm_tick_pulse[10] = pm_tick_reg[0][10] & !pm_tick_reg[1][10];
assign pm_tick_pulse[11] = pm_tick_reg[0][11] & !pm_tick_reg[1][11];
assign pm_tick_pulse[12] = pm_tick_reg[0][12] & !pm_tick_reg[1][12];
assign pm_tick_pulse[13] = pm_tick_reg[0][13] & !pm_tick_reg[1][13];
assign pm_tick_pulse[14] = pm_tick_reg[0][14] & !pm_tick_reg[1][14];
assign pm_tick_pulse[15] = pm_tick_reg[0][15] & !pm_tick_reg[1][15];
assign pm_tick_pulse[16] = pm_tick_reg[0][16] & !pm_tick_reg[1][16];
assign pm_tick_pulse[17] = pm_tick_reg[0][17] & !pm_tick_reg[1][17];
assign pm_tick_pulse[18] = pm_tick_reg[0][18] & !pm_tick_reg[1][18];
assign pm_tick_pulse[19] = pm_tick_reg[0][19] & !pm_tick_reg[1][19];
assign pm_tick_pulse[20] = pm_tick_reg[0][20] & !pm_tick_reg[1][20];
assign pm_tick_pulse[21] = pm_tick_reg[0][21] & !pm_tick_reg[1][21];
assign pm_tick_pulse[22] = pm_tick_reg[0][22] & !pm_tick_reg[1][22];
assign pm_tick_pulse[23] = pm_tick_reg[0][23] & !pm_tick_reg[1][23];
assign pm_tick_pulse[24] = pm_tick_reg[0][24] & !pm_tick_reg[1][24];
assign pm_tick_pulse[25] = pm_tick_reg[0][25] & !pm_tick_reg[1][25];
assign pm_tick_pulse[26] = pm_tick_reg[0][26] & !pm_tick_reg[1][26];
assign pm_tick_pulse[27] = pm_tick_reg[0][27] & !pm_tick_reg[1][27];
assign pm_tick_pulse[28] = pm_tick_reg[0][28] & !pm_tick_reg[1][28];
assign pm_tick_pulse[29] = pm_tick_reg[0][29] & !pm_tick_reg[1][29];
assign pm_tick_pulse[30] = pm_tick_reg[0][30] & !pm_tick_reg[1][30];
assign pm_tick_pulse[31] = pm_tick_reg[0][31] & !pm_tick_reg[1][31];
assign pm_tick_pulse[32] = pm_tick_reg[0][32] & !pm_tick_reg[1][32];
assign pm_tick_pulse[33] = pm_tick_reg[0][33] & !pm_tick_reg[1][33];
assign pm_tick_pulse[34] = pm_tick_reg[0][34] & !pm_tick_reg[1][34];
assign pm_tick_pulse[35] = pm_tick_reg[0][35] & !pm_tick_reg[1][35];
assign pm_tick_pulse[36] = pm_tick_reg[0][36] & !pm_tick_reg[1][36];
assign pm_tick_pulse[37] = pm_tick_reg[0][37] & !pm_tick_reg[1][37];
assign pm_tick_pulse[38] = pm_tick_reg[0][38] & !pm_tick_reg[1][38];
assign pm_tick_pulse[39] = pm_tick_reg[0][39] & !pm_tick_reg[1][39];

always @* begin
  case (i_rd_index)
    5'd0    : rd_addr = 5'd0;
    5'd1    : rd_addr = 5'd1;
    5'd2    : rd_addr = 5'd2;
    5'd3    : rd_addr = 5'd3;
    5'd4    : rd_addr = 5'd4;
    5'd5    : rd_addr = 5'd5;
    5'd6    : rd_addr = 5'd6;
    5'd7    : rd_addr = 5'd7;
    5'd8    : rd_addr = 5'd8;
    5'd9    : rd_addr = 5'd9;
    5'd10   : rd_addr = 5'd10;
    5'd11   : rd_addr = 5'd11;
    5'd12   : rd_addr = 5'd12;
    5'd13   : rd_addr = 5'd13;
    5'd14   : rd_addr = 5'd14;
    5'd15   : rd_addr = 5'd15;
    5'd16   : rd_addr = 5'd16;
    5'd17   : rd_addr = 5'd17;
    5'd18   : rd_addr = 5'd18;
    5'd19   : rd_addr = 5'd19;
    5'd20   : rd_addr = 5'd20;
    5'd21   : rd_addr = 5'd21;
    5'd22   : rd_addr = 5'd22;
    5'd23   : rd_addr = 5'd23;
    5'd24   : rd_addr = 5'd24;
    default : rd_addr = 5'd0;
  endcase
end

  always @( posedge clk or posedge rst )
    begin
      if ( rst == 1'b1 ) begin
        pm_tick <= '0;
        pm_tick_hold <= '0;
        pm_tick_cnt <= '0;
        pm_tick_cnt_hold <= '0;
        ecc_err0_cnt <= '0;
        ecc_err1_cnt <= '0;
        ecc_err0_cnt_hold <= '0;
        ecc_err1_cnt_hold <= '0;
        ecc_err0_overflow <= '0;
        ecc_err1_overflow <= '0;
      end
      else begin
        if(i_ecc_tick) begin // ecc pm_tick
          ecc_err0_cnt <= {14'd0, i_stat_tx_ecc_err0};
          ecc_err1_cnt <= {14'd0, i_stat_tx_ecc_err1};
          ecc_err0_cnt_hold <= ecc_err0_overflow ? {16{1'b1}} : ecc_err0_cnt;
          ecc_err1_cnt_hold <= ecc_err1_overflow ? {16{1'b1}} : ecc_err1_cnt;
          ecc_err0_overflow <= '0;
          ecc_err1_overflow <= '0;
        end else begin
          {ecc_err0_overflow, ecc_err0_cnt} <= ecc_err0_overflow ? {1'b1, {16{1'b1}}} : ecc_err0_cnt + i_stat_tx_ecc_err0;
          {ecc_err1_overflow, ecc_err1_cnt} <= ecc_err1_overflow ? {1'b1, {16{1'b1}}} : ecc_err1_cnt + i_stat_tx_ecc_err1;
        end


        if (addr[1] == 0) begin
          pm_tick[2] <= pm_tick_hold[rd_id[1]];
        end
        else if (addr[1] == 24 & pm_tick[2]) begin
          pm_tick_hold[rd_id[1]] <= 1'b0;
        end

        // overwrite pm_tick_hold
        for (int i=0; i<40; i++) begin
          if (!(&pm_tick_cnt[i])) pm_tick_cnt[i] <= pm_tick_cnt[i] + 1'b1;

          if (pm_tick_pulse[i]) begin
            pm_tick_hold[i] <= 1'b1;
            pm_tick_cnt_hold[i] <= pm_tick_cnt[i];
            pm_tick_cnt[i] <= 1;
          end
        end

        // per channel reset
        if (ts_rst) pm_tick_hold[ts_rst_id] <= 1'b1;

        pm_tick[6:3] <= pm_tick[6-1:2];
      end
    end


always @(posedge clk) begin
  pm_tick_reg[0] <= i_pm_tick;
  pm_tick_reg[1] <= pm_tick_reg[0];
end




always @(posedge rd_clk) begin
  rd_idx[1] <= i_rd_index;
  rd_h[1] <= i_rd_h;
  pm_tick_hold_sync[0] <= pm_tick_hold;
  pm_tick_hold_sync[1] <= pm_tick_hold_sync[0];
  pm_tick_done[1] <= ~pm_tick_hold_sync[1][i_rd_id];

  o_cnt <= rd_h[1]? sum_wide_usr[63:32] : sum_wide_usr[31:0];
  o_cnt_vld <= rd_en[1] & pm_tick_done[1];

  if (i_rd_en) begin
    rd_en[1] <= 1'b1;
  end
  else if (pm_tick_done[1]) begin
    rd_en[1] <= 1'b0;
  end

end


wire [1:0] rd_cnt_mem_en;
assign rd_cnt_mem_en[0] = 1'b1;
assign rd_cnt_mem_en[1] = i_rd_en;

tx_stats_cnt_mem_external stats_cnt_mem (
  .clk                   (clk),
  .rst                   (rst),
  .ts_rst                (1'b0),
  .i_rd_addr_for_update  (rd_global_addr_for_update[2]),
  .i_pm_tick             (pm_tick[4]),
  .i_dat                 (sum_wide_i[6]),
  .o_dat_for_update      (sum_wide_o[4]),
  .i_rd_addr_for_usr     (rd_global_addr_for_usr),
  .o_init                (o_init),
  .usr_rd_clk            (rd_clk),
  .i_rd_en               (rd_cnt_mem_en),
  .o_dat_for_usr         (sum_wide_usr)
);

genvar z;
generate
  for(z=0; z<1; z++) begin : GEN_COUNTERS
    ts_adder_external #(
      .ADD_WIDTH      (17),
      .SUM_WIDTH      (53)
    ) ts_adder        (
      .clk            (clk),
      .i_clear_p1     (pm_tick[4]),
      .i_add_num      (add_in[3][z]),
      .i_sum_old_p1   (sum_pre[4][z]),
      .o_sum          (sum_new[6][z])
    );
  end
endgenerate

wire add_id_valid = i_stats_id_valid & i_stats_id < 6;


stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (8),
  .SUM_WIDTH         (17)
) stat_tx_total_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_total_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_total_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (8),
  .SUM_WIDTH         (17)
) stat_tx_total_good_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_total_good_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_total_good_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (4),
  .SUM_WIDTH         (11)
) stat_tx_total_packets_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_total_packets),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_total_packets_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_tx_total_good_packets_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_total_good_packets),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_total_good_packets_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_tx_frame_error_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_frame_error),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_frame_error_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_tx_bad_fcs_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_bad_fcs),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_bad_fcs_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_tx_packet_64_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_64_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_64_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_tx_packet_65_127_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_65_127_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_65_127_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_tx_packet_128_255_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_128_255_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_128_255_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_tx_packet_256_511_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_256_511_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_256_511_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_tx_packet_512_1023_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_512_1023_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_512_1023_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_tx_packet_1024_1518_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_1024_1518_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_1024_1518_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_tx_packet_1519_1522_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_1519_1522_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_1519_1522_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_tx_packet_1523_1548_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_1523_1548_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_1523_1548_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_tx_packet_1549_2047_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_1549_2047_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_1549_2047_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_tx_packet_2048_4095_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_2048_4095_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_2048_4095_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_tx_packet_4096_8191_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_4096_8191_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_4096_8191_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_tx_packet_8192_9215_bytes_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_8192_9215_bytes),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_8192_9215_bytes_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (1),
  .SUM_WIDTH         (11)
) stat_tx_packet_large_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_packet_large),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_packet_large_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_tx_unicast_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_unicast),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_unicast_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_tx_multicast_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_multicast),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_multicast_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_tx_broadcast_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_broadcast),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_broadcast_sum_narrow[1])
);

stats_cnt_narrow_external #(
  .NUM_ID            (40),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_tx_vlan_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (i_stats_id_valid),
  .i_add_id          (i_stats_id),
  .i_add_num         (i_stat_tx_vlan),
  .i_rd_en           (rd_narrow_cnt_en[0]),
  .i_rd_id           (rd_id[0]),
  .o_rd_data         (stat_tx_vlan_sum_narrow[1])
);
wire rd_en_stat_tx_pause = rd_narrow_cnt_en[0] & rd_id[0] < 6;

assign stat_tx_pause_sum_narrow[1] = (rd_id[1] < 6)? stat_tx_pause_sum_narrow_tmp[1] : '0;

stats_cnt_narrow_external #(
  .NUM_ID            (6),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_tx_pause_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (add_id_valid),
  .i_add_id          (i_stats_id[2:0]),
  .i_add_num         (i_stat_tx_pause),
  .i_rd_en           (rd_en_stat_tx_pause),
  .i_rd_id           (rd_id[0][2:0]),
  .o_rd_data         (stat_tx_pause_sum_narrow_tmp[1])
);
wire rd_en_stat_tx_user_pause = rd_narrow_cnt_en[0] & rd_id[0] < 6;

assign stat_tx_user_pause_sum_narrow[1] = (rd_id[1] < 6)? stat_tx_user_pause_sum_narrow_tmp[1] : '0;

stats_cnt_narrow_external #(
  .NUM_ID            (6),
  .ADD_WIDTH         (2),
  .SUM_WIDTH         (11)
) stat_tx_user_pause_cnt_narrow (
  .clk               (clk),
  .rst               (rst),
  .i_add_id_valid    (add_id_valid),
  .i_add_id          (i_stats_id[2:0]),
  .i_add_num         (i_stat_tx_user_pause),
  .i_rd_en           (rd_en_stat_tx_user_pause),
  .i_rd_id           (rd_id[0][2:0]),
  .o_rd_data         (stat_tx_user_pause_sum_narrow_tmp[1])
);

endmodule
module tx_stats_cnt_mem_external (
  clk,
  rst,
  ts_rst,
  i_pm_tick,
  i_rd_addr_for_update,
  i_dat,
  o_dat_for_update,
  o_init,
  usr_rd_clk,
  i_rd_addr_for_usr,
  i_rd_en,
  o_dat_for_usr
);

input  clk;
input  rst;
input  ts_rst;
input  i_pm_tick;
input  [9:0] i_rd_addr_for_update;
input  [63:0] i_dat;
input  usr_rd_clk;
input  [9:0] i_rd_addr_for_usr;
input  [1:0] i_rd_en;
output [63:0] o_dat_for_update;
output [63:0] o_dat_for_usr;
output  o_init;

logic  init_global;
logic [2:0] init_ts;
wire  [1:0][63:0] mem_din;
logic [1:0] wr_en;
wire  [1:0] rd_en;
reg   [1:0][9:0] wr_addr_ram;
logic [2+1:0][9:0] rd_addr_p;
logic [1:0][63:0] mem_dout_tmp, mem_dout;
reg   [63:0] dat_p1;

assign init_ts[0] = init_global | ts_rst;
assign mem_din[0] = init_ts[2]? {64{1'b0}} : i_dat;
assign mem_din[1] = o_dat_for_update;
assign wr_en[0] = 1'b1;
assign wr_en[1] = init_ts[2] | i_pm_tick;

assign rd_addr_p[0] = i_rd_addr_for_update;
assign o_dat_for_update = init_ts[2]? {64{1'b0}} : mem_dout[0];
assign o_dat_for_usr = mem_dout[1];
assign o_init = init_global;


reg [9:0] init_addr;


  always @( posedge clk or posedge rst )
    begin
      if ( rst == 1'b1 ) begin
        init_global <= 1'b1;
        init_addr <= '0;
        wr_addr_ram[0] <= '0;
      end
      else if(init_global) begin
        init_global <= init_addr < 1000 - 1;
        init_addr <= init_addr + 1'b1;
        wr_addr_ram[0] <= wr_addr_ram[0] + 1'b1;
      end
      else begin
        wr_addr_ram[0] <= rd_addr_p[2+1];
        wr_addr_ram[1] <= rd_addr_p[1];
      end
    end


always @(posedge clk) begin
  init_ts[2:1] <= init_ts[1:0];
  dat_p1 <= i_dat;
  rd_addr_p[2+1:1] <= rd_addr_p[2:0];
end

(* ram_style = "block" *) reg [64-1:0] mem_0 [1000-1:0];
(* ram_style = "block" *) reg [64-1:0] mem_1 [1000-1:0];

always @(posedge clk) begin
  if (wr_en[0])  mem_0[wr_addr_ram[0]] <= mem_din[0];
  if (wr_en[1])  mem_1[wr_addr_ram[1]] <= mem_din[1];
  mem_dout_tmp[0] <= mem_0[i_rd_addr_for_update];
  mem_dout[0] <= mem_dout_tmp[0]; // two stages RAM dout for timing
end

always @(posedge usr_rd_clk) begin
  mem_dout[1] <= mem_1[i_rd_addr_for_usr];
end


endmodule


module stats_cnt_narrow_external (
  clk,
  rst,
  i_add_id_valid,
  i_add_id,
  i_add_num,
  i_rd_en, // pulse when a new channel starts, scan all the narraow counters together
  i_rd_id,
  o_rd_data
);

parameter ADD_WIDTH = 1;
parameter SUM_WIDTH = 32;
parameter NUM_ID = 40;

localparam ID_W = $clog2(NUM_ID);

input                        clk;
input                        rst;
input                        i_add_id_valid;
input  [ID_W-1:0]            i_add_id;
input  [ADD_WIDTH-1:0]       i_add_num;
input                        i_rd_en;
input  [ID_W-1:0]            i_rd_id;
output logic [SUM_WIDTH-1:0] o_rd_data;

reg   add_id_valid_p1;
reg   [ID_W-1:0] add_id_p1;
reg   [ADD_WIDTH-1:0] add_num_p1;
reg   [NUM_ID-1:0] clear_hold;
reg   rd_during_wr;
reg   clear_p1;
wire  [SUM_WIDTH-1:0] sum_i;
wire  [SUM_WIDTH-1:0] sum_o;
reg   [SUM_WIDTH-1:0] mem_dout;
(* ram_style = "distributed" *) reg [SUM_WIDTH-1:0] sum_ctx [NUM_ID];

  assign sum_i = clear_p1? add_num_p1 : sum_o + add_num_p1;
  assign o_rd_data = mem_dout;

  always @(posedge clk) begin
    add_id_valid_p1 <= i_add_id_valid;
    add_id_p1 <= i_add_id;
    add_num_p1 <= i_add_id_valid? i_add_num : '0;

    if (i_add_id_valid) clear_hold[i_add_id] <= 1'b0;
    if (i_rd_en & !(i_rd_id == i_add_id & i_add_id_valid)) clear_hold[i_rd_id] <= 1'b1; // read out for the wide adder, clear the context

    clear_p1 <= i_rd_en & i_rd_id == i_add_id & i_add_id_valid | clear_hold[i_add_id];
    rd_during_wr <= i_rd_en & i_rd_id == i_add_id & i_add_id_valid;

    if (add_id_valid_p1) sum_ctx[add_id_p1] <= sum_i;
    if (i_rd_en) mem_dout <= (i_rd_id == add_id_p1)? sum_i : sum_ctx[i_rd_id];

    if (rst) clear_hold <= '0;
  end


  dcmac_0_ts_context_mem_v2  #(
    .DW (SUM_WIDTH),
    .NUM_ID (NUM_ID),
    .INIT_VALUE (0)
  ) i_dcmac_0_sum_ctx (
    .clk         (clk),
    .rst         (rst),
    .ts_rst      (1'b0), // FIXME
    .i_rd_id     (i_add_id),
    .i_ena       (add_id_valid_p1),
    .i_dat       (sum_i),
    .o_dat       (sum_o),
    .i_rd_during_wr (),
    .o_init         ()
  );


endmodule

module ts_adder_external (
  clk,
  i_clear_p1,
  i_add_num,
  i_sum_old_p1,
  o_sum
);

parameter ADD_WIDTH = 1;
parameter SUM_WIDTH = 32;

localparam ADD2_WIDTH = ADD_WIDTH + 1;

input                         clk;
input                         i_clear_p1;
input      [ADD_WIDTH-1:0]    i_add_num;
input      [SUM_WIDTH-1:0]    i_sum_old_p1;
output reg [SUM_WIDTH-1:0]    o_sum;

reg [ADD_WIDTH-1:0] add_num_p1, add_num_p2;
wire [SUM_WIDTH:0] sum_19_p1;
reg [18:0] sum_tmp_l_p2;
reg [SUM_WIDTH-1:19] sum_old_p2;
reg carry_p2;
reg clear_p2;
wire saturate_p2;
wire [SUM_WIDTH:19] sum_tmp_h_p2;

assign sum_19_p1 = add_num_p1 + i_sum_old_p1[18:0];

assign sum_tmp_h_p2 = sum_old_p2[SUM_WIDTH-1:19] + carry_p2;
assign saturate_p2 = sum_tmp_h_p2[SUM_WIDTH];

always @(posedge clk) begin
  add_num_p1 <= i_add_num;
  add_num_p2 <= add_num_p1;
  sum_tmp_l_p2[18:0] <= sum_19_p1[18:0];
  sum_old_p2[SUM_WIDTH-1:19] <= i_sum_old_p1[SUM_WIDTH-1:19];
  carry_p2 <= sum_19_p1[19];
  clear_p2 <= i_clear_p1;
  o_sum <= '0;
  o_sum[18:0] <= clear_p2? add_num_p2 : saturate_p2? '1 : sum_tmp_l_p2[18:0];
  o_sum[SUM_WIDTH-1:19] <= clear_p2? '0 : saturate_p2? '1 : sum_tmp_h_p2[SUM_WIDTH-1:19];
end

endmodule


