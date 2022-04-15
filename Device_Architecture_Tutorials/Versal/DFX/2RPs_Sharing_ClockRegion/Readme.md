<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal DFX Tutorial</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Clock Region Sharing between 2 reconfigurable partitions</h1>
 </td>
 </tr>
</table>

# Introduction

- This design desmonstrates that a clock region in Versal can be shared among multiple reconfigurable partitions. 
- Reconfigurable partition pblocks with both of them having internal clocking resources can share one clock region. 
- The RCLK row in the clock region is shared between two RPs. 
- User can range pblocks one above RCLK row and one below RCLK row of the clock region.
- RCLK sharing is taken care by the DFX flow in Vivado. User cannot range RCLK sites in their pblock.

# Design Flow

Get familiar with the IPI BDC based DFX flow in Vivado using example design "2RP_GPIO_BRAM_in_RP_Interface_INI". Same design flow is used here too.

## IPI 

- There are 2 RPs in the design.
- Both RPs have internal clocking resources.


<p align="center">
  <img src="./images/ipi.png?raw=true" alt="ipi"/>
</p>

## Implementation 

- This is the pblocks used in the implementation. As you can see, Pblocks for two reconfigurable partitions share one clock region: above and below the RCLK row.

<p align="center">
  <img src="./images/pblocks.png?raw=true" alt="pblocks"/>
</p>

- This is the schematic of two internal clocks of RPs.

<p align="center">
  <img src="./images/rclk_sharing_schematic.PNG?raw=true" alt="rclk_sharing_schematic"/>
</p>

-  This is the device view of a clock region being shared by two reconfiurable partitions: above and below the RP. Notice that RCLK row is being shared by internal clock nets from both the partitions.

<p align="center">
  <img src="./images/rclk_sharing.PNG?raw=true" alt="rclk_sharing"/>
</p>

- This is the magnified view of device view where RCLK row is being shared by internal clocks of two RPs

<p align="center">
  <img src="./images/rclk_close_up.PNG?raw=true" alt="rclk_close_up"/>
</p>

<p align="center"><sup>Copyright&copy; 2021 Xilinx</sup></p>
