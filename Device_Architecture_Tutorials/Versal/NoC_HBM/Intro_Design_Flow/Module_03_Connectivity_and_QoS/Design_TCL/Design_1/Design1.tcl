# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11

set myPath [exec pwd]

create_project Design_1 ${myPath}/Design1 -part xcvh1582-vsva3697-2MP-e-S
create_bd_design "design_1"

open_bd_design {${myPath}/hbm_module_1.srcs/sources_1/bd/design_1/design_1.bd}
update_compile_order -fileset sources_1

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc axi_noc_0
endgroup

apply_bd_automation -rule xilinx.com:bd_rule:axi_noc -config { hbm_density {2} hbm_nmu {1} mc_type {HBM} noc_clk {New/Reuse Simulation Clock And Reset Generator} num_axi_bram {None} num_axi_tg {None} num_aximm_ext {None} num_mc_ddr {None} num_mc_lpddr {None} pl2noc_apm {1} pl2noc_cips {0}}  [get_bd_cells axi_noc_0]

startgroup
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {New Clocking Wizard} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_clk_gen/axi_clk_in_0]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins noc_clk_gen/SYS_CLK0_IN]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (400 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_sim_trig/pclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (400 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_tg/clk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (400 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_tg_pmon/axi_aclk]
endgroup

startgroup
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Clk {New External Port} Manual_Source {Auto}}  [get_bd_pins clk_wiz/clk_in1]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {New External Port (ACTIVE_HIGH)}}  [get_bd_pins clk_wiz/reset]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_pins rst_clk_wiz_100M/ext_reset_in]
endgroup

startgroup
set_property CONFIG.HBM_REF_CLK_SELECTION {Internal} [get_bd_cells axi_noc_0]
set_property -dict [list CONFIG.CONNECTIONS {HBM0_PORT0 {read_bw {500} write_bw {500} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/HBM00_AXI]
delete_bd_objs [get_bd_intf_nets noc_clk_gen_SYS_CLK0]
endgroup

startgroup
set_property -dict [list \
  CONFIG.USER_AXI_CLK_0_FREQ {400} \
  CONFIG.USER_NUM_OF_SYS_CLK {0} \
] [get_bd_cells noc_clk_gen]
delete_bd_objs [get_bd_intf_nets diff_clock_rtl_0_1]
endgroup

startgroup
set_property -dict [list \
  CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
  CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
  CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
  CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
  CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
  CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
  CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {400} \
  CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
  CONFIG.CLKOUT_USED {true,false,false,false,false,false,false} \
] [get_bd_cells clk_wiz]
endgroup

delete_bd_objs [get_bd_intf_ports diff_clock_rtl_0]

startgroup
set_property -dict [list \
  CONFIG.USER_C_AXI_READ_BANDWIDTH {12800} \
  CONFIG.USER_C_AXI_READ_LEN {127} \
  CONFIG.USER_C_AXI_READ_SIZE {32} \
  CONFIG.USER_C_AXI_TEST_SELECT {writes_followed_by_reads} \
  CONFIG.USER_C_AXI_WRITE_BANDWIDTH {12800} \
  CONFIG.USER_C_AXI_WRITE_LEN {127} \
  CONFIG.USER_C_AXI_WRITE_SIZE {32} \
] [get_bd_cells noc_tg]
endgroup

regenerate_bd_layout
assign_bd_address
validate_bd_design
save_bd_design
