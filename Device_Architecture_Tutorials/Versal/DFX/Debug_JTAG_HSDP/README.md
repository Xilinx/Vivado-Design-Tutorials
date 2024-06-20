<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Adaptive SoC DFX Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# Debugging Versal DFX Designs

***Version: AMD Vivado&trade; 2023.2***


## Introduction

AMD Versal&trade; devices provide more capability for users to debug their designs in hardware. This includes JTAG based debug as well as High Speed Debug Protocol (HSDP) using GT transceivers or PCI™-Express. For debugging DFX designs in Versal, you must take additional steps to ensure proper connectivity to debug cores like ILA and VIO that are contained within both the static region and the reconfigurable partition. For all DFX designs, instantiate an instance of the AXI Debug Hub IP with connectivity to the Versal CIPS IP inside each design partition, both static and reconfigurable, that might contain debug cores. The AXI Debug Hub IP instantiated in each design partition is used by the debug flow for the connectivity infrastructure to all debug cores (ILA, VIO, and so on) contained within that design partition. 

AMD recommends using NoC INI (Inter-NoC-Interconnect) interface across static-RM boundary to communicate to an AXI Debug Hub in reconfigurable partition. This is preferred because isolation is built into the NoC Architecture.

***Note***: Accessing the AXI Debug Hub in an RP across a PL based DFX decoupler requires manual intervention. Contact AMD for more information.

Interacting with the debug cores for a DFX design, regardless of design flow, matches a standard debug solution. For more information on debug capabilities in Versal devices, refer to chapter 10 of UG908. 

### Project Structure
-	**rp1rm1:** Shows example of MARK_DEBUG on the IP counter through Diagram right-click
-	**rp1rm2:** Shows example of RTL MARK_DEBUG on the module reference  "up_counter_rtl" with a VIO core attached
-	**rp1rm3:** Shows example of two instantiated ILA (no changes)
-	**rp1rm4:** The same as RM1 but with no MARK_DEBUG


### Adding Debug Cores

There are two supported methodologies for adding debug cores to Versal DFX designs. Debug cores can be <b>instantiated</b> or <b>inserted</b>. In either case, an AXI Debug Hub IP must be added to the design in the target partition where debug is desired. The debug hub must exist in each reconfigurable module to accommodate any debug cores in that RM. Each RM in the parent configuration must include a debug hub to establish the debug infrastructure that is used in any child configurations.

#### Instantiation

For the instantiation approach, manually add debug cores and connect them to signals you wish to probe. In the following block design, a Debug Hub (green) has been added and connect to the NoC, then multiple ILA (red) and VIO (purple) cores have been added to monitor two counter IP. 

***Note***: Green bug icons have been added to the signals to be probed by the ILA cores. By explicitly adding the ILA cores and adding probe points, you can define all the debug details early in the design flow. 

<p align="center"> <img src="./images/debug_instantiated.png?raw=true" alt="Instantiation Example"/> </p>


#### Insertion

For the insertion case, signals are identified in the block design or RTL source and insertion of the ILA debug core is done later in the flow. To add a debug tag to a signal on a block design canvas, right-click and select **Debug**. Once this is done, the green bug icon is added to the signal as shown below.

<p align="center"> <img src="./images/mark_debug_bd_before.png?raw=true" alt="Mark Debug Before"/> </p>
<p align="center"> <img src="./images/mark_debug_bd_after_anno.png?raw=true" alt="Mark Debug After"/> </p>

This action is seen on the Tcl Console as adding the DEBUG property to that net:

``` set_property HDL_ATTRIBUTE.DEBUG true [get_bd_nets {c_counter_binary_0_Q }] ```

The equivalent process within RTL is done using the **MARK_DEBUG** attribute. When RTL code that uses this attribute is added to a block design as a module reference, and the Debug Hub IP has been added, the same insertion technique is used. Here is the attribute applied in Verilog:

```(* mark_debug = "true" *) reg [31:0] count_out;```

***Note***: In each of these cases, the Debug Hub IP (green) has been explicitly added to the BD canvas and connected to the NoC.

### Setting Up Inserted Debug Cores

After synthesis, details about the debug features can be identified. This step is necessary for the insertion flow but not the instantiation flow. The insertion flow allows you to defer selection of which signals to probe and the customization of the ILA core itself.

After synthesis completes, open the synthesized design. This post-synthesis view of the parent run can be used for managing the DFX floorplan as it shows the full design hierarchy for the primary configuration. With this view open, select the Set Up Debug menu selection from the Flow Navigator, then click **Next**.

<p align="center"> <img src="./images/set_up_debug_flow_anno.png?raw=true" alt="Set Up Debug Menu"/> </p>

Shown in the dialog box are a list of signals that have been tagged with the **Debug (BD)** or **MARK_DEBUG (RTL)** property. Adjust settings as needed, or add more if desired, then click **Next**.

<p align="center"> <img src="./images/set_up_debug_gui.png?raw=true" alt="Set Up Debug GUI"/> </p>

Adjust the ILA debug core settings as needed then click Next and then Finish to complete the debug setup.

<p align="center"> <img src="./images/set_up_debug_ila.png?raw=true" alt="Set Up Debug ILA GUI"/> </p>

This final click sets in motion the insertion of the ILA core. The core is declared, properties of the core are defined, and the core is connected to the existing design logic. This information is stored in the post-synthesis checkpoint for this configuration. The generation of the ILA core itself (as well as the debug hub core) is actually done during the opt_design phase of implementation. You can see in the netlist view these cores are still black boxes, and in the schematic view this is represented by yellow levels of hierarchy.

<p align="center"> <img src="./images/pre_opt_debug_cores.png?raw=true" alt="Core Hierarchy Dropdowns"/> </p>
<p align="center"> <img src="./images/ila_inserted.png?raw=true" alt="Schematic of Inserted ILA"/> </p>

Save the design checkpoint before continuing.
These contraints are saved in the ".gen" folder, for example:
`project_1/project_1.gen/sources_1/bd/design_1/bd/rp1rm1_inst_0/imports/rp1rm1_inst_0_debug.xdc`

This sequence of steps for Set Up Debug must be repeated for other configurations if reconfigurable modules not included in the parent configuration are to be debugged. For every other reconfigurable module that is expected to have ILA cores inserted, a configuration containing that RM should be opened to declare the ILA core details (if not using default settings). The Open Synthesized Design selection in the Flow Navigator only opens the post-synthesis parent run configuration, so to instrument RMs in child configurations, this action must be done from the Tcl Console. Open a child run configuration by calling open_run directly:

Template: `open_run synth_name -name <synth_name> -pr_config <config_name>`

Example:  `open_run synth_1 -name synth_1 -pr_config config_3`

Once open, the process is the same: call Set Up Debug to define the details of the ILA core and its connections, then save the modified configuration checkpoint.

Compile the parent and child runs as are done for any DFX design. Debug cores are generated during the opt_design step. You can confirm successful insertion by opening the routed checkpoints and examining the design hierarchy. Reconfigurable modules do not have to have ILA core insertion performed even if other RMs for the same RP do have inserted ILA, though it is recommended that debug hubs are still added to these RMs to maintain a consistent NoC topology. Grey box configurations are supported (as child configurations) with the insertion flow.


### Working Hardware Example
Download the full PDI from initial implementation and poll the GPIOs from rp1rm1, rp1rm2, rp1rm3 and rp1rm4. You can find the .PDI & .LTX files in each RM's respective implementation (.proj folder).

`Note: You cannot upload the partial .pdi to the board.`

#### Static Region

  The static region in this design has the output of the counter being probed for debug. Waveforms for the static region are shown in the waveform screenshots below.
  <p align="center"> <img src="./images/static_region_diagram.png?raw=true" alt="Static Region Diagram"/> </p>

#### rp1rm1

  These screenshots show the ***Q*** output of the counter being probed with the ILA. Additionally, the counter ***c_counter_binary*** in the static region is probed.
  <p align="center"> <img src="./images/rm1_diagram.png?raw=true" alt="rm1 Diagram"/> </p>
  <p align="center"> <img src="./images/rm1_waves.png?raw=true" alt="rp1rm1 Waves"/> </p>

#### rp1rm2

  These screenshots show the ***count_out*** output of the RTL Mod Ref counter being probed with the ILA and VIO. Additionally, the counter ***c_counter_binary*** in the static region is probed.
  <p align="center"> <img src="./images/rm2_diagram.png?raw=true" alt="rm2 Diagram"/> </p>
  <p align="center"> <img src="./images/rm2_waves.png?raw=true" alt="rp1rm2 Waves"/> </p>

#### rp1rm3

 These screenshots show the **Q** output of the counters being probed with the ILA and VIO.
  <p align="center"> <img src="./images/rm3_diagram.png?raw=true" alt="rm3 Diagram"/> </p>
  <p align="center"> <img src="./images/rm3_waves.png?raw=true" alt="rp1rm3 Waves"/> </p>

#### rp1rm4
 This screenshot is the block diagram for rp1rm4, which has no debug probes.
  <p align="center"> <img src="./images/rm4_diagram.png?raw=true" alt="rm4 Diagram"/> </p>



<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
