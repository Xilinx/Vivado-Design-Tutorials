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

	tar -set -filter {name =~ "Versal *"}
	# Enable ISO
	mwr -force 0xf1120000 0xffbff
	# Switch boot mode
	mwr 0xf1260200 0x2100
	mrd 0xf1260200
	# Set MULTIBOOT address to 0
	mwr -force 0xF1110004 0x0
	# SYSMON_REF_CTRL is switched to NPI by user PDI so ensure its
	#  switched back
	mwr -force 0xF1260138 0
	mwr -force 0xF1260320 0x77
	# Perform reset
	tar -set -filter {name =~ "PMC"}
	rst
#	after 10
#	tar -set -filter {name =~ "Versal *"}
#	mrd -force 0xF1120000
