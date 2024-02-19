#--------------------------------------------------------------------------------------
#
# Copyright(C) 2023 Advanced Micro Devices, Inc. All rights reserved.
#
# This document contains proprietary, confidential information that
# may be used, copied and/or disclosed only as authorized by a
# valid licensing agreement with Advanced Micro Devices, Inc. This copyright
# notice must be retained on all authorized copies.
#
# This code is provided "as is". Advanced Micro Devices, Inc. makes, and
# the end user receives, no warranties or conditions, express,
# implied, statutory or otherwise, and Advanced Micro Devices, Inc.
# specifically disclaims any implied warranties of merchantability,
# non-infringement, or fitness for a particular purpose.
#
#--------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------
#
# Description : This file contains additional floorplanning constraints using PBLOCKs.
#
#--------------------------------------------------------------------------------------

create_pblock nmu_pblock
create_pblock nsu_pblock
create_pblock dcmac0_pblock
create_pblock dcmac1_pblock

set nmu_cells    [ list  ]
set nsu_cells    [ list  ]
set dcmac0_cells [ list  ]
set dcmac1_cells [ list  ]

set main_hier_path "i_dcmac_0_exdes"
set bd_hier_path   "i_dcmac_0_exdes/noc_inst/bd_noc_i"

# constrain modules to pblocks
lappend  nmu_cells "$bd_hier_path/axis_seg_to_unseg"

lappend  nsu_cells "$bd_hier_path/axis_unseg_to_seg"

lappend  dcmac0_cells "$main_hier_path/i_dcmac_0_emu_gearbox_tx_0"
lappend  dcmac0_cells "$main_hier_path/i_dcmac_0_core_sniffer_0"
lappend  dcmac0_cells "$main_hier_path/i_dcmac_0_axis_pkt_gen_ts"

lappend  dcmac1_cells "$main_hier_path/i_dcmac_0_emu_gearbox_rx_1"
lappend  dcmac1_cells "$main_hier_path/i_dcmac_0_core_sniffer_1"
lappend  dcmac1_cells "$main_hier_path/i_dcmac_0_axis_pkt_mon_ts"


add_cells_to_pblock [ get_pblocks nmu_pblock ]    [ get_cells -quiet $nmu_cells ]
add_cells_to_pblock [ get_pblocks nsu_pblock ]    [ get_cells -quiet $nsu_cells ]
add_cells_to_pblock [ get_pblocks dcmac0_pblock ] [ get_cells -quiet $dcmac0_cells ]
add_cells_to_pblock [ get_pblocks dcmac1_pblock ] [ get_cells -quiet $dcmac1_cells ]

resize_pblock [ get_pblocks nmu_pblock ]    -add "CLOCKREGION_X3Y6:CLOCKREGION_X7Y6"
resize_pblock [ get_pblocks nsu_pblock ]    -add "CLOCKREGION_X2Y12:CLOCKREGION_X6Y13"
resize_pblock [ get_pblocks dcmac0_pblock ] -add "CLOCKREGION_X0Y5:CLOCKREGION_X9Y7"
resize_pblock [ get_pblocks dcmac1_pblock ] -add "CLOCKREGION_X0Y11:CLOCKREGION_X9Y13"

