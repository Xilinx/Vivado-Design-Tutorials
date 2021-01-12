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
#
proc reset { t } {
  set fs  [open sf_rst.tcl w]
  set sraddr 4000
  set sr_addr [concat 000$t$sraddr]
  puts $fs "write_reg $sr_addr 0000_0000"
  puts $fs "write_reg $sr_addr 0000_0001"
  close $fs
  source sf_rst.tcl
}


