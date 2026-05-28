#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

# Get NoC Interfaces
set fpd_cci_nmu_0 [get_noc_interfaces design_1_i/axi_noc_0/S00_AXI_nmu]
set fpd_cci_nmu_1 [get_noc_interfaces design_1_i/axi_noc_0/S01_AXI_nmu]
set fpd_cci_nmu_2 [get_noc_interfaces design_1_i/axi_noc_0/S02_AXI_nmu]
set fpd_cci_nmu_3 [get_noc_interfaces design_1_i/axi_noc_0/S03_AXI_nmu]
set lpd_axi_nmu [get_noc_interfaces design_1_i/axi_noc_0/S04_AXI_rpu]
set pmc_nmu [get_noc_interfaces design_1_i/axi_noc_0/S05_AXI_nmu]
set ddrmc_nsu_0 [get_noc_interfaces design_1_i/axi_noc_0/PORT0_ddrc]
set ddrmc_nsu_1 [get_noc_interfaces design_1_i/axi_noc_0/PORT1_ddrc]

# Create Virtual NoC Interfaces
set virtual_nmu_to_static_ddr_low0 [create_noc_interface -mode vnmu -type AXIMM RP1_inst/virtual_nmu_to_static_ddr_low0]
set virtual_nsu_to_static_ddr_low1 [create_noc_interface -mode vnsu -type AXIMM RP1_inst/virtual_nsu_to_static_ddr_low1]
set virtual_nsu_from_static_pmc_for_dynamic_debug [create_noc_interface -mode vnsu -type AXIMM RP1_inst/virtual_pmc_to_dbg_hub]

# Create NoC Connections
set conn0 [create_noc_connection -source  $virtual_nmu_to_static_ddr_low0 -target  $ddrmc_nsu_0]
set conn1 [create_noc_connection -source  $virtual_nsu_to_static_ddr_low1 -target  $ddrmc_nsu_1]
set conn_dbg_hub_rm1 [create_noc_connection -source $pmc_nmu -target $virtual_nsu_from_static_pmc_for_dynamic_debug]

# Set QoS for NoC Connections
set_property -dict [list READ_BANDWIDTH 400 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 400 WRITE_AVERAGE_BURST 4] $conn0

# Set Aperture for NoC NSUs
set_property APERTURES [list {0x204_0000_0000:0x204_001F_FFFF}] $virtual_nsu_from_static_pmc_for_dynamic_debug
set_property APERTURES [list {0x0000_0000:0x7FFF_FFFF}] $virtual_nmu_to_static_ddr_low0
set_property APERTURES [list {0x0008_0000_0000:0x0009_7FFF_FFFF}] $virtual_nsu_to_static_ddr_low1
