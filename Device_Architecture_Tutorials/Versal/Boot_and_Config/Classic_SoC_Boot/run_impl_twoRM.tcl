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
make_wrapper -files [get_files project_1/project_1.srcs/sources_1/bd/top/top.bd] -top
add_files -norecurse project_1/project_1.gen/sources_1/bd/top/hdl/top_wrapper.v
#update_compile_order -fileset sources_1


##Generate the targets and synthesize IP within top
generate_target all [get_files project_1/project_1.srcs/sources_1/bd/top/top.bd]

catch { config_ip_cache -export [get_ips -all top_axi_noc_0_0] }
export_ip_user_files -of_objects [get_files project_1/project_1.srcs/sources_1/bd/top/top.bd] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] project_1/project_1.srcs/sources_1/bd/top/top.bd]
launch_runs top_axi_noc_0_0_synth_1 -jobs 2
wait_on_run top_axi_noc_0_0_synth_1
update_compile_order -fileset sources_1


##DFX Wizard to configure parent/child implementation
create_pr_configuration -name config_1 -partitions [list top_i/PL:bram_bd_inst_0 ]
create_pr_configuration -name config_2 -partitions [list top_i/PL:timer_bd_inst_0 ]
set_property PR_CONFIGURATION config_1 [get_runs impl_1]
create_run child_0_impl_1 -parent_run impl_1 -flow {Vivado Implementation 2021} -pr_config config_2


##Launch OOC synthesis of RMs, Parent Synthesis, Parent Implementation and Child Implementation
launch_runs impl_1 child_0_impl_1 -to_step write_device_image -jobs 2
wait_on_run child_0_impl_1


#Export the XSA from parent implementation
open_run impl_1
write_hw_platform -fixed -include_bit -force -file project_1/project_1.runs/impl_1/top_wrapper.xsa
close_design
         
#Export the XSA from child implementation
open_run child_0_impl_1
write_hw_platform -fixed -include_bit -force -file project_1/project_1.runs/child_0_impl_1/top_wrapper.xsa
close_design
                      

