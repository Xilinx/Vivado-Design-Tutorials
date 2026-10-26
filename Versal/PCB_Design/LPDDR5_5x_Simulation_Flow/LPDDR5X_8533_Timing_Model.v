/*******************************************************************************
*
* Simple HyperLynx DDRx Controller Timing Model
* Created by the HLTimingModelWizard
* Wednesday, September 24, 2025  14:57:14
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

   integer DDRDataRate = 8530;

   real VdIVW = 0.080;
   real TdIVW1 = 35.00;
   real TdIVW2 = 18.00;
   real VrefToVrefLimit = 0;
   real MinSlewRateLimit = 1;
   real MaxSlewRateLimit = 12;
   real MaxEyeHeightLimit = 0.080;
   real OutputUncertaintyForPulseWidth = 0;


/*******************************************************************************
*  Timing relationships
*******************************************************************************/
specify

   // ADDR/CMD prelaunch window from next CK (1T or 2T)
   $delay(posedge ck, addr_cmd, -134.75, -99.25);
   // CTL prelaunch window from next CK (1T always)
   $delay(posedge ck, ctl, -134.75, -99.25);

   // DRAM Write cycles
   $delay(ck, dqs, -17.75, 17.75);
   $delay(posedge dqs, dq, -76.25, -40.75);
   $delay(posedge dqs, dm, -76.25, -40.75);

endspecify

endmodule
