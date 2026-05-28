 <table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://raw.githubusercontent.com/Xilinx/Image-Collateral/main/xilinx-logo.png" width="30%"/><h1>AMD Vivado™ Design Suite Tutorials</h1>
    <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
    </td>
 </tr>
</table>

# Revision Control Tutorial : User Managed v/s Tool Managed

***Version: AMD Vivado&trade; 2025.2***

## Introduction
In this tutorial, we continue the theme of revision control by focusing on the two distinct approaches for managing Vivado™ projects: **User Managed Scripts** and **Tool Managed Scripts**. Throughout our series of revision control tutorials, all designs have been constructed using user-managed scripts. This approach allows us to clearly demonstrate the benefits of crafting custom scripts over relying on the tool-generated output from the `write_project_tcl` command.

While tool-generated scripts can provide a quick way to set up a project, they are often verbose and may include default settings and BD regeneration tcl commands that are not always relevant for project creation. Additionally, the format and content of tool-generated files can change with different releases of Vivado™, which poses challenges for long-term maintenance and revision control.

In contrast, user-managed scripts offer a leaner, more readable alternative that is easier to follow and maintain. By developing a custom script, users can ensure that their code remains clear of unnecessary noise while retaining full control over the project configuration. This enhances collaboration and makes it simpler to implement in revision control systems.

In this tutorial, we will utilize the `user_managed.tcl` script to create and manage the Vivado™ project. After the project is established, users will have the opportunity to call the `tool_managed.tcl` script, which opens the created project and executes `write_project_tcl`. This will allow users to compare the output of both methods directly, illuminating the reasons why approaching project management with user-managed scripts is recommended for scalability and clarity.

Join us as we explore these two methodologies in-depth, assessing their strengths and understanding the greater implications for revision control and project management in AMD Vivado™.

## Focus
- A Vivado™ project can be created and managed by two approaches:
   - User Managed Script : 
      - User keeps a custom script and is in full control of sources management, IP and BD generation, and design run configurations.
   - Tool Managed Script
     -  User can write out a Vivado™ project in TCL format using  ``` write_project_tcl ``` command.

- How user can extract the history of TCL commands executed by Vivado™ GUI session.

## Read more about TCL commands 
- Any action in the Vivado™ GUI has an TCL command that is written to the TCL console. This command can be copied/paste to the user managed TCL file. Please follow [link](https://docs.amd.com/r/en-US/ug835-vivado-tcl-commands/Tcl-Commands-Listed-by-Category) to read about different TCL commands supported by Vivado™.

- User can extract the history of TCL commands executed by a Vivado™ session by running the command ```history``` in TCL console. Please follow [link](https://docs.amd.com/r/en-US/ug893-vivado-ide/Viewing-the-Tcl-Command-History) to read more about it.


## Pros of User Managed Script
- A lean script manually managed by user.
- Human generated which is revision control friendly.
- No noise from tool generated GUI defaults in script, unlike write_project_tcl outputs.
- Commands to read RTL, source BD and IP, followed by synthesis and implementation are minimal and self explanatory.

## Cons of User Managed Script
- Any changes to the generated design when the GUI is open must be copied back into the user managed TCL file.
- For advanced usecases, user will need to follow [TCL guide](https://docs.amd.com/r/en-US/ug835-vivado-tcl-commands/Tcl-Commands-Listed-by-Category) or follow the TCL console in GUI mode to extract precise TCL commands. User can also use ```history``` in TCL console to get the list of TCL commands executed in that session.

## Launch the Tutorial
- Run ``` make all``` to launch two targets, one after other. 
  - First target is ```user_managed``` which  implements the user managed source script ``` user_managed.tcl```. This will create the Vivado™ project, followed by adding required IPs, BDs, RTL and XDC and launch synthesis. This is to demonstrate the leaner custom script.

  - Second target is ``` tool_managed``` which implements the script ```tool_managed.tcl```. This script opens the project created by the first target and execute ```write_project_tcl``` to generate a file called ```prj.tcl```. This is primarily for user to examine and compare the difference of this file with the ```user_managed.tcl```, although they are creating same project.

## Design Flow
- Source the ```user_managed.tcl``` to launch the project creation, reading required sources followed by synthesis and implementation.
- Once project is created, user can launch the ```tool_managed.tcl```  to open the project and do ```write_project_tcl```. User can then analyze the difference between generated ```prj.tcl``` and the ```user_managed.tcl``` to realize the potentially redundant information in prj.tcl which is not necessarily important from a revision control perspective.

###  ```user_managed.tcl ```

#### Create the project and set the part/board
```
#Create the project in the output directory
create_project vivado_prj_from_tcl -force  -part xcvc1902-vsva2197-2MP-e-S

#Set the board part
set_property board_part xilinx.com:vck190:part0:3.2 [current_project]
```
#### Sourcing the ip.tcl to create the IPs
```
#Generate the XCI files for BRAMs, Performance Traffic Generators and VIO IPs
source ../sources/ip/axi_bram_ctrl_pl_slave_from_pl_master.tcl
source ../sources/ip/axi_bram_ctrl_pl_slave_from_ps.tcl
source ../sources/ip/axis_vio_pl_master_to_ddr.tcl
source ../sources/ip/axis_vio_pl_master_to_pl_slave.tcl
source ../sources/ip/axis_vio_pl_master_to_ps.tcl
source ../sources/ip/axis_MxN_vio.tcl
source ../sources/ip/axi_tg_pl_to_pl.tcl
source ../sources/ip/axi_tg_pl_to_ps.tcl
source ../sources/ip/axi_tg_pl_master_to_ddr.tcl
```
#### Sourcing the bd.tcl to create the block diagram
```
#Generate the system BD that has only CIPS and DDR NOCs
source ../sources/bd/bd.tcl
```
#### Import all other RTL and XDC files

```
#Read the RTL files that has XPM NMUs and NSUs instantiated along with traffic generators and BRAM 
add_files ../sources/rtl

#Read the simulation testbench files to sim_1 fileset only
add_files -fileset sim_1 ../sources/testbench

#Read the XDC files for creating NoC connection, setting its QoS settings and the aperture of XPM NSUs. 
add_files -fileset constrs_1 ../sources/xdc/noc_constraints.xdc

#Read the XDC files that has constraints for creating ILAs and for connecting them to debug hub in the design. This constraint is auto-generated by the tool based on "Set up Debug" flow.
add_files -fileset constrs_1 ../sources/xdc/design_1_wrapper_debug.xdc
```

#### Generate the outputs for BD and XCI
```
#####Generate all targets : XCI/BD######
generate_target {synthesis instantiation_template} [get_files { axis_MxN_vio.xci axi_bram_ctrl_pl_slave_from_pl_master.xci axi_bram_ctrl_pl_slave_from_ps.xci axis_vio_pl_master_to_ddr.xci axis_vio_pl_master_to_pl_slave.xci axis_vio_pl_master_to_ps.xci perf_axi_tg_pl_master_to_ddr.xci perf_axi_tg_pl_to_pl.xci perf_axi_tg_pl_to_ps.xci design_1.bd}]

```
#### Launch OOC synthesis of all XCIs and BDs
```
##Updating the sourcefile set 
update_compile_order -fileset sources_1

##Launch Synthesis/Implementation and WDI. 
#start_gui
launch_runs synth_1 -jobs 16
wait_on_run synth_1
```

###  ```tool_managed.tcl ```
- This opens the Vivado™ project and do ``` write_project_tcl``` to create ```prj.tcl```. 

- This generated TCL has pointers to XCIs used in the project, BD.tcl used to recreate the Block Diagrams and also some of the default GUI settings which many advanced users may not care about. 

- As generated prj.tcl ( output of write_project_tcl) has relative references to XCIs, BD, it is critical to ensure that prj.tcl is checked into revision control with the same relative file path requirements maintained.

- As this is a tool generated file, there can be changes in its contents once Vivado™ version changes. As a result, this is not a recommended revision control file in terms of EoU.

- User can also observe the default GUI dashboards configuration in the output of write_project_tcl which may not be relevant from a revision control perspective.
