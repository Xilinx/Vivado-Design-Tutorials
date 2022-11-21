# Copyright 2022 Xilinx Inc.
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


# Set the name of the project:
set project_name "vck190_emmc"

# Set the project device:
set device xcvc1902-vsva2197-2MP-e-S
set board_part xilinx.com:vck190:part0:3.0

# If using a UI layout, uncomment this line:
#set ui_name layout.ui


# Set the path to the directory we want to put the Vivado build in. Convention is <PROJECT NAME>_hw
set proj_dir ../Design/Hardware/${project_name}_hw
   
create_project -name ${project_name} -force -dir ${proj_dir} -part ${device}
set_property BOARD_PART ${board_part} [current_project]

# Source the BD file, BD naming convention is <PROJECT_NAME>_bd.tcl
source ${project_name}_bd.tcl


make_wrapper -files [get_files ${proj_dir}/${project_name}.srcs/sources_1/bd/design_1/design_1.bd] -top

add_files -norecurse ${proj_dir}/${project_name}.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

validate_bd_design
save_bd_design
close_bd_design design_1

# If using UI, uncomment these two lines:
#file mkdir ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/ui
#file copy -force ${ui_name} ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/ui/${ui_name}

open_bd_design ${proj_dir}/${project_name}.srcs/sources_1/bd/design_1/design_1.bd
set_property synth_checkpoint_mode None [get_files ${proj_dir}/${project_name}.srcs/sources_1/bd/design_1/design_1.bd]

