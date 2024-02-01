<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Adaptive SoC PCB Design Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# Memory Interface Planning

***Version: Vivado 2021.1***


## Introduction
The Versal&trade; external memory pre-planning tool allows system architects to quickly determine which Versal devices are suitable for their memory interace needs.<p>

The tool has two portions.   The first portion is an overview table that shows all of the Versal devices and the maximum capacities for each type of hardened memory interface (such as DDR4 or LPDDR4).     The second portion of the tool is interactive. It allows the user to specify the exact memory interfaces required and determines which Versal devices can accommodate them.<p>

## Overview Table

The **## of Interfaces** tab shows an overview of all Versal devices and supported hardened memory interfaces.   The maximum amount of each interface that can fit in each device is listed, assuming it is the only interface used.   This is useful to get a quick understanding of the capacities of each device.<p>

![Interfaces](images/interfaces.png)

## Dynamic Assessment

The **Dynamic Assessment** tab contains the interactive portion of the tool where a specific amount of interfaces can be entered as well as a list of devices that can accommodate them all.   This tab also contains a placement routine which can be run to approximate how each selected interface will be placed in the device.

![Dynamic Assessment](images/dynamic_assessment.png)

The sections of the dynamic assessment are as follows:

## Quantity Selection

1. Choose the desired datarate for any LPDDR4 interfaces.  NOTE: Some banks in some devices do not support the fastest datarates.
2. For LPDDR4 1x32 or LPDDR4 2x32 interfaces, check this box when the pin-efficient pinout is desired.
3. Manually type in the desired quantity for each interface.    Press ENTER after typing each quantity or click elsewhere on the sheet.
4. OPTIONAL:   Check this box to run the placement routine now and after each quantity change.   NOTE:   Keeping this checked slows down the placement results.
5. After each quantity change, the devices are listed in the order in which the quantities specified can be supported.   If selected quantities cannot fit in a device, the primary reason why is listed.

![Quantity](images/quantity_results.png)

## Placement Routine

If the **Run Placement** box was checked in step 4 above, a placement routine is run to show where each chosen interface is placed in each Versal device that can support the number of interfaces.   NOTE:  As mentioned above, the placement routine takes some time, so only check the **Run Placement** button after all desired interface quantities have been selected.

The placements shown are approximate and for illustration purposes only to show how the interfaces might be placed by the Vivado® software.   Do not rely on this placement for any purpose other than a general approximation.

![Placement](images/placement.png)


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
