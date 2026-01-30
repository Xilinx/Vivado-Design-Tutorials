<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Adaptive SoC Architecture Tutorials</h1>
    <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
    </td>
 </tr>
</table>

# Versal Architecture-Specific Tutorials


## Dynamic Function eXchange (DFX)

This repository contains tutorials that augment the fundamental tutorials found in the Dynamic Function eXchange Tutorial Guide [UG947](https://docs.amd.com/r/en-US/ug947-vivado-partial-reconfiguration-tutorial). These examples show design flow features that
are common to all devices that support DFX. Additional DFX tutorials can be found under device-specific categories:
* [All Devices (General)](../../General/DFX) 
* [UltraScale+](../../UltraScalePlus/DFX) 

 <table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Tutorial</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="center"><a href="./1RP_AXI_GPIO_in_RP_Interface_INI/"> Single Reconfigurable Partition Design using Block Design Container </a></td>
 <td>This tutorial introduces the block design container feature in Vivado and how it can be leveraged to create DFX designs for Versal.</td>
 </tr>
  <tr>
 <td align="center"><a href="./2RP_GPIO_BRAM_in_RP_Interface_INI/">Multiple Reconfigurable Partitions Design using Block Design Container</a></td>
 <td>This tutorial demonstrates how to create design with multiple reconfigurable partitions using the block design container feature.</td>
 </tr>
 <tr>
 <td align="center"><a href="./2RPs_Sharing_ClockRegion/"> Clock Region Shared by two Reconfigurable Partitions</a></td>
 <td>This tutorial demonstrates a floorplan in Versal that allows sharing a clock region between two reconfigurable partitions.</td>
 </tr>
  <tr>
 <td align="center"><a href="./Debug_JTAG_HSDP/"> JTAG and HSDP based debugging for Versal DFX Designs</a></td>
 <td>This tutorial demonstrates debug methodologies for DFX designs in Versal using JTAG and HSDP.</td>
 </tr>
  <tr>
 <td align="center"><a href="./Disjoint_pblock/"> Disjoint pblock solutions for remote clocking resources</a></td>
 <td>This tutorial demonstrates solutions for resolving resource overlap errors and creating disjoint pblocks for including remote clocking in dynamic regions.</td>
 </tr>
  <tr>
 <td align="center"><a href="./Linux_based_partial_image_delivery/"> Linux-based partial image delivery</a></td>
 <td>This tutorial demonstrates a methodology for managing DFX via PetaLinux, taking advantage of fpgautil and libdfx to program partial images and update the device tree.</td>
 </tr>
 <tr>
 <td align="center"><a href="./NoC_INI_Static_RM_Interface/"> NoC connections in DFX designs</a></td>
 <td>This tutorial introduces multiple NoC connectivity options for DFX designs to transfer data between static and reconfiurable partitions.</td>
 </tr>
   <tr>
 <td align="center"><a href="./VNOC_Sharing/"> VNOC column sharing b/w multiple RPs</a></td>
 <td>This tutorial desmonstrates how VNOC clock tiles can be shared by two reconfigurable partitions. VNOC clock tiles are automatically included in the clock routing footprint of the reconfigurable partition by the tool.</td>
 </tr>
 </table>


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
