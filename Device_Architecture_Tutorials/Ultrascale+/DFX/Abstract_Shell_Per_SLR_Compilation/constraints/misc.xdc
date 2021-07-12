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

#IO properties for ports
set_property IOSTANDARD LVCMOS18 [get_ports ext_reset_in_0]
set_property PACKAGE_PIN K12 [get_ports ext_reset_in_0]

set_property IOSTANDARD LVCMOS18 [get_ports clk_in1_0]
set_property PACKAGE_PIN R14 [get_ports clk_in1_0]


