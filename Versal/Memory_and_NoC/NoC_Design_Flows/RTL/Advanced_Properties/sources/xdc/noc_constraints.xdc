#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#


################################
# AXI4 
################################

# Get NoC Interfaces
set pl_nmu_to_pl [get_noc_interfaces pl_master_to_pl_slave_inst/pl_to_pl_master_inst/xpm_nmu_mm_pl_to_pl_master_inst/S_AXI_nmu]
set pl_nsu_from_pl [get_noc_interfaces pl_master_to_pl_slave_inst/pl_to_pl_slave_inst/xpm_nsu_mm_pl_to_pl_slave_inst/M_AXI_nsu]

# Create NoC Connections
set conn1 [create_noc_connection -source $pl_nmu_to_pl -target $pl_nsu_from_pl]
                        
#LOCATION constraint for NMUs and NSUs
set_property LOCATION NOC_NMU512_X1Y1 $pl_nmu_to_pl
set_property LOCATION NOC_NSU512_X1Y6 $pl_nsu_from_pl

# Set QoS for NoC Connections
set_property -dict [list READ_BANDWIDTH 400 READ_AVERAGE_BURST 4 WRITE_BANDWIDTH 300 WRITE_AVERAGE_BURST 4] $conn1

# Set Aperture for NoC NSUs
set_property APERTURES [list {0x202_0000_0000:0x202_001F_FFFF}] $pl_nsu_from_pl

# Setting Exclusive Routing Group to AXI-MM  PL to PL NoC Path.
set_property EXCLUSIVE_ROUTING_GROUP mm_group $conn1

# Setting REMAP on PL to PL  AXI-MM NoC path
set_property REMAPS [list {0x0000_0000 0x202_0000_0000 4G}] $conn1

################################
# AXIS 
################################

# Get NoC Interfaces
set pl_nmu_0 [get_noc_interfaces pl_axis_MxN_top_inst/genblk1[0].xpm_nmu_strm_pl_to_pl/S_AXIS_nmu]
set pl_nmu_1 [get_noc_interfaces pl_axis_MxN_top_inst/genblk1[1].xpm_nmu_strm_pl_to_pl/S_AXIS_nmu]
set pl_nsu_0 [get_noc_interfaces pl_axis_MxN_top_inst/genblk2[0].xpm_nsu_strm_pl_to_pl/M_AXIS_nsu]
set pl_nsu_1 [get_noc_interfaces pl_axis_MxN_top_inst/genblk2[1].xpm_nsu_strm_pl_to_pl/M_AXIS_nsu]

# Create NoC Connections
set conn_00 [create_noc_connection -source $pl_nmu_0 -target $pl_nsu_0]
set conn_01 [create_noc_connection -source $pl_nmu_0 -target $pl_nsu_1]
set conn_10 [create_noc_connection -source $pl_nmu_1 -target $pl_nsu_0]
set conn_11 [create_noc_connection -source $pl_nmu_1 -target $pl_nsu_1]

# LOCATION constraint for NMUs and NSUs
set_property LOCATION NOC_NMU512_X1Y2 $pl_nmu_0
set_property LOCATION NOC_NMU512_X1Y5 $pl_nmu_1
set_property LOCATION NOC_NSU512_X1Y4 $pl_nsu_0
set_property LOCATION NOC_NSU512_X1Y3 $pl_nsu_1

# AXIS MxN TDEST IDs (BASE:HIGH)
set_property TDEST_ID 0x0:0x0 $pl_nsu_0
set_property TDEST_ID 0x1:0x1 $pl_nsu_1
