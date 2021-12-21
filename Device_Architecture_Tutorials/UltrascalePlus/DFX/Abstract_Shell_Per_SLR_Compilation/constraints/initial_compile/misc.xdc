
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


#Use the soft constraints to guide the placer to keep SLR crossing registers in the LAGUNA registers
set_property USER_SLL_REG true [get_cells -hier -filter {PRIMITIVE_GROUP == REGISTER && PARENT =~ "*ax*_register_slice*"}]
#Apply DONT_TOUCH on the SLR crossing registers so that they are not optimized away during opt_design
set_property DONT_TOUCH true [get_cells design_1_i/slr*_to_*_crossing/*_register_slice*]

#set_property USER_MAX_PROG_DELAY 1 [get_nets -of [get_pins design_1_i/static_region/clk_wiz_0/inst/clkout1_buf/O]]

#We are offloading some SLR crossing registers from LAGUNA back to fabric. These are on crossings away from center of device (clock root) as you might experience TXREG-RXREG hold violation otherwise
set_property USER_SLL_REG false [get_cells -hier -filter {PRIMITIVE_GROUP == REGISTER && PARENT =~ "*ax*_register_slice_0*"}] 
set_property USER_SLL_REG false [get_cells -hier -filter {PRIMITIVE_GROUP == REGISTER && PARENT =~ "*ax*_register_slice_2/*"}]  
set_property USER_SLL_REG false [get_cells -hier -filter {PRIMITIVE_GROUP == REGISTER && PARENT =~ "*ax*_register_slice_4/*"}]  

set_property USER_SLL_REG false [get_cells -hier -filter {PRIMITIVE_GROUP == REGISTER && PARENT =~ "*ax*_register_slice_30/*"}] 
set_property USER_SLL_REG false [get_cells -hier -filter {PRIMITIVE_GROUP == REGISTER && PARENT =~ "*ax*_register_slice_28/*"}] 
set_property USER_SLL_REG false [get_cells -hier -filter {PRIMITIVE_GROUP == REGISTER && PARENT =~ "*ax*_register_slice_26/*"}] 
set_property USER_SLL_REG false [get_cells -hier -filter {PRIMITIVE_GROUP == REGISTER && PARENT =~ "*ax*_register_slice_24/*"}] 
set_property USER_SLL_REG false [get_cells -hier -filter {PRIMITIVE_GROUP == REGISTER && PARENT =~ "*ax*_register_slice_22/*"}] 
set_property USER_SLL_REG false [get_cells -hier -filter {PRIMITIVE_GROUP == REGISTER && PARENT =~ "*ax*_register_slice_20/*"}] 

#IO properties for ports
set_property IOSTANDARD LVCMOS18 [get_ports ext_reset_in_0]
set_property PACKAGE_PIN K12 [get_ports ext_reset_in_0]

set_property IOSTANDARD LVCMOS18 [get_ports clk_in1_0]
set_property PACKAGE_PIN R14 [get_ports clk_in1_0]

#Locking the BSCAN in master SLR SLR1
set_property LOC CONFIG_SITE_X0Y1 [get_cells design_1_i/static_region/debug_bridge_0/inst/bs_switch/inst/BSCAN_SWITCH.N_EXT_BSCAN.bscan_inst/SERIES7_BSCAN.bscan_inst]

#Since CONFIG_SITE_X0Y1 is removed from rp_slr0, adjacent CLB column will also be removed from rp_slr0 pblock. We need to avoid any static logic placement in this island to avoid timing closure challenges
set_property PROHIBIT TRUE [get_sites -range SLICE_X220Y300:SLICE_X220Y359]
