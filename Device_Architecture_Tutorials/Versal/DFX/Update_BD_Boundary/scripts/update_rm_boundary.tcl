#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

current_bd_design [get_bd_designs design_1]
set_property -dict [list CONFIG.LOCK_PROPAGATE {false}] [get_bd_cells rp1]
update_bd_boundaries [ get_bd_cells /rp1 ] -from_bd rp1rm3.bd	
upgrade_bd_cells [get_bd_cells /rp1]


#Validating individual BDs after updating ports using update_bd_boundaries
current_bd_design [get_bd_designs rp1rm2]
validate_bd_design
save_bd_design

current_bd_design [get_bd_designs rp1rm1]
validate_bd_design
save_bd_design

current_bd_design [get_bd_designs design_1]
upgrade_bd_cells [get_bd_cells /rp1]

