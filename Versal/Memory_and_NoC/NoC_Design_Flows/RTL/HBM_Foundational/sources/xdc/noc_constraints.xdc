#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

# Get NoC Interfaces
set nmu_vnoc  [get_noc_interfaces vnoc_to_hbm_inst/xpm_nmu_mm_inst/S_AXI_nmu]
set nmu_bli  [get_noc_interfaces bli_to_hbm_inst/xpm_nmu_mm_inst/S_AXI_nmu]

set hbm_nsu_port_0 [get_noc_interfaces design_1_i/axi_noc_hbm/HBM0_PORT0_hbmc]
set hbm_nsu_port_1 [get_noc_interfaces design_1_i/axi_noc_hbm/HBM0_PORT1_hbmc]
set hbm_nsu_port_2 [get_noc_interfaces design_1_i/axi_noc_hbm/HBM0_PORT2_hbmc]
set hbm_nsu_port_3 [get_noc_interfaces design_1_i/axi_noc_hbm/HBM0_PORT3_hbmc]

# Create NoC Connections
# Making NoC Path connection from RTL PL NOC Master to BD based HBM memory port NSU
# Each NMU connects to 2 NSUs for access to entire address space of HBM MC (2 pseudu channels per HBM MC)
set conn00 [create_noc_connection -source  $nmu_bli -target  $hbm_nsu_port_0]
set conn01 [create_noc_connection -source  $nmu_bli -target  $hbm_nsu_port_2]
set conn10 [create_noc_connection -source  $nmu_vnoc -target  $hbm_nsu_port_1]
set conn11 [create_noc_connection -source  $nmu_vnoc -target  $hbm_nsu_port_3]

# Set QoS for NoC Connections
set_property -dict [list READ_BANDWIDTH 400 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 400 WRITE_AVERAGE_BURST 4] $conn00
set_property -dict [list READ_BANDWIDTH 400 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 400 WRITE_AVERAGE_BURST 4] $conn01
set_property -dict [list READ_BANDWIDTH 400 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 400 WRITE_AVERAGE_BURST 4] $conn10
set_property -dict [list READ_BANDWIDTH 400 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 400 WRITE_AVERAGE_BURST 4] $conn11
