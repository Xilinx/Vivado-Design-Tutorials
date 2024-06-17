#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

current_bd_design [get_bd_designs design_1]

#Enable DFX on RP1 and RP2 BDC
set_property -dict [list CONFIG.ENABLE_DFX {true}] [get_bd_cells rp1]
set_property -dict [list CONFIG.ENABLE_DFX {true}] [get_bd_cells rp2]

#Lock the Static-RP boundary
set_property -dict [list CONFIG.LOCK_PROPAGATE {true}] [get_bd_cells rp1]
set_property -dict [list CONFIG.LOCK_PROPAGATE {true}] [get_bd_cells rp2]

validate_bd_design
save_bd_design


