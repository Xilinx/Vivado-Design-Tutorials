<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Gen2 Tutorial</h1>
   <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Connect to the board from Vivado Hardware Manager</h1>
 </td>
 </tr>
</table>

***Version: 2025.2***<br>

This tutorial explains how to establish a connection between the host system and a target board using the Vivado Hardware Manager. It covers opening the Hardware Manager, launching or selecting a local or remote hardware server, detecting the connected board through JTAG, and confirming successful communication so the device is ready for programming and debugging.

## Launch Vivado Tool
Open a terminal and run the following commands to set up the environment and launch the Vivado GUI
* source <Vivado_Install_Path>/2025.2/Vivado/settings64.sh
* vivado &

## Open Hardware Manager
* Once Vivado opens, navigate to the Hardware Manager by clicking Open Hardware Manager on the main interface.

	<img src="./images/image1.png?raw=true">

## Start New Hardware Target
* In the Hardware Manager, click Open Target → Open New Target. This begins the process of connecting to a hardware device.

	<img src="./images/image2.png?raw=true">

## Open New Hardware Target Wizard
* A pop-up titled Open New Hardware Target will appear.
* Click Next to proceed.

	<img src="./images/image3.png?raw=true">

## Configure Hardware Server Settings
You will be prompted to select the hardware server connection type:

* Local Server:
  * If the device is connected to the same machine running Vivado, select Connect to local server and click Next.
	
	<img src="./images/image4.png?raw=true">

* Remote Server:
  * If the device is connected to a different machine, select Connect to remote server, enter the remote server details, and click Next.
	
	<img src="./images/image5.png?raw=true">

## Select Hardware Target
* The wizard will display available hardware targets.
* Verify the device details and click Next.

	<img src="./images/image6.png?raw=true">

## Review Summary
* The Open Hardware Target Summary page will show the connection details.
* Review the information and click Finish.

	<img src="./images/image7.png?raw=true">

## Connection Established
* Device is now successfully connected to the Vivado Hardware Server.
* We can proceed with programming, debugging, or monitoring the hardware.

	<img src="./images/image8.png?raw=true">


	<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>

<p class="sphinxhide" align="center"><sub>###### SPDX-License-Identifier: MIT</sub></p>
