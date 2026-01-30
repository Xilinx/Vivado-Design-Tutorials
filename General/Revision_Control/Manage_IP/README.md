 <table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://raw.githubusercontent.com/Xilinx/Image-Collateral/main/xilinx-logo.png" width="30%"/><h1>AMD Vivado™ Design Suite Tutorials</h1>
    <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
    </td>
 </tr>
</table>

# Revision Control Tutorial : Manage IP Flow

***Version: AMD Vivado&trade; 2025.1***

## Introduction

This tutorial focuses on the **Manage IP Flow** methodology in AMD Vivado™, which is particularly beneficial for users looking to maintain a centralized repository for all XCI configurations. By employing this approach, design teams can share and utilize IP configurations across multiple projects while ensuring a well-organized structure.

The Manage IP Flow technique allows users to maintain a single directory for each IP, encompassing both its source files and generated outputs. This organization not only simplifies project management but also enhances traceability and revision control, as all relevant files for each IP reside within a dedicated folder. 

Throughout this tutorial, we will demonstrate how to set up a Vivado™ project using the Manage IP Flow approach. We will showcase its advantages, including potential company-wide IP sharing and straightforward migration to future Vivado™ releases by preserving synthesized DCPs alongside source files. Users will also see how this methodology facilitates a cleaner project assembly, eliminating the need for maintaing a separate .gen folder for each IP to store it's generated outputs, in comparison to the ```Check_In_Generated_Outputs``` tutorial.

While the Manage IP Flow approach provides many benefits, it is important to note current limitations, such as the lack of Block Design (BD) support. Therefore, we will also briefly address alternatives for users who need to revision control Block Designs effectively.

Note: In this tutorial, the ./sources/ip/managed_ip_prj directory would ideally be included in the repository from the start, but this wasn’t feasible due to licensing restrictions. As a solution, the Makefile will automatically create the managed_ip_prj directory and remove any unnecessary files, preparing it to be checked back into version control.

## Focus
- Manage IP flow is recommended for users who want to keep a separate single project for maintaining all XCIs configuration.
- Maintain single directory for IP source and its generated outputs.

## Read More about Manage IP flow
- Creating a Manage IP project in Vivado™ is swift and straightforward; users can simply add the `-ip` switch to the `create_project` command. This simplicity makes it easier for users to adopt this methodology right from the outset of their projects. Please read this [link](https://docs.amd.com/r/en-US/ug896-vivado-ip/Using-the-Manage-IP-Flow) to read more about Manage IP flow.


## Pros
- Potentially, a Single Project that maintains all IPs used by a company.
  - Enables sharing IPs across teams. 
-Single directory per IP maintaining source and generated outputs.
  - In the tutorial: "Check_In_Generated_Outputs", user had to separately revision control .srcs and .gen directory where as in manage IP flow, each IP has one folder that maintain its sources and generated outputs.
- Migrate-able to future Vivado™ Releases
  - IP upgrades are not required in future AMD Vivado™ releases since synthesized DCPs are included in the folders that are checked into revision control. The project build scripts can leverage read_ip or add_files commands in future AMD Vivado™ releases to add these IP.

## Cons
- Lack of BD support in Manage IP flow
  - Manage IP project flow does not support Block Designs today. For users who want to revision control the BD and its generated targets, we recommend the approach mentioned in "Check_In_Generated_Outputs" tutorial where both .gen and .srcs must be checked in.
- User still need to revision control the whole directory of the IP that contains XCI and its generated outputs like DCP.

## Launch the tutorial

- Run `make all` to execute top level assembly of design in both project mode and non-project mode. Both approaches allow the user to reuse an IP which is managed in a separate `manage_ip` project.

- As described in the next section, user can check the `sources` folder to see the managed IP project with IPs already generated and synthesized. These are then reuse in the top level assembly.

## Design Flow

### Revision control Sources
#### Manage IP Project

Note: In this tutorial, the ./sources/ip/managed_ip_prj directory would ideally be included in the repository from the start, but this wasn’t feasible due to licensing restrictions. As a solution, the Makefile will automatically create the managed_ip_prj directory and remove any unnecessary files, preparing it to be checked back into version control.

- Check the project named ```manage_ip_prj``` inside ```sources/ip``` directory.
- Observe that each IP has a directory and XCI and generated outputs of that IPs are in respective directories

```
> ls -1 sources/ip/manage_ip_prj/
axi_bram_ctrl_pl_slave_from_pl_master
axi_bram_ctrl_pl_slave_from_ps
axis_MxN_vio
axis_vio_pl_master_to_ddr
axis_vio_pl_master_to_pl_slave
axis_vio_pl_master_to_ps
axi_tg_pl_master_to_ddr
axi_tg_pl_to_pl
axi_tg_pl_to_ps
```

```
> find ./sources/ip/manage_ip_prj/ -name "*.xci"
./sources/ip/manage_ip_prj/axis_MxN_vio/axis_MxN_vio.xci
./sources/ip/manage_ip_prj/axis_vio_pl_master_to_ddr/axis_vio_pl_master_to_ddr.xci
./sources/ip/manage_ip_prj/axis_vio_pl_master_to_pl_slave/axis_vio_pl_master_to_pl_slave.xci
./sources/ip/manage_ip_prj/axis_vio_pl_master_to_ps/axis_vio_pl_master_to_ps.xci
./sources/ip/manage_ip_prj/axi_bram_ctrl_pl_slave_from_pl_master/axi_bram_ctrl_pl_slave_from_pl_master.xci
./sources/ip/manage_ip_prj/axi_bram_ctrl_pl_slave_from_ps/axi_bram_ctrl_pl_slave_from_ps.xci
./sources/ip/manage_ip_prj/axi_tg_pl_master_to_ddr/axi_tg_pl_master_to_ddr.xci
./sources/ip/manage_ip_prj/axi_tg_pl_to_pl/axi_tg_pl_to_pl.xci

```

```
> find ./sources/manage_ip_prj/ -name "*.dcp"
./sources/ip/manage_ip_prj/axis_MxN_vio/axis_MxN_vio.dcp
./sources/ip/manage_ip_prj/axis_vio_pl_master_to_ddr/axis_vio_pl_master_to_ddr.dcp
./sources/ip/manage_ip_prj/axis_vio_pl_master_to_pl_slave/axis_vio_pl_master_to_pl_slave.dcp
./sources/ip/manage_ip_prj/axis_vio_pl_master_to_ps/axis_vio_pl_master_to_ps.dcp
./sources/ip/manage_ip_prj/axi_bram_ctrl_pl_slave_from_pl_master/axi_bram_ctrl_pl_slave_from_pl_master.dcp
./sources/ip/manage_ip_prj/axi_bram_ctrl_pl_slave_from_ps/axi_bram_ctrl_pl_slave_from_ps.dcp
./sources/ip/manage_ip_prj/axi_tg_pl_master_to_ddr/axi_tg_pl_master_to_ddr.dcp
./sources/ip/manage_ip_prj/axi_tg_pl_to_pl/axi_tg_pl_to_pl.dcp
./sources/ip/manage_ip_prj/axi_tg_pl_to_ps/axi_tg_pl_to_ps.dcp

```
#### Top level Design Assembly

- Source the following script to build the top level design by reusing the BD and IPs from the golden project.

 ``` build_top_prj_mode.tcl ```
 
- Observe that top level assembly script is adding XCIs from the manage IP project

```
add_files ../sources/ip/manage_ip_prj/axi_bram_ctrl_pl_slave_from_pl_master/axi_bram_ctrl_pl_slave_from_pl_master.xci
add_files ../sources/ip/manage_ip_prj/axi_bram_ctrl_pl_slave_from_ps/axi_bram_ctrl_pl_slave_from_ps.xci
add_files ../sources/ip/manage_ip_prj/axis_vio_pl_master_to_ddr/axis_vio_pl_master_to_ddr.xci
add_files ../sources/ip/manage_ip_prj/axis_vio_pl_master_to_pl_slave/axis_vio_pl_master_to_pl_slave.xci
add_files ../sources/ip/manage_ip_prj/axis_vio_pl_master_to_ps/axis_vio_pl_master_to_ps.xci
add_files ../sources/ip/manage_ip_prj/axis_MxN_vio/axis_MxN_vio.xci
add_files ../sources/ip/manage_ip_prj/axi_tg_pl_to_pl/axi_tg_pl_to_pl.xci
add_files ../sources/ip/manage_ip_prj/axi_tg_pl_to_ps/axi_tg_pl_to_ps.xci
add_files ../sources/ip/manage_ip_prj/axi_tg_pl_master_to_ddr/axi_tg_pl_master_to_ddr.xci
```
#### User do not need to do generate_target again on top level project as all XCIs and BDs are already generated in golden project.

- Observe this message when launch_runs is executed. Top level assembly is reusing synthesized DCPs of IPs from the .srcs folder of the project where IPs are locked.
```
INFO: [Vivado 12-4149] The synthesis checkpoint for IP '/group/bcapps/gpocklas/outbound/revision_control/Lock_IPs_from_Upgrade/vivado_prj_xci_bd/vivado_prj_xci_bd.srcs/sources_1/ip/axis_MxN_vio/axis_MxN_vio.xci' is already up-to-date

```

### ```build_top_non_prj_mode.tcl``` : Non-Project Mode Top Level Assemnbly
 This script is doing top level assembly of a design by reusing BD and XCI along with its generated targets in a Non-Project Mode setup. This will not create an on-disk project, instead DCPs can be written out post synthesis.
