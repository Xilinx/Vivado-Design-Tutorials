#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

#set the aperture for RP1
current_bd_design [get_bd_designs rp1rm1]
set_property APERTURES {{0x8001_0000 64K}} [get_bd_intf_ports /S_AXI]
validate_bd_design
save_bd_design

#set the aperture for RP2
current_bd_design [get_bd_designs rp2rm1]
set_property APERTURES {{0x8003_0000 64K}} [get_bd_intf_ports /S_AXI]
validate_bd_design
save_bd_design


#Upgrade the modified RP BDC at the top. Corresponds to clicking "Refresh Modules" banner at the top
current_bd_design [get_bd_designs design_1]
upgrade_bd_cells [get_bd_cells rp1]
upgrade_bd_cells [get_bd_cells rp2]
validate_bd_design
save_bd_design



