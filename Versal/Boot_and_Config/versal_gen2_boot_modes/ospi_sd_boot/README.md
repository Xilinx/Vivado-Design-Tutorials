<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Gen2 Tutorial</h1>
   <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>OSPI + SD Boot Mode for AMD Versal™ Gen2 devices</h1>
 </td>
 </tr>
</table>

***Version: 2025.2***<br>

Tutorial to cover OSPI as a primary boot source & SD card as a secondary boot source.

## Table of Contents
[Introduction](#introduction)

[Requirements](#requirements)

[Building the Design](#building-the-design)

[Programming the OSPI Flash Using Vivado Hardware Manager](#programming-the-ospi-flash-using-vivado-hardware-manager)

[Load the SD card with WIC image](#load-the-sd-card-with-wic-image)

[Booting from OSPI & SD](#booting-from-ospi-&-sd)

# Introduction
* This tutorial describes the boot flow for AMD Versal™ Gen 2 devices using multiple boot sources. Specifically, it demonstrates booting bare‑metal applications from the primary boot source (OSPI) and Linux images from the secondary boot source (SD card). The tutorial explains how to program the bare‑metal BIN image into OSPI flash memory and how to prepare and load the Linux WIC image onto an SD card.
* In addition, the tutorial outlines the steps required to boot the device using this dual‑source configuration and provides guidance on verifying that both the bare‑metal and Linux images have been successfully loaded and executed from their respective boot sources. By following this tutorial, users will gain a clear understanding of the Versal Gen 2 boot sequence when using OSPI and SD card as primary and secondary boot sources, respectively, and how control transitions between these boot stages during system startup.

# Requirements

## Hardware
* VEK385 RevA Evaluation Board
* Power supply, SD card, USB/JTAG cables

## Software
* Vivado Design Suite 2025.2
* Vitis Unified IDE 2025.2 (for XSDB verification)
* Raspberry Pi Imager
* Linux golden images (optional - only needed when we program SD remotely)

## Environment Setup
Before proceeding, ensure Vivado 2025.2 is set up by sourcing the settings script
* source <Vivado_Install_Path>/2025.2/Vivado/settings64.sh

# Building the Design

* In this tutorial, we have used the EDF flow for PDI, BIN & WIC (OpenEmbedded Image Creator) images generation.
* Below are the steps to generate VEK385 Rev-A images from EDF flow
  * mkdir -p yocto/edf
  * cd yocto/edf
  * repo init -u https://github.com/Xilinx/yocto-manifests.git -b rel-v2025.2 -m default-edf.xml
  * repo sync
  * source edf-init-build-env
  * MACHINE=versal-2ve-2vm-vek385-sdt-seg bitbake edf-ospi
  * MACHINE=amd-cortexa78-mali-common bitbake edf-linux-disk-image
* After successful EDF build, below are the artifacts we use for OSPI & SD programming
  * yocto/edf/build/tmp/deploy/images/versal-2ve-2vm-vek385-sdt-seg/boot.bin-extracted/base-design.pdi
  * yocto/edf/build/tmp/deploy/images/versal-2ve-2vm-vek385-sdt-seg/BOOT-versal-2ve-2vm-vek385-sdt-seg-*.bin
  * yocto/edf/build/tmp/deploy/images/amd-cortexa78-mali-common/edf-linux-disk-image-amd-cortexa78-mali-common.rootfs-*.wic.xz
  * yocto/edf/build/tmp/deploy/images/amd-cortexa78-mali-common/edf-linux-disk-image-amd-cortexa78-mali-common.rootfs-*.wic.bmap

# Programming the OSPI Flash Using Vivado Hardware Manager

* Please follow below link to program OSPI. In this tutorial we are not using PLD PDI, please use the Flat mode.
  * [OSPI programming through HW manager](../ospi_flash_program/README.md)

# Load the SD card with WIC image

* Please follow below link to load SD
  * [Flashing WIC Image to SD Card](../sd_flash_program/README.md)

# Booting from OSPI & SD

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

* It boots from OSPI initially, followed by the SD card for the rootfs and kernel image.
* Once Linux boots, Username for amd-edf is amd-edf and set password option will be prompted where user need to set a password.
* Below are the serial terminal logs indicating a successful <b>OSPI+SD boot</b>: look at the lines that have the <b>IMPORTANT</b> marker.

```
NOTICE:  TF-A running on Silicon v0.0, RTL v8.6, PS v8.6, PMC v8.6
NOTICE:  BL31: Executing from 0x1600000
I/TC: Non-secure external DT found
I/TC: Switching console to device: /axi/serial@f1930000
I/TC: Primary CPU initializing
I/TC: OP-TEE OS Running on Platform AMD Versal Gen 2
I/TC: Primary CPU switching to normal world boot

U-Boot 2025.01-g5e0d8abc7e09-dirty (Nov 12 2025 - 07:44:59 +0000)

CPU:   Versal Gen 2      <-------- IMPORTANT
Silicon: v1.0
Chip:  v1.0
Model: AMD Versal VEK385 revA    <-------- IMPORTANT
DRAM:  2 GiB (effective 10 GiB)
EL Level:       EL2
Xilinx I2C FRU format at nvmem1:
 Manufacturer Name: XILINX
 Product Name: VEK385
 Serial No: 519101A01197
 Part Number: 5191-01
 File ID: 0x0
 Revision Number: A01
Core:  58 devices, 27 uclasses, devicetree: board
MMC:
Loading Environment from SPIFlash... SF: Detected mt35xu02g with page size 256 Bytes, erase size 128 KiB, total 256 MiB     <-------- IMPORTANT
OK
In:    serial@f1930000
Out:   serial@f1930000
Err:   serial@f1930000
Bus usb@f1c00000: Register 1000440 NbrPorts 1
Starting the controller
USB XHCI 1.10
scanning bus usb@f1c00000 for devices... 3 USB Device(s) found
       scanning usb for storage devices... 1 Storage Device(s) found
ufs-versal2-pltfm ufs@f10b0000: [RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
scanning bus for devices...
  Device 0: (0:0) Vendor: MICRON Prod.: MT064GBCAV1U31AA Rev: 0302
            Type: Hard Disk
            Capacity: 20480.0 MB = 20.0 GB (5242880 x 4096)
  Device 1: (0:1) Vendor: MICRON Prod.: MT064GBCAV1U31AA Rev: 0302
            Type: Hard Disk
            Capacity: 1024.0 MB = 1.0 GB (262144 x 4096)
  Device 2: (0:2) Vendor: MICRON Prod.: MT064GBCAV1U31AA Rev: 0302
            Type: Hard Disk
            Capacity: 4096.0 MB = 4.0 GB (1048576 x 4096)

  *** U-Boot Boot Menu ***



  usb 0
  scsi 0
  scsi 1
  scsi 2
  Exit
  Press UP/DOWN to move, ENTER to select, ESC to quit
Booting: usb 0       <-------- IMPORTANT
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
[    0.000000] Machine model: AMD Versal VEK385 revA
[    0.000000] efi: EFI v2.10 by Das U-Boot
[    0.000000] efi: ESRT=0x83ffc1040 RTPROP=0x83ffc7040 SMBIOS 3.0=0x7bff7000 MEMRESERVE=0x83ffad040

[    8.329493] Freeing unused kernel memory: 4672K
[    8.334044] Run /sbin/init as init process
[    9.170452] systemd[1]: systemd 255.21^ running in system mode (+PAM -AUDIT -SELINUX -APPARMOR +IMA -SMACK +SECCOMP -GCRYPT -GNUTLS +OPENSSL +ACL +BLKID -CURL -ELFUTILS -FIDO2 -IDN2 -IDN -IPTC +KMOD -LIBCRYPTSETUP +LIBFDISK -PCRE2 -PWQUALITY -P11KIT -QRENCODE -TPM2 -BZIP2 -LZ4 -XZ -ZLIB +ZSTD -BPF_FRAMEWORK +XKBCOMMON +UTMP +SYSVINIT default-hierarchy=unified)
[    9.202351] systemd[1]: Detected architecture arm64.

Welcome to AMD Embedded Development Framework Linux distribution 25.11.1+development-e96834ba24a16dc2257c707a94683bb1eb6d720a (scarthgap)!

[    9.243427] systemd[1]: Hostname set to <amd-edf>.
[    9.609748] systemd[1]: /usr/lib/systemd/system/xen-qemu-dom0-disk-backend.service:11: PIDFile= references a path below legacy directory /var/run/, updating /var/run/xen/qemu-dom0.pid → /run/xen/qemu-dom0.pid; please update the unit file accordingly.
[    9.772600] systemd[1]: Queued start job for default target Multi-User System.

[   12.823267] FAT-fs (sdd1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[  OK  ] Mounted /efi.
[  OK  ] Reached target Local File Systems.
         Starting Update Boot Loader Random Seed...
         Starting Automatic Boot Loader Update...
         Starting Create System Files and Directories...
[  OK  ] Finished Create System Files and Directories.

[  OK  ] Finished Permit User Sessions.
[  OK  ] Started Getty on tty1.
[  OK  ] Started Serial Getty on ttyAMA0.
[  OK  ] Started Serial Getty on ttyAMA1.
[  OK  ] Reached target Login Prompts.
[  OK  ] Started Target Communication Framework agent.
[  OK  ] Finished dfx-mgrd Default Firmware Load Service.
[  OK  ] Started Authorization Manager.
         Starting Modem Manager...
[  OK  ] Started Modem Manager.

AMD Embedded Development Framework Linux distribution 25.11.1+development-e96834ba24a16dc2257c707a94683bb1eb6d720a amd-edf ttyAMA1

amd-edf login: amd-edf  <-------- IMPORTANT
Password:

WARNING: AMD Embedded Development Framework is a reference Yocto Project
distribution that should be used for testing and development purposes only.
It is recommended that you create your own distribution for production use.

amd-edf:~$    <-------- IMPORTANT
```

<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2026 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>

<p class="sphinxhide" align="center"><sub>###### SPDX-License-Identifier: MIT</sub></p>
