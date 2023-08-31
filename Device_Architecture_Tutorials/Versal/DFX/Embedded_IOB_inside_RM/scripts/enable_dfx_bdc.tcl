#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

set_property PR_FLOW 1 [current_project]
current_bd_design [get_bd_designs design_1]
#Enable DFX for the BDC rp1 rp2
set_property -dict [list CONFIG.ENABLE_DFX {true}] [get_bd_cells {rp1}]
#Lock the Static-RP interface
set_property -dict [list CONFIG.LOCK_PROPAGATE {true}] [get_bd_cells {rp1}]

current_bd_design rp1rm1
delete_bd_objs [get_bd_addr_segs] [get_bd_addr_segs -excluded]
assign_bd_address
validate_bd_design
save_bd_design

##Validate and Save the Top BD
update_compile_order -fileset sources_1
current_bd_design design_1
upgrade_bd_cells [get_bd_cells rp1]
validate_bd_design
save_bd_design

