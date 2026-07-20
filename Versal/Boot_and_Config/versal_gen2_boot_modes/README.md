<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Adaptive SoC Architecture Tutorials</h1>
    <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
    </td>
 </tr>
</table>

# Boot and Configuration Tutorials -- Second Generation Versal

The tutorials in this repository are designed to educate users on different boot modes and utilities for second generation Versal devices, specifially Versal Prime Series Gen 2 and Versal AI Edge Series Gen 2. 


## <a href="./ospi_segmented_boot/">OSPI Segmented Boot Mode for Versal Gen2 devices</a>

This tutorial presents a comprehensive overview of the Segmented Configuration boot mode for Versal Gen2 devices. It explains the concept and purpose of segmented booting and describes how configuration images are organized and flashed onto OSPI memory in segmented mode. The document further details the process of booting the device using these segmented images and outlines the mechanisms involved in the OSPI segmented boot flow. In addition, it provides guidance on validating and confirming that the device has successfully booted from OSPI using the segmented configuration.


## <a href="./ospi_sd_boot/">OSPI + SD Boot Mode for Versal Gen2 devices</a>

Tutorial to cover OSPI as a primary boot source & SD card as a secondary boot source.


## <a href="./ospi_ufs_boot/">OSPI + UFS Boot Mode for Versal Gen2 devices</a>

Tutorial to cover OSPI as a primary boot source & UFS as a secondary boot source.


## <a href="./vivado_hw_manager/">Connect to the board from Vivado Hardware Manager</a>

This tutorial explains how to establish a connection between the host system and a target board using the Vivado Hardware Manager. It covers opening the Hardware Manager, launching or selecting a local or remote hardware server, detecting the connected board through JTAG, and confirming successful communication so the device is ready for programming and debugging.


## <a href="./ospi_flash_program/">Programming the OSPI Flash Using Vivado Hardware Manager</a>

This tutorial describes how to program the OSPI flash memory on a target board using the Vivado Hardware Manager. It covers connecting to the hardware via JTAG, adding the OSPI configuration memory device, selecting the required PDI files, and programming the flash so the system can boot from OSPI.


## <a href="./sd_flash_program/">Flashing WIC Image to SD Card</a>

The tutorial focuses on preparing an SD card by writing a prebuilt WIC image generated from the Linux/Yocto build flow. A WIC image is a complete disk image that encapsulates the required boot components, partition layout, and root file system in a single artifact. Once written, the SD card can be used as secondary boot media to bring up the Linux operating system on AMD platforms.


## <a href="./ufs_flash_program/">Program UFS Device with WIC Image</a>

This tutorial describes how to program an UFS device with a WIC disk image, which contains the Linux root filesystem and required partition layout. Flashing the WIC image initializes the UFS device as a bootable or runtime storage medium, enabling the system to load the operating system and associated software components from UFS.


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
