<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Adaptive SoC DFX Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# Different NoC Connectivity

***Version: Vivado 2023.2***

## Introduction

This design demonstrates different NoC connections allowed in DFX designs. Broadly, there are three main categories shown in this example design.
- NoC Master (NMU) in the static region drives NoC Slave (NSU) in a reconfigurable partition (RP1).
- NoC Master (NMU) in a reconfigruable partition (RP2) drives NoC Slave (NSU) in the static region.
- NoC Master in one reconfigurable partition (RP3) drives NoC Slave in another reconfigurable partition (RP4) through a static logical NoC instance.
- RM-Static data transfer is done using NoC INI ports. Hence, no PL based DFX decoupler is needed.

## Design Flow

Follow the design flow steps from tutorials "1RP design 1RP_AXI_GPIO_in_RP_Interface_INI" and "2RP_GPIO_BRAM_in_RP_Interface_INI" to become familiar with IPI based DFX design flows in AMD Vivado&trade;.

### Bottom-Up IPI Design Creation Approach

Unlike the top-down approach, this tutorial uses a bottom-up approach for IPI design creation. The <code>create_ipi.tcl</code> script creates individual BDs for each reconfigurable partition first, followed by a top BD creation that references the block design containers of individual reconfigurable partitions.

`source create_ipi.tcl`

- Once the IPI design creation is completed, the design is categorized into five hierarchies: One static region and four reconfigurable partitions.

<p align="center">
  <img src="./images/top_bd_with_all_bdcs.png?raw=true" alt="top_bd_with_all_bdcs"/>
</p>

#### Connectivity 1: NoC NMU in static region drives NoC NSU in Reconfigurable Partition RP1

This interface demonstrates the connectivity where a master (AXI Traffic Generator) in static region is driving a slave (AXI BRAM) in the reconfigurable partition RP1. The LNOC (master) in static region drives the LNOC (slave) in the reconfigurable partition through Inter-NoC-Interface (INI).   

<p align="center">
  <img src="./images/NMU_in_Static_NSU_in_RM.png?raw=true" alt="NMU_in_Static_NSU_in_RM"/>
</p>

#### Connectivity 2: NoC NMU in Reconfigurable Partition RP2 drives NoC NSU in Static Region

This interface demonstrates the connecitivy where a master (AXI Traffic Generator) in reconfigurable partition RP2 drives a slave (AXI BRAM) in the static region. The LNOC (master) in reconfigurable partition RP2 drives the LNOC (slave) in the static region through Inter-NoC-Interface (INI).   

<p align="center">
  <img src="./images/NMU_in_RM_NSU_in_static.png?raw=true" alt="NMU_in_RM_NSU_in_static"/>
</p>

#### Connectivity 3: NoC NMU in Reconfigurable Partition RP3 drives a NoC NSU in Reconfigurable Partition RP4 through a logical NoC instance in Static Region

This interface demonstrates the communication between multiple reconfigurable partitions using NoC. Users are required to add a logical NoC instance in the static region for the NoC paths between multiple reconfigurable partitions. In this design, AXI TG in RP3 drives AXI FIFO in RP4 through a LNOC in the static region.

<p align="center">
  <img src="./images/NoC_RP_to_RP_through_static.png?raw=true" alt=NoC_RP_to_RP_through_static"/>
</p>

## Hardware Validation
1. AXI Traffic Generator in Static Region configured in the Static Mode. Enable this and observe the data in BRAM of RP1 (rp1rm1)
2. Download the rp1rm2 partial PDI. After successful download, you should observe BRAM values back to its initialization value (0x0).
3. AXI Traffic Generator in RP2 is configured in the Static Mode without Address Sweep in rp2rm1. Enable this and observe the data in BRAM of Static Region.
4. Download the rp2rm2 partial PDI. In rp2rm2, AXI TG is configured in the Static mode with Address Sweep enabled. Enable the AXI TG and observe the data in BRAM of static region across specific address range.
5. In RP3, AXI TG is configured again in the Static mode with AXIS interface to static. In the RP4, AXI Stream FIFO is the slave that recieves the data from RP3 through static LNOC.



<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
