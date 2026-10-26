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

create_project kmeans_project_zc1657 ./kmeans_project_zc1657 -part xczu19eg-ffvb1517-2-i
set_property  ip_repo_paths  ../kernel/kmeans_ip_from_vitis_zc1657 [current_project]
update_compile_order -fileset sources_1
update_ip_catalog
source ../../bd/design_21_zc1657.tcl
add_files -fileset constrs_1 -norecurse ../../xdc/const_zc1657.xdc
make_wrapper -files [get_files ./kmeans_project_zc1657/kmeans_project_zc1657.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse ./kmeans_project_zc1657/kmeans_project_zc1657.gen/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1
set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]

