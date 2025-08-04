#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#


create_pblock pblock_RP1
add_cells_to_pblock [get_pblocks pblock_RP1] [get_cells -quiet [list design_1_i/RP1]]
resize_pblock [get_pblocks pblock_RP1] -add {CLOCKREGION_X1Y2:CLOCKREGION_X1Y2}
set_property SNAPPING_MODE ON [get_pblocks pblock_RP1]



create_pblock pblock_RP2
add_cells_to_pblock [get_pblocks pblock_RP2] [get_cells -quiet [list design_1_i/RP2]]
resize_pblock [get_pblocks pblock_RP2] -add {CLOCKREGION_X3Y2:CLOCKREGION_X3Y2}
set_property SNAPPING_MODE ON [get_pblocks pblock_RP2]

create_pblock pblock_RP3
add_cells_to_pblock pblock_RP3 [get_cells [list design_1_i/RP3]] 
resize_pblock [get_pblocks pblock_RP3] -add {CLOCKREGION_X5Y2:CLOCKREGION_X5Y2}
set_property SNAPPING_MODE ON [get_pblocks pblock_RP3]

create_pblock pblock_RP4
add_cells_to_pblock pblock_RP4 [get_cells [list design_1_i/RP4]] 
resize_pblock [get_pblocks pblock_RP4] -add {CLOCKREGION_X7Y2:CLOCKREGION_X7Y2}
set_property SNAPPING_MODE ON [get_pblocks pblock_RP4]
