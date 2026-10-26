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


source project_top_sd1.tcl

launch_runs synth_1 -jobs 10
wait_on_run synth_1
launch_runs impl_1 -to_step write_device_image -jobs 10
wait_on_run impl_1
open_run impl_1
write_hw_platform -fixed -include_bit -force -file ../Design/Software/sd1/vck190_wrapper_sd1.xsa
close_project

source project_top_emmc.tcl

launch_runs synth_1 -jobs 10
wait_on_run synth_1
launch_runs impl_1 -to_step write_device_image -jobs 10
wait_on_run impl_1
open_run impl_1
write_hw_platform -fixed -include_bit -force -file ../Design/Software/emmc/vck190_wrapper_emmc.xsa
close_project