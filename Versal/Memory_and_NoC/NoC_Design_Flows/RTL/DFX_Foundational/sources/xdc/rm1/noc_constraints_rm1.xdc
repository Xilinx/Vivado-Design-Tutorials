#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

################################
# AXI4 
################################

# Get NoC Interfaces
set pl_nmu_to_ddr_0 [get_noc_interfaces _4_pl_master_to_ddr_inst/xpm_nmu_pl_master_to_ddr/S_AXI_nmu]
set pl_dbg_hub_nsu_0 [get_noc_interfaces xpm_nsu_mm_debug_hub/M_AXI_nsu]

# Create Virtual NoC Interfaces
set virtual_nmu_to_static_ddr [create_noc_interface -mode vnmu -type AXIMM virtual_nmu_to_static_ddr]
set virtual_nsu_from_static_pmc_for_dynamic_debug [create_noc_interface -mode vnsu -type AXIMM virtual_pmc_to_dbg_hub]

# Create NoC Connections
set conn_ddr [create_noc_connection -source $pl_nmu_to_ddr_0 -target $virtual_nmu_to_static_ddr]
set conn_dbg_hub_rp1 [create_noc_connection -source $virtual_nsu_from_static_pmc_for_dynamic_debug -target $pl_dbg_hub_nsu_0]

# Set Aperture for NoC NSUs
set_property APERTURES [list {0x204_0000_0000:0x204_001F_FFFF}] $virtual_nsu_from_static_pmc_for_dynamic_debug
set_property APERTURES [list {0x204_0000_0000:0x204_001F_FFFF}] $pl_dbg_hub_nsu_0
set_property APERTURES [list {0x0000_0000:0x7FFF_FFFF}] $virtual_nmu_to_static_ddr

################################
# AXIS 
################################

# Get NoC Interfaces
set pl_axis_nsu_0 [get_noc_interfaces _5_pl_axis_S_top_inst/genblk1[0].xpm_nsu_strm_pl_to_pl/M_AXIS_nsu]

# Create Virtual NoC Interfaces
set virtual_nsu_axis_from_static_pl [create_noc_interface -mode vnsu -type AXIS virtual_nsu_from_static_pl]

# Create NoC Connections
set conn_axis_0 [create_noc_connection -source $virtual_nsu_axis_from_static_pl -target $pl_axis_nsu_0]

#AXIS MxN TDEST IDs (BASE:HIGH)
set_property TDEST_ID 0x0:0x0 $pl_axis_nsu_0
