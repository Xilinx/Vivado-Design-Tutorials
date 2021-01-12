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
set fe  [open RESULT.csv w]
puts $fe "TG_NUM,TEST_CASE,READ_EFFICIENCY,WRITE_EFFICIENCY,READ_BW,WRITE_BW,RD_MIN_LATENCY,RD_MAX_LATENCY,WR_MIN_LATENCY,WR_MAX_LATENCY,READ_BEATS_CAPTURED,WRITE_BEATS_CAPTURED,READ_REQUESTS_CAPTURED,WRITE_REQUESTS_CAPTURED"
close $fe
