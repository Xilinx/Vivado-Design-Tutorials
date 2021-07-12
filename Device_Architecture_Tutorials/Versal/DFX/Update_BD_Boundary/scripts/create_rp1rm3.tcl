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


current_bd_design [get_bd_designs design_1]
set curdesign [current_bd_design]
create_bd_design -boundary_from_container [get_bd_cells /rp1] rp1rm3
current_bd_design $curdesign
set_property -dict [list CONFIG.LIST_SYNTH_BD {rp1rm1.bd:rp1rm2.bd:rp1rm3.bd} CONFIG.LIST_SIM_BD {rp1rm1.bd:rp1rm2.bd:rp1rm3.bd}] [get_bd_cells /rp1]
current_bd_design [get_bd_designs rp1rm3]
update_compile_order -fileset sources_1
regenerate_bd_layout
#Populating RP1RM3
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property -dict [list CONFIG.CONST_WIDTH {32} CONFIG.CONST_VAL {0xC00100F}] [get_bd_cells xlconstant_0]
set_property -dict [list CONFIG.C_ALL_INPUTS {1}] [get_bd_cells axi_gpio_0]
connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins xlconstant_0/dout]

#Connecting RM Ports to IPs
connect_bd_intf_net [get_bd_intf_ports S_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
connect_bd_intf_net [get_bd_intf_ports S_AXI1] [get_bd_intf_pins axi_gpio_0/S_AXI]
connect_bd_net [get_bd_ports s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
connect_bd_net [get_bd_ports s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk]
connect_bd_net [get_bd_ports s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]
connect_bd_net [get_bd_ports s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn]

#Apply BD automation for BRAM controller
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB]



copy_bd_objs /  [get_bd_cells {axi_gpio_0 xlconstant_0}]
set_property -dict [list CONFIG.CONST_VAL {0xFACEFEED}] [get_bd_cells xlconstant_1]
connect_bd_net [get_bd_pins xlconstant_1/dout] [get_bd_pins axi_gpio_1/gpio_io_i]
connect_bd_net [get_bd_ports s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk]
connect_bd_net [get_bd_ports s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn]

#Creating an extra Port for NoC INI in RP1RM3
make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_1/S_AXI]

set_property APERTURES {0xA400_0000 8K} [get_bd_intf_ports /S_AXI]
set_property APERTURES {0xA402_0000 64K} [get_bd_intf_ports /S_AXI1]
set_property APERTURES {{{0xA403_0000 64K}}} [get_bd_intf_ports /S_AXI_0]

#Assign address
assign_bd_address
validate_bd_design
save_bd_design
