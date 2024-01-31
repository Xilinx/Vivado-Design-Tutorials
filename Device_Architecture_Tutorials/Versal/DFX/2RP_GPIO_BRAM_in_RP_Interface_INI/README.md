<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Adaptive SoC DFX Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# 2 RP Design with NoC INI in the static-RM interface

***Version: Vivado 2023.2***

This Versal DFX design has 2 RPs:
- AXI GPIO in 1st RP
- AXI BRAM in 2nd RP

Each RP has 2 RMs: 
- RP1: RP1RM1, RP1RM2
- RP2: RP2RM1, RP2RM2

- GPIO in Static Region connected to Constant: 0XC00100F
- GPIO in RP1RM1 connected to Constant: 0XFACEFEED
- GPIO in RP1RM2 connected to Constant: 0XFEEDC0DE

- Static-RP interface is using NoC INI (Inter NoC Interconnect).
  Hence there is no need of additional DFX Decoupler in the static region.

Currently BRAMs are not initialized to any memory initialization value in the design.

<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
