<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Adaptive SoC DFX Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# Clock Region Sharing between 2 reconfigurable partitions

***Version: Vivado 2023.2***



## Introduction

- This design demonstrates that a clock region in Versal can be shared among multiple reconfigurable partitions (RP). 
- Reconfigurable partition pblocks both having internal clocking resources can share one clock region. 
- The RCLK row in the clock region is shared between two RPs. 
- Users can range pblocks one above RCLK row and one below RCLK row of the clock region.
- RCLK sharing is automatically taken care by the DFX flow in Vivado. Users cannot range RCLK sites in their pblock.

## Design Flow

Become familiar with the IPI BDC based DFX flow in Vivado using example design "2RP_GPIO_BRAM_in_RP_Interface_INI." The same design flow is used in this tutorial.

### IPI 

- There are 2 RPs in the design.
- Both RPs have internal clocking resources.


<p align="center">
  <img src="./images/ipi.png?raw=true" alt="ipi"/>
</p>

### Implementation 

- These are the pblocks used for implementation. As you can see, Pblocks for the two reconfigurable partitions share one clock region: above and below the RCLK row, which is the boundary between the two.

<p align="center">
  <img src="./images/pblocks.png?raw=true" alt="pblocks"/>
</p>

- This is the schematic of the two internal clocks of the RPs.

<p align="center">
  <img src="./images/rclk_sharing_schematic.PNG?raw=true" alt="rclk_sharing_schematic"/>
</p>

-  This is the device view of a clock region being shared by two reconfiurable partitions: above and below the RP. Notice that RCLK row is being shared by internal clock nets from both partitions.

<p align="center">
  <img src="./images/rclk_sharing.PNG?raw=true" alt="rclk_sharing"/>
</p>

- This is the magnified view of the device view where the RCLK row is being shared by internal clocks of two RPs

<p align="center">
  <img src="./images/rclk_close_up.PNG?raw=true" alt="rclk_close_up"/>
</p>


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
