create_pblock pblock_rp1
add_cells_to_pblock [get_pblocks pblock_rp1] [get_cells -quiet [list design_1_i/rp1]]
resize_pblock [get_pblocks pblock_rp1] -add {CLOCKREGION_X3Y2:CLOCKREGION_X3Y2}
set_property SNAPPING_MODE ON [get_pblocks pblock_rp1]

create_pblock pblock_rp2
add_cells_to_pblock [get_pblocks pblock_rp2] [get_cells -quiet [list design_1_i/rp2]]
resize_pblock [get_pblocks pblock_rp2] -add {CLOCKREGION_X6Y2:CLOCKREGION_X7Y2}
set_property SNAPPING_MODE ON [get_pblocks pblock_rp2]

