#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#



current_bd_design [get_bd_designs design_1]
#Enable DFX for the BDC rp1 rp2
set_property -dict [list CONFIG.ENABLE_DFX {true}] [get_bd_cells {rp1 rp2}]
#Lock the Static-RP interface
set_property -dict [list CONFIG.LOCK_PROPAGATE {true}] [get_bd_cells {rp1 rp2}]

current_bd_design [get_bd_designs rp1rm1]
set_property APERTURES {{0x80010000 64K}} [get_bd_intf_ports /S_AXI]
validate_bd_design
save_bd_design

current_bd_design [get_bd_designs rp2rm1]
set_property APERTURES {{0x80030000 64K}} [get_bd_intf_ports /S_AXI]
validate_bd_design
save_bd_design

current_bd_design [get_bd_designs design_1]
#Set the Aperture for the interface ports of RP1
#set_property APERTURES {0x80010000 64K} [get_bd_intf_pins /rp1/S_AXI]
#set_property APERTURES {0x80030000 64K} [get_bd_intf_pins /rp2/S_AXI]

##Validate and Save the Top BD
validate_bd_design
save_bd_design

