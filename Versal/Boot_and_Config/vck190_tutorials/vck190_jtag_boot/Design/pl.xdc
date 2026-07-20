# © Copyright 2019 – 2020 Xilinx, Inc.
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

# pl.xdc: Constraints for the PL GPIO (2 push buttons, 4 LEDs, and 4 dip switches)
set_property PACKAGE_PIN G37 [get_ports push_button_0]
set_property PACKAGE_PIN G36 [get_ports push_button_1]

set_property PACKAGE_PIN H34 [get_ports led_0]
set_property PACKAGE_PIN J33 [get_ports led_1]
set_property PACKAGE_PIN K36 [get_ports led_2]
set_property PACKAGE_PIN L35 [get_ports led_3]

set_property PACKAGE_PIN J35 [get_ports dip_sw_0]
set_property PACKAGE_PIN J34 [get_ports dip_sw_1]
set_property PACKAGE_PIN H37 [get_ports dip_sw_2]
set_property PACKAGE_PIN H36 [get_ports dip_sw_3]

set_property IOSTANDARD LVCMOS18 [get_ports led_0]
set_property IOSTANDARD LVCMOS18 [get_ports led_1]
set_property IOSTANDARD LVCMOS18 [get_ports led_2]
set_property IOSTANDARD LVCMOS18 [get_ports led_3]

set_property IOSTANDARD LVCMOS18 [get_ports push_button_0]
set_property IOSTANDARD LVCMOS18 [get_ports push_button_1]

set_property IOSTANDARD LVCMOS18 [get_ports dip_sw_0]
set_property IOSTANDARD LVCMOS18 [get_ports dip_sw_1]
set_property IOSTANDARD LVCMOS18 [get_ports dip_sw_2]
set_property IOSTANDARD LVCMOS18 [get_ports dip_sw_3]
