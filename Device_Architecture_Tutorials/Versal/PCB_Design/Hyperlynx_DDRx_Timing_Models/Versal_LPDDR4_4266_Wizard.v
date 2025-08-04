`timescale 1ps / 1ps


module ddrxctl (
output ck,
output ca,
output cs,
output cke,
output dm,
inout dq,
inout dqs
);

integer DDRDataRate = 4266;
specify
$delay(posedge ck, ca, -275, -193);
$delay(posedge ck, cs, -275, -193);
$delay(posedge ck, cke, -275, -193);
$delay(ck, dqs, -41, 41);
$delay(posedge dqs, dq, -158, -76);
$delay(posedge dqs, dm, -158, -76);
endspecify

real EyeMaskHeightLimit = 0.12;
real EyeMaskWidthLimit = 30;
real VrefToVrefLimit = 0;
real MaxEyeHeightLimit = 0.12;
real MinSlewRateLimit = 1;
real MaxSlewRateLimit = 7;
real ExtraOutputUncertaintyForPulseWidth = 0;
real OutputUncertaintyForPulseWidth_CA = 0;

endmodule

/*Copyright 2020 Xilinx, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.

You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/