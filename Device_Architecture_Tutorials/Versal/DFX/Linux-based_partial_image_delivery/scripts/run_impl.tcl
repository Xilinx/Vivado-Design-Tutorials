#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: X11
#

#Create a wrapper for Top BD
make_wrapper -files [get_files design_1.bd] -top
add_files -norecurse ./vivado_prj/axi_gpio_in_rp_versal.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1

##Add the pblock constraints
add_files -fileset constrs_1 -norecurse ./constraints/pblocks.xdc
import_files -fileset constrs_1 [get_files ./constraints/pblocks.xdc]

##Generate the targets
generate_target all [get_files design_1.bd]


##DFX Wizard to configure parent/child implementation
create_pr_configuration -name config_1 -partitions [list design_1_i/rp1:rp1rm3_inst_0 ]
create_pr_configuration -name config_2 -partitions [list design_1_i/rp1:rp1rm1_inst_0 ]
create_pr_configuration -name config_3 -partitions [list design_1_i/rp1:rp1rm2_inst_0 ]
set_property PR_CONFIGURATION config_1 [get_runs impl_1]
create_run child_0_impl_1 -parent_run impl_1 -flow {Vivado Implementation 2022} -pr_config config_2
create_run child_1_impl_1 -parent_run impl_1 -flow {Vivado Implementation 2022} -pr_config config_3

#Launch OOC synthesis of RMs, Parent Synthesis, Parent Implementation and Child Implementation
launch_runs impl_1 child_0_impl_1 child_1_impl_1 -to_step write_bitstream
wait_on_run child_1_impl_1

#Export the XSA from parent implementation
open_run impl_1
write_hw_platform -fixed -force -include_bit ./xsa/design.xsa

#Export static XSA for use in static-app and rp xsa for use in rprm-app
write_hw_platform -fixed -force -include_bit -static  ./xsa/static.xsa
write_hw_platform -fixed -force -include_bit -rp design_1_i/rp1  ./xsa/rp1rm3.xsa

close_design
         
#Export the XSA from child implementations, -rp is used for it to work with rprm-app
open_run child_0_impl_1
write_hw_platform -fixed -force -include_bit -rp design_1_i/rp1  ./xsa/rp1rm1.xsa

close_design

open_run child_1_impl_1
write_hw_platform -fixed -force -include_bit -rp design_1_i/rp1  ./xsa/rp1rm2.xsa

close_design

#Exit Vivado 
exit
