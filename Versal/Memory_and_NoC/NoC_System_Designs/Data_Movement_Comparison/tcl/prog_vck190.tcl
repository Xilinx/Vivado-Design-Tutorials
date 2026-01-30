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

proc prog_ep_target { ep_target } {
	connect
	targets -set -nocase -filter {name =~ "PMC"}
	rst -type ps-por
	after 10
	targets -set -nocase -filter {name =~ "*Versal**"}
	mwr 0xf1260200 0x0100
	mrd 0xf1260200
	mwr -force 0xF1260138 0
	# SYSMON_REF_CTRL is switched to NPI by user PDI so ensure its switched back
	targets -set -nocase -filter {name =~ "PMC"}
	rst
	# Toggle reset to continue PDI download on PMC
	after 10
	targets -set -nocase -filter {name =~ "*Versal**"}
	mrd -force 0xF1120000
	configparams default-config-timeout 30000
	targets -set -nocase -filter {name =~ "PMC"}
	puts "Programming VCK190 target: $ep_target"
	device program $ep_target
	exit
}

