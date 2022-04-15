<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal DFX Tutorial</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>1 RP Design with NoC INI in the static-RM interface</h1>
 </td>
 </tr>
</table>

# Introduction

This  design demonstrates a simple DFX design in Versal. Content of the design is as follows:
- Static Region has CIPS IP, AXI NoC Interface to DDRs and DDR Controller.
- Reconfigurable Partition has AXI GPIO IP connected to Constant Values that differ in different reconfigurable modules
- Static - RM interface is NoC Inter NoC Interconnect (INI)
- Since the Static-RM interface is using NoC INI, No PL based decoupler is  used.

# Design Flow
---
1. Create flat Top BD
2. Group the design to hierarchies: Static Region and Reconfigurable Partitions
3. Create a block design container for the reconfigurable partition
4. Enable the DFX and Freeze the Static - RM interface
5. Set the Aperture for all interfaces of reconfigurable partition
6. Add the Pblock constraints
7. Generate the targets for all BDs : Top BD and reconfigurable modules BDCs
8. Use DFX Wizard to configure parent and child implementation
9. Launch Synthesis, Implementation and WDI generation

## Create Flat Top BD
---
Source the create_top_bd.tcl to create the flat BD. This BD contains static region IPs and the IPs that eventually go to reconfigurable partition.
`source create_top_bd.tcl`

<p align="center">
  <img src="./images/flat_bd.png?raw=true" alt="flat bd"/>
</p>

## Create hierarchies for reconfigruable partition and static region
In the DFX flow, a seperate hierarchy for reconfigurable partition is a must. It is recommended to keep a hierarchy for static region whenever possible for easier floorplanning down the flow if needed.

<p align="center">
  <img src="./images/static_rp_hierarchies.png?raw=true" alt="static_rp_hierarchy"/>
</p>

## Create a block design container for reconfigurable partition RP1
We need to create a new BD for reconfigurable module that contains all its sources. This is achieved using block design container feature in IPI. For each reconfigurable module, a block design is created using BDC.

`source create_rp1_bdc.tcl` rearranges the design into right hierarchies and creates a block design container "rp1rm1.bd" for the RP1 partition. rp1rm1.bd will be the first reconfigurable module for this partition.

<p align="center">
  <img src="./images/rp1_bdc.png?raw=true" alt="rp1 bdc"/>
</p>

## Enable DFX and define the aperture for Static-RM interfaces
---
`source enable_dfx_bdc.tcl`

We need to enable DFX on a block design container. Double click the BDC, in the "General" tab , select "Enable Dynamic Function eXchange on this container" . You can also "freeze the boundary of this container" if the Static-RP interface definition is complete. This will stop  further parameter propogration across static-RP boundary.
In the "Addressing" tab, the aperture will be automatically defined for each interface based on  address assignment at the top. You can switch the aperture inference to "Manual" if interested.


<p align="center">
  <img src="./images/enable_DFX_BDC.png?raw=true" alt="enable_dfx_bdc"/>
</p>

<p align="center">
  <img src="./images/addressing_BDC_DFX.png?raw=true" alt="addressing_BDC"/>
</p>

## Create a new reconfigurable module for the partition RP1
---

`source create_rp1rm2.tcl`

1. Create the second reconfigurable module rp1rm2.bd for the same reconfigurable partition rp1. You can right click the rp1 BDC and select "Create Reconfirurable Module"

<p align="center">
  <img src="./images/create_rp1rm2.png?raw=true" alt="create_rp1rm2"/>
</p>

2. Provide a name for the new reconfigurable module

<p align="center">
  <img src="./images/rp1rm2_name.png?raw=true" alt="rp1rm2_name"/>
</p>

3. This will create a new BD: rp1rm2.bd with exact same ports as rp1rm2.bd. Populate the new BD.

<p align="center">
  <img src="./images/rp1rm2_bd.png?raw=true" alt="rp1rm2_bd"/>
</p>

## Create RTL wrapper, Generate Targets and define the pblocks
---

Once the BD sources are defined and validated, create the RTL wrapper for the top, followed by generate targets for BD. You may also add the constraints ( timing and physical constraints) to the project at this stage.

1. Create the RTL wrapper for the top BD

<p align="center">
  <img src="./images/create_rtl_wrapper.png?raw=true" alt="create_rtl_wrapper"/>
</p>

2. Generate Targets for the Top BD also generates the targets for its child BDs : rp1rm1.bd and rp1rm2.bd

<p align="center">
  <img src="./images/generate_targets.png?raw=true" alt="generate_targets"/>
</p>

## Use DFX Wizard to define the parent and child configurations
---

1. Once the targets are generated, click the DFX wizard in the "Flow Navigator" of Vivado. The associated RMs of the RP will be automatically asscoaited with the partition in the DFX wizard.


<p align="center">
  <img src="./images/dfx_wizard_edit_rms.png?raw=true" alt="dfx_wizard_edit_rms"/>
</p>

2. Define configuration for each reconfigurable module for each partition


<p align="center">
  <img src="./images/dfx_wizard_edit_configurations.png?raw=true" alt="dfx_wizard_edit_configurations"/>
</p>

3. Associate each configuration with implementation runs. in DFX flow, parent implementation does both static and associated reconfigurable module implementation. Child implementations place and route associated reconfigurable module in the context of locked static from parent implementation.

<p align="center">
  <img src="./images/dfx_wizard_edit_conf_runs.png?raw=true" alt="dfx_wizard_edit_conf_runs"/>
</p>

4. Once configuration and runs are defined in DFX wizard, corresponding implementations will appear in "Design Runs" tab of Vivado.

<p align="center">
  <img src="./images/design_runs_window.png?raw=true" alt="design_runs_window"/>
</p>

## Launch Synthesis, Implementation and WDI generation
---
`source run_impl.tcl` generates the targets, add constraints, define configurations using DFX wizard, launch synthesis, implementation and export XSA after device image generation.

Selecting "write_device_image" in the flow navigator automatically starts the synthesis and implementation in the following order.

- Parallel OOC synthesis of RMs: rp1rm1 and rp1rm2
- Top level Synthesis once OOC synthesis of RMs are complete.
- Parent Implementation ( impl_1) where static and intial reconfigurable module (rp1rm1) is placed and routed.
- Child Implememtation (child_0_impl_1) where corresponding reconfigurable module (rp1rm2) is implemented in the context of locked static region from impl_1
- Device Image is generated for both parent and child implementations.

## Generate the Hardware Hand-off file XSA for software application
---

For DFX designs, XSA hand-off is not officially supported in project mode. However, user can write out flat fixed XSAs and extract the reconfigurable module's contents using XSCT.

```
open_run impl_1
write_hw_platform -fixed -force  xsa/design_1_wrapper_impl_1.xsa

open_run child_0_impl_1
write_hw_platform -fixed -force  xsa/design_1_wrapper_child_0_impl_1.xsa
```
<p align="center"><sup>Copyright&copy; 2021 Xilinx</sup></p>
