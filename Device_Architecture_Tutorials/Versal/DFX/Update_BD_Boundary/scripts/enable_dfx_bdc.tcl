#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#


current_bd_design [get_bd_designs design_1]
#Enable DFX for the BDC rp1
set_property -dict [list CONFIG.ENABLE_DFX {true}] [get_bd_cells rp1]
##Lock the Static-RP interface
set_property -dict [list CONFIG.LOCK_PROPAGATE {true}] [get_bd_cells rp1]

#Observed that aperture in rp1rm1 is not reflected to right value. Hence manually setting
current_bd_design [get_bd_designs rp1rm1]
set_property APERTURES {0xA400_0000 8K} [get_bd_intf_ports /S_AXI]
set_property APERTURES {0xA402_0000 64K} [get_bd_intf_ports /S_AXI1]
#Validate and Save the Top BD
validate_bd_design
save_bd_design

current_bd_design [get_bd_designs design_1]
upgrade_bd_cells [get_bd_cells rp1]
##Validate and Save the Top BD
validate_bd_design
save_bd_design
