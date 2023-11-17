<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo_30percent.png?raw=true" width="30%"/><h1>2023.1 Versal Tutorial: Post BootROM State</h1>
   </td>
 </tr>
</table>

# Table of Contents

1. [Introduction](#introduction)

2. [Before You Begin](#before-you-begin)

3. [Building Hardware Design](#building-hardware-design)

4. [Building Software Design](#building-software-design)

5. [Running the Design](#running-the-design)

6. [Collecting Results](#collecting-results)

# Introduction

This Versal example design is intended to illustrate the post bootROM state (pre-PLM) of the device on different boot modes, just to verify the registers modified by Versal ROM code. The idea is to replicate for Versal the information provided on Table 6-22 and Table 6-11 of UG585 for Zynq-7000 and Table 37-7 of UG1085 for Zynq UltraScale+ MPSoC/RFSoC.

## Directory Structure
<details>
<summary> Tutorial Directory Details </summary>

```
Post_Boot
|___Software/Vitis.........Contains Vitis Design files
  |___bootimage......................Contains bootimage files
  |___src............................Contains Software source files
|___Scripts................Contains TCL scripts to generate reference Design, PDI, etc...
  |___postbootrom.tcl................Prints Register Readouts
  |___vitis.tcl......................Generates the Vitis Design
|___README.md..............Includes tutorial overview, steps to create reference design, and debug resources
```
</details>

# Before You Begin

Recommended general knowledge of:

* VCK190 evaluation board
* Versal QSPI boot mode
* Versal SD boot mode
* Versal PMC
* AMD Vitis IDE

<details>

<summary> Key Versal Reference Documents </summary>

* VCK190 Evaluation Board User Guide [(UG1366)](https://docs.xilinx.com/r/en-US/ug1366-vck190-eval-bd)
* Versal Technical Reference Manual [(AM011)](https://www.xilinx.com/support/documentation/architecture-manuals/am011-versal-acap-trm.pdf)
* Versal System Software Developers User Guide [(UG1304)](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1304-versal-acap-ssdg.pdf)
* Versal Adaptive SoC Register Reference [(AM012)](https://docs.xilinx.com/r/en-US/am012-versal-register-reference)

</details>

<details>

<summary> Versal Terms </summary>

|Term|Description|
|  ---  |  ---  |
|Platform management controller (PMC)|Manages Versal ACAP boot and the life cycle management of the device. The PMC ROM Code Unit (RCU) and platform processing unit (PPU) are responsible for booting the device.|
|ROM code unit (RCU)| Includes a microblaze processor that executes the BootROM to initiate the boot phase2: boot setup.|
|Platform processing unit (PPU)|Includes a microblaze processor that executes the platform loader and manager (PLM) to initiate the boot phase3: load platform.|
|Scalar engines|Includes the processing system (PS) Dual-Core ARM Cortex R5F and A72.|
|Adaptable engines|Includes Versal adaptable hardware also referred to in this tutorial as programmable logic (PL).|
|Control Interfaces and Processing System (CIPS)|CIPS LogiCORE IP sets the configuration of PMC/PS peripherals, clocks, and MIO.|
|BootROM|Responsible for initial security and boot mode interface checks. Reads and processes the PDI boot header. Releases the PMC PPU to complete the boot phases. See the Versal Technical Reference Manual [(AM011)](https://www.xilinx.com/support/documentation/architecture-manuals/am011-versal-acap-trm.pdf) for more detail on BootROM.|
|Platform loader and manager (PLM)|Responsible for the final boot phases to load the PDI. Executes supported platform management libraries and application user code. See the Versal System Software Developers User Guide [(UG1304)](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1304-versal-acap-ssdg.pdf) for more detail on the PLM.|
|Programmable device image (PDI)|Boot image for programming and configuring the Versal Adaptive SoC device. See the BootGen UG1283 for details on the format. See system software developers user guide for details on how PLM manages the images and partitions.|
|MIO| Multiplexed IO pins that can be configured for different peripherals and functions.|
|DIO| Dedicated IO pins dedicated for specific functions, such as JTAG (TCK, TMS, TDI, TDO) or power-on reset (POR_B).|

</details>

## Tutorial Requirements

Note: This tutorial targets the VCK190 evaluation board, but the methodology flow also applies to the VMK180 evaluation board.

#### Hardware Requirements:

* Host machine with an operating system supported by Vitis IDE 2023.1
* VCK190 Evaluation Board, which includes:
  * Versal Adaptive SoC XCVC1902-2VSVA2197
  * AC power adapter (100-240VAC input, 12VDC 15.0A output).
  * System controller microSD card in socket (J302).
  * USB Type-C cable (for JTAG communications).
  * Boot Module X-EBM-01 (QSPI)

#### Software Requirements:
In order to build and run the tutorial reference design, the following must be available or installed:
  * Vitis IDE 2023.1:
  	- Visit https://www.xilinx.com/support/download.html for the latest tool version.
  	- For more information on installing Vitis, refer to [UG1400 Vitis Unified Software Platform Embedded Software Development](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2023_1/ug1400-vitis-embedded.pdf).
  * Scripts to generate the reference design are provided in the `Scripts` directory 
  * Command-line interpreter, such as Command Prompt (cmd) in Windows or Bash in Linux

# Building Hardware Design

Custom hardware designs will not be required in this tutorial.

# Building Software Design

## Vitis

To set up the Vitis environment, use the command-line interpreter:
* Windows 32-bit: Run the settings32.bat from the Vitis/2023.1 directory
* Windows 34-bit: Run the settings64.bat from the Vitis/2023.1 directory
* Linux 32-bit: Run the settings32.sh from the Vitis/2023.1 directory
* Linux 64-bit: Run the settings64.sh from the Vitis/2023.1 directory

Enter the `Scripts` directory. From the command line run the following:

```Tcl
xsct ../Scripts/vitis.tcl
```

The Vitis workspace will be created in `Software/Vitis/workspace` with the VCK190_platform and the customized PLM code. The PLM is customized by adding a `while(1);` loop at the beginning of main() to halt the PLM execution so bootROM post configuration is NOT altered.

Additionally the boot image containing solely the custom PLM will be generated and the BOOT.bin file placed within the `Software/Vitis/bootimage` folder.

Program/copy the boot image into the boot device:

* SD: Copy the BOOT.bin file into the SD card
* QSPI: Use program_flash to program the flash device with the previously generated boot image.

```
program_flash -f Software/Vitis/bootimage/BOOT.bin -pdi Software/Vitis/workspace/vck190_platform/hw/vck190.pdi -flash_type qspi-x8-dual_parallel -url <hw_server URL>
```

# Running the Design

The `postbootrom.tcl` script reads and prints relevant registers. The script takes as reference the boot mode and the URL of the hw_server used to connect to the device and dumps the register values. 
The script assumes the board is configured in JTAG boot mode and the boot image has been already programed/copied into the boot device. Run the script from the `vck190_post_boot` directory.

```Tcl
xsct Scripts/postbootrom.tcl -bootmode jtag -url <hw_server URL>
```
```Tcl
xsct Scripts/postbootrom.tcl -bootmode qspi32 -url <hw_server URL>
```
```Tcl
xsct Scripts/postbootrom.tcl -bootmode sd1_ls -url <hw_server URL>
```

Here is an example of the script output running QSPI boot mode:
```
Versal PostBootROM Register Status
HW Server URL:  XXXXXXXXXX
attempting to launch symbol_server
Boot mode: qspi32
Microblaze PPU, pc: f020076c


*** PLL Clock Registers
NOCPLL_CTRL is 0x00024809
PMCPLL_CTRL is 0x00024800
APLL_CTRL is 0x00024809
RPLL_CTRL is 0x00024809
CPLL_CTRL is 0x00024800

*** Processor Clock Registers
ACPU_CTRL is 0x02000200
CPU_R5_CTRL is 0x0E000300

*** Peripheral Clock Registers
SDIO1_REF_CTRL is 0x01000600
QSPI_REF_CTRL is 0x01000B00
CFU_REF_CTRL is 0x02000300
I2C_REF_CTRL is 0x00000C00
NPI_REF_CTRL is 0x00000400
SDDLL_REF_CTRL is 0x00000100
SDIO0_REF_CTRL is 0x01000600
OSPI_REF_CTRL is 0x01000400

*** MIO Registers
0xF1060000: 0x00000006
0xF1060004: 0x00000006
0xF1060008: 0x00000006
0xF106000C: 0x00000006
0xF1060010: 0x00000006
0xF1060014: 0x00000006
```

# Collecting Results

## Clocks

### PLL

| Register Name | Base Address | Reset Value   | JTAG  | QSPI32 | SD1_LS |
|---|---|---|---|---|---|
| PMCPLL_CTRL | 0xF1260040 | 0x00024809 | **0x00024800**  | **0x00024800**  | **0x00024800** |
| NOCPLL_CTRL | 0xF1260050 | 0x00024809 |  - |  - | -  |
| APLL_CTRL   | 0xFD1A0040 | 0x00024809 |  - | -  | -  |
| RPLL_CTRL   | 0xFF5E0040 | 0x00024809 |  - | -  | -  |
| CPLL_CTRL   | 0xF1260040 | 0x00024809 | **0x00024800** | **0x00024800**  | **0x00024800** |

### Processors

| Register Name | Base Address | Reset Value   | JTAG  | QSPI32 | SD1_LS |
|---|---|---|---|---|---|
| ACPU_CTRL   | 0XFD1A010C | 0X02000200 | -  | -  | - |
| CPU_R5_CTRL | 0XFF5E010C | 0x0E000300 |  - |  - | -  |

#### Peripherals

| Register Name | Base Address | Reset Value   | JTAG  | QSPI32 | SD1_LS |
|---|---|---|---|---|---|
| QSPI_REF_CTRL  | 0XF1260118 | 0X01000400 | - | **0x1000B00**  | - |
| OSPI_REF_CTRL  | 0xF1260120 | 0X01000400 | - | - | - |
| SDIO0_REF_CTRL | 0xF1260124 | 0x01000600 | - | - | - |
| SDIO1_REF_CTRL | 0XF1260128 | 0x01000600 | - | - | **0x01001200** |
| SD_DLL_REF_CTRL| 0XF1260160 | 0X00000100 | - | - | - |
| I2C_REF_CTRL   | 0xF1260130 | 0x00000C00 | - | - | - |
| CFU_REF_CTRL   | 0xF1260108 | 0x02000300 | - | - | - |
| NPI_REF_CTRL   | 0xF1260114 | 0x00000400 | - | - | - |

The registers can be used to calculate BootROM xx_REF_CLK speeds. xx_REF_CLK is used by the respective controller. This is NOT the clock at the interface pins. 

The following QSPI_REF_CLK example assumes the board default settings are used, which uses the PMC PLL as the source and REF_CLK is 33.33 MHz.

The following formula should be used to calculate QSPI_REF_CLK:
`QSPI_REF_CLK = REF_CLK x FBDIV / CLKOUTDIV / DIVISOR`

Referencing AM012, FBDIV is 0x48(72), CLKOUTDIV is 4, and DIVISOR is 11:
`QSPI_REF_CLK = 33.33 x 72 / 4 / 11 = 54.54 MHz`

To get the interface clock frequencies, the following formulas should be used:
`QSPI_CLK = QSPI_REF_CLK / BAUD_RATE_DIV`
`SD_CLK = SD_REF_CLK / SDClkFreqDiv_L`

### Multiplexed IOs

#### QSPI32 with x4 single configuration
| Base Address | MIO Pin | Register Value  | I/O signal |
|---|---|---|---|
|0xF1060000 | MIO_PIN_0 | **0x6** | qspi_sclk_out |
|0xF1060004 | MIO_PIN_1 | **0x6** | qspi_mo1 |
|0xF1060008 | MIO_PIN_2 | **0x6** | qspi_mo2 |
|0xF106000C | MIO_PIN_3 | **0x6** | qspi_mo3 |
|0xF1060010 | MIO_PIN_4 | **0x6** | qspi_mi0 |
|0xF1060014 | MIO_PIN_5 | **0x6** | qspi_n_ss_out |
|0xF1060018 | MIO_PIN_6 | 0x0 | sysmon_i2c_smbalert_input |

`BootROM does not use qspi_clk_for_lpbk signal so the MIO Pin 6 remains in the default state as an input signal`

The registers can be used to interpret MIO settings. For example, MIO_PIN_1 has the value 0x6. Referencing AM012, this shows that MIO1 is configured as QSPI0_IO[1] input/output.

#### QSPI32 with x8 dual parallel configuration
| Base Address | MIO Pin | Register Value  | I/O signal |
|---|---|---|---|
|0xF1060000 | MIO_PIN_0 | **0x6** | qspi_sclk_out |
|0xF1060004 | MIO_PIN_1 | **0x6** | qspi_mo1 |
|0xF1060008 | MIO_PIN_2 | **0x6** | qspi_mo2 |
|0xF106000C | MIO_PIN_3 | **0x6** | qspi_mo3 |
|0xF1060010 | MIO_PIN_4 | **0x6** | qspi_mi0 |
|0xF1060014 | MIO_PIN_5 | **0x6** | qspi_n_ss_out |
|0xF106001C | MIO_PIN_7 | **0x6** | qspi_n_ss_out_upper |
|0xF1060020 | MIO_PIN_8 | **0x6** | qspi_upper[0] |
|0xF1060024 | MIO_PIN_9 | **0x6** | qspi_upper[1] |
|0xF1060028 | MIO_PIN_10 | **0x6** | qspi_upper[2] |
|0xF106002C | MIO_PIN_11 | **0x6** | qspi_upper[3] |
|0xF1060030 | MIO_PIN_12 | **0x6** | qspi_sclk_out_upper |

`BootROM does not use qspi_clk_for_lpbk signal so the MIO Pin 6 remains in the default state as an input signal`

The registers can be used to interpret MIO settings. For example, MIO_PIN_8 has the value 0x6. Referencing AM012, this shows that MIO1 is configured as QSPI1_IO[0] input/output.

#### SD1_LS (3.0)
| Base Address | MIO Pin | Register Value  | I/O signal |
|---|---|---|---|
|0xF1060068 | MIO_PIN_26 | **0x2** | sdio1_clk_out |
|0xF106006C | MIO_PIN_27 | **0x2** | sd1_data[7[]] |
|0xF1060070 | MIO_PIN_28 | 0x0 | sysmon_i2c_smbalert_input |
|0xF1060074 | MIO_PIN_29 | **0x2** | sd1_cmd |
|0xF1060078 | MIO_PIN_30 | **0x2** | sd1_data[0] |
|0xF106007C | MIO_PIN_31 | **0x2** | sd1_data[1] |
|0xF1060080 | MIO_PIN_32 | **0x2** | sd1_data[2] |
|0xF1060084 | MIO_PIN_33 | **0x2** | sd1_data[3] |
|0xF1060088 | MIO_PIN_34 | **0x2** | sd1_data[4] |
|0xF106008C | MIO_PIN_35 | **0x2** | sd1_data[5] |
|0xF1060090 | MIO_PIN_36 | **0x2** | sd1_data[6] |
|0xF10600C8 | MIO_PIN_50 | 0x0 | sysmon_i2c_sda_input |
|0xF10600CC | MIO_PIN_51 | **0x2** | sdio1_bus_pow |

`BootROM does not use sdio1_cd_n and sdio1_wp signals so the MIO Pin 28 and 50 remains in the default state as an input signal`

The registers can be used to interpret MIO settings. For example, MIO_PIN_29 has the value 0x2. Referencing AM012, this shows that MIO29 is configured as SD1_CMD, eMMC_CMD input/output.

# Notes

This tutorial was created using Vitis IDE 2023.1. This has also been tested with Vitis IDE 2023.2 on Linux.

# Support

GitHub issues will be used for tracking requests and bugs. For questions go to [forums.xilinx.com](http://forums.xilinx.com/).

# License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0]( http://www.apache.org/licenses/LICENSE-2.0 )



Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

<p align="center"><sup>XD0xx | &copy; Copyright 2021 Advanced Micro Devices, Inc.</sup></p>