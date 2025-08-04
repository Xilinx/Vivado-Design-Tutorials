# © Copyright 2021 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

open_project kmeans_rtl_vitis_vck190
set_top kmeans_top
add_files ../../hls/kmeans_vitis.cpp
open_solution solution1 -flow_target vivado
set_part xcvc1902-vsva2197-2MP-e-S-es1
create_clock -period 5 -name default
set_clock_uncertainty 0.050
csynth_design
export_design -flow impl -rtl verilog -format ip_catalog -vendor xilinx.com -output ./kmeans_ip_from_vitis_vck190/kmeans_top.zip 
exit
