#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

################################
# AXI4 
################################

# Get NoC Interfaces
set nmu_to_ddr [get_noc_interfaces _4_pl_master_to_ddr_inst/xpm_nmu_pl_master_to_ddr/S_AXI_nmu]
set ddrmc_nsu [get_noc_interfaces design_1_i/axi_noc_0/PORT0_ddrc]
set pl_nmu_to_cips [get_noc_interfaces _2_pl_master_to_cips_inst/xpm_nmu_mm_pl_to_cips_master_inst/S_AXI_nmu ]
set noc_fpd_nsu_cips [get_noc_interfaces /design_1_i/axi_noc_0/M00_AXI_nsu]
set pl_nmu_to_pl [get_noc_interfaces _3_pl_master_to_pl_slave_inst/pl_to_pl_master_inst/xpm_nmu_mm_pl_to_pl_master_inst/S_AXI_nmu]
set pl_nsu_from_pl [get_noc_interfaces _3_pl_master_to_pl_slave_inst/pl_to_pl_slave_inst/xpm_nsu_mm_pl_to_pl_slave_inst/M_AXI_nsu]
set fpd_cci_nmu_0 [get_noc_interfaces design_1_i/axi_noc_0/S00_AXI_nmu]
set fpd_cci_nmu_1 [get_noc_interfaces design_1_i/axi_noc_0/S01_AXI_nmu]
set fpd_cci_nmu_2 [get_noc_interfaces design_1_i/axi_noc_0/S02_AXI_nmu]
set fpd_cci_nmu_3 [get_noc_interfaces design_1_i/axi_noc_0/S03_AXI_nmu]
set lpd_axi_nmu [get_noc_interfaces design_1_i/axi_noc_0/S04_AXI_rpu]
set pmc_nmu [get_noc_interfaces design_1_i/axi_noc_0/S05_AXI_nmu]
set pl_nsu_from_cips [get_noc_interfaces _1_pl_slave_from_cips_inst/xpm_nsu_mm_pl_slave_from_cips/M_AXI_nsu]

# Create NoC Connections
set conn0 [create_noc_connection -source  $nmu_to_ddr -target  $ddrmc_nsu]
set conn1 [create_noc_connection -source $pl_nmu_to_pl -target $pl_nsu_from_pl]
set conn2 [create_noc_connection -source $fpd_cci_nmu_0 -target $pl_nsu_from_cips]
set conn3 [create_noc_connection -source $fpd_cci_nmu_1 -target $pl_nsu_from_cips]
set conn4 [create_noc_connection -source $fpd_cci_nmu_2 -target $pl_nsu_from_cips]
set conn5 [create_noc_connection -source $fpd_cci_nmu_3 -target $pl_nsu_from_cips]
set conn6 [create_noc_connection -source $lpd_axi_nmu -target $pl_nsu_from_cips]
set conn7 [create_noc_connection -source $pmc_nmu -target $pl_nsu_from_cips]
set conn8 [create_noc_connection -source $pl_nmu_to_cips -target $noc_fpd_nsu_cips]

# Set QoS for NoC Connections
set_property -dict [list READ_BANDWIDTH 400 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 400 WRITE_AVERAGE_BURST 4] $conn0
set_property -dict [list READ_BANDWIDTH 400 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 300 WRITE_AVERAGE_BURST 4] $conn1
set_property -dict [list READ_BANDWIDTH 500 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 600 WRITE_AVERAGE_BURST 4] $conn2
set_property -dict [list READ_BANDWIDTH 300 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 200 WRITE_AVERAGE_BURST 4] $conn3
set_property -dict [list READ_BANDWIDTH 800 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 700 WRITE_AVERAGE_BURST 4] $conn4
set_property -dict [list READ_BANDWIDTH 900 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 800 WRITE_AVERAGE_BURST 4] $conn5
set_property -dict [list READ_BANDWIDTH 700 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 700 WRITE_AVERAGE_BURST 4] $conn6
set_property -dict [list READ_BANDWIDTH 600 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 600 WRITE_AVERAGE_BURST 4] $conn7
set_property -dict [list READ_BANDWIDTH 1000 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 1000 WRITE_AVERAGE_BURST 4] $conn8

# Set Aperture for NoC NSUs
set_property APERTURES [list {0x202_0000_0000:0x202_001F_FFFF}] $pl_nsu_from_pl
set_property APERTURES [list {0x203_0000_0000:0x203_001F_FFFF}] $pl_nsu_from_cips

################################
# AXIS 
################################

# Get NoC Interfaces
set pl_axis_nmu_0 [get_noc_interfaces _5_pl_axis_MxN_top_inst/genblk1[0].xpm_nmu_strm_pl_to_pl/S_AXIS_nmu]
set pl_axis_nmu_1 [get_noc_interfaces _5_pl_axis_MxN_top_inst/genblk1[1].xpm_nmu_strm_pl_to_pl/S_AXIS_nmu]
set pl_axis_nsu_0 [get_noc_interfaces _5_pl_axis_MxN_top_inst/genblk2[0].xpm_nsu_strm_pl_to_pl/M_AXIS_nsu]
set pl_axis_nsu_1 [get_noc_interfaces _5_pl_axis_MxN_top_inst/genblk2[1].xpm_nsu_strm_pl_to_pl/M_AXIS_nsu]

# Create NoC Connections
set conn_00 [create_noc_connection -source $pl_axis_nmu_0 -target $pl_axis_nsu_0]
set conn_01 [create_noc_connection -source $pl_axis_nmu_0 -target $pl_axis_nsu_1]
set conn_10 [create_noc_connection -source $pl_axis_nmu_1 -target $pl_axis_nsu_0]
set conn_11 [create_noc_connection -source $pl_axis_nmu_1 -target $pl_axis_nsu_1]

# AXIS MxN TDEST IDs (BASE:HIGH)
set_property TDEST_ID 0x0:0x0 $pl_axis_nsu_0
set_property TDEST_ID 0x1:0x1 $pl_axis_nsu_1

