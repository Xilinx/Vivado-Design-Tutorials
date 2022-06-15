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
create_project module_1 ${myPath}/module_1 -part xcvc1902-vsva2197-1LP-e-S
create_bd_design "design_1"
open_bd_design {${myPath}/module_1/module_1.srcs/sources_1/bd/design_1/design_1.bd}
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi_noc -config {num_axi_tg "1" num_aximm_ext "None" pl2noc_apm "0" num_axi_bram "1" num_mc "None" noc_clk "New/Reuse Simulation Clock And Reset Generator" }  [get_bd_cells axi_noc_0]
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_bc/s_axi_aclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {New Clocking Wizard} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_clk_gen/axi_clk_in_0]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_sim_trig/pclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_tg/clk]
endgroup
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Clk {New External Port} Manual_Source {Auto}}  [get_bd_pins clk_wiz/clk_in1]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {New External Port (ACTIVE_HIGH)}}  [get_bd_pins clk_wiz/reset]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_pins rst_clk_wiz_100M/ext_reset_in]
endgroup
regenerate_bd_layout
startgroup
set_property -dict [list CONFIG.USER_C_AXI_DATA_INTEGRITY_CHECK {ON}] [get_bd_cells noc_tg]
endgroup
assign_bd_address
after 5000
validate_bd_design
after 5000
startgroup
set_property -dict [list CONFIG.USER_C_AXI_WDATA_PATTERN {RANDOM_DATA}] [get_bd_cells noc_tg]
endgroup
set_property SIM_ATTRIBUTE.MARK_SIM true [get_bd_intf_nets {noc_tg_M_AXI}]

make_wrapper -files [get_files ${myPath}/module_1/module_1.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse ${myPath}/module_1/module_1.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
after 5000
generate_target Simulation [get_files ${myPath}/module_1/module_1.srcs/sources_1/bd/design_1/design_1.bd]
after 5000
export_ip_user_files -of_objects [get_files ${myPath}/module_1/module_1.srcs/sources_1/bd/design_1/design_1.bd] -no_script -sync -force -quiet
after 5000
export_simulation -of_objects [get_files ${myPath}/module_1/module_1.srcs/sources_1/bd/design_1/design_1.bd] -directory ${myPath}/module_1/module_1.ip_user_files/sim_scripts -ip_user_files_dir ${myPath}/module_1/module_1.ip_user_files -ipstatic_source_dir ${myPath}/module_1/module_1.ip_user_files/ipstatic -lib_map_path [list {modelsim=${myPath}/module_1/module_1.cache/compile_simlib/modelsim} {questa=${myPath}/module_1/module_1.cache/compile_simlib/questa} {ies=${myPath}/module_1/module_1.cache/compile_simlib/ies} {xcelium=${myPath}/module_1/module_1.cache/compile_simlib/xcelium} {vcs=${myPath}/module_1/module_1.cache/compile_simlib/vcs} {riviera=${myPath}/module_1/module_1.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
after 5000

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
set_property -name {xsim.simulate.runtime} -value {10000us} -objects [get_filesets sim_1]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
launch_simulation


