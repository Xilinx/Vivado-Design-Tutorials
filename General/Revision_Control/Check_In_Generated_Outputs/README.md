<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://raw.githubusercontent.com/Xilinx/Image-Collateral/main/xilinx-logo.png" width="30%"/><h1>AMD Vivado™ Design Suite Tutorials</h1>
    <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
    </td>
 </tr>
</table>

# Revision Control Tutorial : Check in Generated Outputs

***Version: AMD Vivado&trade; 2025.2***

## Introduction

This tutorial focuses on a revision control methodology that seamlessly accommodates both BDs and standalone IPs (XCIs instantiated in RTL). By adopting this approach, users can leverage a golden project that maintains validated BDs and IPs, enabling the revision control of both the source and generated outputs directory simultaneously.

In this tutorial, we will guide you through the design flow of using existing BDs and IPs from the golden project in your top level design assembly. Specifically, we will demonstrate how to employ the `add_files` ( in project mode) and `read_bd/read_ip` (non-project mode) commands to integrate the generated DCPs (of BD and XCI) into a top-level assembly project. This methodology eliminates unnecessary regeneration and resynthesis of components, allowing teams to work more efficiently by reusing validated designs directly.

We will also discuss the pros and cons of this methodology.

Note: In this tutorial, the Vivado™ BD and IP generation directory (./sources/ip_bd/ vivado_prj_xci_bd) would ideally be included in the repository from the start, but this wasn’t feasible due to licensing restrictions. As a solution, the Makefile will automatically create the vivado_prj_xci_bd directory and remove any unnecessary files, preparing it to be checked back into version control.

## Focus
- This is the recommended revision control methodology for BD and IPs for users who would like to achieve the following: 
  - Avoid regenerating BD and IP RTL everytime it is used in a design.
  - Maintain a single golden project that maintains IPs and BDs to be shared across different design teams.


## Pros
- Migrate-able to future Vivado™ releases.
  - This methodology allows the user to avoid upgrading IP and BDs when going to a newer AMD Vivado™ release.
  - As user is revision controlling the synthesized DCP of BD and IP ( in .gen folder), the older Vivado™ version build DCP is read-able in newer Vivado™ version based design assembly.
- This is the single methodology that works for both BDs and IPs (in RTL).
- Allows reuse of the BD and IP  
  - Avoid regenerating and resynthesizing XCIs and BDs that are already validated. 
  - Enables reuse of generated and synthesized BD and IP DCPs.
  -Can use this revision controlled project as gatekeeper for IPs and subsystems that need to be shared across multiple teams.

## Cons
- Higher number of files and folders in revision control
  - User must check-in .srcs and .gen folder along with .xpr of the project
  - The synthesized outputs like .dcp are located in the .gen folder of the project 
- The .srcs and the .gen folder can become out of sync. Special care by users must be taken to ensure this does not happen.

## Launch the tutorial
- Run `make all` to launch the tutorial in both project mode and non-project mode.
- Both approaches read the IP from .srcs directory of the project available in `sources` folder. As IPs are already synthesized and generated outputs are available in .gen folder of that project, you can see the .dcp files of the IP which are then reused in the top level assembly. Review the messages mentiond in the next section to ensure that IPs' DCP are reused in top level assembly.

## Design Flow

Note: In this tutorial, the Vivado™ BD and IP generation directory (./sources/ip_bd/ vivado_prj_xci_bd) would ideally be included in the repository from the start, but this wasn’t feasible due to licensing restrictions. As a solution, the Makefile will automatically create the vivado_prj_xci_bd directory and remove any unnecessary files, preparing it to be checked back into version control.

### Revision control the golden project that maintains the XCI and BD

- This tutorial contains the IP/BD with outputs products generated in the Vivado™ project named ```vivado_prj_xci_bd``` under the sources folder.
- Only three folders in this Vivado™ project are revision controlled:
  - ```vivado_prj_xci_bd.srcs```
    - This folder maintains the source files for XCI and BD.
  - ```vivado_prj_xci_bd.gen```
    - This folder keeps the generated files including synthesized DCP of XCI and BD.
  - ```vivado_prj_xci_bd.xpr```
    - This is required to be checked-in only if user is expected to iterate on this single project later to make changes to BD and IP.

### Assemble the top level design in Project Mode
- Source the following script to build the top level design by reusing the BD and IPs from the golden project.

 ``` build_top_prj_mode.tcl ```

It is important to observe two sets of code in the top level assembly of the project: Adding XCIs and BDs from golden project.
#### Adding the BD which is already generated and synthesized in golden project

  ```
add_files ../sources/ip_bd/vivado_prj_xci_bd/vivado_prj_xci_bd.srcs/sources_1/bd/design_1/design_1.bd
  ```

#### Adding the IPs (outside BD) which is already generated and synthesized in golden project
```
add_files ../sources/ip_bd/vivado_prj_xci_bd/vivado_prj_xci_bd.srcs/sources_1/ip/axi_bram_ctrl_pl_slave_from_pl_master/axi_bram_ctrl_pl_slave_from_pl_master.xci
add_files ../sources/ip_bd/vivado_prj_xci_bd/vivado_prj_xci_bd.srcs/sources_1/ip/axi_bram_ctrl_pl_slave_from_ps/axi_bram_ctrl_pl_slave_from_ps.xci
add_files ../sources/ip_bd/vivado_prj_xci_bd/vivado_prj_xci_bd.srcs/sources_1/ip/axis_vio_pl_master_to_ddr/axis_vio_pl_master_to_ddr.xci
add_files ../sources/ip_bd/vivado_prj_xci_bd/vivado_prj_xci_bd.srcs/sources_1/ip/axis_vio_pl_master_to_pl_slave/axis_vio_pl_master_to_pl_slave.xci
add_files ../sources/ip_bd/vivado_prj_xci_bd/vivado_prj_xci_bd.srcs/sources_1/ip/axis_vio_pl_master_to_ps/axis_vio_pl_master_to_ps.xci
add_files ../sources/ip_bd/vivado_prj_xci_bd/vivado_prj_xci_bd.srcs/sources_1/ip/axis_MxN_vio/axis_MxN_vio.xci
add_files ../sources/ip_bd/vivado_prj_xci_bd/vivado_prj_xci_bd.srcs/sources_1/ip/axi_tg_pl_to_pl/axi_tg_pl_to_pl.xci
add_files ../sources/ip_bd/vivado_prj_xci_bd/vivado_prj_xci_bd.srcs/sources_1/ip/axi_tg_pl_to_ps/axi_tg_pl_to_ps.xci
add_files ../sources/ip_bd/vivado_prj_xci_bd/vivado_prj_xci_bd.srcs/sources_1/ip/axi_tg_pl_master_to_ddr/axi_tg_pl_master_to_ddr.xci
```
