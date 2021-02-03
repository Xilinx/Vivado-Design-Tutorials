/*******************************************************************************
*
* Simple HyperLynx DDRx Controller Timing Model
* Created by the HLTimingModelWizard
* Tuesday, November 17, 2020  14:53:19
*
*******************************************************************************/

`timescale 1ps / 1ps       // do not change


// top-level module definition and interface ports
// ...the port names are HyperLynx standard names...do not change
module ddrxctl (
   output ck,
   output addr_cmd,
   output ctl,
   output dm,
   inout dq,
   inout dqs
);

   integer DDRDataRate = 3200;

   real EyeMaskHeightLimit = 0.11;
   real EyeMaskWidthLimit = 26;
   real VrefToVrefLimit = 0;
   real MinSlewRateLimit = 1;
   real MaxSlewRateLimit = 9;
   real MaxEyeHeightLimit = 0.11;
   real OutputUncertaintyForPulseWidth = 0;


/*******************************************************************************
*  Timing relationships
*******************************************************************************/
specify

   // ADDR/CMD prelaunch window from next CK (1T or 2T)
   $delay(posedge ck, addr_cmd, -353, -271);
   // CTL prelaunch window from next CK (1T always)
   $delay(posedge ck, ctl, -353, -271);

   // DRAM Write cycles
   $delay(ck, dqs, -41, 41);
   $delay(posedge dqs, dq, -197, -115);
   $delay(posedge dqs, dm, -197, -115);

endspecify

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
