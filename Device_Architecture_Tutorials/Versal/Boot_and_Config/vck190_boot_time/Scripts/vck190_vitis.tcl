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

proc vck190_create {} {
	setws ../Design/Software/Vitis
	platform create -name vck190_wrapper -hw ../Design/Software/vck190_wrapper.xsa
	
	domain create -name psv_pmc_0 -os standalone -proc versal_cips_0_pspmc_0_psv_pmc_0
	bsp setlib -name xilffs -ver 4.5
	bsp setlib -name xilloader -ver 1.4
	bsp setlib -name xilpdi -ver 1.3
	bsp setlib -name xilplmi -ver 1.4
	bsp setlib -name xilpm -ver 3.4
	bsp setlib -name xilpuf -ver 1.3
	bsp setlib -name xilsecure -ver 4.5
	bsp setlib -name xilsem -ver 1.3
	bsp regenerate
	
	domain create -name psv_psm_0 -os standalone -proc versal_cips_0_pspmc_0_psv_psm_0
#	bsp config stdin none
#	bsp config stdout none
	bsp regenerate

	domain create -name psv_cortexa72_0 -os standalone -proc versal_cips_0_pspmc_0_psv_cortexa72_0

	app create -name plm -sysproj vck190_system -platform vck190_wrapper -domain psv_pmc_0 -template {versal PLM} -lang C
	app create -name psmfw -sysproj vck190_system  -platform vck190_wrapper -domain psv_psm_0 -template {versal PSM Firmware} -lang C
	app create -name hello_a72_0 -sysproj vck190_system -platform vck190_wrapper -domain psv_cortexa72_0 -template {Hello World} -lang C	
}

proc vck190_build {} {
	setws ../Design/Software/Vitis
	app build -name plm
	app build -name psmfw
	app build -name hello_a72_0
}

vck190_create
vck190_build
