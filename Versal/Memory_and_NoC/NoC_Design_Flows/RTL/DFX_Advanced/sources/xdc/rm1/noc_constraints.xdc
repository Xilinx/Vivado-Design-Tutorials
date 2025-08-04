#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

# Get NoC Interfaces
set pl_nmu_to_ddr_0 [get_noc_interfaces pl_master_to_ddr_low0_inst/xpm_nmu_pl_master_to_ddr/S_AXI_nmu]
set pl_nmu_to_ddr_1 [get_noc_interfaces pl_master_to_ddr_low1_inst/xpm_nmu_pl_master_to_ddr/S_AXI_nmu]
set pl_dbg_hub_nsu_0 [get_noc_interfaces xpm_nsu_mm_debug_hub/M_AXI_nsu]
set virtual_nmu_to_static_ddr_low0 [create_noc_interface -mode vnmu -type AXIMM virtual_nmu_to_static_ddr_low0]
set virtual_nsu_to_static_ddr_low1 [create_noc_interface -mode vnsu -type AXIMM virtual_nsu_to_static_ddr_low1]
set virtual_nsu_from_static_pmc_for_dynamic_debug [create_noc_interface -mode vnsu -type AXIMM virtual_pmc_to_dbg_hub]

# Create Virtual NoC Interfaces
set conn_ddr_vnmu [create_noc_connection -source $pl_nmu_to_ddr_0 -target $virtual_nmu_to_static_ddr_low0]
set conn_ddr_vnsu [create_noc_connection -source $pl_nmu_to_ddr_1 -target $virtual_nsu_to_static_ddr_low1]
set conn_dbg_hub_rp1 [create_noc_connection -source $virtual_nsu_from_static_pmc_for_dynamic_debug -target $pl_dbg_hub_nsu_0]

# Set Aperture for NoC NSUs
set_property APERTURES [list {0x204_0000_0000:0x204_001F_FFFF}] $virtual_nsu_from_static_pmc_for_dynamic_debug
set_property APERTURES [list {0x204_0000_0000:0x204_001F_FFFF}] $pl_dbg_hub_nsu_0
set_property APERTURES [list {0x0000_0000:0x7FFF_FFFF}] $virtual_nmu_to_static_ddr_low0
set_property APERTURES [list {0x0008_0000_0000:0x0009_7FFF_FFFF}] $virtual_nsu_to_static_ddr_low1
