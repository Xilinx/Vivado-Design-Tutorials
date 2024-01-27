<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal DFX Tutorial</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Update Reconfigurable Partition Boundaries</h1>
 </td>
 </tr>
</table>
<b><i>Version: Vivado 2023.2</b></i><p>

# Introduction

In the DFX flow, a fundemental requirement is that all reconfigurable modules associated with a reconfigurable partition must have the same interface ports to static. In IPI, if one reconfigurable module is modified to add or remove ports, all remaining reconfigurable modules associated with that partition must also be updated to match the exact same ports. This can be done using the command <code>update_bd_boundaries</code>. This allows users to easily apply the same modifications on ports to each reconfigurable module. This reduces the chance of making errors, especially while creating interface ports that have multiple data width signals.

# Design Flow

Follow the design flow from tutorial "1RP_AXI_GPIO_in_RP_Interface_INI" to become familiar with the IPI based DFX design flow using the block design container feature. This is the similar flow used for this tutorial.

## IP Integrator
- A simple 1RP based design is used to demonstrate the feature.
- Observe that there are two AXI interfaces to reconfigurable partition: S_AXI and S_AXI1
- The GPIO is connected to a simple constant value IP confgured to "0XFACEFEED"
```
source create_top_bd.tcl
source create_rp1_bdc.tcl
source enable_bdc_dfx.tcl
```

<p align="center">
  <img src="./images/top_bd.png?raw=true" alt="top_bd"/>
</p>

- This is the block diagram of second reconfigurable module : rp1rm2.bd
- As expected rp1rm2 also has same interface ports to static region with the GPIO connected to constant value "0XC001000F"

```
source create_rp1rm2.tcl
```

<p align="center">
  <img src="./images/rp1rm2.png?raw=true" alt="rp1rm2"/>
</p>

- A new reconfigurable module rp1rm3.bd has been created using the same steps mentioned in tutorial. However, please note that a new port has been added to rp1rm3.bd. The S_AXI and S_AXI1 ports are inherited when rp1rm3 is created using "Create_reconfigurable" option of the DFX BDC rp1. Then a new interface port S_AX1_0 is manually added in the script followed by new IPs: axi_gpio_1 and xlconstant_1.

```
source create_rp1rm3.tcl
```

<p align="center">
  <img src="./images/rp1rm3.png?raw=true" alt="rp1rm3"/>
</p>

- Before updating the BD boundaries, you may unfreeze the boundary of DFX BDCs. This is to re-enable any parameter propogation across the DFX boundary since new port has been added.

<p align="center">
  <img src="./images/unfreeze_bdc_boundary.png?raw=true" alt="unfreeze_bdc_boundary"/>
</p>

- Once the boundary is unlocked, select the Top BD, right-click the rp1 BDC and select "Update Boundary of Sources..."

```
source update_rm_boundary.tcl
```

<p align="center">
  <img src="./images/update_bd_boundary.png?raw=true" alt="update_bd_boundary"/>
</p>

- In the "Update Boundary" window, you can decide which reconfigurable module can be used as source to update the remaining reconfigurable module ports. In this example, we pick rp1rm3.bd as the source and remaining sources rp1rm1.bd and rp1rm2.bd are updated to match with it.

<p align="center">
  <img src="./images/update_bd_boundary_from_source.png?raw=true" alt="update_bd_boundary_from_source"/>
</p>

- Once the BDs are updated and validated, observe the following changes in each reconfigurable module. Notice that the new port has appeared in the rp1rm1.bd as shown below. This image shows the view from the top BD.

<p align="center">
  <img src="./images/bd_bounday_after_update.png?raw=true" alt="bd_boundary_after_update"/>
</p>

- Observe the similar change in rp1rm2.bd as well. This image shows the view from within the RM BD.

<p align="center">
  <img src="./images/bd_bounday_after_update_rp1rm2.png?raw=true" alt="bd_bounday_after_update_rp1rm2"/>
</p>

- In this design, since a new interface has been added to the reconfigurable partition, ensure proper decoupling is added in the static region for the new interface. For that, we update the top BD.

```
source update_top_bd.tcl
```

<p align="center">
  <img src="./images/update_static.png?raw=true" alt="update_static"/>
</p>

- You may manually update the aperture for each BD if required.
```
source match_aperture.tcl
```

- Once IPI design creation is complete, you can implement the design. Note that even though some ports of the reconfigurable module rp1rm1 and rp1rm2 are loadless, it is ok since the DFX flow automatically legalizes the netlist by inserting a LUT1 during implementation (opt_design).

```
source run_impl.tcl
```

<p align="center">
  <img src="./images/schematic_LUT1.png?raw=true" alt="schematic_LUT1"/>
</p>
