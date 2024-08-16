set myPath [exec pwd]
create_project module05 ${myPath}/module_05 -part xcvc1902-vsva2197-2MP-e-S
set_property board_part xilinx.com:vck190:part0:3.3 [current_project]
set_property simulator_language Verilog [current_project]
create_bd_design "design_1"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.1 axi_noc_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi_noc -config { hbm_density {None} hbm_internal_clk {0} hbm_nmu {None} mc_type {DDR} noc_clk {None} num_axi_bram {None} num_axi_tg {None} num_aximm_ext {None} num_mc_ddr {1} num_mc_lpddr {None} pl2noc_apm {0} pl2noc_cips {1}}  [get_bd_cells axi_noc_0]
startgroup
set_property CONFIG.MC_CHAN_REGION1 {DDR_CH1} [get_bd_cells axi_noc_0]
set_property -dict [list CONFIG.CONNECTIONS {MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S00_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S01_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_0 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S02_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_1 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S03_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_3 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S04_AXI]
set_property -dict [list CONFIG.CONNECTIONS {MC_2 {read_bw {100} write_bw {100} read_avg_burst {4} write_avg_burst {4}}}] [get_bd_intf_pins /axi_noc_0/S05_AXI]
endgroup
assign_bd_address
make_wrapper -files [get_files ${myPath}/module_05/module05.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse ${myPath}/module_05/module05.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1
launch_runs impl_1 -to_step write_device_image 


