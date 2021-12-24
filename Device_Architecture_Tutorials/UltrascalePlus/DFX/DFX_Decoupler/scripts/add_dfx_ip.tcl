# #########################################################################
#© Copyright 2021 Xilinx, Inc.

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

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_decoupler:1.0 dfx_decoupler_0
endgroup
set_property -dict [list CONFIG.ALL_PARAMS {INTF {intf_0 {ID 0 VLNV xilinx.com:interface:gpio_rtl:1.0 SIGNALS {TRI_T {DECOUPLED 0} TRI_I {DECOUPLED 0} TRI_O {MANAGEMENT manual WIDTH 8 DECOUPLED_VALUE 0x3c}}}}} CONFIG.GUI_SELECT_INTERFACE {0} CONFIG.GUI_INTERFACE_NAME {intf_0} CONFIG.GUI_SELECT_VLNV {xilinx.com:interface:gpio_rtl:1.0} CONFIG.GUI_SIGNAL_SELECT_0 {TRI_T} CONFIG.GUI_SIGNAL_SELECT_1 {TRI_O} CONFIG.GUI_SIGNAL_SELECT_2 {TRI_I} CONFIG.GUI_SIGNAL_DECOUPLED_0 {false} CONFIG.GUI_SIGNAL_DECOUPLED_1 {true} CONFIG.GUI_SIGNAL_DECOUPLED_2 {false} CONFIG.GUI_SIGNAL_PRESENT_0 {true} CONFIG.GUI_SIGNAL_PRESENT_1 {true} CONFIG.GUI_SIGNAL_PRESENT_2 {true} CONFIG.GUI_SIGNAL_WIDTH_1 {8} CONFIG.GUI_SIGNAL_DECOUPLED_VALUE_1 {0x3c} CONFIG.GUI_SIGNAL_MANAGEMENT_1 {manual}] [get_bd_cells dfx_decoupler_0]

delete_bd_objs [get_bd_nets reconfig_gpio2_io_o]
connect_bd_net [get_bd_pins hier_1/gpio2_io_o] [get_bd_pins dfx_decoupler_0/rp_intf_0_TRI_O]

connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins dfx_decoupler_0/s_intf_0_TRI_O]

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_axi_shutdown_manager:1.0 dfx_axi_shutdown_man_0
endgroup
set_property -dict [list CONFIG.RP_IS_MASTER {false} CONFIG.CTRL_INTERFACE_TYPE {1} CONFIG.DP_PROTOCOL {AXI4LITE} CONFIG.DP_AXI_RESP {2}] [get_bd_cells dfx_axi_shutdown_man_0]

connect_bd_net [get_bd_pins dfx_axi_shutdown_man_0/in_shutdown] [get_bd_pins dfx_decoupler_0/decouple]
delete_bd_objs [get_bd_intf_nets axi_interconnect_0_M01_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins dfx_axi_shutdown_man_0/S_AXI]
connect_bd_intf_net [get_bd_intf_pins dfx_axi_shutdown_man_0/M_AXI] -boundary_type upper [get_bd_intf_pins hier_1/S_AXI]
connect_bd_net [get_bd_pins dfx_axi_shutdown_man_0/clk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins dfx_axi_shutdown_man_0/resetn] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]

startgroup
set_property -dict [list CONFIG.NUM_MI {3}] [get_bd_cells axi_interconnect_0]
endgroup

connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins dfx_axi_shutdown_man_0/S_AXI_CTRL]
connect_bd_net [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]

regenerate_bd_layout
assign_bd_address

validate_bd_design
save_bd_design