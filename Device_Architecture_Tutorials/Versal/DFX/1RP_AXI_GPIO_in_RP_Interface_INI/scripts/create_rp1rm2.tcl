#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

set curdesign [current_bd_design]
create_bd_design -boundary_from_container [get_bd_cells /rp1] rp1rm2
current_bd_design $curdesign
set_property -dict [list CONFIG.LIST_SYNTH_BD {rp1rm1.bd:rp1rm2.bd} CONFIG.LIST_SIM_BD {rp1rm1.bd:rp1rm2.bd}] [get_bd_cells /rp1]
current_bd_design [get_bd_designs rp1rm2]
#Populate the new RM
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 axi_noc_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0

set_property -dict [list CONFIG.NUM_SI {1}] [get_bd_cells smartconnect_0]

set_property -dict [list CONFIG.NUM_SI {0} CONFIG.NUM_NSI {1}] [get_bd_cells axi_noc_0]
set_property -dict [list CONFIG.INI_STRATEGY {load}] [get_bd_intf_pins /axi_noc_0/S00_INI]
set_property -dict [list CONFIG.CONNECTIONS {M00_AXI { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} }] [get_bd_intf_pins /axi_noc_0/S00_INI]
set_property -dict [list CONFIG.ASSOCIATED_BUSIF {M00_AXI}] [get_bd_pins /axi_noc_0/aclk0]

set_property -dict [list CONFIG.CONST_WIDTH {32} CONFIG.CONST_VAL {0xFACEFEED}] [get_bd_cells xlconstant_0]

set_property -dict [list CONFIG.C_ALL_INPUTS {1}] [get_bd_cells axi_gpio_0]


connect_bd_intf_net [get_bd_intf_ports S00_INI] [get_bd_intf_pins axi_noc_0/S00_INI]
connect_bd_net [get_bd_ports s_axi_aclk] [get_bd_pins axi_noc_0/aclk0]
connect_bd_net [get_bd_ports s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk]
connect_bd_net [get_bd_ports s_axi_aclk] [get_bd_pins smartconnect_0/aclk]
connect_bd_net [get_bd_ports s_axi_aresetn] [get_bd_pins smartconnect_0/aresetn]
connect_bd_net [get_bd_ports s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn]
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins axi_gpio_0/gpio_io_i]
connect_bd_intf_net [get_bd_intf_pins axi_noc_0/M00_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]

assign_bd_address -target_address_space /S00_INI [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
set_property offset 0x20180010000 [get_bd_addr_segs {S00_INI/SEG_axi_gpio_0_Reg}]
set_property range 64K [get_bd_addr_segs {S00_INI/SEG_axi_gpio_0_Reg}]


validate_bd_design
save_bd_design

