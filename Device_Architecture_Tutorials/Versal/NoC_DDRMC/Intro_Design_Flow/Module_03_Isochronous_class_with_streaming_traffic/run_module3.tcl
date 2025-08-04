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
create_project module_3 ${myPath}/module_3 -part xcvc1902-vsva2197-1LP-e-S
create_bd_design "design_1"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi_noc -config {num_axi_tg "2" num_aximm_ext "None" pl2noc_apm "1" num_axi_bram "1" num_mc "1" noc_clk "New/Reuse Simulation Clock And Reset Generator" }  [get_bd_cells axi_noc_0]
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins axi_noc_0/CH0_DDR4_0]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_bc/s_axi_aclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {New Clocking Wizard} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_clk_gen/axi_clk_in_0]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins noc_clk_gen/SYS_CLK0_IN]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_sim_trig/pclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_tg/clk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_tg_1/clk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_tg_pmon/axi_aclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins noc_tg_pmon_1/axi_aclk]
endgroup
regenerate_bd_layout
startgroup
set_property -dict [list CONFIG.NUM_MCP {1}] [get_bd_cells axi_noc_0]
set_property -dict [list CONFIG.CONNECTIONS {MC_0 { read_bw {5000} write_bw {5000} read_avg_burst {4} write_avg_burst {4}} } CONFIG.R_TRAFFIC_CLASS {ISOCHRONOUS} CONFIG.W_TRAFFIC_CLASS {ISOCHRONOUS}] [get_bd_intf_pins /axi_noc_0/S00_AXI]
set_property -dict [list CONFIG.CONNECTIONS {M00_AXI { read_bw {600} write_bw {600} read_avg_burst {4} write_avg_burst {4}} } CONFIG.R_TRAFFIC_CLASS {LOW_LATENCY}] [get_bd_intf_pins /axi_noc_0/S01_AXI]
endgroup
startgroup
set_property -dict [list CONFIG.USER_C_AXI_WRITE_LEN {16} CONFIG.USER_C_AXI_WRITE_BANDWIDTH {5000} CONFIG.USER_C_AXI_NO_OF_WR_TRANS {50}] [get_bd_cells noc_tg]
endgroup
startgroup
set_property -dict [list CONFIG.USER_C_AXI_WDATA_WIDTH {64} CONFIG.USER_C_AXI_RDATA_WIDTH {64} CONFIG.USER_C_AXI_WRITE_LEN {8} CONFIG.USER_C_AXI_WRITE_SIZE {8} CONFIG.USER_C_AXI_READ_SIZE {1} CONFIG.USER_C_AXI_WRITE_BANDWIDTH {600} CONFIG.USER_C_AXI_DATA_INTEGRITY_CHECK {ON} CONFIG.USER_C_AXI_WDATA_VALUE {0x0000000000000000}] [get_bd_cells noc_tg_1]
endgroup
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Clk {New External Port} Manual_Source {Auto}}  [get_bd_pins clk_wiz/clk_in1]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {New External Port (ACTIVE_HIGH)}}  [get_bd_pins clk_wiz/reset]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_pins rst_clk_wiz_100M/ext_reset_in]
endgroup
assign_bd_address
validate_bd_design
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_noc:1.0 axis_noc_0
endgroup

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:perf_axi_tg:1.0 perf_axi_tg_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0
endgroup
set_property -dict [list CONFIG.USER_C_AXI_PROTOCOL {AXI4_STREAM} CONFIG.USER_C_AXIS_TDATA_WIDTH {128} CONFIG.USER_C_AXIS_PKT_LEN {50} CONFIG.USER_C_AXIS_NO_OF_PKT {25} CONFIG.USER_C_AXIS_TDATA_VALUE {0x00000000000000000000000000000000} CONFIG.USER_C_AXIS_BANDWIDTH {4800} CONFIG.USER_SYN_ID_WIDTH {6} CONFIG.USER_SYN_USER_WIDTH {16} CONFIG.USER_EN_VIO_STATUS_MONITOR {FALSE} CONFIG.USER_DEST_ID_PORTS {WRITE}] [get_bd_cells perf_axi_tg_0]
set_property -dict [list CONFIG.FIFO_DEPTH {8192}] [get_bd_cells axis_data_fifo_0]
startgroup
set_property -dict [list CONFIG.USER_NUM_AXI_TG {4}] [get_bd_cells noc_sim_trig]
endgroup
connect_bd_intf_net [get_bd_intf_pins perf_axi_tg_0/M_AXIS] [get_bd_intf_pins axis_noc_0/S00_AXIS]
connect_bd_net [get_bd_pins perf_axi_tg_0/axi_tg_done] [get_bd_pins noc_sim_trig/all_done_02]
connect_bd_net [get_bd_pins perf_axi_tg_0/trigger_in] [get_bd_pins noc_sim_trig/trig_02]
connect_bd_net [get_bd_pins perf_axi_tg_0/axi_tg_start] [get_bd_pins noc_const/dout]
connect_bd_intf_net [get_bd_intf_pins axis_noc_0/M00_AXIS] [get_bd_intf_pins axis_data_fifo_0/S_AXIS]
startgroup
set_property -dict [list CONFIG.CONNECTIONS {M00_AXIS { write_bw {4800}} }] [get_bd_intf_pins /axis_noc_0/S00_AXIS]
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins perf_axi_tg_0/clk]

connect_bd_net [get_bd_pins noc_clk_gen/axi_rst_0_n] [get_bd_pins axis_data_fifo_0/s_axis_aresetn]
connect_bd_net [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins noc_clk_gen/axi_clk_0]

copy_bd_objs /  [get_bd_cells {perf_axi_tg_0 axis_data_fifo_0 axis_noc_0}]
connect_bd_intf_net [get_bd_intf_pins perf_axi_tg_1/M_AXIS] [get_bd_intf_pins axis_noc_1/S00_AXIS]
connect_bd_net [get_bd_pins perf_axi_tg_1/axi_tg_done] [get_bd_pins noc_sim_trig/all_done_03]
connect_bd_net [get_bd_pins perf_axi_tg_1/trigger_in] [get_bd_pins noc_sim_trig/trig_03]
connect_bd_net [get_bd_pins perf_axi_tg_1/axi_tg_start] [get_bd_pins noc_const/dout]
connect_bd_net [get_bd_pins axis_data_fifo_1/s_axis_aresetn] [get_bd_pins noc_clk_gen/axi_rst_0_n]
connect_bd_net [get_bd_pins axis_data_fifo_1/s_axis_aclk] [get_bd_pins noc_clk_gen/axi_clk_0]
connect_bd_intf_net [get_bd_intf_pins axis_noc_1/M00_AXIS] [get_bd_intf_pins axis_data_fifo_1/S_AXIS]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/noc_clk_gen/axi_clk_0 (300 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins perf_axi_tg_1/clk]
regenerate_bd_layout
after 5000
validate_bd_design
after 5000
set_property -dict [list CONFIG.PHYSICAL_LOC {NOC_NMU512_X0Y0}] [get_bd_intf_pins axi_noc_0/S00_AXI]
set_property -dict [list CONFIG.PHYSICAL_LOC {NOC_NMU512_X3Y6}] [get_bd_intf_pins axi_noc_0/S01_AXI]
set_property -dict [list CONFIG.PHYSICAL_LOC {NOC_NSU512_X0Y1}] [get_bd_intf_pins axi_noc_0/M00_AXI]
set_property -dict [list CONFIG.PHYSICAL_LOC {NOC_NMU512_X0Y2}] [get_bd_intf_pins axis_noc_0/S00_AXIS]
set_property -dict [list CONFIG.PHYSICAL_LOC {NOC_NSU512_X3Y6}] [get_bd_intf_pins axis_noc_0/M00_AXIS]
set_property -dict [list CONFIG.PHYSICAL_LOC {NOC_NMU512_X3Y5}] [get_bd_intf_pins axis_noc_1/S00_AXIS]
set_property -dict [list CONFIG.PHYSICAL_LOC {NOC_NSU512_X0Y0}] [get_bd_intf_pins axis_noc_1/M00_AXIS]
validate_bd_design
set_property SIM_ATTRIBUTE.MARK_SIM true [get_bd_intf_nets {noc_tg_1_M_AXI noc_tg_M_AXI}]
after 5000
make_wrapper -files [get_files ${myPath}/module_3/module_3.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse ${myPath}/module_3/module_3.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
after 5000
update_compile_order -fileset sources_1
generate_target Simulation [get_files ${myPath}/module_3/module_3.srcs/sources_1/bd/design_1/design_1.bd]
after 5000
export_ip_user_files -of_objects [get_files ${myPath}/module_3/module_3.srcs/sources_1/bd/design_1/design_1.bd] -no_script -sync -force -quiet
after 5000
export_simulation -of_objects [get_files ${myPath}/module_3/module_3.srcs/sources_1/bd/design_1/design_1.bd] -directory ${myPath}/module_3/module_3.ip_user_files/sim_scripts -ip_user_files_dir ${myPath}/module_3/module_3.ip_user_files -ipstatic_source_dir ${myPath}/module_3/module_3.ip_user_files/ipstatic -lib_map_path [list {modelsim=${myPath}/module_3/module_3.cache/compile_simlib/modelsim} {questa=${myPath}/module_3/module_3.cache/compile_simlib/questa} {ies=${myPath}/module_3/module_3.cache/compile_simlib/ies} {xcelium=${myPath}/module_3/module_3.cache/compile_simlib/xcelium} {vcs=${myPath}/module_3/module_3.cache/compile_simlib/vcs} {riviera=${myPath}/module_3/module_3.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
after 5000
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
launch_simulation
run all


