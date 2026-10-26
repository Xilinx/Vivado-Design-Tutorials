<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Gen2 Tutorial</h1>
   <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>OSPI Segmented Boot Mode for AMD Versal Gen2 devices</h1>
 </td>
 </tr>
</table>

***Version: 2025.2***<br>

This tutorial presents a comprehensive overview of the Segmented Configuration boot mode for Versal Gen2 devices. It explains the concept and purpose of segmented booting and describes how configuration images are organized and flashed onto OSPI memory in segmented mode. The document further details the process of booting the device using these segmented images and outlines the mechanisms involved in the OSPI segmented boot flow. In addition, it provides guidance on validating and confirming that the device has successfully booted from OSPI using the Segmented Configuration. By following this document, readers will develop a thorough understanding of the segmented OSPI boot process, including its operation, verification steps, and relevance within the overall Versal Gen2 boot architecture.

## Table of Contents
[Introduction](#introduction)

[Requirements](#requirements)

[Building the Design](#building-the-design)

[Steps to Implement Segmented Boot](#steps-to-implement-segmented-boot)

[Programming the OSPI Flash Using Vivado Hardware Manager](#programming-the-ospi-flash-using-vivado-hardware-manager)

[Booting from OSPI](#booting-from-ospi)

# Introduction
Segmented Configuration is a boot methodology introduced for Versal Gen2 architectures (AI Edge, Prime, Premium series). Segmented boot allows the primary boot image (PS PDI) to load additional images (e.g., PL PDI) from a secondary boot device such as OSPI/QSPI flash. This is essential when the design includes programmable logic configuration after the processor subsystem boots. It divides the device configuration into two distinct phases, enabling faster boot times and dynamic flexibility:
* <b>Phase 1 – PS Boot</b>
  * Boots the Processing System (PS)
  * Initializes critical infrastructure such as DDR memory and NoC paths before configuring the Programmable Logic (PL)
  * Allows early software execution (e.g., Linux boot) without waiting for PL configuration
* <b>Phase 2 – PL Load</b>
  * Loads the Programmable Logic (PL) and optional AI Engine components later
  * Can occur from primary/secondary boot devices or dynamically at runtime
  * Provides flexibility for applications requiring fast boot or dynamic PL reconfiguration
* <b>Key Concepts</b>
  * Primary Boot Device: Contains the initial boot image (PS PDI)
  * Secondary Boot Device: Stores additional images (PL PDI or other partitions)
  * Offset Address: Defines where the secondary image resides in flash memory
  * Alignment: Offsets must align to flash erase block boundaries (e.g., 128 KB)

# Requirements

## Hardware
* VEK385 RevA Evaluation Board
* Power supply, USB/JTAG cables

## Software
* Vivado Design Suite 2025.2
* Vitis Unified IDE 2025.2 (for XSDB verification)

## Environment Setup
Before proceeding, ensure Vivado 2025.2 is set up by sourcing the settings script
* source <Vivado_Install_Path>/2025.2/Vivado/settings64.sh

# Building the Design

**In this tutorial, we are using the VEK385 Embedded Common Platform CED project. Below are the steps to perform for project generation**
* git clone https://github.com/Xilinx/amd-yocto-hw-platforms.git
* cd amd-yocto-hw-platforms
* git checkout xlnx_rel_v2025.2
* cd eval_board_base/vek385_base/
* make xsa (Expect ~1 hour for this step)

**Quick verification checklist**
* After “make xsa”, these must exist:
  * hw_project/vek385_base/vek385_base.xpr
  * hw_project/vek385_base/vek385_base.runs/impl_1/*.pdi     <b> <-- Location of boot & pld PDIs required for OSPI porgramming </b>
  * hw_project/vek385_base/outputs/*.xsa
* If any of these are missing → the build is incomplete.

# Steps to Implement Segmented Boot

## Calculate PL PDI Offset
* Find Size of First Image (boot PDI)
  * After generating boot.pdi, check its size in bytes (size varies based on design) by running below command in the directory where PDI is present: 
    * ls -l *boot.pdi
    * Example: 3,041,280 bytes (~2.9 MB)
* Find PL PDI offset based on size of boot PDI
  * This offset will be useful in 2 places which is documented in later sections of this tutorial
    * In segmented BIF
	* During OSPI flashing from HW manager
  * Formula: 
    * pl_pdi_offset = ceil(image_size / block_size) * block_size
	  * image_size is the size of first image
	  * block_size comes from flash specifications. Flash requires offsets aligned to erase block boundaries (e.g., 128 KB = 131,072 bytes).
    * Example: 
      * image_size     = 3,041,280 bytes
      * block_size     = 131,072 bytes (For the VEK385, the OSPI flash block size is 128 KB. This is specific to the VEK385 board and is mentioned here to avoid the need for users to look it up separately.)
      * pl_pdi_offset  = ceil(3,041,280 / 131,072) * 131,072
                       = 24 * 131,072
                       = 3,145,728 bytes
                       = 0x300000

## Create BIF File (segmented.bif) to generate the segmeneted PDI
* Bootgen supports a secondary boot device. This can be any static memory that contains the secondary boot partition.
* The boot PDI needs to be updated to pass the metadata on the secondary boot device location and address where the PLD PDI will reside. This is done via a BIF with the boot_device param
* To generate a segmented PDI, create a BIF file that specifies the secondary boot device and secondary image location, as shown in the reference BIF below, which requires the boot.pdi name and the PL PDI offset.
	```
	seg_bif:
	{
	# OSPI is the flash type & 0x300000 is the offset where secondary image is located
	boot_device {ospi, address = 0x300000}  
	image
	{
	{ type = bootimage, file = boot.pdi }
	}
	}
	```

## Generate Segmented PDI
* Run the following command which takes a bif file as an input to bootgen for segmented pdi generation
  * bootgen -arch versal_2ve_2vm -image segmented.bif -w -o segmented.pdi
* Output: <b>segmented.pdi</b> contains info about secondary image location.

# Programming the OSPI Flash Using Vivado Hardware Manager

* Please follow this link to program OSPI. In this tutorial we are using PLD PDI, please use the Segmented mode.
  * [OSPI programming through HW manager](../ospi_flash_program/README.md)

# Booting from OSPI

Booting from <b>Octal SPI (OSPI)</b> flash is a common method for Versal devices. This section explains how to configure the boot mode to OSPI and verify successful boot using logs.

## Change Boot Mode to OSPI

There are two ways to set the boot mode:

**Option1: Physical Board Access**
* Change the boot strap settings for SW1 to: Mode [3:0] Pins → 1000
* Power on the board

**Option2: Using XSDB Commands**

If physical access is not available, use XSDB to switch boot mode:
* Open new terminal and source Vivado Environment
  * source <Vivado_Install_Path>/2025.2/Vivado/settings64.sh
* Run "xsdb" on terminal which enables the xsdb prompt
* Execute below command which connects XSDB to the hardware server
  * connect -url TCP:<server_name>:3121
* Connect to the device using below command
  * ta 1
* Switch boot mode to OSPI
  * mwr 0xf1260200 0x8100
* Perform PMC reset
  * mwr 0xf126031c 0x8
* After executing these commands, the device will boot from the images programmed in OSPI flash.

## Verify boot logs

Below are the serial terminal logs indicating a successful OSPI boot: look at the lines that have the <b>IMPORTANT</b> marker.

```
[0.051]Xilinx Versal 2ve_2vm Platform Loader and Manager
[0.096]Release 2025.2   Feb 26 2026  -  12:18:24
[0.139]Platform Version: v1.0 PMC: v1.0, PS: v1.0
[0.188]BOOTMODE: 0x8, MULTIBOOT: 0x0
[0.223]****************************************
[0.526]Non Secure Boot
[6.285]PLM Initialization Time
[6.318]Boot PDI Load: Started
[6.404]Loading PDI from OSPI      <------- IMPORTANT
[6.435]Monolithic/Master Device
[7.855]FlashID=0x2C 0x5B 0x1C
[9.382]OSPI mode switched to DDR
[11.258]4.887 ms: PDI initialization time
[11.302]+++Loading Image#: 0x1, Name: lpd, Id: 0x04210002
[11.586]LPD scan clear pass
[83.427]Done LPD power up      <------- IMPORTANT
[90.820]+++Loading Image#: 0x2, Name: fpd, Id: 0x0420C003
[105.779]FPD scan clear pass
[118.986]Done FPD power up      <------- IMPORTANT
[120.896]MMI T50 house cleaning sequence version 0.72
[127.763]MMI scan clear pass
[159.516]Done MMI power up      <------- IMPORTANT
[164.369]+++Loading Image#: 0x3, Name: pl_cfi, Id: 0x18700000
[184.490]NPD scan clear pass
[239.206]Done NPD power up.      <------- IMPORTANT
[3304.564]+++Loading Image#: 0x4, Name: asufw, Id: 0x1C000002
[3316.285] 2.222 ms for Partition#: 0x4, Size: 544 Bytes
[3319.069]---Loading Partition#: 0x5, Id: 0xB
[3323.909] 0.777 ms for Partition#: 0x5, Size: 135984 Bytes
[3328.417]+++Loading Image#: 0x5, Name: aie2_subsys, Id: 0x0421C028
[3334.362]---Loading Partition#: 0x6, Id: 0x7
[3358.354]AIE scan clear pass
[3381.671]Done AIE power up
[3383.803] 45.374 ms for Partition#: 0x6, Size: 12896 Bytes
[3389.134]Loading PDI from OSPI      <------- IMPORTANT
[3391.914]Monolithic/Master Device
[3396.412]FlashID=0x2C 0x5B 0x1C
[3399.419]OSPI mode switched to DDR
[3402.956]13.855 ms: PDI initialization time
[3405.137]+++Loading Image#: 0x0, Name: pl_cfi, Id: 0x18700001
[3418.629]pl_preconfig
[3420.699]PLPD T50 power sequence version 0.34
[3437.507]PL scan clear pass
[3452.426]Done PL power up      <------- IMPORTANT
[3455.047] 40.138 ms for Partition#: 0x0, Size: 17840 Bytes
[3460.109]---Loading Partition#: 0x1, Id: 0x205
[3467.221] 2.873 ms for Partition#: 0x1, Size: 44720 Bytes
[3469.559]---Loading Partition#: 0x2, Id: 0x103
[3474.491] 0.694 ms for Partition#: 0x2, Size: 221920 Bytes
[3479.066]---Loading Partition#: 0x3, Id: 0x203
[3483.368] 0.064 ms for Partition#: 0x3, Size: 928 Bytes
[3488.315]---Loading Partition#: 0x4, Id: 0x303
[3508.047] 15.492 ms for Partition#: 0x4, Size: 842080 Bytes
[3510.558]---Loading Partition#: 0x5, Id: 0x305
[3519.615] 4.818 ms for Partition#: 0x5, Size: 123248 Bytes
[3522.038]---Loading Partition#: 0x6, Id: 0x403
[3526.852] 0.579 ms for Partition#: 0x6, Size: 173328 Bytes
[3531.543]---Loading Partition#: 0x7, Id: 0x405
[3536.033] 0.254 ms for Partition#: 0x7, Size: 3760 Bytes
[3553.074]Boot PDI Load: Done      <------- IMPORTANT
[3557.648]48.000 ms: ROM Time
[3560.321]Total PLM Boot Time
```


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>

<p class="sphinxhide" align="center"><sub>###### SPDX-License-Identifier: MIT</sub></p>
