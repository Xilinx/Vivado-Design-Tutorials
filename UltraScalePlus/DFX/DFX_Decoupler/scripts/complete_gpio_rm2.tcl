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
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
endgroup
set_property -dict [list CONFIG.C_GPIO2_WIDTH {8} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_INPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1}] [get_bd_cells axi_gpio_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
endgroup
set_property -dict [list CONFIG.CONST_WIDTH {32} CONFIG.CONST_VAL {0x22DFEC22}] [get_bd_cells xlconstant_0]
connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins xlconstant_0/dout]
connect_bd_net [get_bd_ports gpio2_io_o] [get_bd_pins axi_gpio_0/gpio2_io_o]
connect_bd_intf_net [get_bd_intf_ports S_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
connect_bd_net [get_bd_ports s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk]
connect_bd_net [get_bd_ports s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn]

assign_bd_address
regenerate_bd_layout
validate_bd_design
save_bd_design

#validate top level block diagram and save
current_bd_design [get_bd_designs dfx_shdn_mgr]
validate_bd_design
save_bd_design

#switch back to gpio_rm2 block diagram
current_bd_design [get_bd_designs gpio_rm2]
