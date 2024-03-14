<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Adaptive SoC DFX Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# VNOC tile Sharing between 2 Reconfigurable Partitions

***Version: Vivado 2023.2***

## Introduction

This design demonstrates that VNOC clock tiles can be shared by two reconfigurable partitions. VNOC clock tiles are automatically included in the clock routing footprint of the reconfigurable partition by the tool. 

## Design Flow

Become familiar with the IPI BDC based DFX flow in an AMD Vivado&trade; using example design "2RP_GPIO_BRAM_in_RP_Interface_INI." The same design flow is used here.

### IPI 

- There are two RPs in the design.
- Both RPs have internal clocking resources.
- This tutorial uses the same design used in the tutorial "2RPs_Sharing_ClockRegion."

### Implementation 

- These are the pblocks used in the implementation. To include clocking sites from the bottom clock region in the pblock, notice that both pblocks have an island in the bottom clock region. 

<p align="center">
  <img src="./images/pblocks.png?raw=true" alt="pblocks"/>
</p>

- This is the schematic of two internal clocks of RPs.

<p align="center">
  <img src="./images/vnoc_sharing_schematic.png?raw=true" alt="vnoc_sharing_schematic"/>
</p>

-  This is the device view of a clock region being shared by two reconfiurable partitions: above and below the RCLK row. The RCLK row is shared by internal clock nets from both the partitions.

<p align="center">
  <img src="./images/vnoc_tile_sharing.png?raw=true" alt="vnoc_sharing"/>
</p>

- This is the magnified view of device view where the VNOC tile is being shared by clock nets of both partitions.

<p align="center">
  <img src="./images/voc_shared_tile.png?raw=true" alt="voc_shared_tile"/>
</p>


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
