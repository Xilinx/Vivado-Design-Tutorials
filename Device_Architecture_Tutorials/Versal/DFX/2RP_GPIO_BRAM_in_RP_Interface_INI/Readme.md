<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal DFX Tutorial</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>2 RP Design with NoC INI in the static-RM interface</h1>
 </td>
 </tr>
</table>

This Versal DFX design has 2 RPs:
- AXI GPIO in 1st RP
- AXI BRAM in 2ns RP

Each RP has 2 RMs: 
- RP1: RP1RM1, RP1RM2
- RP2: RP2RM1, RP2RM2

- GPIO in Static Region connected to Constant: 0XC00100F
- GPIO in RP1RM1 connected to Constant: 0XFACEFEED
- GPIO in RP1RM2 connected to Constant: 0XFEEDC0DE

- Static-RP interface is using NoC INI (Inter NoC Interconnect).
  Hence there is no need of additional DFX Decoupler in the static region.

Currently BRAMs are not initialized to any memory initialization value in the design.
<p align="center"><sup>Copyright&copy; 2021 Xilinx</sup></p>
