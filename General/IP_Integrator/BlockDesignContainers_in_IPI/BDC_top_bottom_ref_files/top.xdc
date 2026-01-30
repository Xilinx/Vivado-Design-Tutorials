create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] [get_cells -quiet [list top_i/peripherals]]
resize_pblock [get_pblocks pblock_1] -add {SLICE_X0Y0:SLICE_X100Y61}
set_property SNAPPING_MODE ON [get_pblocks pblock_1]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
