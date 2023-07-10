<table width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal Architecture-Specific Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

### Boot and Configuration

 <table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Tutorial</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="center"><a href="./Boot_and_Config/JTAG_Boot/">JTAG Boot</a></td>
 <td>This tutorial demonstrates the basics of booting your Versal design via JTAG for testing and development</td>
 </tr>
 </table>


### Dynamic Function eXchange (DFX)

 <table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Tutorial</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="center"><a href="./DFX/1RP_AXI_GPIO_in_RP_Interface_INI/"> Single Reconfigurable Partition Design using Block Design Container </a></td>
 <td>This tutorial introduces the block design container feature in Vivado and how it can be leveraged to create DFX designs in Versal</td>
 </tr>
  <tr>
 <td align="center"><a href="./DFX/2RP_GPIO_BRAM_in_RP_Interface_INI/">Multiple Reconfigurable Partitions Design using Block Design Container</a></td>
 <td>This tutorial demonstrates how to create design with multiple reconfigurable partitions using block design container.</td>
 </tr>
 <tr>
 <td align="center"><a href="./DFX/2RPs_Sharing_ClockRegion/"> Clock Region Shared by two Reconfigurable Partitions</a></td>
 <td>This tutorial demonstrates a floorplan in Versal that allows sharing a clock region b/w two reconfigurable partitions.</td>
 </tr>
  <tr>
 <td align="center"><a href="./DFX/Debug_JTAG_HSDP/"> JTAG and HSDP based debugging for Versal DFX Designs</a></td>
 <td>This tutorial demonstrates a debug methodology for DFX designs in Versal using JTAG and HSDP.</td>
 </tr>
 <tr>
 <td align="center"><a href="./DFX/Embedded_IOB_inside_RM/"> Embedded IOBs inside the Reconfigurable Partition</a></td>
 <td>This tutorial demonstrates a methodology to insert embedded IOBs inside reconfigurable partition using utility buffer IP in Vivado.</td>
 </tr>
 <tr>
 <td align="center"><a href="./DFX/NoC_INI_Static_RM_Interface/"> NoC connections in DFX designs</a></td>
 <td>This tutorial introduces multiple NoC connectivity options for DFX designs to transfer data b/w static and reconfiurable partition.</td>
 </tr>
  <tr>
 <td align="center"><a href="./DFX/Update_BD_Boundary/"> Update BD Boundary for DFX Designs</a></td>
 <td>If one of the reconfigurable module is modified to add or remove ports, all the remaining reconfigurable modules associated with that partition can also be updated to match with exact same ports using the command called "update_bd_boundaries".</td>
 </tr>
   <tr>
 <td align="center"><a href="./DFX/VNOC_Sharing/"> VNOC column sharing b/w multiple RPs</a></td>
 <td>This design desmonstrates that VNOC clock tiles can be shared by two reconfigurable partitions. VNOC clock tiles are automatically included in the clock routing footprint of the reconfigurable partition by the tool.</td>
 </tr>
 </table>

### Network-on-Chip (NoC) and DDR Memory Design and Optimization

 <table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Tutorial</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="center"><a href="./NoC_DDRMC/Intro_Design_Flow/">NoC and DDRMC Design Flow Introduction</a></td>
 <td>This tutorial introduces the basic concepts, tools, and techniques of the NoC and DDR memory controller design flow in Vivado</td>
 </tr>
  <tr>
 <td align="center"><a href="./NoC_DDRMC/Performance_Tuning/">NoC and DDRMC Performance Tuning</a></td>
 <td>Learn how to tune your NoC and DDR memory controller designs to deliver optimum performance for your designs.</td>
 </tr>
 <tr>
 <td align="center"><a href="./NoC_DDRMC/03-Multiple_DDRMC/">NoC and Multiple DDRMCs</a></td>
 <td>Learn how to instantiate multiple DDRMCs in one design and how to interleave DDRMCs.</td>
 </tr>
 <tr>
 <td align="center"><a href="./NoC_DDRMC/04-NoC_Data_Movement_Comparison/">NoC Data Movement Comparison</a></td>
 <td>This tutorial uses a complex design example to demonstrate how the NoC simplifies the design process for on-chip data movement.
</td>
 </tr>
 <tr>
 <td align="center"><a href="./NoC_DDRMC/Versal_Performance_AXI_Traffic_Generator/">Versal NoC Performance AXI Traffic Generator</a></td>
 <td>The Performance AXI Traffic Generator is intended for modeling traffic masters in Versal™ ACAP designs for performance evaluation of network on chip (NoC) based solutions.
</td>
 </tr>
  <tr>
 <td align="center"><a href="./NoC_HBMC/">NoC and HBMC Design Flow Introduction</a></td>
 <td>This tutorial introduces the basic concepts, tools, and techniques of the NoC and HBM controller design flow in Vivado along with running the design on VHK158
</td>
 </tr>
  </table>

 ### PCB Design

 <table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Tutorial</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="center"><a href="./PCB_Design/Memory_Pinouts/">Memory Pinouts</a></td>
 <td>This tutorial introduces best pracices for working with DDR memory pinouts in Versal.</td>
 </tr>
 <tr>
 <td align="center"><a href="./PCB_Design/Hyperlynx_DDRx_Timing_Models/">Hyperlynx DDRx Timing Models</a></td>
 <td>How to perform DDRx signal integrity simulations with the Mentor Graphics DDRx Wizard.</td>
 </tr>
 </table>

 ### AI Engine

 AI Engines are supported through the Vitis&trade; Unified Development Environment. Please see the
 [Vitis In-Depth Tutorial](http://github.com/Xilinx/Vitis-In-Depth-Tutorial) for more information.

<p align="center"><sup>Copyright&copy; 2021 Xilinx</sup></p>
