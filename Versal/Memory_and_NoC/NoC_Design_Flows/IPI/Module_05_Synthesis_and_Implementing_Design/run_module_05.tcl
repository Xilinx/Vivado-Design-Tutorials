# #########################################################################
#© Copyright 2020 Xilinx, Inc.

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
# ###########################################################################
set myPath [exec pwd]
create_project project_1 ${myPath}/project_1 -part xcvc1902-vsva2197-1LP-e-S
create_bd_design "design_1"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0
endgroup
startgroup
set_property -dict [list CONFIG.NUM_MI {0} CONFIG.NUM_MC {1} CONFIG.NUM_MCP {1} CONFIG.LOGO_FILE {data/noc_mc.png} CONFIG.MC_EN_INTR_RESP {TRUE}] [get_bd_cells axi_noc_0]
set_property -dict [list CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} M00_AXI { read_bw {1720} write_bw {1720}} }] [get_bd_intf_pins /axi_noc_0/S00_AXI]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S00_AXI}] [get_bd_pins /axi_noc_0/aclk0]
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_traffic_gen:3.0 axi_traffic_gen_0
endgroup
set_property -dict [list CONFIG.TRAFFIC_PROFILE {Data} CONFIG.DATA_SIZE_AVG {16} CONFIG.MASTER_AXI_WIDTH {128} CONFIG.ATG_OPTIONS {High Level Traffic} CONFIG.C_EXTENDED_ADDRESS_WIDTH_HLT {64}] [get_bd_cells axi_traffic_gen_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_gen_sim:1.0 clk_gen_sim_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips:3.0 versal_cips_0
endgroup
set_property -dict [list CONFIG.USER_NUM_OF_SYS_CLK {2} CONFIG.USER_SYS_CLK1_FREQ {200.000} CONFIG.USER_NUM_OF_AXI_CLK {0}] [get_bd_cells clk_gen_sim_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0
endgroup
set_property -dict [list CONFIG.PRIM_IN_FREQ.VALUE_SRC USER] [get_bd_cells clk_wizard_0]
set_property -dict [list CONFIG.PRIM_IN_FREQ {200.000} CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} CONFIG.USE_LOCKED {true} CONFIG.CLKFBOUT_MULT {15.000000}] [get_bd_cells clk_wizard_0]
set_property -dict [list CONFIG.PS_PMC_CONFIG { DESIGN_MODE 1  PCIE_APERTURES_DUAL_ENABLE 0  PCIE_APERTURES_SINGLE_ENABLE 0  PS_BOARD_INTERFACE Custom  PS_NUM_FABRIC_RESETS 1  PS_PCIE1_PERIPHERAL_ENABLE 0  PS_PCIE2_PERIPHERAL_ENABLE 0  SMON_ALARMS Set_Alarms_On  SMON_ENABLE_TEMP_AVERAGING 0  SMON_TEMP_AVERAGING_SAMPLES 8 } CONFIG.PS_PMC_CONFIG_APPLIED {1} CONFIG.DESIGN_MODE {1}] [get_bd_cells versal_cips_0]
connect_bd_net [get_bd_pins clk_wizard_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
connect_bd_net [get_bd_pins axi_noc_0/aclk0] [get_bd_pins clk_wizard_0/clk_out1]
connect_bd_net [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins clk_wizard_0/clk_out1]
connect_bd_net [get_bd_pins versal_cips_0/pl0_resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_traffic_gen_0/s_axi_aresetn]
connect_bd_intf_net [get_bd_intf_pins clk_gen_sim_0/SYS_CLK1] [get_bd_intf_pins clk_wizard_0/CLK_IN1_D]
connect_bd_intf_net [get_bd_intf_pins clk_gen_sim_0/SYS_CLK0] [get_bd_intf_pins axi_noc_0/sys_clk0]
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins axi_traffic_gen_0/core_ext_start]

startgroup
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins axi_noc_0/CH0_DDR4_0]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {/clk_wizard_0/clk_out1 (100 MHz)} Clk_xbar {Auto} Master {/axi_traffic_gen_0/M_AXI} Slave {/axi_noc_0/S00_AXI} ddr_seg {C0_DDR_LOW0} intc_ip {/axi_noc_0} master_apm {0}}  [get_bd_intf_pins axi_noc_0/S00_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins clk_gen_sim_0/SYS_CLK0_IN]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins clk_gen_sim_0/SYS_CLK1_IN]
endgroup
regenerate_bd_layout
validate_bd_design
make_wrapper -files [get_files ${myPath}/project_1/project_1.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse ${myPath}/project_1/project_1.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1
generate_target all [get_files  ${myPath}/project_1/project_1.srcs/sources_1/bd/design_1/design_1.bd]
catch { config_ip_cache -export [get_ips -all design_1_axi_noc_0_0] }
catch { config_ip_cache -export [get_ips -all design_1_axi_traffic_gen_0_0] }
catch { config_ip_cache -export [get_ips -all design_1_proc_sys_reset_0_0] }
catch { config_ip_cache -export [get_ips -all design_1_clk_wizard_0_0] }
export_ip_user_files -of_objects [get_files ${myPath}/project_1/project_1.srcs/sources_1/bd/design_1/design_1.bd] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] ${myPath}/project_1/project_1.srcs/sources_1/bd/design_1/design_1.bd]
launch_runs design_1_axi_noc_0_0_synth_1 design_1_axi_traffic_gen_0_0_synth_1 design_1_proc_sys_reset_0_0_synth_1 design_1_clk_wizard_0_0_synth_1 -jobs 16
export_simulation -of_objects [get_files ${myPath}/project_1/project_1.srcs/sources_1/bd/design_1/design_1.bd] -directory ${myPath}/project_1/project_1.ip_user_files/sim_scripts -ip_user_files_dir ${myPath}/project_1/project_1.ip_user_files -ipstatic_source_dir ${myPath}/project_1/project_1.ip_user_files/ipstatic -lib_map_path [list {modelsim=${myPath}/project_1/project_1.cache/compile_simlib/modelsim} {questa=${myPath}/project_1/project_1.cache/compile_simlib/questa} {ies=${myPath}/project_1/project_1.cache/compile_simlib/ies} {xcelium=${myPath}/project_1/project_1.cache/compile_simlib/xcelium} {vcs=${myPath}/project_1/project_1.cache/compile_simlib/vcs} {riviera=${myPath}/project_1/project_1.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
launch_runs synth_1 -jobs 16
wait_on_run synth_1
open_run synth_1 -name synth_1
place_ports {ddr4_rtl_0_act_n[0]} AR23 {ddr4_rtl_0_adr[0]} AT23 {ddr4_rtl_0_adr[10]} AT22 {ddr4_rtl_0_adr[11]} BA25 {ddr4_rtl_0_adr[12]} BE22 {ddr4_rtl_0_adr[13]} BB24 {ddr4_rtl_0_adr[14]} AV21 {ddr4_rtl_0_adr[15]} AW21 {ddr4_rtl_0_adr[16]} AM23 {ddr4_rtl_0_adr[1]} AY25 {ddr4_rtl_0_adr[2]} AW24 {ddr4_rtl_0_adr[3]} AP22 {ddr4_rtl_0_adr[4]} AV23 {ddr4_rtl_0_adr[5]} BA23 {ddr4_rtl_0_adr[6]} BA24 {ddr4_rtl_0_adr[7]} BD24 {ddr4_rtl_0_adr[8]} BB25 {ddr4_rtl_0_adr[9]} AM24 {ddr4_rtl_0_ba[0]} AP21 {ddr4_rtl_0_ba[1]} AW23 {ddr4_rtl_0_bg[0]} AR21 {ddr4_rtl_0_bg[1]} BB23 {ddr4_rtl_0_ck_c[0]} AY23 {ddr4_rtl_0_ck_t[0]} AY22 {ddr4_rtl_0_cke[0]} AP24 {ddr4_rtl_0_cs_n[0]} AV22 {ddr4_rtl_0_dm_n[0]} BD23 {ddr4_rtl_0_dm_n[1]} BF23 {ddr4_rtl_0_dm_n[2]} AP19 {ddr4_rtl_0_dm_n[3]} BE19 {ddr4_rtl_0_dm_n[4]} BE17 {ddr4_rtl_0_dm_n[5]} AT16 {ddr4_rtl_0_dm_n[6]} BE12 {ddr4_rtl_0_dm_n[7]} BB14 {ddr4_rtl_0_dq[0]} BC21 {ddr4_rtl_0_dq[10]} BF21 {ddr4_rtl_0_dq[11]} BG25 {ddr4_rtl_0_dq[12]} BE21 {ddr4_rtl_0_dq[13]} BF24 {ddr4_rtl_0_dq[14]} BE20 {ddr4_rtl_0_dq[15]} BG23 {ddr4_rtl_0_dq[16]} AM20 {ddr4_rtl_0_dq[17]} AT19 {ddr4_rtl_0_dq[18]} AN20 {ddr4_rtl_0_dq[19]} AU19 {ddr4_rtl_0_dq[1]} BE24 {ddr4_rtl_0_dq[20]} AM21 {ddr4_rtl_0_dq[21]} AR18 {ddr4_rtl_0_dq[22]} AU20 {ddr4_rtl_0_dq[23]} AN19 {ddr4_rtl_0_dq[24]} BB20 {ddr4_rtl_0_dq[25]} BA19 {ddr4_rtl_0_dq[26]} BB19 {ddr4_rtl_0_dq[27]} BA20 {ddr4_rtl_0_dq[28]} BG18 {ddr4_rtl_0_dq[29]} BG19 {ddr4_rtl_0_dq[2]} BC22 {ddr4_rtl_0_dq[30]} BF18 {ddr4_rtl_0_dq[31]} BF19 {ddr4_rtl_0_dq[32]} BB18 {ddr4_rtl_0_dq[33]} BE16 {ddr4_rtl_0_dq[34]} BF17 {ddr4_rtl_0_dq[35]} BA16 {ddr4_rtl_0_dq[36]} BC17 {ddr4_rtl_0_dq[37]} BA17 {ddr4_rtl_0_dq[38]} BG16 {ddr4_rtl_0_dq[39]} BF16 {ddr4_rtl_0_dq[3]} BE25 {ddr4_rtl_0_dq[40]} AT17 {ddr4_rtl_0_dq[41]} AU17 {ddr4_rtl_0_dq[42]} AU16 {ddr4_rtl_0_dq[43]} AV17 {ddr4_rtl_0_dq[44]} AN17 {ddr4_rtl_0_dq[45]} AM17 {ddr4_rtl_0_dq[46]} AM18 {ddr4_rtl_0_dq[47]} AL16 {ddr4_rtl_0_dq[48]} BE11 {ddr4_rtl_0_dq[49]} BE15 {ddr4_rtl_0_dq[4]} BC20 {ddr4_rtl_0_dq[50]} BF12 {ddr4_rtl_0_dq[51]} BG14 {ddr4_rtl_0_dq[52]} BG11 {ddr4_rtl_0_dq[53]} BE14 {ddr4_rtl_0_dq[54]} BF11 {ddr4_rtl_0_dq[55]} BG15 {ddr4_rtl_0_dq[56]} BD12 {ddr4_rtl_0_dq[57]} BB15 {ddr4_rtl_0_dq[58]} BC12 {ddr4_rtl_0_dq[59]} BD15 {ddr4_rtl_0_dq[5]} BD25 {ddr4_rtl_0_dq[60]} BC11 {ddr4_rtl_0_dq[61]} BD14 {ddr4_rtl_0_dq[62]} BB11 {ddr4_rtl_0_dq[63]} BC15 {ddr4_rtl_0_dq[6]} BD20 {ddr4_rtl_0_dq[7]} BC25 {ddr4_rtl_0_dq[8]} BG20 {ddr4_rtl_0_dq[9]} BG24 {ddr4_rtl_0_dqs_c[0]} BD22 {ddr4_rtl_0_dqs_c[1]} BF22 {ddr4_rtl_0_dqs_c[2]} AR20 {ddr4_rtl_0_dqs_c[3]} BD18 {ddr4_rtl_0_dqs_c[4]} BC16 {ddr4_rtl_0_dqs_c[5]} AP16 {ddr4_rtl_0_dqs_c[6]} BG13 {ddr4_rtl_0_dqs_c[7]} BD13 {ddr4_rtl_0_dqs_t[0]} BC23 {ddr4_rtl_0_dqs_t[1]} BG21 {ddr4_rtl_0_dqs_t[2]} AT20 {ddr4_rtl_0_dqs_t[3]} BC18 {ddr4_rtl_0_dqs_t[4]} BB16 {ddr4_rtl_0_dqs_t[5]} AN16 {ddr4_rtl_0_dqs_t[6]} BF14 {ddr4_rtl_0_dqs_t[7]} BC13 {ddr4_rtl_0_odt[0]} AR24 {ddr4_rtl_0_reset_n[0]} AW20 diff_clock_rtl_0_clk_n AY18 diff_clock_rtl_0_clk_p AW19
set_property IOSTANDARD LVDS15 [get_ports [list diff_clock_rtl_1_clk_p]]
file mkdir ${myPath}/project_1/project_1.srcs/constrs_1/new
close [ open ${myPath}/project_1/project_1.srcs/constrs_1/new/memory_constraints.xdc w ]
add_files -fileset constrs_1 ${myPath}/project_1/project_1.srcs/constrs_1/new/memory_constraints.xdc
set_property target_constrs_file ${myPath}/project_1/project_1.srcs/constrs_1/new/memory_constraints.xdc [current_fileset -constrset]
save_constraints -force
set_property needs_refresh false [get_runs synth_1]
launch_runs impl_1 -jobs 16
wait_on_run impl_1
after 7000
open_run impl_1
after 9000
close_design

