<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Adaptive SoC Boot and Configuration Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# JTAG Boot Tutorial: Custom Board Bring-up Resources

***Version: Vivado 2021.2***

## Table of Contents

1. [Introduction](README.md)

2. [Before You Begin](2BeforeYouBegin.md)

3. [Quick-Start Instructions](3QuickStartInstructions.md)

4. [Building Hardware Design](4BuildingHardwareDesign.md)

5. [Debug Resources](5DebugResources.md)

6. Custom Board Bring-up Resources  

7. [References](7References.md)

## Resources for Custom Board Bring-up
This tutorial loads an example reference design into the VCK190, which has a power delivery solution option with Infineon. Each custom board must manage Versal Adaptive SoC power up and sequencing based on application requirements. The VCK190 may not be optimal for all solutions. For custom boards, review the example power delivery solutions for Versal Adaptive SoCs at http://www.xilinx.com/power.

The best practices described in this section are a few key general checks for custom board bring-up. These are applicable regardless of the power solution that the board has selected and may refer to the VCK190 as an example.

If boot debug is required during custom board bring-up, check that the REF_CLK is running before the POR_B signal is released. Ensure the key power rails VCCO_503, VCC_PMC, and VCCAUX_PMC are at expected levels before the POR_B is released. All rails should be checked against Xilinx power estimator (XPE) to ensure proper sequencing.

### Power Rails and Sequencing:
When bringing up a new custom board, basic voltage power rail checks for level and sequence are recommended. Refer to the Xilinx Power Estimator User Guide for Versal Adaptive SoC [(UG1275)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug1275-xilinx-power-estimator-versal.pdf) power sequence requirements, information on rail relationship to domains and components, and recommended example solutions for different applications. Refer to the Versal AI Core Series Data Sheet: DC and AC Switching Characteristics [(DS957)](https://www.xilinx.com/support/documentation/data_sheets/ds957-versal-ai-core.pdf) for the operating range of each power rail. Verify that the power rails used are within the appropriate specification levels for the selected family and speed grade.

### Clocking and Reset

* Verify the REF_CLK clock is stable before POR_B is released and follows the data sheet specification. The REF_CLK default setting in CIPS will be 33.333MHz, the same REF_CLK frequency the VCK190 uses.

* Verify that the REF_CLK input is running and the PMC power rails (VCC_503, VCC_PMC, and VCCAUX_PMC) are stable (at minimum) before the POR_B pin is released. When POR_B is released it will begin the boot and initialization process. Refer to Xilinx Power Estimator User Guide for Versal Adaptive SoC [(UG1275)](https://www.xilinx.com/content/dam/xilinx/support/documentation/sw_manuals/xilinx2021_2/ug1275-xilinx-power-estimator-versal.pdf) for additional sequencing requirements.

* ###### Important Note:
Devices with two REF_CLKs (REF_CLK0 and REF_CLK1) must be supplied from the same clock source. See REF_CLK recommendations in the Versal Adaptive SoC PCB Design User Guide (UG863).

### Interfaces Recommended for Custom Board Bring-up (JTAG and UART)

For custom board bring-up, it is helpful to have both UART and JTAG access. JTAG provides the simplest boot mode access to the Versal acap. UART can be used for PLM execution status and debug.

#### JTAG Interface
* JTAG is the simplest boot mode and recommended for initial Versal Adaptive SoC custom board bring-up.
* System monitor and registers (JTAG and memory mapped) can be accessed to provide status on boot, to monitor the device, and for debug.
* Connect the standard IEEE 1149.1 JTAG signals (TCK, TMS, TDI, TDO), as instructed in Versal Adaptive SoC Schematic Review Checklist (XTP546) and Versal Adaptive SoC PCB User Guide [(UG863)](https://www.xilinx.com/support/documentation/user_guides/ug863-versal-pcb-design.pdf).
* JTAG is a valuable debug interface even if another primary boot mode is selected for production. Provide access to set the mode pins (MODE[3:0]=0000) to JTAG boot mode for initial boot board bring-up and debugging future updates.
* After a primary boot attempt, the JTAG boot mode can also be accessed after a system reset with the BOOT_MODE_USER register. As an example, Vivado Hardware Manager uses the BOOT_MODE_USER register to set JTAG boot mode register when debugging or indirectly programming flash via JTAG that are accessible by PMC controllers (i.e., QSPI, OSPI, and eMMC). Refer to the Versal Adaptive SoC Register Reference [(AM012)](https://www.xilinx.com/html_docs/registers/am012/am012-versal-register-reference.html#pmc_global___pmc_err1_status.html) for more details on this register.

* ###### Important Note:
Custom boards that use SelectMAP as primary boot mode are recommended to include the JTAG boot mode setting selection from the MODE pins. If JTAG PDI boot is required for debug or testing, it will enable testing from power up. For example, a board fixed to SelectMAP boot mode will require a successful SelectMAP boot, an error condition seen, or timeout (~30 min) if nothing is driven on the SelectMAP interface before a secondary boot (JTAG boot) can be tried.   

#### UART Interface:
* Ensure the UART interface is connected, as instructed in Versal Adaptive SoC Schematic Review Checklist (XTP546) and Versal Adaptive SoC PCB User Guide [(UG863)](https://www.xilinx.com/support/documentation/user_guides/ug863-versal-pcb-design.pdf) recommendations.
* Provides a method to view PLM execution, boot status, and advanced debug with boot timestamps.

* ###### Important Note:
 UART access is recommended, but in cases that the UART is not accessible, access the PLM log with the xsct command. The PLM log is a valuable debug output. The -log-size option should be used if an error is encountered to get the full PLM log and register dump. By default, the PLM log buffer size is 1024 bytes.

```
xsct% connect
xsct% ta 1
xsct% plm log -log-size 4000
```
For additional detail on the PLM log command use the following:
```
xsct% plm log -help
```

### General Custom Board Review
* Versal Adaptive SoC Schematic Review Checklist (XTP546) recommendations should be followed. See the schematic review checklist for the user selected peripherals, MIO, and dedicated I/O usage.

* Versal Adaptive SoC PCB User Guide [(UG863)](https://www.xilinx.com/support/documentation/user_guides/ug863-versal-pcb-design.pdf) recommendations should be followed. Refer to this user guide for interface recommendations on trace lengths, pull-ups and pull-downs, guidance on simulation, and PCB interface requirements.

* VCK190 schematic can be used as an example reference.
  * [VCK190 schematic example](https://www.xilinx.com/member/vck190_headstart/VCK190_VMK180_REVA04.pdf)
  * [VCK190 constraints file example](https://www.xilinx.com/member/vck190_headstart/vck190_vmk180_Master_XDC.zip)


* Versal Adaptive SoC Technical Reference Manual [(AM011)](https://www.xilinx.com/support/documentation/architecture-manuals/am011-versal-acap-trm.pdf) should be reviewed for general hardware boot information, details on the PMC and PS flash controllers, peripheral interfaces, and MIO options.

* Versal Adaptive SoC System Software Developers User Guide [(UG1304)](https://www.xilinx.com/content/dam/xilinx/support/documentation/sw_manuals/xilinx2021_2/ug1304-versal-acap-ssdg.pdf) should be reviewed for boot flow information and use cases (i.e., MultiBoot or secondary boot requirements).

* For custom boards with non-Xilinx devices included in the JTAG device chain, ensure the other non-Xilinx devices are fully JTAG compliant. If the non-Xilinx devices use optional signals (i.e., TRST) ensure they are tied appropriately because Xilinx devices do not support.


### Go To Next Section:  
[References](7References.md)

### Go To Table of Contents:  
[README](README.md)


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
