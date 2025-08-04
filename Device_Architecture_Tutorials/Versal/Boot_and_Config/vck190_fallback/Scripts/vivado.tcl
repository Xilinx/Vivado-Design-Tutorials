################################################################
# Copyright 2020 Xilinx Inc.						    
#    									    
# Licensed under the Apache License, Version 2.0 (the "License");           
# you may not use this file except in compliance with the License.          
# You may obtain a copy of the License at                                   
#                                                                           
# http://www.apache.org/licenses/LICENSE-2.0                                
#									    
# Unless required by applicable law or agreed to in writing, software       
# distributed under the License is distributed on an "AS IS" BASIS,         
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  
# See the License for the specific language governing permissions and       
# limitations under the License.					    
################################################################


# Set the name of the project:
set project_name vck190_fallback

# Set the project device:
set device xcvc1902-vsva2197-2MP-e-S


# Set the path to the directory we want to put the Vivado build in. Convention is <PROJECT NAME>_hw
set proj_dir ../Design/Hardware/${project_name}_hw


create_project -name ${project_name} -force -dir ${proj_dir} -part ${device}

# Source the BD file, BD naming convention is <PROJECT_NAME>_bd.tcl
source ${project_name}_bd.tcl

#Set the path to the constraints file:
set impl_const ../Design/Hardware/constraints/constraints.xdc

if [file exists ${impl_const}] {
    add_files -fileset constrs_1 -norecurse ./${impl_const}
    set_property used_in_synthesis true [get_files ./${impl_const}]
}


save_bd_design
validate_bd_design
save_bd_design
close_bd_design ${project_name}

make_wrapper -files [get_files ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd] -top

add_files -norecurse ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/hdl/${project_name}_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

launch_runs impl_1 -to_step write_device_image -jobs 24
wait_on_run impl_1
write_hw_platform -fixed -include_bit -force -file versal_fallback_final/versal_fallback_wrapper.xsa