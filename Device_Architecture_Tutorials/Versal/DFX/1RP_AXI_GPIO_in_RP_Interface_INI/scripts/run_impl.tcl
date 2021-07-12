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

#Create a wrapper for Top BD
make_wrapper -files [get_files design_1.bd] -top
add_files -norecurse ../vivado_prj/axi_gpio_in_rp_versal.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1

##Add the pblock constraints
add_files -fileset constrs_1 -norecurse ../constraints/pblocks.xdc
import_files -fileset constrs_1 [get_files ../constraints/pblocks.xdc]

##Generate the targets
generate_target all [get_files design_1.bd]


##DFX Wizard to configure parent/child implementation
create_pr_configuration -name config_1 -partitions [list design_1_i/rp1:rp1rm1_inst_0 ]
create_pr_configuration -name config_2 -partitions [list design_1_i/rp1:rp1rm2_inst_0 ]
set_property PR_CONFIGURATION config_1 [get_runs impl_1]
create_run child_0_impl_1 -parent_run impl_1 -flow {Vivado Implementation 2021} -pr_config config_2

##Launch OOC synthesis of RMs, Parent Synthesis, Parent Implementation and Child Implementation
launch_runs impl_1 child_0_impl_1 -to_step write_bitstream -jobs 8
wait_on_run child_0_impl_1


#Export the XSA from parent implementation
open_run impl_1
write_hw_platform -fixed -force  ../xsa/design_1_wrapper_impl_1.xsa
close_design
         
#Export the XSA from child implementation
open_run child_0_impl_1
write_hw_platform -fixed -force ../xsa/design_1_wrapper_child_0_impl_1.xsa
close_design
                     

 

