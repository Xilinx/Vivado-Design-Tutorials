#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#


set_clock_groups -asynchronous -group [get_clocks -of [get_pins design_1_i/static_region/versal_cips_0/inst/pspmc_0/inst/buffer_pl_clk_0.PL_CLK_0_BUFG/O]] -group [get_clocks -of [get_pins design_1_i/rp1/clk_wizard_0/inst/clock_primitive_inst/BUFG_clkout1_inst/O]]
set_clock_groups -asynchronous -group [get_clocks -of [get_pins design_1_i/static_region/versal_cips_0/inst/pspmc_0/inst/buffer_pl_clk_0.PL_CLK_0_BUFG/O]] -group [get_clocks -of [get_pins design_1_i/rp2/clk_wizard_1/inst/clock_primitive_inst/BUFG_clkout1_inst/O]]
