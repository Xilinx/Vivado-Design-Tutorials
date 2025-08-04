<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal Tutorial</h1>
   <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Segmented Configuration for Versal</h1>
 </td>
 </tr>
</table>

***Version: 2024.2***<br>
Updated 4 April 2025

This tutorial covers an overview of the new Segmented Configuration solution in Vivado 2024.2. This release is considered an <b>open early access</b> for this Versal feature. This document illustrates the basic path through the Vivado and PetaLinux tools.

<details>
<summary>Click to expand for device support in Vivado 2024.2</summary>
Segmented Configuration in Vivado 2024.2 supports the following devices:

- Versal Prime Series: VM1102, VM1302, VM1402, VM1502, VM1802, VM2202, VM2302, VM2502, VM2902
- Versal AI Core Series: VC1502, VC1702, VC1802, VC1902, VC2602, VC2802
- Versal AI Edge Series: VE1752, VE2002, VE2102, VE2202, VE2302, VE2602, VE2802
- Versal Premium Series: VP1002, VP1052, VP1102, VP1202, VP1402, VP1502, VP1552, VP1702, VP1802, VP1902, VP2502, VP2802
- Versal HBM Series: VH1522, VH1542, VH1582, VH1742, VH1782
- Development Kits: Alveo V70, Alveo V80, VCK190, VEK280, VHK158, VMK180, VPK120, VPK180

Support does NOT include Versal Prime VM2152 or any Versal AI Edge Series Gen 2, Versal Prime Series Gen 2 or Versal Premium Series Gen 2 devices.
</details>

## Purpose
The Segmented Configuration solution has a number of key goals, including:
* Quickly booting processors and memory to load an operating system as quickly as possible
* Deferring PL configuration
* Enabling delivery of the PL image over a secondary boot interface
* Dynamically reloading the entire PL configuration


## Table of Contents
[Segmented Configuration Tool Flow in Vivado](#segmented-configuration-tool-flow-in-vivado)

[Known Issues and Limitations](#known-issues-and-limitations)

[Generating PetaLinux Images](#generating-petalinux-images)

[Testing Boot and PLD PDIs without PetaLinux](#testing-boot-and-pld-pdis-without-petalinux)

[Booting Linux and Downloading PLD PDI](#booting-linux-and-downloading-pld-pdi)

[Delivering PL images via U-boot](#delivering-pl-images-via-u-boot)

# Segmented Configuration Tool Flow in Vivado

The fundamental goal of the **Segmented Configuration** feature is to split programming images to allow for incrementally configuring the sections of the device, much like one can do with Zynq MPSoC devices. 
This enables users to quickly boot to an operating system with as much DDR or HBM memory access as needed. Programming of the entirety of the programmable logic (PL) domain is deferred until the user needs it. 
Delivery of the PL programming image can be delivered via any primary or secondary boot path that does not require programmable logic to implement. These paths include PCIe end points implemented in CPM (images transferred via QDMA) and gigabit Ethernet connections.

The enclosed example script (vck190_seg_cfg_pl_demo.tcl) will process a simple design from Vivado project creation to PDI generation, stopping before exporting hardware in an XSA. All the details for a single pass through Vivado place and route as described below are automated. PL reload use cases are not considered.

## Enable the Segmented Configuration project property

Within an open Versal design, set a project property that initiate Segmented Configuration process. 
This is done by selecting Tools > Settings > General, then check the option labeled <b>Project is a Segmented Configuration project</b>.<p>
<img src="./images/project_property.png?raw=true">

Setting this property can be done via Tcl as well:
```
set_property segmented_configuration true [current_project]
```

## Process the Design

When creating and implementing the Versal design, a standard design flow is used. The segmented configuration solution is intended to support any 
silicon feature without restriction, with early access limitations noted below.<p>

However, one additional piece of information is required by the tools prior to PDI generation: the identification of NoC connectivity needed for the 
initial boot image. All NoC paths that must exist prior to PL configuration must be declared. This is done within the AXI NoC IP, under the QoS tab.  
In the <b>Initial Boot</b> column, all paths completely contained within the PS domain (FPD, LPD, etc.) or that access DDR or HBM memory will be selected by default, but if any must be omitted, the box for that connection can be deselected. Any path that exists within or connects to the PL domain cannot be checked, as these are not viable options for the initial boot image. This information is passed through implementation tools (running through DRCs along the way) to be stored in the database for PDI generation decisions.<p>
<img src="./images/QOS_GUI.png?raw=true">

Within the design, this action is setting a property on these path segments for identification during write_device_image. This initial_boot property 
can be directly applied if necessary:
```
set_property initial_boot true [get_noc_logical_paths <...>] ; 
```

Do not apply the Initial Boot property on any NoC paths that are entirely within the PL domain or connect to or from the PL domain. The NoC IP GUI 
will prevent these connections from being selectable, and DRCs will prevent direct application of the initial_boot property on unsupported connections. <!-- CR-1156666 -->

*Known Issue in early access:* If the NoC IP have had output products generated prior to the setting of the Segmented Configuration project property, these outputs will need to be 
regenerated. Simply open the NoC IP GUI for each instance in your design, examine the QoS tab to see the Initial Boot property settings, then click OK to accept and 
regenerate the output products.
 

## Generate Programming Images

After the design has been implemented, create programming images as usual. The call to <code>write_device_image</code> will produce two PDI images:
 * <b>&lt;design&gt;_boot.pdi</b> – this image is used for the initial boot image and is used to bring up the PMC, processors, DDR memory and all other hard blocks 
 in the FPD and PLD domains
* <b>&lt;design&gt;_pld.pdi</b> – this image is used to program the entire programmable logic domain

The final step in Vivado is to export the hardware for Vitis. The call to <code>write_hw_platform</code> includes both PDI images within the single generated XSA. 
This can be done directly in the project directory via Tcl (with the -include_bit option) or within a project by selecting <b>File > Export > Export Hardware</b> 
and choosing the "Include device image" option. Inclusion of final PDI images and system level information is supported for project modes only.


## Dynamic Reload of a PL Image
The Segmented Configuration approach enables users to delay delivery of the programmable logic programming image. Moreover, users can dynamically reload the 
configuration of the PL on the fly, changing the functionality of the design in the PL domain. This **PL Reload** capability effectively provides simplified entry point to a DFX-like 
solution without requiring the use of the full DFX design flow within Vivado. This approach does have a few details to note: 
* The use of <code>pr_verify</code> is **required**, as it is for DFX designs, to ensure compatibility between images, leading to a safe programming environment.
    * Use <code>pr_verify</code> to compare routed checkpoints from different design runs within a project or between projects to check if the NoC solution is identical. 
    * In future versions, checks in place will be modified to align to new flexibility possible, and expanded to confirm consistency on PL interfaces as needed. During early access it is advised to keep the boot image configuration identical between runs.
    * <a href="./details/pr_verify_checks.md">Click here</a> to see a list of checks performed in this release.

* While isolation on the PS-PL boundary is automatically enabled (and then disabled upon completion), it is the user's responsibility to manage activity in the processing 
domain. Activity must be paused during the transition and drivers may need to be unloaded/reloaded to account for any change in the mapping of the new image.

Segmented Configuration does not require a DFX design flow. However, it is important to establish consistency between multiple runs so that NoC usage and interfaces match. 
Supported use cases in this Vivado release are narrow in scope. Different PL images are expected to be subtle variations of a base design (if not completely identical), at least in terms of the boundary 
conditions. The initial "golden" design run must be a superset of all connectivity required for any PL variant that is to be connected to this fixed boot image, and all 
characteristics of the interface -- pin usage, address apertures, NoC connectivity (number and types of connections), etc. must not exceed this initial image. Subsets of 
connectivity are permitted (tie off unused ports) but users may not introduce new PS-PL boundary connections.<p>

To ensure consistency between implementation runs and their corresponding PDI images, the NoC solution can be exported from one run and imported into another. This is done 
with a pair of Tcl commands: <code>write_noc_solution</code> and <code>read_noc_solution</code>. Each of these commands has a single option, -file, to reference the JSON 
formatted .ncr file that is exported and imported, respectively. <p>
The recommended approach to establish consistency from one project to the next is to create a "golden" project and spawn all new variations from this source. 
This can be done by saving a copy of the golden project using <code>save_project_as</code> (File > Project > Save As...), or by sourcing the same project Tcl script that 
created the golden project. This is recommended as this ensures the same PS domain consistency, from the top-level block design name to NoC IP configuration and NoC connectivity.<p>
If designers expect to modify NoC usage within the PL domain (either entirely in the PL domain, or PL NMU connecting to PS NSU), it is advised to separate this "dynamic" 
portion of the NoC into one or more unique NoC IP instances. This allows the PS NoC (connected to CIPS and DDR) to more easily remain untouched from one run/project to 
the next. A secondary NoC IP instance that is modified will receive the uniquification noted below, but this will not disrupt consistency for the PS domain.<p>
Once a design is complete and is routed, the NoC solution can be exported from a routed design checkpoint. First, with the routed design open in memory, lock all the 
NoC path segments that have been tagged with the initial_boot property (either from the NoC IP GUI or directly via Tcl) as well as all the segments connect the PS domain 
to the PL. The first lock property covers all paths contained in the boot image. The second lock property application covers configuration NoC paths for SSI devices and 
all the PS-PL boundary paths. Finally, write the .ncr file representing the NoC solution.
 ```
 set_property lock true [get_noc_net_routes -of [get_noc_logical_paths -filter {initial_boot == 1}]]
 set_property lock true [get_noc_net_routes -of [get_noc_logical_paths -of [get_noc_logical_instances *N?U128*]]]
 write_noc_solution -file <noc_solution>.ncr
 ```
 <!-- second lock property necessitated by CR-1198983 -->
 Note: It would also be wise at this point to save a copy of the routed design database with these locked paths, as any changes that force runs out of date would remove 
 the routed design results. This locked .ncr can still be used even when rerunning the same runs (presumably after design iterations or tool option changes) to continue 
 to produce the same NoC solution.

 A new design variation, in the same project or a new project, can be used to create a new PLD programming image. To replicate the NoC solution in the boot image (ensuring 
 all NoC paths tagged "initial_boot" for Segmented Configuration are replicated), read in this .ncr file by setting the NOC_SOLUTION_FILE option within the Implementation 
 Run Properties.<p>
 
 <img src="./images/NOC_solution_file_GUI.png?raw=true">
 
 Behind the scenes, this option calls the `read_noc_solution` Tcl command prior to running `place_design` to apply the NoC solution from the initial run.  
 
 Once the second design image is completely implemented, a call to `pr_verify` will confirm that the NoC solutions are identical and the PLD images may be interchanged.  This must be done directly on the Tcl Console to identify the two routed checkpoints to compare. 
 The first design checkpoint to be listed must be the "golden" design that has established the NoC solution reused in subsequent projects/runs. This parent run must contain the greatest usage of PS/PL and NoC boundary connections to establish the superset of connectivity possible.
 ```
 pr_verify -initial <first_design>_routed.dcp -additional <second_design>_routed.dcp
 ```

 <b>Design Compatibility Checking</b><p>
In addition to checks within the Vivado flow, a runtime check is done whenever the PL image is loaded or reloaded onto the target device. Unique Identifiers (UID) are 
inserted in the PDI to ensure compatibility of the boot image with any incoming PL image. This feature is native to DFX and Tandem Configuration -- for more details, 
please see the "Design Version Compatibility Checks" section of [UG909](https://docs.amd.com/r/en-US/ug909-vivado-partial-reconfiguration/Design-Version-Compatibility-Checks).<p>
Versal devices have safeguards in the form of Unique Identifiers (UID) that are checked by the PLM when programming images are delivered. Three 32-bit fields are embedded 
in the PDI as described here:<p>
<table>ID Name	Description	Defined by	PDI Mapping
Node ID	Defines the configuration node in the PL or AIE	Vivado	id (0x18)
Unique ID	A unique hash value to identify the module	Vivado	unique_id (0x24)
Parent ID	A reference to the Unique ID of the module above the target module	Vivado	parent_unique_id (0x28)
Function ID	Identification of the function residing in the target module	User	function_id (0x2c)

These three IDs are automatically generated by Vivado tools. A fourth (Function ID) is defined by the user but is not utilized by Segmented Configuration at this point.<p>
The <b>Node ID</b> is a fixed value that is incremented for each partition in the design.  The boot image represents the initial configuration of the device and is given 
an ID of 0x18700000. A value of 0x18700001 is assigned to the PLD image. This value is useful in differentiating the partitions in the design.<p>
The <b>Unique ID</b> is a hash value automatically generated by Vivado.  The value is deterministic, calculated by a number of factors within the design, so any change to 
a module’s results (code change, new synthesis or implementation options, design constraints, etc.) will produce a new Unique ID.  If the boot design modified in any way, 
a new Unique ID will be issued. This means it is critical to carry forward the PS design from the golden project if PL reload is desired.<p>
The <b>Parent ID</b> is a reference to the Unique ID of the image prior to the current one. The Parent ID of the boot image will always be zero (0x00000000) as it is the 
first image loaded in any Segmented Configuration design. The Parent ID of a PLD image will be the Unique ID of the boot image it was compiled with. This is the comparison 
done in PLM to ensure compatibility between images.<p>

You can read these values in a number of ways, but the easiest is to parse them using bootgen. Call bootgen with the -read option to see the details of the PDI contents. 
Find the four UID fields in the pl_cfi portion of the output.
```
bootgen -arch versal -read <pdi file>
```
The boot image will contain information like this within the pl_cfi portion of the results:
```
--------------------------------------------------------------------------------
   IMAGE HEADER (pl_cfi)
--------------------------------------------------------------------------------
          pht_offset (0x00) : 0x00015f8c       section_count (0x04) : 0x00000001
      mHdr_revoke_id (0x08) : 0x00000000          attributes (0x0c) : 0x00001800
                name (0x10) : pl_cfi
                  id (0x18) : 0x18700000           unique_id (0x24) : 0x86bd4f86
    parent_unique_id (0x28) : 0x00000000         function_id (0x2c) : 0x00000000
   memcpy_address_lo (0x30) : 0x00000000   memcpy_address_hi (0x34) : 0x00000000
            checksum (0x3c) : 0xfd716316
 attribute list -
                   owner [plm]               memcpy [no]           
                    load [now]              handoff [now]          
   dependentPowerDomains [spd][pld]  
```
The PLD image will contain similar information: 
```
--------------------------------------------------------------------------------
   IMAGE HEADER (pl_cfi)
--------------------------------------------------------------------------------
          pht_offset (0x00) : 0x00000034       section_count (0x04) : 0x00000008
      mHdr_revoke_id (0x08) : 0x00000000          attributes (0x0c) : 0x00001800
                name (0x10) : pl_cfi
                  id (0x18) : 0x18700001           unique_id (0x24) : 0x34c4043e
    parent_unique_id (0x28) : 0x86bd4f86         function_id (0x2c) : 0x00000000
   memcpy_address_lo (0x30) : 0x00000000   memcpy_address_hi (0x34) : 0x00000000
            checksum (0x3c) : 0xc8aebe28
 attribute list -
                   owner [plm]               memcpy [no]           
                    load [now]              handoff [now]          
   dependentPowerDomains [spd][pld]  
```
Note how the parent_unique_id of the PLD image matches the unique_id of the boot image: 0x86bd4f86. These images are therefore compatible.

Because the Unique ID of the Boot PDI is based on the construction of the design in the PS domain, users are advised to not make changes to this part of the design to 
have the greatest possibility of not changing that UID. By compartmentalizing changes to the PL domain, only the UID of the PLD PDI should change. AMD is continuing 
to expand use case testing to provide further guidance during this early access phase. One expected suggestion is to separate the NoC IP into PS/boundary and PL 
instances, where only the latter is modified if PL iterations require updates to the NoC solution.

## Design Considerations

Special considerations must be understood when using Segmented Configuration, especially when a feature straddles PS and PL domains. These situations will be documented 
once testing has confirmed behavior.<p>

<b>CPM Use Cases.</b> The CPM enables a host of functions that will undergo testing as Segmented Configuration continues development.  Use cases to be tested to confirm 
successful functionality and any potential restrictions include:
- Root Port mode within the CPM: this mode will not be ready until the PL has finished loading, so the CPM itself must be held in reset until the PLD PDI has been delivered. 
Likewise, the CPM must be held in reset for the duration of a dynamic reload of the PL region.<p>
- In order to load PLD PDI images over the CPM QDMA interface, PCIe must be declared as a secondary boot interface. In the <design>_boot.bif generated by the Vivado flow (found in the implmementation runs directory), add a single line.  Insert `boot_device { pcie }` after line 5 (id = 0x2).<br> 
  <img src="./images/mod_boot_bif.png?raw=true">
   - If this command is missing, PLD loading over QDMA will fail. The resulting PLM error may look like this:
   ```
   /dev/qdma01000-MM-0, W off 0x102100000, 0x578730 failed -1. write file: Input/output error.
   ```
- Segmented Configuration will structure the boot image to meet the 120ms link training goal for CPM5 devices by default when one or more controllers are set to end point mode. The <design>_boot.pdi is built much like a Tandem PROM image so that the CPM and other required elements are programmed and released first, followed by the rest of the boot image.
  - Do not select a Tandem Configuration option during CPM customization; an error will be given during write_device_image if both features are selected.
  - CPM4 devices are not yet supported with this capability; the full boot PDI must be loaded before the end point(s) can begin link training. This capability is scheduled for a future Vivado release.

<b>Mixed IO Banks</b> IO banks may be shared between domains, although it should be avoided if possible. If a bank must be split, with some pins required for DDR access and others used as GPIO, the IOSTANDARD must be set to LVCMOS. Failure to do so will result in a DRC.  Also note that the entire bank will be configured during the boot image delivery stage and will not be reconfigured when the PL image is loaded.  <!-- CR-1221015, CR-1215278, CR-1224250 -->
- The DRC that results from a mismatched bank is:
```
ERROR: [DRC HDPRSOC-2] Non-LVCMOS pld port in shared IO bank: Pld port <instance> IOSTANDARD property is set to <non-LVCMOS standard>. This port is in IO bank <number> that is shared by the initial boot design and pld design. In a Segmented Configuration design, pld port in a shared IO bank must be confgured as LVCMOS, please change IOSTANDARD property of this port to LVCMOS.
```
 
<b>CIPS-inferred PL logic.</b> Even though many IP are customized within CIPS which appears to be independent of the programmable logic domain, some features are not entirely implemented within hard blocks. These features are not restricted but must be understood that they will not be available until PL configuration has completed. For example: 
 - SYSMON auxillary ports. While the System Monitor block itself resides in the PMC, the SYSMON can leverage multiplexed I/O (MIO) or high-density I/O (HDIO) pins to access external pins that can monitor external channels in the wider system. Measurements from these external pins will not be possible until the pins are configured.


# Known Issues and Limitations

Device support in Vivado 2024.2 includes all devices currently in production. This includes Versal Premium and Versal HBM devices utilizing SSI technology, as well as Versal AI Core, Versal AI Edge and Versal Prime devices.<p>


Some known issues exist within the current tools:
 - If your design has been previously compiled without Segmented Configuration, you need to ensure all NoC IP instances are generated with the Segmented Configuration project property after it has been set. After setting the project property, open each instance of the NoC IP (there may be only one) to confirm that the Initial Boot property has been set on the QoS tab. Clicking OK will ensure regeneration of the IP such that the initial_boot property settings propagate through design compilation. Failure to do so may lead to NoC path segments being excluded from the initial boot image, which results in no access to memory controllers, for example.
 - pr_verify does not catch all possible mismatches in NoC connectivity in the processor domain. Users are advised, in addition to locking and importing the NoC solution from the primary design run, to be sure to use the same CIPS customization and non-PL NoC connectivity when using the PL reload feature. In this release, pr_verify is only checking NoC paths tagged with "initial_boot" and nothing within the core of the CIPS.
   - For example, an NMU included in an initial_boot path could have different destIDs between configurations. This mismatch can lead to a PLM error when loading a PLD PDI from a design image than the resident Boot PDI. This pr_verify issue is planned to be fixed in an upcoming Vivado release.

- IP Integrator creates unique hierarchical names for NoC IP elements to ensure differentiation between any possible NoC IP instances. This 4-digit hex code is deterministic, but factors beyond the IP itself can have an impact on how it is generated, so even identical NoC IP instances can be uniquified differently in different projects. Flexibility in naming, within the NoC IP as well as in the design hierarchy above it, is under consideration for future versions of Vivado. <!-- CR-1193012 -->
  - This issue prevents independent projects from being seen as identical in many cases (for PL reload goals) even if the NoC IP is identical; read_noc_solution will not be able to match NoC path instances, and pr_verify may fail as the NoC solution is not actually locked in the second design. The following error will be seen at the beginning of place_design when the .ncr is read in:  `CRITICAL WARNING: [Ipconfig 75-698] Problem reading NoC solution file 'demo_impl_1_locked.ncr'.  Could not find Logical Master Traffic Instance for 'vck190_seg_cfg_pl_demo_i/axi_noc_0/inst/S00_AXI_nmu/bd_9f25_S00_AXI_nmu_0_top_INST/NOC_NMU128_INST'.`
  - In this early access release, the issue can be avoided by staying in a single project (or a replicated project), where the NoC IP and the PS portion of the design overall are not regenerated. Differentiation in PL images can be stored in block design containers.
  - If users modify the .ncr generated from the initial project to match paths and instances for NoC resources as named in the second project and beyond, so PL images may be compatible, but pr_verify will not pass as it is comparing the routed databases. Depending on what other changes may have been introduced, UID checks may also fail.

- Designs using the PCIe end point(s) in devices with CPM4 (Versal Prime, Versal AI Core) may fail to load properly. A workaround that requires modification of a CPM CDO file is necessary. Contact support via the versal_seg_cfg_ea@amd.com alias for details on the workaround. Devices with CPM5 do not experience this failure. <!-- CR-1215136 -->
- Designs with exclusive PL access to LPDDR are not functioning properly. If NoC connections to memory controllers for LPDDR are not included in the initial boot image (i.e. tagged with initial_boot) they may not calibrate property upon configuration or dynamic reconfiguration (PL Reload). Memory controllers for DDR4 or shared with the PS domain do not experience this issue.<!-- CR-1208147 -->

- Some PCIe features for CPM4 and CPM5 are not yet supported. The following features are implemented in programmable logic and must be withheld from initial driver load:
  - PCIe Extended Configuration Space as this requires PL logic.
  - QDMA multi-function is not supported. This feature uses PL mailbox which is probed during driver load.
  - These capabilities will be examined for full support in a future version of Vivado and/or driver updates.

- The AXI Lite interface is not currently supported for XRAM in Versal AI Edge devices. <!-- CR-1192384 --> <!-- CR-11999515 -->


During early access, there are some limitations in place:
* Vitis/AIE use cases are also considered early access.
* Additional delivery paths for the PLD image (e.g. PCIe, Ethernet) have undergone limited hardware testing.
* Tandem Configuration is not yet supported for CPM4 devices. Tandem options must not be selected during CPM customization for any device when Segmented Configuration is enabled.
* DFX (within the PL) is not yet supported and must not be enabled on Block Design Containers.
* Some advanced Versal features and IP, such as the Soft Error Mitigation (SEM) IP and NoC system isolation have not been fully tested.

These features are not disabled within Vivado as the goal for production status is to support all these capabilities.  All these current early access limitations will be considered for support in the next release. If any feature is not yet ready for general access (e.g. DFX) then access to that feature will be disabled when Segmented Configuration is enabled.<p>


# Generating PetaLinux Images

This section shows the PetaLinux build process tailored to the segmented configuration solution.  For more information on this general topic, please refer to the PetaLinux Tool Reference Guide UG1144. A section dedicated to Segmented Configuration has been added recently, [here](https://docs.amd.com/r/en-US/ug1144-petalinux-tools-reference-guide/Versal-Segmented-Configuration-Flow).

These instructions assume that an XSA called *vck190_seg_cfg_pl_demo.xsa* has been generated from the example design and resides above the Vivado and PetaLinux projects. Adjust any paths or file names accordingly if this is not the case.

1.	Set up the PetaLinux environment for 2024.2.
```
$ source <path_to_installed_petalinux>/settings.sh
```

2.	Create a PetaLinux Versal temple project.
```
#Name of the project
$ petalinux-create -t project -n vck190-seg --template versal  
$ cd vck190-seg
```

3.	Configure the project using the XSA created from the Vivado build flow. 
 Set board dtsi files and Enable Device Tree Overlays in the PetaLinux project. This can be done either by using menu options or via the command line.<p>

a. 	
Menuconfig method:
```
$ petalinux-config --get-hw-description=../vck190_seg_cfg_pl_demo.xsa
```
```
$ petalinux-config ---> DTG Settings ---> (versal-vck190-reva-x-ebm-01-reva) MACHINE_NAME
$ petalinux-config ---> FPGA Manager ---> [*] Fpga Manager
```
b. 
Command line method:
```
$ sed -i '/CONFIG_SUBSYSTEM_MACHINE_NAME/ c\CONFIG_SUBSYSTEM_MACHINE_NAME="versal-vck190-reva-x-ebm-01-reva"' project-spec/configs/config
$ sed -i '/CONFIG_SUBSYSTEM_FPGA_MANAGER/ c\CONFIG_SUBSYSTEM_FPGA_MANAGER=y' project-spec/configs/config
$ petalinux-config --silentconfig --get-hw-description=../vck190_seg_cfg_pl_demo.xsa
```

4. Create a PLD firmware app 
```
$ petalinux-create -t apps --template dfx_dtg_versal_full --enable -n <pld-firmware-app-name> --srcuri "../vck190_seg_cfg_pl_demo.xsa"
```
Note: the firmware app name cannot contain underscores

5.	Build the images and package the boot.bin
```
$ petalinux-build
$ petalinux-package --boot --format BIN --plm --psmfw --u-boot --dtb --force
```

Output/Build images are available within the images/linux directory.

<table>
  <tr>
    <th>File Name</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>boot.bin</td>
    <td>Boot image with boot PDI & u-boot (also includes other required images, like atf, plm, etc)</td>
  </tr>
  <tr>
    <td>boot.scr</td>
    <td>Boot script used by u-boot for various boot modes</td>
  </tr>
  <tr>
    <td>image.ub</td>
    <td>Flatten Linux kernel image packing: Kernel, dtb and rootfs</td>
  </tr>
  <tr>
    <td>system.dtb</td>
    <td rowspan="3">Separate images for Kernel, dtb and rootfs</td>
  </tr>
  <tr>
    <td>rootfs.cpio.gz.u-boot</td>
  </tr>
</table>

# Testing Boot and PLD PDIs without PetaLinux

To check if the segmented configuration design has been built properly before building the Linux images, a quick check can be done by downloading the PDI files from XSDB and checking for access to the PL memory locations.
 
1.	Connect to a VCK190, locally or remotely.
 
2.	Open an Serial console window and use this for UART console.  In the serial console, select the serial interface connected to UART0 terminal, and set the Baudrate as 115200. 

3.	Set another serial terminal for the system controller serial console, by selecting an appropriate serial interface. 
 
4.	Start an XSDB console if not open already. This can be done using Vivado or Vitis tools.
```
 $ xsdb
xsdb% connect
```
 
5. In the XSDB console, set the target using following command:
```
 xsdb% ta 1
```

6.	In the XSDB console, change directory to the Vivado project location.  Download the boot PDI by typing:
```
xsdb% device program project_1.runs/impl_1/<design>_boot.pdi
```

You should see text scrolling on the UART console with no errors.<p>

7.	Next verify that the BRAM is NOT accessible when only the initial boot portion of Versal loaded:
```
xsdb% mrd -force 0xa4000000
Memory read error at 0xA4000000.  AP transaction timeout
```

At this point you have confirmed that the memory location does not yet exist.  Plus Linux has hung.<p>

8.	Power cycle the board.  
<!-- If using the board farm, type the following in the systest console:
```
Systest# power 0
Systest# power 1
```
-->

9.	Wait for the system controller to boot up before moving on.  <!-- You will also need to restart the UART console again, by executing the 'connect com0' command again.  Up arrow will also bring up the last command. --> <p>

10.	Download the boot image again (step 4), then program the PL image:
```
xsdb% device program project_1.runs/impl_1/<design>_boot.pdi
xsdb% device program project_1.runs/impl_1/<design>_pld.pdi
```

11.	Now you should be able to access the BRAM:
```
xsdb% mrd -force 0xa4000000
A4000000:    00000000
xsdb% mwr -force 0xa4000000 0xdeadbeef
xsdb% mrd -force 0xa4000000
A4000000:    DEADBEEF
```

You have now verified that the boot PDI does not contain the BRAM portion of the PL, and the PLD PDI does contain the BRAM.<p>

# Booting Linux and Downloading PLD PDI
Ultimately the desired flow (for most use cases using this solution) will be to load the boot PDI from a primary boot interface, boot Linux, then later deliver the PLD PDI image.<p>

1.	Connect to a VCK190 board, either locally or remotely. Refer to steps in  <a href="https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded">UG1400</a> to connect the board remotely.
<!-- ```
~$ /proj/systest/bin/systest vck190
``` -->

2.	Start the Hardware Server (note the hw server address, normally <MachineName>:3121)
```
xsdb% hw_server
```

3.	Add the TFTP root path to the Linux images repository within the project area.
```
$ tftpd "<path_to_example>/my_petalinux_project/images/linux"
```

<!-- 4.	Connect to the com port.
```
Systest 2# connect com0
``` -->
4. Open an Serial console window and use this for the UART console. In the serial console, select the serial interface connected to the UART0 terminal, and set the Baudrate as 115200.

5.	Back in the primary terminal (in the example directory), run following make command:
```
$ petalinux-boot --jtag --u-boot --hw_server-url <MachineName>:3121
```
You can see Linux boot up on the serial console connected to UART0.<p>

6. Enter your username as <b>petalinux</b> and pick a password. Refer to [UG1144](https://docs.xilinx.com/r/en-US/ug1144-petalinux-tools-reference-guide) for more details.
 
7. At the Linux prompt, program the PLD PDI file using the fpgautil command.
```
$ sudo fpgautil -b /lib/firmware/<test-app-name>.pdi -o /lib/firmware/<dtbo-name>.dtbo
```

At this point, Linux has been booted and the memory location in the PL is accessible.  You can use an XSDB console to read from and write to the memory location as was done in the prior section of this tutorial.  Or you can interact with memory directly via Linux:
```
devmem 0xa4000000

   0x00000000

devmem 0xa4000000 32 0xdeadbeef
devmem 0xa4000000

   0xDEADBEEF
```

8.	If you have created a second PL image, you can load this in now. If not you can reload the same PLD PDI, emulating a full PL reconfiguration.
```
#Remove the existing PL image (required for reprogramming a new image)
$ sudo fpgautil -R

#Program the new PL image
$ sudo fpgautil -b /lib/firmware/<second_design>_pld.pdi -o /lib/firmware/<dtbo-name>.dtbo
```

Verify that reading 0xa4000000 returns 0x0 instead of whatever was written to the BRAM. The results here will depend on what functionality is is the PL image that was just loaded. For example:
```
$ sudo devmem 0xa4000000
0x00000000
```
<!-- If a timer application is created...
Then enable the timer, and check that the write was successful.
```
devmem 0xa4000000 32 0xD0
devmem 0xa4000000
```
Read the timer register which should change each time it is read.
```
devmem 0xa4000008
```

You should be able to read and write to the AXI Timer registers now.
-->

# Delivering PL images via U-boot
Alternatively to Linux, loading PDI images can also be achieved in U-Boot. This is a desirable alternative since U-Boot comes before Linux in the boot sequence, meaning you can load your PL faster at boot and proceed to Linux with a full PL design already loaded. In our current flow where the boot PDI is handled by the primary boot interface, you can use U-Boot to load the PLD PDI.<p>
1.	Place your pld.pdi file(s) on the SD card along with the rest of the PetaLinux boot files.
2.	Boot the board:
```
petalinux-boot --jtag --u-boot --hw_server-url <MachineName>:3121
```
3.	Watch systest terminal 2 as the board boots. The boot sequence will pause with a message:
```
 “Hit any key to stop autoboot”. 
 Pressing any key will interrupt Linux boot and put you in U-Boot.
 ```

Once in U-Boot, the PLD PDI file must be moved from the SD card to on-board device memory before it can be downloaded to the FPGA.<p>
4.	Use the fatload command to move the PLD PDI file to an on-board memory location with enough space (PLD PDI files are typically multiple MB in size). In this case you will use DDR memory location 0x1000000:
```
fatload mmc 0 0x1000000 <design>_pld.pdi
```
 
Alternatively, you can do it using JTAG from XSDB using:

```
xsdb% dow -data <design>_pld.pdi 0x1000000
```

Note: the mmc 0 parameter means MultiMediaCard 0 which in this case is the SD card.<p>
Once the fatload command has been run, the size of the moved file is automatically stored in the $filesize variable which you will use in the next step.<p>
5.	Use the versal loadpdi command to download the PDI to the FPGA. The command takes the memory location and size of the PDI data:
```
versal loadpdi 0x1000000 $filesize
```

The PDI file should download to the FPGA successfully. Now that the PL is loaded, you can also use U-Boot to access the PL memory space.<p>
6.	Use the md (memory dump) command to read the unmodified BRAM memory at 0xa4000000:
```
md 0xa4000000 1
```

Note: the second parameter is the number of values to dump, in this case ‘1’.<p>
7.	Use the mm (memory modify) command to write to the BRAM memory at 0xa4000000.<p>
Once you run the command you will be prompted to type the write data. You can type the data and press enter which will execute the write and then prompt you to type more data for the next memory location, and so on. You can exit this writing mode by pressing ctrl+C:
```
mm 0xa4000000
deadbeef
(Press ctrl+C)	
```
8.	Read the BRAM memory again using the md command:
```
md 0xa4000000 1
```

You should see ‘deadbeef’.<p>
9.	To boot to Linux using the image on the SD card, use the command:
```
run bootcmd_mmc0
```
For more information on U-Boot commands, refer to the official U-Boot documentation: https://u-boot.readthedocs.io/en/latest/

<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020-2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
