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
pwd
create_project module_04 ${myPath}/module_04 -part xcvc1902-vsva2197-1LP-e-S
create_bd_design "design_1"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_1
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_2
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_3
endgroup
startgroup
set_property -dict [list CONFIG.NUM_MI {0} CONFIG.NUM_NMI {2}] [get_bd_cells axi_noc_0]
set_property -dict [list CONFIG.CONNECTIONS {M01_INI { read_bw {1720} write_bw {1720}} M00_AXI { read_bw {1720} write_bw {1720}} M00_INI { read_bw {1720} write_bw {1720}} }] [get_bd_intf_pins /axi_noc_0/S00_AXI]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S00_AXI}] [get_bd_pins /axi_noc_0/aclk0]
endgroup
startgroup
set_property -dict [list CONFIG.NUM_SI {0} CONFIG.NUM_MI {0} CONFIG.NUM_NSI {2} CONFIG.NUM_CLKS {0} CONFIG.NUM_MC {1} CONFIG.NUM_MCP {2} CONFIG.LOGO_FILE {data/noc_mc.png}] [get_bd_cells axi_noc_1]
set_property -dict [list CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_1/S00_INI]
set_property -dict [list CONFIG.CONNECTIONS {MC_1 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_1/S01_INI]
endgroup
startgroup
set_property -dict [list CONFIG.NUM_MI {0} CONFIG.NUM_NMI {2}] [get_bd_cells axi_noc_2]
set_property -dict [list CONFIG.CONNECTIONS {M01_INI { read_bw {1720} write_bw {1720}} M00_AXI { read_bw {1720} write_bw {1720}} M00_INI { read_bw {1720} write_bw {1720}} }] [get_bd_intf_pins /axi_noc_2/S00_AXI]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {S00_AXI}] [get_bd_pins /axi_noc_2/aclk0]
endgroup
startgroup
set_property -dict [list CONFIG.NUM_SI {0} CONFIG.NUM_MI {0} CONFIG.NUM_NSI {2} CONFIG.NUM_CLKS {0} CONFIG.NUM_MC {1} CONFIG.NUM_MCP {2} CONFIG.LOGO_FILE {data/noc_mc.png}] [get_bd_cells axi_noc_3]
set_property -dict [list CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_3/S00_INI]
set_property -dict [list CONFIG.CONNECTIONS {MC_1 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_3/S01_INI]
endgroup
connect_bd_intf_net [get_bd_intf_pins axi_noc_0/M00_INI] [get_bd_intf_pins axi_noc_1/S00_INI]
connect_bd_intf_net [get_bd_intf_pins axi_noc_0/M01_INI] [get_bd_intf_pins axi_noc_3/S01_INI]
connect_bd_intf_net [get_bd_intf_pins axi_noc_2/M00_INI] [get_bd_intf_pins axi_noc_3/S00_INI]
connect_bd_intf_net [get_bd_intf_pins axi_noc_2/M01_INI] [get_bd_intf_pins axi_noc_1/S01_INI]
regenerate_bd_layout
update_compile_order -fileset sources_1
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi_noc -config {num_axi_tg "1" num_aximm_ext "None" pl2noc_apm "1" num_axi_bram "None" num_mc "None" noc_clk "New/Reuse Simulation Clock And Reset Generator" }  [get_bd_cells axi_noc_0]
apply_bd_automation -rule xilinx.com:bd_rule:axi_noc -config {num_axi_tg "1" num_aximm_ext "None" pl2noc_apm "1" num_axi_bram "None" num_mc "None" noc_clk "New/Reuse Simulation Clock And Reset Generator" }  [get_bd_cells axi_noc_2]
endgroup
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi_noc -config {num_axi_tg "None" num_aximm_ext "None" pl2noc_apm "0" num_axi_bram "None" num_mc "1" noc_clk "/noc_clk_gen" }  [get_bd_cells axi_noc_1]
apply_bd_automation -rule xilinx.com:bd_rule:axi_noc -config {num_axi_tg "None" num_aximm_ext "None" pl2noc_apm "0" num_axi_bram "None" num_mc "1" noc_clk "/noc_clk_gen" }  [get_bd_cells axi_noc_3]
endgroup
startgroup
set_property -dict [list CONFIG.NUM_SI {0} CONFIG.NUM_CLKS {0}] [get_bd_cells axi_noc_1]
endgroup
startgroup
set_property -dict [list CONFIG.NUM_SI {0} CONFIG.NUM_CLKS {0}] [get_bd_cells axi_noc_3]
endgroup
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins axi_noc_1/CH0_DDR4_0]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins axi_noc_3/CH0_DDR4_0]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {New Clocking Wizard} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_clk_gen/axi_clk_in_0]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins noc_clk_gen/SYS_CLK0_IN]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins noc_clk_gen/SYS_CLK1_IN]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_sim_trig/pclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_tg/clk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_tg_1/clk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_tg_pmon/axi_aclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_tg_pmon_1/axi_aclk]
endgroup
startgroup
set_property -dict [list CONFIG.USER_C_AXI_TEST_SELECT {user_defined_pattern} CONFIG.USER_USR_DEFINED_PATTERN_CSV {../../../../../../../lesson04.csv}] [get_bd_cells noc_tg]
endgroup
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Clk {New External Port} Manual_Source {Auto}}  [get_bd_pins clk_wiz/clk_in1]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {New External Port (ACTIVE_HIGH)}}  [get_bd_pins clk_wiz/reset]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_pins rst_clk_wiz_100M/ext_reset_in]
endgroup
regenerate_bd_layout
startgroup
set_property -dict [list CONFIG.MC_CHAN_REGION0 {DDR_CH1}] [get_bd_cells axi_noc_3]
endgroup
assign_bd_address
set_property SIM_ATTRIBUTE.MARK_SIM true [get_bd_intf_nets {noc_tg_M_AXI noc_tg_1_M_AXI}]
validate_bd_design
save_bd_design

make_wrapper -files [get_files ${myPath}/module_04/module_04.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse ${myPath}/module_04/module_04.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
after 5000
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
after 5000
generate_target all [get_files  ${myPath}/module_04/module_04.srcs/sources_1/bd/design_1/design_1.bd]
after 5000
export_ip_user_files -of_objects [get_files ${myPath}/module_04/module_04.srcs/sources_1/bd/design_1/design_1.bd] -no_script -sync -force -quiet
after 5000
export_simulation -of_objects [get_files ${myPath}/module_04/module_04.srcs/sources_1/bd/design_1/design_1.bd] -directory ${myPath}/module_04/module_04.ip_user_files/sim_scripts -ip_user_files_dir ${myPath}/module_04/module_04.ip_user_files -ipstatic_source_dir ${myPath}/module_04/module_04.ip_user_files/ipstatic -lib_map_path [list {modelsim=${myPath}/module_04/module_04.cache/compile_simlib/modelsim} {questa=${myPath}/module_04/module_04.cache/compile_simlib/questa} {ies=${myPath}/module_04/module_04.cache/compile_simlib/ies} {xcelium=${myPath}/module_04/module_04.cache/compile_simlib/xcelium} {vcs=${myPath}/module_04/module_04.cache/compile_simlib/vcs} {riviera=${myPath}/module_04/module_04.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
launch_simulation
run all
