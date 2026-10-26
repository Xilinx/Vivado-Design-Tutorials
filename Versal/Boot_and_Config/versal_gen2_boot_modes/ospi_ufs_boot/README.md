<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Gen2 Tutorial</h1>
   <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>OSPI + UFS Boot Mode for AMD Versal™ Gen2 devices</h1>
 </td>
 </tr>
</table>

***Version: 2025.2***<br>

Tutorial to cover OSPI as a primary boot source & UFS as a secondary boot source.

## Table of Contents
[Introduction](#introduction)

[Requirements](#requirements)

[Building the Design](#building-the-design)

[Programming the OSPI Flash Using Vivado Hardware Manager](#programming-the-ospi-flash-using-vivado-hardware-manager)

[Load the UFS with WIC image](#load-the-ufs-with-wic-image)

[Booting from OSPI & UFS](#booting-from-ospi-&-ufs)

# Introduction
* This tutorial presents an overview of the boot architecture for AMD Versal™ Gen 2 devices configured with multiple boot sources. It focuses on a dual‑boot scenario in which a bare‑metal application is loaded from the primary boot medium, OSPI flash, while a Linux system image is launched from a secondary boot medium, UFS storage. The guide details the process of programming the bare‑metal BIN file into OSPI flash memory and describes the steps required to prepare, deploy, and store the Linux WIC image on the UFS device.
* Additionally, the tutorial walks through the complete boot sequence for this configuration, outlining how execution progresses from the primary to the secondary boot stage. It also provides validation steps to confirm that both the bare‑metal application and the Linux operating system are correctly loaded and executed from their respective storage devices.
* By completing this tutorial, users will develop a clear understanding of the Versal Gen 2 boot flow when OSPI and UFS are used as the primary and secondary boot sources, respectively, and how control is handed off between boot stages during system initialization.

# Requirements

## Hardware
* VEK385 RevB Evaluation Board
* Power supply, USB/JTAG cables, Ethernet cable

## Software
* Vivado Design Suite 2025.2
* Vitis Unified IDE 2025.2 (for XSDB verification)
* Ufsconfig file to configure the UFS device before programming
* Linux golden images (optional - only needed when we program UFS remotely)

## Environment Setup
Before proceeding, ensure Vivado 2025.2 is set up by sourcing the settings script
* source <Vivado_Install_Path>/2025.2/Vivado/settings64.sh

# Building the Design

* In this tutorial, we have used the EDF flow for PDI, BIN & WIC (OpenEmbedded Image Creator) images generation.
* Below are the steps to generate VEK385 Rev-B images from EDF flow
  * mkdir -p yocto/edf
  * cd yocto/edf
  * repo init -u https://github.com/Xilinx/yocto-manifests.git -b rel-v2025.2 -m default-edf.xml
  * repo sync
  * source edf-init-build-env
  * MACHINE=versal-2ve-2vm-vek385-revb-sdt-seg bitbake edf-ospi
  * MACHINE=amd-cortexa78-mali-common bitbake edf-linux-disk-image
* After successful EDF build, below are the artifacts we use for OSPI & SD programming
  * yocto/edf/build/tmp/deploy/images/versal-2ve-2vm-vek385-revb-sdt-seg/boot.bin-extracted/base-design.pdi
  * yocto/edf/build/tmp/deploy/images/versal-2ve-2vm-vek385-revb-sdt-seg/edf-ospi-versal-2ve-2vm-vek385-revb-sdt-seg-*.bin
  * yocto/edf/build/tmp/deploy/images/amd-cortexa78-mali-common/edf-linux-disk-image-amd-cortexa78-mali-common.rootfs-*.wic.ufs.xz
  * yocto/edf/build/tmp/deploy/images/amd-cortexa78-mali-common/edf-linux-disk-image-amd-cortexa78-mali-common.rootfs-*.wic.ufs.bmap

# Programming the OSPI Flash Using Vivado Hardware Manager

* Please follow below link to program OSPI. In this tutorial we are not using PLD PDI, please use the Flat mode.
  * [OSPI programming through HW manager](../ospi_flash_program/README.md)

# Load the UFS with WIC image

* Please follow below link to load UFS
  * [Flashing WIC Image to UFS](../ufs_flash_program/README.md)

# Booting from OSPI & UFS

## Change Boot Mode to OSPI

There are two ways to set the boot mode:

**Option1: Physical Board Access**
* Change the boot strap settings for SW1 to: Mode [3:0] Pins → 1000
* Power on the board.

**Option2: Using XSDB Commands**

If physical access is not available, use XSDB to switch boot mode:
* Open new terminal and source Vivado Environment
  * source <Vivado_Install_Path>/2025.2/Vivado/settings64.sh
* Run "xsdb" on terminal which enables the xsdb prompt
* Execute below command which connects XSDB to the hardware server
  * connect -url TCP:XHD<server_name>:3121
* Connect to the device using below command
  * ta 1
* Switch boot mode to OSPI
  * mwr 0xf1260200 0x8100
* Perform PMC reset
  * mwr 0xf126031c 0x8
* After executing these commands, the device will boot from the images programmed in OSPI flash.

## Reset the board

* It boots from OSPI initially, followed by the UFS device for the rootfs and kernel image.
* Once Linux boots, Username for amd-edf is amd-edf and set password option will be prompted where user need to set a password.
* Below are the serial terminal logs indicating a successful <b>OSPI+UFS boot</b>: look at the lines that has <b>IMPORTANT</b> marker

```
NOTICE:  BL31: Executing from 0x1600000
I/TC: Non-secure external DT found
I/TC: pl011: device parameters ignored (115200n8)
I/TC: Switching console to device: /axi/serial@f1930000
I/TC: Primary CPU initializing
I/TC: OP-TEE OS Running on Platform AMD Versal Gen 2
I/TC: Primary CPU switching to normal world boot

U-Boot 2025.01-g5e0d8abc7e09-dirty (Nov 12 2025 - 07:44:59 +0000)

CPU:   Versal Gen 2    <-------- IMPORTANT
Silicon: v1.0
Chip:  v1.0
Model: AMD Versal VEK385 revB    <-------- IMPORTANT
DRAM:  2 GiB (effective 20 GiB)
EL Level:	EL2
Xilinx I2C FRU format at nvmem1:
 Manufacturer Name: XILINX
 Product Name: VEK385
 Serial No: XFL115GKB3V0
 Part Number: 5191-01
 File ID: 0x0
 Revision Number: B2
Core:  57 devices, 27 uclasses, devicetree: board
MMC:   
Loading Environment from SPIFlash... SF: Detected mt35xu02g with page size 256 Bytes, erase size 128 KiB, total 256 MiB    <-------- IMPORTANT
OK
In:    serial@f1930000
Out:   serial@f1930000
Err:   serial@f1930000
Bus usb@f1c00000: Register 1000440 NbrPorts 1
Starting the controller
USB XHCI 1.10
scanning bus usb@f1c00000 for devices... 4 USB Device(s) found
       scanning usb for storage devices... 1 Storage Device(s) found
ufs-versal2-pltfm ufs@f10b0000: [RX, TX]: gear=[4, 4], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
scanning bus for devices...
  Device 0: (0:0) Vendor: MICRON Prod.: MT064GBCAV1U31AA Rev: 0307
            Type: Hard Disk
            Capacity: 20480.0 MB = 20.0 GB (5242880 x 4096)
  Device 1: (0:1) Vendor: MICRON Prod.: MT064GBCAV1U31AA Rev: 0307
            Type: Hard Disk
            Capacity: 1024.0 MB = 1.0 GB (262144 x 4096)
  Device 2: (0:2) Vendor: MICRON Prod.: MT064GBCAV1U31AA Rev: 0307
            Type: Hard Disk
            Capacity: 4096.0 MB = 4.0 GB (1048576 x 4096)
Net:   
ZYNQ GEM: f1a60000, mdio bus f1a60000, phyaddr 1, interface rgmii-id
eth0: ethernet@f1a60000
Missing RNG device for EFI_RNG_PROTOCOL
Hit any key to stop autoboot:  0 

  *** U-Boot Boot Menu ***



  usb 0
  scsi 0
  scsi 1
  scsi 2
  Exit
  Press UP/DOWN to move, ENTER to select, ESC to quit

Booting: scsi 0    <-------- IMPORTANT
No RNG device



                                EDF Xen    
                               EDF Linux   
                         ─────────────────────
                              Boot in 1 s.                                 
EFI stub: Booting Linux Kernel...
EFI stub: EFI_RNG_PROTOCOL unavailable
EFI stub: Using DTB from configuration table
EFI stub: Exiting boot services...
I/TC: Secondary CPU 1 initializing
I/TC: Secondary CPU 1 switching to normal world boot
I/TC: Secondary CPU 7 initializing
I/TC: Secondary CPU 7 switching to normal world boot
I/TC: Reserved shared memory is disabled
I/TC: Dynamic shared memory is enabled
I/TC: Normal World virtualization support is disabled
I/TC: Asynchronous notifications are disabled
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd423]
[    0.000000] Linux version 6.12.40-xilinx-g31626ef92ff1 (oe-user@oe-host) (aarch64-amd-linux-gcc (GCC) 13.4.0, GNU ld (GNU Binutils) 2.42.0.20240723) #1 SMP Fri Nov  7 15:28:23 UTC 2025
[    0.000000] KASLR disabled due to lack of seed
[    0.000000] Machine model: AMD Versal VEK385 revB
[    0.000000] efi: EFI v2.10 by Das U-Boot
[    0.803842] remoteproc remoteproc0: eba00000.r52f is available
[    4.280953] hub 1-0:1.0: USB hub found
[    4.284703] hub 1-0:1.0: 1 port detected
[  OK  ] Finished     8.844495] mali ed0e0000.gpu: Arbitration interface enabled
[    8.929486] mali ed0e0000.gpu: Continuing without devfreq
[    8.935128] workqueue: name exceeds WQ_NAME_LEN. Truncating to: kbase_job_fault_resume_work_que
[    8.944062] mali ed0e0000.gpu: * MALI kbase_mmap_min_addr compiled to CONFIG_DEFAULT_MMAP_MIN_ADDR, no runtime update possible! *
[    8.955715] mali ed0e0000.gpu: Probed as mali0
[    8.961439] mali_gpu_resource_group ed0a0000.gpu_resource_group: GPU subinstance is in invalid state 1
[  OK  ] Finished Rebuild Dynamic Linker Cache.
[    9.000102] random: crng init done
[  OK  ] Listening on Load/Save RF Kill Switch Status /dev/rfkill Watch.
         Starting Run pending postinsts...
[    9.090601] Unloading old XRT Linux kernel modules
[    9.097494] Loading new XRT Linux kernel modules
[  OK  ] Finished Record System Boot/Shutdown in UTMP.
[    9.707378] audit: type=1334 audit(1748544505.576:9): prog-id=13 op=LOAD
[    9.714097] audit: type=1334 audit(1748544505.584:10): prog-id=14 op=LOAD
[    9.720880] audit: type=1334 audit(1748544505.584:11): prog-id=9 op=UNLOAD
[  OK  ] Started Network Time Synchronization.
[  OK  ] Started dfx-mgrd Dynamic Function eXchange.
[  OK  ] Started User Login Management.
[  OK  ] Finished IPv6 Packet Filtering Framework.
[  OK  ] Finished IPv4 Packet Filtering Framework.
[  OK  ] Reached target Preparation for Network.
         Starting dfx-mgrd Default Firmware Load Service...
         Starting Network Configuration...
[  OK  ] Started Serial Getty on ttyAMA0.
[  OK  ] Started Serial Getty on ttyAMA1.
[  OK  ] Reached target Login Prompts.
[  OK  ] Started Target Communication Framework agent.
[  OK  ] Finished OpenSSH Key Generation.
[  OK  ] Started containerd container runtime.
[  OK  ] Finished dfx-mgrd Default Firmware Load Service.

AMD Embedded Development Framework Linux distribution 25.11.1+development-e96834ba24a16dc2257c707a94683bb1eb6d720a amd-edf ttyAMA1

amd-edf login: amd-edf    <-------- IMPORTANT
You are required to change your password immediately (administrator enforced).
New password:
Retype new password: 

WARNING: AMD Embedded Development Framework is a reference Yocto Project
distribution that should be used for testing and development purposes only.

It is recommended that you create your own 
amd-edf:~$    <-------- IMPORTANT
```

<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>

<p class="sphinxhide" align="center"><sub>###### SPDX-License-Identifier: MIT</sub></p>
