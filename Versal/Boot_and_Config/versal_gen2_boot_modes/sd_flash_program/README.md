<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal Gen2 Tutorial</h1>
   <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Flashing WIC Image to SD Card</h1>
 </td>
 </tr>
</table>

***Version: 2025.2***<br>

The tutorial focuses on preparing an SD card by writing a prebuilt WIC image generated from the Linux/Yocto build flow. A WIC image is a complete disk image that encapsulates the required boot components, partition layout, and root file system in a single artifact. Once written, the SD card can be used as secondary boot media to bring up the Linux operating system on AMD platforms.

# Using Raspberry Pi Imager on Physical board

## Verify Connected Drives
* Before launching Raspberry Pi Imager, insert the SD card into your system using card reader & confirm that your USB drive (SD card) is detected by the system.

	<img src="./images/image1.png?raw=true">

## Add Configuration Memory Device
Open the Raspberry Pi Imager application. The main screen displays three options:
* Choose device – No action (optional).
* Choose OS – Select the operating system image.
* Choose Storage – Select the target device (USB or SD card).
* Click NEXT after making selections.

	<img src="./images/image2.png?raw=true">

## Select Operating System
* Click Choose OS and pick the custom image from your workspace

	<img src="./images/image3.png?raw=true">

## Select Storage Device
* Click Choose Storage and select the correct USB drive from the list.
* Important: Double-check the device name and size to avoid overwriting the wrong drive.

	<img src="./images/image4.png?raw=true">

## Click "Next"
* Click NEXT

	<img src="./images/image5.png?raw=true">

## Apply Customization Settings (Optional)
* After selecting OS and storage, you may configure additional settings:
  * Enable SSH
  * Set hostname
  * Configure Wi-Fi
  * Set locale and keyboard layout
* Click EDIT SETTINGS if customization is needed, or NO to skip.

	<img src="./images/image6.png?raw=true">

## Confirm Overwrite Warning
* The imager will display a warning:
  * All existing data on the selected USB device will be erased.
* Click YES to proceed if you are sure.

	<img src="./images/image7.png?raw=true">

## Writing Process
* The tool begins writing the OS image to the USB drive.
  * Progress is shown as a percentage (e.g., Writing... 3%, 7%, 10%, …, 100%).
* Do not remove the device during this process.

	<img src="./images/image8.png?raw=true">

## Verification
* After writing, the imager verifies the data.
  * Progress is shown as a percentage (e.g., Verifying... 3%, 7%, 10%, …, 100%).
* Do not remove the device during this process.

	<img src="./images/image9.png?raw=true">

## Completion
* A message appears: 
  * Write successful. You can now remove the USB device from the reader.
* Click CONTINUE to finish.

	<img src="./images/image10.png?raw=true">

## Insert SD card into board

Remove the SD card from system and insert into the SD slot on board.


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>

<p class="sphinxhide" align="center"><sub>###### SPDX-License-Identifier: MIT</sub></p>
