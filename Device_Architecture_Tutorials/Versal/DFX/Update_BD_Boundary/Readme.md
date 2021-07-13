<table>
 <tr>
   <td align="center"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>Versal DFX Tutorial</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Update the RM interface using update_bd_boundaries Command</h1>
 </td>
 </tr>
</table>

# Introduction

In DFX flow, it is a fundemental requirement that all reconfigurable modules associated with a reconfigurable partition should have same interface ports to static. In the IPI, if one of the reconfigurable module is modified to add or remove ports, all the remaining reconfigurable modules associated with that partition can also be updated to match with exact same ports using the command called "update_bd_boundaries". This tutorial demonstrates this ability. This allows user to not to manually make the same modifications on ports to each reconfigurable module. This significantly improves the EoU and reduces the chance of making user error, especially while creating interface ports that has multiple data width signals.

# Design Flow

Follow Design flow from tutorial "1RP_AXI_GPIO_in_RP_Interface_INI" to become familiar with the IPI based DFX design flow using block design container feature. This is the similar flow used for this tutorial.

## IPI
- A simple 1RP based design is used to demonstrate the feature.
- Observe that there are two AXI interfaces to reconfigurable partition: S_AXI and S_AXI1
- The GPIO is connected to a simple constant value IP confgured to "0XFACEFEED"

`source create_top_bd.tcl`
`source create_rp1_bdc.tcl`
`source enable_bdc_dfx.tcl`

<p align="center">
  <img src="./images/top_bd.png.png?raw=true" alt="top_bd"/>
</p>

- This is the block diagram of second reconfigurable module : rp1rm2.bd
- As expected rp1rm2 also has same interface ports to static region with the GPIO connected to constant value "0XC001000F"

`source create_rp1rm2.tcl`

<p align="center">
  <img src="./images/rp1rm2.png?raw=true" alt="rp1rm2"/>
</p>

- We also create a new reconfigurable module rp1rm3.bd using the same steps mentioned in tutorial. However, Please note that we have also added a new port to the rp1rm3.bd. The S_AXI and S_AXI1 is inherited when rp1rm3 is created using "Create_reconfigurable" option of the DFX BDC rp1.The new interface port S_AX1_0 is manually added in the script followed by new IPs : axi_gpio_1 and xlconstant_1.

`source create_rp1rm3.tcl`

<p align="center">
  <img src="./images/rp1rm3.png?raw=true" alt="rp1rm3"/>
</p>

- Before updating the BD boundaries, you may unfreeze the boundary of DFX BDCs. This is to re-enable any parameter propogation across the DFX boundary since new port is added.

<p align="center">
  <img src="./images/unfreeze_bdc_boundary.png?raw=true" alt="unfreeze_bdc_boundary"/>
</p>

- Once the boundary is unlocked, select the Top BD, right click the rp1 BDC and select "Update Boundary of Sources..."

`source update_rm_boundary.tcl`

<p align="center">
  <img src="./images/update_bd_boundary.png?raw=true" alt="update_bd_boundary"/>
</p>

- In the "update Boundary" window, you can decide which reconfigurable module can be used as source to update the remaning reconfigurable module's ports. In this example, we pick rp1rm3.bd as the source and remaining sources rp1rm1.bd and rp1rm2.bd are updated to match with it.

<p align="center">
  <img src="./images/update_bd_boundary_from_source.png?raw=true" alt="update_bd_boundary_from_source"/>
</p>

- Once the BDs are updated, validated, Observe the following changes in each reconfigurable module ports. Notice that the new port has appeared in the rp1rm1.bd as shown below.

<p align="center">
  <img src="./images/bd_bounday_after_update.png?raw=true" alt="bd_boundary_after_update"/>
</p>

- Observe the similar change in rp1rm2.bd too

<p align="center">
  <img src="./images/bd_bounday_after_update_rp1rm2.png?raw=true" alt="bd_bounday_after_update_rp1rm2"/>
</p>

- In this design, since a new interface is added to the reconfigurable partition, you need to make sure proper decoupling is added in the static region for the new interface. For that, we update the top BD.

`source update_top_bd.tcl`

<p align="center">
  <img src="./images/update_static.png?raw=true" alt="update_static"/>
</p>

- You may manually update the aperture for each BD if required.
`source match_aperture.tcl`

- Once IPI design creation is complete, you can implement the design. Note that, even though some ports of the reconfigurable module rp1rm1 and rp1rm2 are loadless, it is ok since the DFX flow automatically legalizes the netlist by inserting a LUT1 during implementation (opt_design).

`source run_impl.tcl`

<p align="center">
  <img src="./images/schematic_LUT1.png?raw=true" alt="schematic_LUT1"/>
</p>

<p align="center"><sup>Copyright&copy; 2021 Xilinx</sup></p>
