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

current_bd_design [get_bd_designs top]
create_bd_design -boundary_from_container [get_bd_cells /PL] timer_bd
current_bd_design [get_bd_designs top]
set_property -dict [list CONFIG.LIST_SYNTH_BD {bram_bd.bd:timer_bd.bd} CONFIG.LIST_SIM_BD {bram_bd.bd:timer_bd.bd}] [get_bd_cells /PL]
current_bd_design [get_bd_designs timer_bd]

#Populate the new RM with IP, then make connections
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0

set_property -dict [list CONFIG.NUM_SI {1}] [get_bd_cells smartconnect_0]

connect_bd_intf_net [get_bd_intf_ports S00_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins axi_timer_0/S_AXI]
connect_bd_net [get_bd_ports aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_ports aclk] [get_bd_pins axi_timer_0/s_axi_aclk]
connect_bd_net [get_bd_ports aclk] [get_bd_pins smartconnect_0/aclk]
connect_bd_net [get_bd_ports ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins smartconnect_0/aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_timer_0/s_axi_aresetn]

#Clean up the layout and auto-assign all addresses
regenerate_bd_layout
assign_bd_address -offset 0xA4000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] -force

#Validate and save the timer module
validate_bd_design
save_bd_design

#Validate and save the top module
current_bd_design [get_bd_designs top]
validate_bd_design
save_bd_design

