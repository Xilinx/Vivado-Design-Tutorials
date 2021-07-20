# #########################################################################
#© Copyright 2021 Xilinx, Inc.

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
# ###########################################################################


set_clock_groups -asynchronous -group [get_clocks -of [get_pins design_1_i/static_region/versal_cips_0/inst/pspmc_0/inst/buffer_pl_clk_0.PL_CLK_0_BUFG/O]] -group [get_clocks -of [get_pins design_1_i/rp1/clk_wizard_0/inst/clock_primitive_inst/BUFG_clkout1_inst/O]]
set_clock_groups -asynchronous -group [get_clocks -of [get_pins design_1_i/static_region/versal_cips_0/inst/pspmc_0/inst/buffer_pl_clk_0.PL_CLK_0_BUFG/O]] -group [get_clocks -of [get_pins design_1_i/rp2/clk_wizard_1/inst/clock_primitive_inst/BUFG_clkout1_inst/O]]
