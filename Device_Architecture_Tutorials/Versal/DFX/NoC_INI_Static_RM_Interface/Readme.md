<table>
 <tr>
   <td align="center"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Versal DFX Tutorial</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Different NoC connectivity </h1>
 </td>
 </tr>
</table>

# Introduction

This design demonstrates different allowed NoC connections allowed in a DFX design. Broadly, there are three main categories demo-ed in this example design.
- NoC Master (NMU) in static region drives NoC Slave (NSU) in reconfigurable partition (RP1).
- NoC Master(NMU) in reconfigruable partition  (RP2) drives NoC Slave (NSU) in the static region.
- NoC Master in one reconfigurable partition (RP3) driving NoC Slave in another reconfigurable partition (RP4) through a static logical NoC instance.
- RM-Static data transfer is done using NoC INI ports. Hence no PL based decoupler is used.

# Design Flow

Follow the design flow steps from tutorials" 1RP design 1RP_AXI_GPIO_in_RP_Interface_INI" and "2RP_GPIO_BRAM_in_RP_Interface_INI" to get familiar with IPI based DFX design creations in Vivado.

## Bottom-Up IPI Design Creation Approach

Unlike the top-down approach, this tutorial uses a bottom-up approach for IPI design creation. The create_ipi.tcl creates individual BDs for each reconfigurable partition first, followed by a top BD creation that references the block design containers of individual reconfigurable partitions.

`source create_ipi.tcl`

- Once the IPI design creation is complete, you will observe design is categorized into 5 hierarchies: 1 static region and 4 reconfigurable partitions.

<p align="center">
  <img src="./images/top_bd_with_all_bdcs.png?raw=true" alt="top_bd_with_all_bdcs"/>
</p>

### Connectivity 1: NoC NMU in static region drives NoC NSU in Reconfigurable Partition RP1

This interface demonstrates the connectivity where a master (AXI Traffic Generator) in static region is driving a slave (AXI BRAM) in the reconfigurable partition RP1. The LNOC (master) in static region drives the LNOC (slave) in the reconfigurable partition through Inter-NoC-Interface (INI).   

<p align="center">
  <img src="./images/NMU_in_Static_NSU_in_RM.png?raw=true" alt="NMU_in_Static_NSU_in_RM"/>
</p>

### Connectivity 2: NoC NMU in Reconfigurable Partition RP2 drives NoC NSU in Static Region

This interface demonstrates the connecitivy where a master (AXI Traffic Generator) in reconfigurable partition RP2 drives a slave (AXI BRAM) in the static region. The LNOC (master) in reconfigurable partition RP2 drives the LNOC (slave) in the static region through Inter-NoC-Interface (INI).   

<p align="center">
  <img src="./images/NMU_in_RM_NSU_in_static.png?raw=true" alt="NMU_in_RM_NSU_in_static"/>
</p>

### Connectivity 3: NoC NMU in Reconfigurable Partition RP3 drives a NoC NSU in Reconfigurable Partition RP4 through a logical NoC instance in Static Region

This interface demonstrates the communication between multiple reconfigurable partitions using NoC. Users are required to add a logical NoC instance in the static region for the NoC paths between multiple reconfigurable partitions. In this design, AXI TG in RP3 drives AXI FIFO in RP4 through a LNOC in the static region.

<p align="center">
  <img src="./images/NoC_RP_to_RP_through_static.png?raw=true" alt=NoC_RP_to_RP_through_static"/>
</p>

# Hardware Validation
1. AXI Traffic Generator in Static Region configured in "Static" Mode. Enable this and observe the data in BRAM of RP1 (rp1rm1)
2. Download the rp1rm2 partial PDI . After the successful download, you should observe BRAM values back to its initialization value (0x0).
3. AXI Traffic Generator in RP2 is configured in "Static" Mode without "Address Sweep"  in rp2rm1. Enable this and observe the data in BRAM of Static Region.
4. Download the rp2rm2 partial PDI. In rp2rm2, AXI TG is configured in "Static" mode with "Address Sweep" enabled. Enable the AXI TG and observe the data in BRAM of static region across specific address range.
5. In RP3, AXI TG is configured again in "Static mode" with AXIS interface to static. In the RP4, AXI Stream FIFO is the slave that recieves the data from RP3 through static LNOC.

<p align="center"><sup>Copyright&copy; 2021 Xilinx</sup></p>
