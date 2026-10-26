# Copyright © Advanced Micro Devices, Inc., or its affiliates.
# SPDX-License-Identifier: MIT

create_clock -period 2.000 -name clk -waveform {0.000 1.000} [get_ports clk]
create_clock -period 2.000 -name clk_g -waveform {0.000 1.000} [get_ports clk_g]

set rst_setup       5
set rst_hold        7
set ce_max_delay    5

set_multicycle_path $rst_setup -setup -from [get_cells generate_clk_gating_rst*reg_reset_1_7_reg*] -to [get_cells *regs*[0][*]]
set_multicycle_path $rst_hold -hold -from [get_cells generate_clk_gating_rst*reg_reset_1_7_reg*] -to [get_cells *regs*[0][*]]

set_multicycle_path $rst_setup -setup -from [get_cells generate_clk_gating_rst*reg_reset_3_4_reg*] -to [get_cells *regs*[1][*]]
set_multicycle_path $rst_hold -hold -from [get_cells generate_clk_gating_rst*reg_reset_3_4_reg*] -to [get_cells *regs*[1][*]]

set_multicycle_path $rst_setup -setup -from [get_cells generate_clk_gating_rst*reg_reset_7_reg*] -to [get_cells *regs*[2][*]]
set_multicycle_path $rst_hold -hold -from [get_cells generate_clk_gating_rst*reg_reset_7_reg*] -to [get_cells *regs*[2][*]]

create_pblock pblock_SLR0
resize_pblock [get_pblocks pblock_SLR0] -add {SLR0:SLR0}
set_property IS_SOFT FALSE [get_pblocks pblock_SLR0]
create_pblock pblock_SLR1
resize_pblock [get_pblocks pblock_SLR1] -add {SLR1:SLR1}
set_property IS_SOFT FALSE [get_pblocks pblock_SLR1]
create_pblock pblock_SLR2
resize_pblock [get_pblocks pblock_SLR2] -add {SLR2:SLR2}
set_property IS_SOFT FALSE [get_pblocks pblock_SLR2]

add_cells_to_pblock pblock_SLR0 [get_cells *regs*[0][*]]
add_cells_to_pblock pblock_SLR0 [get_cells *reg_clk_g_rst*]
add_cells_to_pblock pblock_SLR0 [get_cells *reg_reset_1_reg*]
add_cells_to_pblock pblock_SLR0 [get_cells *reg_reset_2_reg*]
add_cells_to_pblock pblock_SLR0 [get_cells *reg_reset_3_reg*]
add_cells_to_pblock pblock_SLR0 [get_cells *reg_reset_1_2_reg*]
add_cells_to_pblock pblock_SLR0 [get_cells *reg_reset_1_3_reg*]
add_cells_to_pblock pblock_SLR0 [get_cells *reg_reset_1_4_reg*]
add_cells_to_pblock pblock_SLR0 [get_cells *reg_reset_1_5_reg*]
add_cells_to_pblock pblock_SLR0 [get_cells *reg_reset_1_6_reg*]
add_cells_to_pblock pblock_SLR0 [get_cells *reg_reset_1_7_reg*]

add_cells_to_pblock pblock_SLR1 [get_cells *regs*[1][*]]
add_cells_to_pblock pblock_SLR1 [get_cells *reg_reset_4_reg*]
add_cells_to_pblock pblock_SLR1 [get_cells *reg_reset_5_reg*]
add_cells_to_pblock pblock_SLR2 [get_cells *reg_reset_6_reg*]
add_cells_to_pblock pblock_SLR1 [get_cells *reg_reset_3_1_reg*]
add_cells_to_pblock pblock_SLR1 [get_cells *reg_reset_3_2_reg*]
add_cells_to_pblock pblock_SLR1 [get_cells *reg_reset_3_3_reg*]
add_cells_to_pblock pblock_SLR1 [get_cells *reg_reset_3_4_reg*]

add_cells_to_pblock pblock_SLR2 [get_cells *regs*[2][*]]
add_cells_to_pblock pblock_SLR2 [get_cells *reg_reset_7_reg*]

set clk_period [get_property PERIOD [get_clocks clk]]
set_max_delay -from [get_pins *reg_clk_en_2_reg/C] -to [get_pins *bufgce_clk_g/CE] [expr $clk_period * $ce_max_delay]
