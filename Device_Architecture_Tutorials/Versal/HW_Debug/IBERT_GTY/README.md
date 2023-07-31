<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal ACAP Hardware Debug Tutorial</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Versal IBERT GTY Tutorial</h1>
 </td>
 </tr>
</table>

## Introduction

## Hardware Setup

1. QSPI loopback?

## Design Creation
A design that is IBERT capable can be generated quickly using the CED.


1. Launch Vivado 2023.1 and select **Open Example Design** at the landing page.  Click **Next** to proceed.
    ![](./images/01_open_example_project.png)
1. In the **Select Project Template** window, scroll to the **Versal IBERT** template.  Click **Next**.
    _Note:  If the Versal IBERT example design is not present, click **Refresh**
	![](./images/02_IBERT_Example_1.png)
1. _(Optional)_ If desired, enter a project name and choose a location for the project to be created. 
1. This design targets the VCK190 Evaluation Kit which has the XCVC1902-2MSEVSVA2197 Versal AI Core device.  In the part selection page, select: `xcvc1902-vsva2197-2MP-e-S` to target this part.
    ![](./images/03_part_selection.png)
1. Referencing the [VCK190 User Guide GTY Transceivers Section](https://docs.xilinx.com/r/en-US/ug1366-vck190-eval-bd/GTY-Transceivers) and the [VCK190 Evaluation Board User Guide Clock Generation Section](https://docs.xilinx.com/r/en-US/ug1366-vck190-eval-bd/Clock-Generation) it can be observed that the following GTY Quads are connected as follows with the following reference clocks:

    | Quad | Reference Clock Source | Reference Clock Frequency (MHz) | 
	|------|------------------------|---------------------------------|
	| 200  | Shared from QUAD 201 | - |
	| 201  | SI570 Connected to REFCLK0 | 100 MHz | 
	| 204  | SI570 Connected to REFCLK0 | 100 MHz |
	
1. In the **Design Preset** menu, select the following, then click **Next** and finally **Finish** to generate the design.
    
	![](./images/04_quad_selection.png)
	
1. After the IBERT Example Design is created, click **Generate Device Image** from the flow navigator.  While PDI generation completes, proceed to the next section for hardware setup.
   
   ![](./images/05_generate_pdi.png)

## Hardware Setup

1. QSPI loopback?

## Generating the PDI and Programming into Hardware

1.  Program into hardware

## Interacting with IBERT using the Serial I/O Analyzer

1. Create links
1. Create scan
1. Create sweep

### Chipscopy plug?

## Conclusion


<p class="sphinxhide" align="center"><sub>Copyright © 2020–2023 Advanced Micro Devices, Inc</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
