#
# Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

create_pblock pblock_rp1
add_cells_to_pblock [get_pblocks pblock_rp1] [get_cells -quiet [list design_1_i/rp1]]
resize_pblock [get_pblocks pblock_rp1] -add {CLOCKREGION_X3Y2}
set_property SNAPPING_MODE ON [get_pblocks pblock_rp1]


