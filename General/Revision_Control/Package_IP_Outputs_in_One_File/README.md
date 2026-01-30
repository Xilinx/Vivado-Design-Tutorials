 <table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://raw.githubusercontent.com/Xilinx/Image-Collateral/main/xilinx-logo.png" width="30%"/><h1>AMD Vivado™ Design Suite Tutorials</h1>
    <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
    </td>
 </tr>
</table>

# Revision Control Tutorial : Package IP Outputs in One Binary File - Core Container Flow

***Version: AMD Vivado&trade; 2025.1***

## Introduction 

This tutorial focuses on utilizing **Core Container Technology** within AMD Vivado™, which enhances the Manage IP Flow methodology by packaging both the XCI file and its synthesized outputs into a single binary file with the `.xcix` extension. This encapsulated format significantly reduces the number of files requiring revision control and simplifies IP management across projects.

While this tutorial will guide you through the process of assembling designs using Core Container files, it does not provide direct instructions on how to create a Core Container; instead, we offer a reference to the official documentation for enabling Core Container functionality in Vivado™. By leveraging these `.xcix` files in your top-level design assembly, you can streamline project organization and minimize administrative overhead.

Throughout this tutorial, we will demonstrate how to integrate Core Container files into a Vivado™ project, showcasing the benefits of reduced file management overhead and seamless reuse of IP across Vivado™ versions. We will also briefly address the limitations of this approach, particularly the lack of support for Block Design (BD) components, and suggest alternative methods for managing those.


## Focus
- Reduce the number of files for revision controlling AMD IPs.
- Enable Core Container Technology in Vivado™ which enables wrapping the XCI and its generated outputs in a single binary file with extension .xcix
- XCIX can be used in future AMD Vivado™ versions without requiring the user to upgrade the IP.

## Read More about Core Container Flow
- Please read this [link](https://docs.amd.com/r/en-US/ug896-vivado-ip/Using-a-Core-Container) to read more about enabling/disabling core containers for IPs.


## Pros
- Reduced number of files required for revision control of AMD IPs.
   - IP sources and generated/synthesized outputs are contained within a single binary file with extension .xcix.
   - Single Binary representing single IP along with its outputs.
- Migrate-able across Vivado™ Releases.

## Cons
- Not supported for Block Design. For revision control of block designs with its generated/synthesized outputs, we recommend using "Check_In_Generated_Outputs" tutorial that checks in .srcs and .gen folder.
- XCIX is a binary file. In order to track changes, a user could have an XCI file in parallel to the XCIX and maintain a checksum for alignment. 

## Launch the tutorial
- Run `make all` to launch the top level assembly of a design in both project mode and non-project mode.

- Both approaches read the .xcix (core container format of IP) from the project that maintains it in under `sources` tab.

## Design Flow

### Revision control the Core Container IPs

- Notice the project named ```manage_ip_xcix_prj``` in ```sources``` folder.
- As the project was created with Core Container enabled, Notice the .xcix for each IP.
- Revision controlling .xpr is recommended if user wants to make modifications to the IP later.

```
> ls -1 sources/manage_ip_xcix_prj/
axi_bram_ctrl_pl_slave_from_pl_master.xcix
axi_bram_ctrl_pl_slave_from_ps.xcix
axis_MxN_vio.xcix
axis_vio_pl_master_to_ddr.xcix
axis_vio_pl_master_to_pl_slave.xcix
axis_vio_pl_master_to_ps.xcix
axi_tg_pl_master_to_ddr.xcix
axi_tg_pl_to_pl.xcix
axi_tg_pl_to_ps.xcix
manage_ip_xcix_prj.xpr
```

### Assemble the top level design in Project Mode
- Source the following script to build the top level design by reusing the BD and IPs from the golden project.

 ``` build_top_prj_mode.tcl ```
 
 - The script reads the IPs in XCIX (Core Container) format
 ```
add_files ../sources/manage_ip_xcix_prj/axi_bram_ctrl_pl_slave_from_pl_master.xcix
add_files ../sources/manage_ip_xcix_prj/axi_bram_ctrl_pl_slave_from_ps.xcix
add_files ../sources/manage_ip_xcix_prj/axis_vio_pl_master_to_ddr.xcix
add_files ../sources/manage_ip_xcix_prj/axis_vio_pl_master_to_pl_slave.xcix
add_files ../sources/manage_ip_xcix_prj/axis_vio_pl_master_to_ps.xcix
add_files ../sources/manage_ip_xcix_prj/axis_MxN_vio.xcix
add_files ../sources/manage_ip_xcix_prj/axi_tg_pl_to_pl.xcix
add_files ../sources/manage_ip_xcix_prj/axi_tg_pl_to_ps.xcix
add_files ../sources/manage_ip_xcix_prj/axi_tg_pl_master_to_ddr.xcix
 ```

- XCIXs need not be generated again as they are already generated and synthesized outputs.

### ```build_top_non_prj_mode.tcl``` : Non-Project Mode Top Level Assembly
 This script is doing top level assembly of a design by adding XCIX in Non-project mode. This does not write the project on-disk. Instead a DCP can be written out.
