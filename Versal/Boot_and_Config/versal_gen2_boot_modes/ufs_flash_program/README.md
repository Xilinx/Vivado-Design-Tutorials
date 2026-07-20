<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Gen2 Tutorial</h1>
   <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Program UFS Device with WIC Image</h1>
 </td>
 </tr>
</table>

***Version: 2025.2***<br>

This tutorial describes how to program an UFS device with a WIC disk image, which contains the Linux root filesystem and required partition layout. Flashing the WIC image initializes the UFS device as a bootable or runtime storage medium, enabling the system to load the operating system and associated software components from UFS.

# Using image recovery tool on Physical board

## Step1: Prepare TFTP server
* Download and install Open TFTP Server (Typical install path: C:\OpenTFTPServer\)
* Copy the following files into "C:\OpenTFTPServer\" from GoldenImages folder
  * Image
  * edf-image-full-cmdline-amd-cortexa78-mali-common.rootfs.cpio.gz.u-boot
  * ufsconfig
* Launch the TFTP server using
  * C:\OpenTFTPServer\RunStandAloneMT.bat
* Ensure that the TFTP server is listening and ready (refer to the TFTP console window for confirmation).
	```
	starting TFTP...
	alias / is mapped to C:\OpenTFTPServer\
	permitted clients: all
	server port range: all
	max blksize: 65464
	default blksize: 512
	default timeout: 3
	file read allowed: Yes
	file create allowed: No
	file overwrite allowed: No
	thread pool size: 1
	Detecting Static Interfaces..
	Listening On: 127.0.0.1:69
	Listening On: 172.23.99.28:69
	```

## Step2: Boot linux golden images using tftp
* Run below command in windows command prompt to allow tftp transfer
  * netsh advfirewall firewall add rule name="TFTP UDP 69" protocol=UDP dir=in localport=69 action=allow
* On serial console, halt at U-boot prompt and load the kernel and rootfs images using tftp.
  * dhcp
  * setenv tftpblocksize 8192
  * setenv ramdisk_addr_r 0x30000000
  * setenv serverip 172.23.99.28 (PC IP address)
  * setenv netretry yes
  * setenv tftpblocksize 512
  * setenv bootdelay 5
  * saveenv
  * tftpb $ramdisk_addr_r edf-image-full-cmdline-amd-cortexa78-mali-common.rootfs.cpio.gz.u-boot; tftpb $kernel_addr_r Image; booti $kernel_addr_r $ramdisk_addr_r $fdtcontroladdr
* Once Linux boots, Username for amd-edf is amd-edf and set password option will be prompted where user need to set a password.

## Step3: Erase the UFS device (optional)
* Find USB and SCSI Devices from EDF terminal
  * find /dev/disk/by-id/ -type l \( -name '*usb*' -o -iname '*scsi*' \) -a ! -iname '*part*'
* Resolve Actual Device Path
  * readlink -f /dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_04011c33db0877b5bf83809bceccff39018518d28ba06b8269cbf65e90d92e07a56800000000000000000000dc60a23f00966918815581074c3114c8-0:0 /dev/sde
  * readlink -f /dev/disk/by-id/usb-Generic_Ultra_HS-COMBO_000000225001-0:0 /dev/sdd
  * readlink -f /dev/disk/by-id/scsi-1MICRON /dev/sda
* Wipe the Device (overwrites the beginning of the device with zeros to erase data)
  * sudo dd if=/dev/zero of=/dev/sde bs=1024 count=1024
  * sudo dd if=/dev/zero of=/dev/sdd bs=1M count=2048
  * sudo dd if=/dev/zero of=/dev/sda bs=1024 count=1024

## Step4: Update the UFS device’s configuration parameters
* Follow below steps in EDF terminal
  * tftp 172.23.99.28 (PC IP address)
  * tftp> get ufsconfig
    * Successful message: Received 230 bytes in 0.0 seconds
  * tftp> quit
  * sudo ufs-utils desc -t 1 -w ufsconfig -p /dev/bsg/ufs-bsg0

## Step5: Flash image into UFS device using Web-based image recovery tool
* Launch Linux-based image recovery shell
  * Press and hold the FWUEN (SW14) push button while powering on the board. After 3 to 5 seconds, release the push button.
  * Device will boot and in serial log, we will see the IP address to launch web interface page
	```
	udhcpc: link is up, IP assigned -> 10.140.30.141
    ##############################################################################################
    #                                                                                            #
    #Launching to Image Recovery shell, Use 10.140.30.141:8080 to launch the Image Recovery web app.#
    #                                                                                            #
    ##############################################################################################
	```
  * On the host machine, launch a browser (e.g., Firefox) and navigate to: http://10.140.30.141:8080, This opens the image recovery web interface page.

* The Image Recovery web interface provides three tabs:
  * System Information
  * Ethernet Recovery
  * USB Recovery

	<img src="./images/image1.png?raw=true">

* To update the Linux image using Ethernet Recovery, click the Ethernet Recovery tab and follow the steps outlined below.
  * Browse and select the WIC (eg., .wic.ufs.xz) image
  * Select the appropriate Target Storage Device (eg., /dev/sda)
  * Click on Upload

	<img src="./images/image2.png?raw=true">

* A pop-up will confirm the successful update and display the message shown below

	<img src="./images/image3.png?raw=true">


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>

<p class="sphinxhide" align="center"><sub>###### SPDX-License-Identifier: MIT</sub></p>
