<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Gen2 Tutorial</h1>
   <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Programming the OSPI Flash Using Vivado Hardware Manager</h1>
 </td>
 </tr>
</table>

***Version: 2025.2***<br>

This tutorial describes how to program the OSPI flash memory on a target board using the Vivado Hardware Manager. It covers connecting to the hardware via JTAG, adding the OSPI configuration memory device, selecting the required PDI files, and programming the flash so the system can boot from OSPI.

## Connect to the board from Vivado Hardware Manager

[Establish the board connection to HW manager](../vivado_hw_manager/README.md)

## Add Configuration Memory Device
* Right-click the board name → Add configuration memory device

	<img src="./images/image1.png?raw=true">

## Select Memory Part
* Choose the supported memory part for your board (refer the board specific user guide) → Click OK
* For VEK385, select the part as highlighted in below image

	<img src="./images/image2.png?raw=true">

## Confirm Addition
* When prompted, select OK to program the flash

	<img src="./images/image3.png?raw=true">

## Program Configuration Memory Device
Option1: Flat mode (combined PDI)
* In the programming window:
  * Select Design Mode as Flat
  * Provide respective images accordingly
  * Click OK to start programming
	
	<img src="./images/image4.png?raw=true">

Option2: Segmented mode (separate boot & PLD PDIs)
* Due to a limitation in the Vivado GUI, we need to set the multi_image_offsets property explicitly with below command from TCL (only for segmented mode). This ensures proper boot and PLD PDI offsets are applied. In below ref command of VEK385, "3145728" is the PL PDI offset calucated based on this ref design. Please update according to your design.
  * set_property PROGRAM.MULTI_IMAGE_OFFSETS [list "0" "3145728"] [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc2ve3858_1] 0]]
* In the programming window
  * Select Design Mode as Segmented
  * Provide respective images accordingly
  * Click OK to start programming

	<img src="./images/image5.png?raw=true">

## Completion
* A popup confirms: Flash programming completed successfully

	<img src="./images/image6.png?raw=true">


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>

<p class="sphinxhide" align="center"><sub>###### SPDX-License-Identifier: MIT</sub></p>
