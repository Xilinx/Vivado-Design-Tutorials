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

# Create Vivado project
create_project vck190_ddr4 ../Design/Hardware/vck190_ddr4 -part xcvc1902-vsva2197-2MP-e-S

# Set the project device
set_property board_part xilinx.com:vck190:part0:3.0 [current_project]

# Source the BD file
source design_bd.tcl

make_wrapper -files [get_files ../Design/Hardware/vck190_ddr4/vck190_ddr4.srcs/sources_1/bd/design_1/design_1.bd] -top

add_files -norecurse ../Design/Hardware/vck190_ddr4/vck190_ddr4.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v

launch_runs impl_1 -to_step write_device_image -jobs 4

write_hw_platform -fixed -include_bit -force -file ../Design/Hardware/vck190_ddr4/design_1_wrapper.xsa

