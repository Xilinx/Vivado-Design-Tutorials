<table>
 <tr>
   <td align="center"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Versal DFX Tutorial</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>VNOC tile Sharing between 2 reconfigurable partitions</h1>
 </td>
 </tr>
</table>

# Introduction

This design demonstrates that VNOC clock tiles can be shared by two reconfigurable partitions. VNOC clock tiles are automatically included in the clock routing footprint of the reconfigurable partition by the tool. 

# Design Flow

Get familiar with the IPI BDC based DFX flow in Vivado using example design "2RP_GPIO_BRAM_in_RP_Interface_INI". Same design flow is used here too.

## IPI 

- There are 2 RPs in the design.
- Both RPs have internal clocking resources.
- This tutorial uses the same design used in tutorial "2RPs_Sharing_ClockRegion"

## Implementation 

- This is the pblocks used in the implementation. To include clocking sites from the bottom clock region in the pblock, notice that both pblocks has an island in the bottom clock region. 

<p align="center">
  <img src="./images/pblocks.png?raw=true" alt="pblocks"/>
</p>

- This is the schematic of two internal clocks of RPs.

<p align="center">
  <img src="./images/vnoc_sharing_schematic.png?raw=true" alt="vnoc_sharing_schematic"/>
</p>

-  This is the device view of a clock region being shared by two reconfiurable partitions: above and below the RCLK row. Notice that RCLK row is being shared by internal clock nets from both the partitions.

<p align="center">
  <img src="./images/vnoc_tile_sharing.png?raw=true" alt="vnoc_sharing"/>
</p>

- This is the magnified view of device view where the VNOC tile is being shared by clock nets of both partitions

<p align="center">
  <img src="./images/voc_shared_tile.png?raw=true" alt="voc_shared_tile"/>
</p>

<p align="center"><sup>Copyright&copy; 2021 Xilinx</sup></p>
