#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

set curdesign [current_bd_design]
create_bd_design -boundary_from_container [get_bd_cells /rp1] rp1rm2
current_bd_design $curdesign
set_property -dict [list CONFIG.LIST_SYNTH_BD {rp1rm1.bd:rp1rm2.bd} CONFIG.LIST_SIM_BD {rp1rm1.bd:rp1rm2.bd}] [get_bd_cells /rp1]
current_bd_design [get_bd_designs rp1rm2]
update_compile_order -fileset sources_1
regenerate_bd_layout
#Creating IPs of RP1RM2
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

#Applying Aperture
set_property APERTURES {0xA400_0000 8K} [get_bd_intf_ports /S_AXI]
set_property APERTURES {0xA402_0000 64K} [get_bd_intf_ports /S_AXI1]

#Assign address
assign_bd_address
validate_bd_design
save_bd_design
