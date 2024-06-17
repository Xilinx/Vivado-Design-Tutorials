#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

#set the aperture for RP1RM1
current_bd_design [get_bd_designs rp1rm1]
set_property APERTURES {{{0x_202_0000_0000 128K}}} [get_bd_intf_ports /S00_INI]
validate_bd_design
save_bd_design

#set the aperture for RP1RM2
current_bd_design [get_bd_designs rp1rm2]
set_property APERTURES {{{0x202_0000_0000 128K}}} [get_bd_intf_ports /S00_INI]
validate_bd_design
save_bd_design

#set the aperture for RP2RM1
current_bd_design [get_bd_designs rp2rm1]
set_property APERTURES {{{0x_201_8000_0000 16K}}} [get_bd_intf_ports /S00_INI]
validate_bd_design
save_bd_design

#set the aperture for RP2RM2
current_bd_design [get_bd_designs rp2rm2]
set_property APERTURES {{{0x201_8000_0000 16K}}} [get_bd_intf_ports /S00_INI]
validate_bd_design
save_bd_design


##Upgrade the modified RP BDC at the top. Corresponds to clicking "Refresh Modules" banner at the top
current_bd_design [get_bd_designs design_1]
upgrade_bd_cells [get_bd_cells rp1] [get_bd_cells rp2]
validate_bd_design
save_bd_design

regenerate_bd_layout


