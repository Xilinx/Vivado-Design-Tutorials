﻿<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal DFX Tutorial</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Embedded IO Buffers inside reconfigurable Partition</h1>
 </td>
 </tr>
</table>

# Introduction

This design demonstrates the methodology to adopt in Vivado IPI based DFX flow to instantiate Input/Output Buffers inside the reconfigurable partition. In DFX flow, If a reconfigurable pblock includes an IO bank, the corresponding IO buffers should be located logically inside the corresponding reconfigurable module hieararchy. By default, Vivado flow infers IOBs at the top level. This tutorial demonstrates the method using Utility Buffer IP in IPI to instantiate IOBs inside the reconfigurable module.  

This tutorial demoes the following :
1. Instantiation of IOBs inside a reconfigurable module block design using Utility Buffer IP.
2. Use RTL attribute "IO_BUFFER_TYPE NONE" on the top port to convey the vivado flow to not to infer IOBs at the top level.
3. Create and apply a constraint set for child implementation, which is different from constraint set used for parent implementation.

# Design Flow

Follow Design flow from tutorial "1RP_AXI_GPIO_in_RP_Interface_INI" to become familiar with the IPI based DFX design flow using block design container feature. This is the same flow used for this tutorial. 

## IPI

- As shown in the IPI diagram below, this is a design with 1 reconfigurable partition. Note that there are two AXI GPIOs in RP1 for demo purpose. axi_gpio_0 is connected to a utility buffer which is configured as "IOBUF", where as axi_gpio_1 is directly taken as output port of design. This is to demo that for the latter, an OBUF will be infered at the top level by the tool, where as for the former one, IOBUF is instantiated inside the reconfigurable module. 

<p align="center">
  <img src="./images/top_bd.png?raw=true" alt="top bd"/>
</p>

- Here is the IP customization of Utiliy Buffer. For this design, it is configured in IOBUF. 

<p align="center">
  <img src="./images/utility_buffer.png?raw=true" alt="utility buffer"/>
</p>


## IO_BUFFER_TYPE RTL Attribute
- Apply the IO_BUFFER_TYPE attribute on any top-level port to instruct the tool to use buffers. Add the property with a value "NONE" to disable automatic inference of buffers at the top. More details about this attribute is provided in UG901. In this design, we set the property to NONE for the top port that already has buffer instantiated inside the module.

<p align="center">
  <img src="./images/IO_BUFFER_TYPE.png?raw=true" alt="IO_BUFFER_TYPE"/>
</p>


## Schematic

- Here is the schematic of the two IOBs used in the design. Note that infered IOB is at the top , where as utility buffer instantiated IOBUF is inside the reconfigurable partition. 
<p align="center">
  <img src="./images/schematic.png?raw=true" alt="schematic"/>
</p>

## IOB Device View
- The picture given below is to demonstrate that the physical location of the IOB inside reconfigurable module should be inside the corresponding pblock, where as top level static IO buffer can go anywhere outside the reconfigurable partition. 

<p align="center">
  <img src="./images/iob_device_view.png?raw=true" alt="iob_device_view"/>
</p>

## Different Constraints set for Child Implementation

- Vivado DFX flow supports applying different constraint set for different implementations. In this example, constrs_1 constraint set has the floorplanning constraints and IOB constraints. In the DFX flow, child implementation is carried out in the output DCP from parent implementation where reconfigurable module is blackboxed. Please note that while blackboxing the reconfigurable module, corresponding embedded IOBs are lost from netlist, there by its constraints too. Hence you need to reapply PACKAGE_PIN and IOSTANDARD constraints for the embedded IOBs inside the RM during child implementation. This is achieved by creating a new constraints set "constrs_2" and applying it for child implementation.  


<p align="center">
  <img src="./images/child_impl_constraints.png?raw=true" alt="child implementation constraints"/>
</p>

- You need to make sure the new constraints set is manually applied to child implementation by enabling it in the child implementaiton's properties window.

<p align="center">
  <img src="./images/constrs_2_child_impl.png?raw=true" alt="constrs_2_child_impl"/>
</p>

- Observe that the Design Runs window is also updated to confirm that parent and child implementation uses different constraints set.

<p align="center">
  <img src="./images/design_runs_window.png?raw=true" alt="design_runs_window"/>
</p>
<p align="center"><sup>Copyright&copy; 2021 Xilinx</sup></p>
