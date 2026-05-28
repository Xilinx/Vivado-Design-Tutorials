#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

################################
# AXI4 
################################

# Get NoC Interfaces
set ddrmc_nsu [get_noc_interfaces design_1_i/axi_noc_0/PORT0_ddrc]
set pmc_nmu [get_noc_interfaces design_1_i/axi_noc_0/S05_AXI_nmu]
                        
# Create Virtual NoC Interfaces
set virtual_nmu_to_static_ddr [create_noc_interface -mode vnmu -type AXIMM RP1_inst/virtual_nmu_to_static_ddr]
set virtual_nsu_from_static_pmc_for_dynamic_debug [create_noc_interface -mode vnsu -type AXIMM RP1_inst/virtual_pmc_to_dbg_hub]

# Create NoC Connections
set conn0 [create_noc_connection -source  $virtual_nmu_to_static_ddr -target  $ddrmc_nsu]
set conn_dbg_hub_rm1 [create_noc_connection -source $pmc_nmu -target $virtual_nsu_from_static_pmc_for_dynamic_debug]

# Set QoS for NoC Connections
set_property -dict [list READ_BANDWIDTH 400 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 400 WRITE_AVERAGE_BURST 4] $conn0

# Set Aperture for NoC NSUs
set_property APERTURES [list {0x204_0000_0000:0x204_001F_FFFF}] $virtual_nsu_from_static_pmc_for_dynamic_debug
set_property APERTURES [list {0x0000_0000:0x7FFF_FFFF}] $virtual_nmu_to_static_ddr

################################
# AXIS 
################################

# Get NoC Interfaces
set pl_axis_nmu_0 [get_noc_interfaces _5_pl_axis_M_top_inst/genblk1[0].xpm_nmu_strm_pl_to_pl/S_AXIS_nmu]
set pl_axis_nmu_1 [get_noc_interfaces _5_pl_axis_M_top_inst/genblk1[1].xpm_nmu_strm_pl_to_pl/S_AXIS_nmu]

# Create Virtual NoC Interfaces
set virtual_nsu_axis_from_static_pl [create_noc_interface -mode vnsu -type AXIS RP1_inst/virtual_nsu_from_static_pl]

# Create NoC Connections
set conn_axis_00 [create_noc_connection -source $pl_axis_nmu_0 -target $virtual_nsu_axis_from_static_pl]
set conn_axis_10 [create_noc_connection -source $pl_axis_nmu_1 -target $virtual_nsu_axis_from_static_pl]
