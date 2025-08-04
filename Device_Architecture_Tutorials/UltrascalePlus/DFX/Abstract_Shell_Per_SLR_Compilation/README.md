<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Vivado™ Device Architecture Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# Parallel Compilation of SLRs using Abstract Shell Technology

***Version: Vivado 2022.1***

## Introduction
This tutorial demonstrates a  methodology to hierarchically arrange your design to achieve maximum QoR with minimal compile time for designs targeting multi SLR devices in Ultrascale+. Target of this methodology is to achieve the following:
- Minimize compile time by enabling parallel compilation of each SLR logic.
- Reduce the timing closure challenges intoroduced by SLR crossings by locking down SLR crossing registers.
- Modify partitions of the designs independently without affecting place and route of the other partitions.

This methodology leverages the abstract shell technology available on Xilinx Ultrascale+ families from Vivado 2020.2. Abstract shell works on the top of DFX technology. Please read more about the abstract shell feature in UG909 and UG947.

## Different Steps
- [Parallel Compilation of SLRs using Abstract Shell Technology](#parallel-compilation-of-slrs-using-abstract-shell-technology)
  - [Introduction](#introduction)
  - [Different Steps](#different-steps)
  - [Workflow of the tutorial](#workflow-of-the-tutorial)
  - [Individiual Steps](#individiual-steps)
    - [Create a design by partitioning into multiple hierarchies.](#create-a-design-by-partitioning-into-multiple-hierarchies)
    - [Using Vivado IP Integrator](#using-vivado-ip-integrator)
    - [About AXI Register Slices for SLR crossing](#about-axi-register-slices-for-slr-crossing)
    - [About SLR crossing registers hierarchy](#about-slr-crossing-registers-hierarchy)
    - [Allocate a fixed number of SLR crossings and design them upfront in initial implementation](#allocate-a-fixed-number-of-slr-crossings-and-design-them-upfront-in-initial-implementation)
    - [Creation of BDCs for each SLR RP](#creation-of-bdcs-for-each-slr-rp)
      - [Creation of ports](#creation-of-ports)
      - [Usage of AXI VIP and AXI Register Slice in the training RM](#usage-of-axi-vip-and-axi-register-slice-in-the-training-rm)
        - [Example picture of AXI Slave BD interface port.](#example-picture-of-axi-slave-bd-interface-port)
        - [Example picture of AXIS Master BD interface port.](#example-picture-of-axis-master-bd-interface-port)
      - [Creation of Embedded IO Ports](#creation-of-embedded-io-ports)
        - [Approach-1](#approach-1)
        - [Approach-2](#approach-2)
      - [Referencing Reconfigurable Partition BDs with Top BD](#referencing-reconfigurable-partition-bds-with-top-bd)
      - [Creating hierarchies for SLR crossing registers](#creating-hierarchies-for-slr-crossing-registers)
    - [BSCAN ports for Debug](#bscan-ports-for-debug)
    - [Generate the Targets, DFX Wizard and OOC Synthesis](#generate-the-targets-dfx-wizard-and-ooc-synthesis)
    - [Floorplanning](#floorplanning)
      - [Some examples to demonstrate Tips and Tricks for Flooplanning.](#some-examples-to-demonstrate-tips-and-tricks-for-flooplanning)
      - [About Pblocks for SLR crossing registers](#about-pblocks-for-slr-crossing-registers)
      - [Placement of Static Region](#placement-of-static-region)
      - [USER\_SLL\_REG constraint on SLR crossing registers](#user_sll_reg-constraint-on-slr-crossing-registers)
    - [Implementation](#implementation)
    - [Abstract Shell Creation](#abstract-shell-creation)
    - [Store the availale resources estimation of each reconfigurable pblock](#store-the-availale-resources-estimation-of-each-reconfigurable-pblock)
    - [Implementation of each Reconfigurable Partition using its abstract shell](#implementation-of-each-reconfigurable-partition-using-its-abstract-shell)
    - [Link all implemented cell DCPs to create one final routed DCP for full bitstream generation](#link-all-implemented-cell-dcps-to-create-one-final-routed-dcp-for-full-bitstream-generation)

## Workflow of the tutorial

<p align="center">
  <img src="./images/flowchart.png?raw=true" alt="flowchart"/>
</p>


1. Hierarchically partition the design into multiple hierarchies. This design uses a VU13P that has 4 SLRs. Hence the design is divided into 4 partitions. Each partition is defined as a reconfigurable partition.
2. Hierarchical arrangement of IPs is easily acheivable using Vivado IP Integrator (IPI). Also, from 2021.1 onwards, Vivado IPI supports Dynamic Function eXchange (DFX) using the Block Design Container (BDC) feature. Hence this tutorial uses IPI BDC to create hierarchies and reconfigurable partitions.
3. This tutorial assumes that all SLR crossings are AXI based. These SLR crossing IPs are in the static region in a seperate hierarchy. These will be locked down in the static region after initial implementation. If your SLR crossings are not AXI based, you still can use the same approach mentioned in this tutorial to lock them down in the static region.  
4. Create an initial implementation (we will call it "platform compile" in this tutorial) with your static region and bare minimum training logic in your reconfigurable partitions.
5. Once platform compile is complete, generate an abstract shell for each reconfigurable partition.
6. Create a new project with the abstract shell and BD for the corresponding reconfigurable partition.
7. Populate the reconfigurable partition BDs with the IPs, synthesize it,  link it with the abstract shell. Implement the corresponding reconfigurable partition in the context of its abstract shell. This step can happen in parallel as each reconfiguarble partition can be OOC synthesized independently, and implemented with its abstract shell in parallel.
8. Once abstract shell based implementation is complete, write out corresponding implemented cell DCPs. These implemented cell DCPs are linked together to create a final full DCP.

## Individiual Steps

### Create a design by partitioning into multiple hierarchies.
This tutorial uses Vivado IPI to create 4 reconfigurable partitions and a separate hierarchy for registers between these hierarchies. The static region does not necessary need to be one single hierarchy. However, for making floorplanning constraints easier, it is recommended to keep one hierarchy for the static region.

<p align="center">
  <img src="./images/block_diagram.png?raw=true" alt="block_diagram"/>
</p>

### Using Vivado IP Integrator

This design uses the block design container feature in IP integrator to define the reconfigurable partitions. A block design container is created for each reconfigruable partition. SLR crossing registers between RPs are only a hierarchy at the top BD. User is free to choose their own design entry to create hierarchies.

The design has 4 Block Design Containers: rp_slr0, rp_slr1, rp_slr2 and rp_slr3.


### About AXI Register Slices for SLR crossing
This tutorial uses AXI based SLR crossing registers to transfer signals across SLRs. SLR crossing registers are connected in cascade as recommended in the [AXI Regslice Documentation Guide](https://www.xilinx.com/support/documentation/ip_documentation/axi_register_slice/v2_1/pg373-axi-register-slice.pdf) page 24.

For example, In the picture shown below, axi_register_slice_0 and axi_register_slice_1 are inside the slr0_to_1_crossing hierarchy. This means the Slave interface from SLR0 is communicating to Master interface in SLR1 using this set of registers.  In this example, axi_regslice_0 is configured as shown below.
The regslices are configured to get SLR crossing endpoints as registers which will enable us to onload them to LAGUNA sites whenever possible.

<p align="center">
  <img src="./images/slr_crossing_axi_reg.png?raw=true" alt="slr_crossing_axi_reg"/>
</p>

If your design does not use AXI based protocol to cross SLRs, you can also use simple one or two stage register pipelines to cross between SLRs. You can either use a TCL based approach to lock the SLR crossing registers to LAGUNA/adjacent CLB column or use a fine-grained pblock approach used in this tutorial. Whatever approach user choose to guide the placer to lock SLR crossing registers, the intent is to make sure there are no zigzag placement for SLR crossing registers.

### About SLR crossing registers hierarchy

For making the floorplanning easier, we have divided the SLR crossing registers to multiple hierarchies. They are:

1. slr0_to_1_crossing : For signals with master in SLR0 driving slave in SLR1.
2. slr1_to_0_crossing : For signals with master in SLR1 driving slave in SLR0.
3. slr1_to_2_crossing : For signals with master in SLR1 driving slave in SLR2.
4. slr2_to_1_crossing : For signals with master in SLR2 driving slave in SLR1.
5. slr3_to_2_crossing : For signals with master in SLR3 driving slave in SLR2.
6. slr2_to_3_crossing : For signals with master in SLR2 driving slave in SLR3.

Users are free to arrange the hierarchies in any way that makes their floorplanning easier down the flow. For this tutorial, we use the hierarchy names mentioned above for SLR crossing registers.

### Allocate a fixed number of SLR crossings and design them upfront in initial implementation

One of the main targets we try to achieve using this flow is to lock down SLR crossing registers as part of static region in DFX flow. In the DFX flow, it is required for users to anticipate all future design variants that static region needs to support and plan their static region accordingly. In this design, For demonstration purpose, we have alloted 16 AXI4 and 16 AXI Stream based registers for SLR crossing. This is under the assumption that at any point of this platform usage, there will be a maximum of 16 AXI4 and 16 AXIS interfaces crossing an SLR boundary. It is up to the user to plan and allot according to their design. For example, user may decide to split the SLR crossings between AXI4Lite, AXI4 and AXI Stream. The total number of crossings depends on the number of available resources in the static region of the floorplan. We will discuss more details about it in the floorplanning section.  

Also, This tutorial design configured the AXI register slices in the default mode for data and address width. If users anticipate different sets of data or address width for these SLR crossing registers, they should customize the IP accordingly.

<p align="center">
  <img src="./images/slr01_hierarchy.png?raw=true" alt="slr01_hierarchy"/>
</p>


### Creation of BDCs for each SLR RP

#### Creation of ports

User needs to decide how many ports are required for each reconfigurable partition. In this tutorial, as mentioned above, We are using 16 interfaces of AXI4 and 16 interfaces of AXIs to communicate b/w RPs. Simple IPI commands are used to create those AXI ports. They are:

- To create a BD interface port for master AXI with default settings

`create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI0_SLR01`

- To create a BD interface port for slave AXI with default settings

`create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI0_SLR01`

- To create a BD interface port for master AXIS with default settings

`create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS0_SLR01`

- To create a BD interface port for slave AXIS with default settings

`create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 M_SXIS0_SLR01`

Likewise, user can create interface port for AXI4Lite too if needed.

Please note the naming convention used to distinguish the ports. For ease of identification, we have provided names that end with SLR01 for the ports that communicate b/w SLR0 and SLR1, SLR12 for ports that communicate b/w SLR1  and SLR2, SLR23 for ports that communicate b/w SLR2 and SLR3. It is completely upto the user to provide any names that enables them to identify them later in the flow. One of the main reasons to focus on the naming is that , during abstract shell based compile, each reconfigurable partitions is compiled in parallel. Hence developer for SLR0 RP compile need not see SLR1 RP IPs. Hence a right naming convention for reconfigurable partition's ports will enable to later connect IPs to right AXI interface ports.

You need not explicitly use create_bd_intf_ports explicitly using TCL. Rather if you have IP connections to each of the BD interface port, let validate_bd_design ensure parameters for the ports and matches it with the IP connected to it.

#### Usage of AXI VIP and AXI Register Slice in the training RM

The AXI based interface ports in the BD currently require an endpoint inside the BDC to successfully validate the BD with right ports width. To achieve that, we instantiate a AXI Verification IP to connect to these Interface ports. AXI VIP infers only a LUT1 in the synthesis which will cause the static-RM boundary to be not timed during initial implementation. Hence, we have added a AXI register slice b/w BD interface port and AXI VIP IP. This is because, it is recommended to have timing endpoints in the static-RM interface.

##### Example picture of AXI Slave BD interface port.
<p align="center">
  <img src="./images/axi_vip_slave.png?raw=true" alt="axi_vip_slave"/>
</p>


##### Example picture of AXIS Master BD interface port.
<p align="center">
  <img src="./images/axis_vip_master.png?raw=true" alt="axis_vip_master"/>
</p>

#### Creation of Embedded IO Ports

In Vivado, even though IO buffers are embedded inside a hierarchy, the ports are still inferred at the top. For DFX designs, it is required to make all ports available in the initial implementation, including that of embedded IOBs. This is because of the requirement that, in DFX flow, after initial implementation, the reconfigurable module's ports cannot be modified.  In this design, we have IPs like DDR and QDMA, both having embedded IOBs inside IP. However, we do not want to implement large IPs inside reconfigurable partition during initial implementation. Intent of Initial implementation is only to lock down the static region and boundary to reconfigurable partition. This section describes the approach taken in this tutorial to make those ports available in the design, even though actual IP is not compiled.

There are two approaches user can do to create ports for the IPs which have embedded IOBs, but do not want to implement those IPs in the initial implementation.

##### Approach-1

1. Instantiate the QDMA and DDR IP in your reconfigurable partition's block design container.
2. Customize the IP to get the right configuration for the ports.
3. Once customization of IP is complete, mark the required ports as External.
4. Validate the BD so that external ports get the right properties and width from the IP.
5. Once validation is complete and ports are accurate to the requirement of IPs, lock the the bd interface port using the HDL attribute property.
    For example:
```
  set bd_intf_prts [get_bd_intf_ports CH0_DDR4_rp2]`
  foreach bd_inft_prt $bd_intf_prts { set_property HDL_ATTRIBUTE.LOCKED TRUE [get_bd_intf_ports $bd_inft_prt]}
```
6. Once ports are locked, validate the RP BDCs again.
7. Go to the top BD and upgrade the BDC cells to the latest version (using refresh modules banner in IPI).
8. The newly created embedded IOBs ports will be visible as new ports of BDC at the top.
9. Mark those ports as external at the top BD to make them top level IO pads.
10. Validate the top BD and apply HDL_ATTRIBUTE.LOCKED on the respective BD interface ports at the top.
11. Once validation of top BD is complete, you may go back to RP BDCs and delete those IPs from the BDC. Save and revalidate both RP BDCs and top BD to update the design.
12. You should observe that the ports of embedded IOBs should have same width as inferred by the IP, even though IP does not exist now. This is because we used HDL_ATTRIBUTED.LOCKED to lock them down.

##### Approach-2
1. Without instantiating IPs, if you want to use default port map for such IPs, you may go ahead and use create_bd_intf_port command.
Example:

`set C0_DDR4_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C0_DDR4_1 -default_portmap ]`

2. To do the above, you need to know the VLNV name for the IPs. You can get the VLNV property of the IP in the Block Properties while the block diagram is open.  

<p align="center">
  <img src="./images/vlnv_ip.png?raw=true" alt="vlnv_ip"/>
</p>

3. You can also get VLNV property using the TCL Command while the corresponding BD is open.  

```
get_property VLNV [get_bd_cells /static_region/axi_bram_ctrl_2]
xilinx.com:ip:axi_bram_ctrl:4.1
```

Please note that intent of approaches provided above is to make sure you get the right port definition in your reconfigurable module boundary and at the top, when the corresponding IP does not exist during initial implementation. If the IPs are present in the initial implementation, parameter propogation in the IPI will automatically match the ports to the IPs.

#### Referencing Reconfigurable Partition BDs with Top BD

The tutorial uses a bottom-up approach to link reconfigurable partition BDs with the Top BD. This is achieved using block design container feature.  The top_bd.tcl is responsible for creating the static region (including the SLR crossing registers) and it references the block designs of reconfigurable partitions.

Given below is the code snippet in top_bd.tcl that references the BDC of RP in SLR0.

```
  ## Create instance: rp_slr0, and set properties
  set rp_slr0 [ create_bd_cell -type container -reference rp_slr0 rp_slr0 ]
  set_property -dict [ list \
   CONFIG.ACTIVE_SIM_BD {rp_slr0.bd} \
   CONFIG.ACTIVE_SYNTH_BD {rp_slr0.bd} \
   CONFIG.ENABLE_DFX {true} \
   CONFIG.LIST_SIM_BD {rp_slr0.bd} \
   CONFIG.LIST_SYNTH_BD {rp_slr0.bd} \
   CONFIG.LOCK_PROPAGATE {false} \
   CONFIG.TRAINING_MODULE {rp_slr0.bd} \
 ] $rp_slr0
```
#### Creating hierarchies for SLR crossing registers

For a multi SLR devices like VU13P, Creating multiple hierarchies that are similar in structure is very time consuming. Hence it is recommended to create one such hierarchy in the BD and write that hierarchy out using the following TCL command. In the following code snippet, we are writing the hierarchy "slr0_to_1_crossing" as a seperate TCL.

`write_bd_tcl -hier_blks [get_bd_cells /slr0_to_1_crossing] slr0_to_1_crossing.tcl`


Since the contents of slr0_to_1_crossing is identical to other SLR crossing hierarchies like slr1_to_2_crossing, You can edit the generated TCL to change the port names and source it again to create similar hierarchies.

`source slr1_to_2_crossing.tcl`

Once you source the TCL, proc will be available in the workspace

```
## available_tcl_procs
##################################################################
## Available Tcl procedures to recreate hierarchical blocks:
#
##    create_hier_cell_slr1_to_2_crossing parentCell nameHier
#
```

You can create a new hierarchy using the proc:

`create_hier_cell_slr1_to_2_crossing / slr1_to_2_crossing`

### BSCAN ports for Debug

The example design also demonstrates how to add BSCAN ports to the reconfigurable partition for debugging of any future RMs. For DFX designs, BSCAN ports must be part of the reconfigurable partition in the initial implementation itself, whether they are used or not.  These BSCAN ports are connected to debug bridge in the static region in the initial implementation itself.


### Generate the Targets, DFX Wizard and OOC Synthesis

- Once design entry phase is complete, generate targets for the BDs. Generating targets for the Top BD also generates targets for the referenced BDCs: rp_slr0,rp_slr1,rp_slr2 and rp_slr3.  

`generate_target all [get_files design_1.bd]`

- Use DFX Wizard to define the configuration. DFX Wizard is used to define the parent/child implementation in DFX and associate them to configurations. In this tutorial, we only make 1 configuration (config_1) that has 4 reconfigurable partitions: rp_slr0, rp_slr1, rp_slr2 and rp_slr3. Refer to [UG947](https://docs.xilinx.com/r/en-US/ug947-vivado-partial-reconfiguration-tutorial/DFX-RTL-Project-Flow) for more information on how to use the DFX Wizard in the Vivado IDE.  

```
###DFX Wizard
create_pr_configuration -name config_1 -partitions [list design_1_i/rp_slr0:rp_slr0_inst_0 design_1_i/rp_slr1:rp_slr1_inst_0 design_1_i/rp_slr2:rp_slr2_inst_0 design_1_i/rp_slr3:rp_slr3_inst_0 ]
set_property PR_CONFIGURATION config_1 [get_runs impl_1]
```
- Now you should see OOC runs in the Design Runs window. There should be one OOC run for each reconfigurable partition BD.

<p align="center">
  <img src="./images/design_runs.png?raw=true" alt="design_runs"/>
</p>

### Floorplanning
Floorplanning is a critical step in DFX.  Please refer to floorplanning guidelines in [UG909](https://docs.xilinx.com/r/2021.1-English/Vivado-Design-Suite-User-Guide-Dynamic-Function-eXchange-UG909) for details regarding pblock comamnds and associated guidelines for reconfigurable pblocks.

The floorplanning constraints used in this tutorial is in pblocks.xdc in the constraints folder.

There are four reconfigurable partitions in the design. Each reconfigurable partition must have a pblock associated with it. In the tutorial, almost all of the SLR resources are provided to reconfigurable partition except the bare minimum resources for static region.

Given below is the picture of SLR level RP pblocks. Highlighted in yellow is the pblock for RP in SLR0, blue for RP pblock in SLR1, magenta for RP pblock in SLR2 and dark blue
for RP pblock in SLR3.

<p align="center">
  <img src="./images/rp_pblocks_device_view.png?raw=true" alt="rp_pblocks_device_view"/>
</p>


You will notice that LAGUNA sites are excluded from the RP pblock. These LAGUNA sites are intentionally removed from RP pblock to make them part of static region where SLR crossing registers will be placed.

```
create_pblock rp_slr0
add_cells_to_pblock [get_pblocks rp_slr0] [get_cells -quiet [list design_1_i/rp_slr0]]
resize_pblock [get_pblocks rp_slr0] -add {SLICE_X229Y180:SLICE_X232Y239 SLICE_X215Y180:SLICE_X226Y239 SLICE_X195Y180:SLICE_X211Y239 SLICE_X183Y180:SLICE_X191Y239 SLICE_X165Y180:SLICE_X179Y239 SLICE_X153Y180:SLICE_X161Y239 SLICE_X140Y180:SLICE_X149Y239 SLICE_X125Y180:SLICE_X136Y239 SLICE_X112Y180:SLICE_X121Y239 SLICE_X98Y180:SLICE_X108Y239 SLICE_X86Y180:SLICE_X94Y239 SLICE_X64Y180:SLICE_X80Y239 SLICE_X51Y180:SLICE_X60Y239 SLICE_X38Y180:SLICE_X47Y239 SLICE_X20Y180:SLICE_X34Y239 SLICE_X9Y180:SLICE_X16Y239 SLICE_X0Y180:SLICE_X5Y239}
resize_pblock [get_pblocks rp_slr0] -add {CMACE4_X0Y2:CMACE4_X0Y2}
resize_pblock [get_pblocks rp_slr0] -add {DSP48E2_X0Y72:DSP48E2_X31Y95}
resize_pblock [get_pblocks rp_slr0] -add {GTYE4_CHANNEL_X0Y12:GTYE4_CHANNEL_X1Y15}
resize_pblock [get_pblocks rp_slr0] -add {GTYE4_COMMON_X0Y3:GTYE4_COMMON_X1Y3}
resize_pblock [get_pblocks rp_slr0] -add {ILKNE4_X1Y1:ILKNE4_X1Y1}
resize_pblock [get_pblocks rp_slr0] -add {RAMB18_X0Y72:RAMB18_X13Y95}
resize_pblock [get_pblocks rp_slr0] -add {RAMB36_X0Y36:RAMB36_X13Y47}
resize_pblock [get_pblocks rp_slr0] -add {URAM288_X0Y48:URAM288_X4Y63}
resize_pblock [get_pblocks rp_slr0] -add {CLOCKREGION_X0Y0:CLOCKREGION_X7Y2}
set_property SNAPPING_MODE ON [get_pblocks rp_slr0]
```

#### Some examples to demonstrate Tips and Tricks for Flooplanning.

- To add an SLR range to a pblock, you can do this:
` resize_pblock pblock_name -add {SLR0}`

- To add a Clock Region range to a pblock:
` resize_pblock pblock_name -add {CLOCKREGION_X0Y0}`

- To remove LAGUNA ranges from the pblock
` resize_pblock pblock_name -remove [get_sites LAGUNA*]`

- To add all sites of a tile to a pblock
`resize_pblock pblock_name -add [get_sites -of [get_tiles <tile_name>]`

- To remove a pblock-a's range from pblock-b's range. This will be useful to remove SLR crossing pblock's range from the reconfigurable pblock's range.
`resize_pblock pblock_b -remove [get_sites -of [get_pblocks pblock_a]]`

#### About Pblocks for SLR crossing registers

In this tutorial, SLR ranges are initially added to the RP pblock, followed by removing the LAGUNA sites from  it.  When a LAGUNA tile is removed from a reconfigurable pblock, adjacent CLB column that share the interconnect with the LAGUNA is also removed the RP pblock. This is due to Programmable Unit (PU) requirement of the pblock. Read more about PU requirement for UltraScale+ in UG909.

In VU13P, there are 16 columns of LAGUNA (two per clock region). In the tutorial, we have created pblocks for each LAGUNA column to have better control of placement of SLR crossing logic. This helps to avoid zigag placement of SLR crossing registers and also helps to linearly distribute the SLR crossing logic across the device.

Note that we have used two pblocks per column of LAGUNA for an SLR crossing: One at the TX side and other for RX side. This helps to neatly do the assignment of SLR crossing AXI Regslice IPs to the corresponding pblocks .

Also, please note that we have configured AXI Regslices for SLR crossing in Fully Registered Mode. Hence it uses LUTRAMs in the CLB. LUTRAMs are only availble in SLICEMs. The CLB column attached to LAGUNA tiles are SLICELs. Hence, to also give space for LUTRAMs used by AXI Regslice IP, we have also provided one additional column of CLB column to the SLR crossing pblock ranges.

<p align="center">
  <img src="./images/slr_crossing_pblocks.png?raw=true" alt="slr_crossing_pblocks"/>
</p>

In this tutorial, we have created pblocks for all 16 LAGUNA columns. Also, logically, there is a total of 16 AXI4 and 16 AXIS based Regslice for SLR crossings. This is linearly assigned to pblock . One example of constraint is shown below.

Given below is the constraint for SLR crossing pblock for column0 laguna in SLR0. As shown, LAGUNA ranges and adjacent SLICE ranges are added to the pblock. The assignment of logic is also done using "add_cells_to_pblock" command. The pblock slr0_cross_column0 takes the first regslice in the cascade network for signals from SLR0 to SLR1, and second regslice in the cascade network for signals from SLR1 to SLR0.

```
create_pblock slr0_cross_column0
add_cells_to_pblock [get_pblocks slr0_cross_column0] [get_cells -quiet design_1_i/slr0_to_1_crossing/*_register_slice_0]
add_cells_to_pblock [get_pblocks slr0_cross_column0] [get_cells -quiet design_1_i/slr1_to_0_crossing/*_register_slice_1]
resize_pblock [get_pblocks slr0_cross_column0] -add {SLICE_X6Y180:SLICE_X9Y239}
resize_pblock [get_pblocks slr0_cross_column0] -add {LAGUNA_X0Y120:LAGUNA_X1Y239}
set_property IS_SOFT FALSE [get_pblocks slr0_cross_column0]
```

 #### Placement of Static Region
In addition to SLR crossing registers, if your static region has more logic, it is recommended to floorplan them too. In this tutorial, we only have a clocking wizard IP and 3 reset blocks. Since the logic is very minimal, we are not adding new pblock for base static region. Otherwise, it is recommended to also control the static region placement with additional pblock constraints.

#### USER_SLL_REG constraint on SLR crossing registers

USER_SLL_REG is a soft constraint to guide the placer to keep SLR crossing registers in the LAGUNA site. Please refer [UG949: Ultrasfast Design Methodology Guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug949-vivado-design-methodology.pdf) Page 288. We have enabled USER_SLL_REG on most of the SLR crossing registers. Please refer misc.xdc in the constraints folder to see the constraint. However, please note that we have disabled USER_SLL_REG on some SLR crossing registers away from the clock root (clock root is at the center of device for clock driving SLR crossing registers). This is to avoid hold violation which can happen from LAGUNA TXRREG -> LAGUNA RXREG sites (dedicated SLL nodes) when they are far away from CLOCK ROOT. Ideally you should try to keep both ends of SLR crossing registers on LAGUNA site. However, if you observe hold violations at the edge of the device, offload one end of the pipeline to adjacent CLB column of LAGUNA site so that router can fix hold violation with deroutes.    

### Implementation

Once floorplanning is done, implement the design. Given below shows the device view after the implementation.

<p align="center">
  <img src="./images/device_view_initial_implementation.png?raw=true" alt="device_view_initial_implementation"/>
</p>


### Abstract Shell Creation
Once initial implementation is complete, create an abstract shell for each reconfigurable partition using write_abstract_shell command.

```
open_run impl_1
exec mkdir abs_shells
write_abstract_shell -cell design_1_i/rp_slr0 -force abs_shells/slr0_abs.dcp
write_abstract_shell -cell design_1_i/rp_slr1 -force abs_shells/slr1_abs.dcp
write_abstract_shell -cell design_1_i/rp_slr2 -force abs_shells/slr2_abs.dcp
write_abstract_shell -cell design_1_i/rp_slr3 -force abs_shells/slr3_abs.dcp
```
Given below is the device view of abstract shell generated for SLR0 reconfigurable partition. As you can see, only the timing endpoints to SLR0 RP are preserved in the abstract shell. They are locked down in the abstracted static region and remaining logic in static which does not have direct timing paths to SLR0 RP are trimmed away.

<p align="center">
  <img src="./images/abs_shell_slr0.png?raw=true" alt="abs_shell_slr0"/>
</p>

### Store the availale resources estimation of each reconfigurable pblock
```
report_utilization -pblock rp_slr0 -file slr0_util.rpt
report_utilization -pblock rp_slr1 -file slr1_util.rpt
report_utilization -pblock rp_slr2 -file slr2_util.rpt
report_utilization -pblock rp_slr3 -file slr3_util.rpt
```
### Implementation of each Reconfigurable Partition using its abstract shell

Once abstract shells are created for each reconfigurable partition, users can work on individual partitions and compile them independently in the context of its abstract shell.
This is achieved by the following process. In this tutorial, we demonstrate modifying only SLR0 RP and SLR1 RP and compile them using its abstract shell:

Following steps demo compile steps in tutorial for SLR0 reconfigurable partition.

1. Create four folders to compile each partition's logic. The corresponding folder will be used to store all files required to compile respective partition .

```
mkdir slr0_compile
mkdir slr1_compile
mkdir slr2_compile
mkdir slr3_compile
```
2. We will take an example of one of the SLRs (SLR0) for demonstrating the steps. In the folder, slrx_compile.tcl (x is the SLR number) compiles all the steps at once. We will explain individual steps below. Change the working directory to slr0_compile.

```
cd slr0_compile
```
3.  Create a project and add required files to the projet. Required input files are:
- Abstract Shell DCP of corresponding SLR
- Block Diagram for corresponding SLR reconfigurable partition to add required IPs for OOC synthesis.

```
create_project slr0_rm2_compile slr0_rm2_compile -part xcvu13p-fhga2104-3-e -force
#Add abstract shell DCP for the partition
add_files ../abs_shells/slr0_abs.dcp
#Import the corresponding partition's BD to the project
import_files ../myproj/project_1.srcs/sources_1/bd/rp_slr0/rp_slr0.bd
```

4. Convert the project to a DFX project.  Select Tools -> Enable Dynamic Function eXchange.  

```
#Convert the project to DFX project
set_property PR_FLOW 1 [current_project]
```

<p align="center">
  <img src="./images/enable_dfx_vivado.png?raw=true" alt="enable_dfx_vivado"/>
</p>


5. Set the design mode of project to GateLvl to make this a Netlist Project. This is required if you would like to link a DCP with an OOC synthesized RTL.Refer to [UG835: Vivado TCL Commands](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug835-vivado-tcl-commands.pdf) to read more about DESIGN_MODE usage.

```
#Linking a OOC synthesized BD with a DCP is possible only with Design Mode set to GateLvl
set_property DESIGN_MODE GateLvl [current_fileset ]
```

6. Set the top for the design. Top for your design comes from abstract shell DCP.

```
#Set the top for the design
set_property top design_1_wrapper [current_fileset]
```
7. Create a partition defintion and make the BD as a reconfigurable module. Associate the module with the partition.

Right click the BD in the "sources" window and click "Create Partition Definition".  In the pop up window, Provide Partition Definition Name as "rp_slr0" and Reconfigurable Module Name as "rp_slr0_rm2". Since this is the second reconfigurable module of this partition (the module used in the iniital implementation can be considered as rm1), we name the module name as rp_slr0_rm2.

```
#Create partition definition and reconfigurable module for the BD. Associate reconfigurable module with the partition
create_partition_def -name rp_slr0 -module rp_slr0
create_reconfig_module -name rp_slr0_rm2 -partition_def [get_partition_defs rp_slr0 ] -define_from rp_slr0
```

<p align="center">
  <img src="./images/create_partition_definition.png?raw=true" alt="create_partition_definition"/>
</p>

<p align="center">
  <img src="./images/partition_definition_reconfigurable_module_name.png?raw=true" alt="partition_definition_reconfigurable_module_name"/>
</p>


8. Create a new reconfiguratation using DFX Wizard and associate the configuration with the partition and module created above.

```
#Create  a new configuration using DFX wizard
create_pr_configuration -name config_1 -partitions [list design_1_i/rp_slr0:rp_slr0_rm2]
```

9. DFX project mode automatically creates a blackboxed DCP for the reconfigurable partition after implementation. This is not required here since we are using abstract shell DCP for implementation. Blackboxing the RM is not supported in an abstract shell DCP. User can simply reuse the generated abstract shell again since it already has the blackbox for the RM.

```
#We do not need blackbox DCP to be generated at the end , because this is abstract shell based implementation. User can pick up same abstract shell for any other RM imlementation
set_property USE_BLACKBOX 0 [get_pr_configuration config_1]
```

10. Associate the configuration created from DFX Wizard with the implementation.
```
#Associate the configuration with the implementation impl_1
set_property PR_CONFIGURATION config_1 [get_runs impl_1]
```

11. By this time, you have converted the design to a DFX project and associated the configruation with the implementation. Now we can modify the reconfigurable BD with the IPs that goes into the corresponding SLR.

```
#Modify the BD with your IPs
open_bd_design {./slr0_rm2_compile/slr0_rm2_compile.srcs/sources_1/bd/rp_slr0/rp_slr0.bd}
source modify_slr0_bd.tcl
```
Please note that you cannot  add or remove any interface BD ports for the reconfigurable partition's BD at this point . This is because DFX flow requires that initial implementation and child implementations should have exact static-RM interface both logically and physically. If you observe the generated abstract shell DCP, you will observe that static region is completely locked down in both placement and routes.

The particular BD modification script in this example design does the following:

- Remove the training logic IPs (BD cells like AXI Regslice and AXI VIP)
- Remove the BD interface nets (BD Intf Nets)

```
delete_bd_objs [get_bd_cells ]
delete_bd_objs [get_bd_intf_nets]
```
- Add AXI Traffic Generators, Video DMAs, Micoblaze, AXI BRAM, AXI CDMA, AXI GPIO and few other IPs. For demonstration purpose, we use a handful of both master and slave interfaces.

- Adds a local MMCM to clock all the IPs inside the partition instead of using the boundary clock directly. It is upto the user to decide whether to use boundary clock directly or to instantiate a clocking wizard inside the partition. For better skew management and timing results, we recommend using internal clocks for timing reconfigurable partitions' IPs. BOundary clock is spanned over all 4 SLRs and will need more special handling for skew management.  

12. Add any other RM specific constraints to the project. You do not need to add pblock constraint for the corresponding partition again since they exist in the abstract shell DCP itself. You are free to add any nested pblocks if needed, or any other RM specific timing constraint.

For this tutorial, we add a CLOCK_DEDICATED_ROUTE constraint because static MMCM is placed in a different SLR. For the BUFG from that MMCM to drive a local MMCM in SLR0, you need to set CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN or SAME_CMT_COLUMN. Read more about CLOCK_DEDICATED_ROUTE constraint in [UG949: Vivado Ultrafast Design Methdology Guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug949-vivado-design-methodology.pdf).

```
#Add constraints specific for implementing this partition. Please note you do not need to add pblock constraints again because it is already present in abstract shell
#Add constraints for slr0_rm2 xdc
add_files -fileset constrs_1 -norecurse constraints/slr0_rm2_misc.xdc
import_files -fileset constrs_1 [get_files slr0_rm2_misc.xdc]
```

12. When the BD is associated with the partition, it will appear as an out-of-context module Runs in the Design Runs Window. Right click the run and Launch Synthesis.
```
#Launch OOC synthesis of BD. By default, we use OOC per IP mode for synthesis. This is recommended to get maximum parallelization.
launch_runs rp_slr0_rm2_synth_1 -jobs 8
wait_on_run rp_slr0_rm2_synth_1
```
13. Once OOC synthesis of the BD is complete, Add the generated BD DCP to the project. Please note that this DCP by itself will not have all blackboxes filled. This gets filled during link_design. This is because we had set the SYNTH_CHECKPOINT_MODE to be HIERARCHICAL. Hence each IP inside the partition will be OOC synthesized and respective DCPs will be located in the respective synthesis folders. Link Design is intelligent to identify these DCPs and stitch them together. If you would like to create one DCP per OOC Reconfigurable Partition, you may set SYNTH_CHECKPOINT_MODE to be SINGULAR. This comes at the runtime cost because you will not get paralleization in the OOC runs per IP. You may refer [UG912: Vivado Properties](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug912-vivado-properties.pdf) for more information.

```
#Add the generated OOC synthesized BD's DCP output to the project
add_files ./slr0_rm2_compile/slr0_rm2_compile.runs/rp_slr0_rm2_synth_1/rp_slr0.dcp
```

14. Scope the generated OOC DCP of reconfigurable partition to right hiearchy

```
#Scope the RM DCP to the corresponding cell in the reconfigurable partition
set_property SCOPED_TO_CELLS {design_1_i/rp_slr0} [get_files ./slr0_rm2_compile/slr0_rm2_compile.runs/rp_slr0_rm2_synth_1/rp_slr0.dcp]
```

15. Launch Implementation for RM using its abstract shell.

```
#Launch Implementation of partition using it abstract shell
launch_runs impl_1 -jobs 8
wait_on_run impl_1
```

The steps from 1 to 15 can be implemented in parallel for each SLR as independent Vivado process. The tutorial also demonstrates the implemetation of SLR1 through SLR3 to
connect corresponding AXI interfaces.

### Link all implemented cell DCPs to create one final routed DCP for full bitstream generation

Now we have to link each reconfigurable partition's implemented cell DCP to the blackbox DCP from the initial implementation to create a final routed DCP for full bitstream generation.

```
cd ..
source link_dcps.tcl
```

```
add_files myproj/project_1.runs/impl_1/design_1_wrapper_routed_bb.dcp
add_files slr0_compile/slr0_rm2_compile/slr0_rm2_compile.runs/impl_1/design_1_i_rp_slr0_rp_slr0_rm2_routed.dcp
add_files slr1_compile/slr1_rm2_compile/slr1_rm2_compile.runs/impl_1/design_1_i_rp_slr1_rp_slr1_rm2_routed.dcp
add_files slr2_compile/slr2_rm2_compile/slr2_rm2_compile.runs/impl_1/design_1_i_rp_slr2_rp_slr2_rm2_routed.dcp
add_files slr3_compile/slr3_rm2_compile/slr3_rm2_compile.runs/impl_1/design_1_i_rp_slr3_rp_slr3_rm2_routed.dcp

set_property SCOPED_TO_CELLS {design_1_i/rp_slr0} [get_files slr0_compile/slr0_rm2_compile/slr0_rm2_compile.runs/impl_1/design_1_i_rp_slr0_rp_slr0_rm2_routed.dcp]
set_property SCOPED_TO_CELLS {design_1_i/rp_slr1} [get_files slr1_compile/slr1_rm2_compile/slr1_rm2_compile.runs/impl_1/design_1_i_rp_slr1_rp_slr1_rm2_routed.dcp]
set_property SCOPED_TO_CELLS {design_1_i/rp_slr2} [get_files slr2_compile/slr2_rm2_compile/slr2_rm2_compile.runs/impl_1/design_1_i_rp_slr2_rp_slr2_rm2_routed.dcp]
set_property SCOPED_TO_CELLS {design_1_i/rp_slr3} [get_files slr3_compile/slr3_rm2_compile/slr3_rm2_compile.runs/impl_1/design_1_i_rp_slr3_rp_slr3_rm2_routed.dcp]

link_design -reconfig_partitions {design_1_i/rp_slr0 design_1_i/rp_slr1 design_1_i/rp_slr2 design_1_i/rp_slr3}
write_bitstream -no_partial final_bitstream/full.bit
```

<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>

