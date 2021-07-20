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

proc design_1_create {} {
	setws ../Software/Vitis
	platform create -name design_1_wrapper -hw ../Software/design_1_wrapper.xsa	
	
	domain create -name psv_cortexa72_0 -os standalone -proc psv_cortexa72_0

	app create -name perf_axi_tg -sysproj vck190_system -platform design_1_wrapper -domain psv_cortexa72_0 -template {Hello World} -lang C	
	file copy -force ../Software/Vitis/helloworld.c ../Software/Vitis/perf_axi_tg/src/.
}

proc design_1_build {} {
	setws ../Software/Vitis
	app build -name perf_axi_tg
}

design_1_create
design_1_build
