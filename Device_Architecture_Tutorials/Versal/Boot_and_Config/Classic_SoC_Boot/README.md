<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal DFX Tutorial</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Classic SoC Boot for Versal</h1>
 </td>
 </tr>
</table>

## Table of Contents

[Overview](#overview)

[Comparison of Boot and Configuration Details](#comparison-of-boot-and-configuration-details)

[Classic SoC Boot Design Considerations](#classic-soc-boot-design-considerations)

[Example Design Tutorial](#example-design-tutorial)

[Create the base block design in Vivado](#create-the-base-block-design-in-vivado)

[Convert the Flat Design to DFX](#convert-the-flat-design-to-dfx)

[Add a Second Reconfigurable Module](#add-a-second-reconfigurable-module)

[Compile the Design through Vivado](#compile-the-design-through-vivado)

[Generating PetaLinux Images](#generating-petalinux-images)

[Testing Static and Partial PDIs without PetaLinux](#testing-static-and-partial-pdis-without-petalinux)

[Booting Linux and Downloading Partial PDI](#booting-linux-and-downloading-partial-pdi)

[Classic SoC Boot Design Structure](#classic-soc-boot-design-structure)

[Valid Connections](#valid-connections)

[Supported/Unsupported Features](#supportedunsupported-features)

[Known Issues/Limitations and other Considerations](#known-issueslimitations-and-other-Considerations)

# Overview

While Versal and Zynq devices are both fundamentally SoC architectures,
containing both programmable logic and processing subsystems, there are
key differences between the two, especially when it comes to boot and
configuration solutions. This document reviews some of these differences
and shows how to develop solutions for Versal that are similar in the
boot process to Zynq solutions.

The fundamental goal of the Classic SoC Boot solution is to enable
designers to boot the processor(s) in the Scalar Engines of a Versal
device before the programmable logic in the Adaptable Engines is
configured. This allows Linux to boot quickly, then the PL can
configured later (if at all) via any primary or secondary boot device.
The Classic SoC Boot feature is intended to treat Versal boot sequences
in the same way as can be done with Zynq SoCs.

**If delaying the configuration of the programmable logic in a Versal SoC
device is not a key goal of your solution, the flow described in this
document is likely not the one you are looking for.** This solution does require
the DFX flow, and while some details such as floorplanning and PS-PL isolation
are handled automatically, knowledge of DFX requirements and tradeoffs is necessary.
Details on restrictions due to containing the entire PL in a dynamic region are 
noted throughout this document.

That said, this document is not meant to be comprehensive; it focuses only on
details for this specific use case and flow. For greater depth in the
areas of device architecture and config and boot solutions, as well as
definitions of acronyms and other terminology, please consult
[UG1085](https://www.xilinx.com/support/documentation/user_guides/ug1085-zynq-ultrascale-trm.pdf)
for Zynq UltraScale+ and
[AM011](https://www.xilinx.com/support/documentation/architecture-manuals/am011-versal-acap-trm.pdf)
for Versal.

## Comparison of Boot and Configuration Details

The primary difference that will be highlighted in this use case is the
fact that DDR configuration is natively part of the PS boot in Zynq
devices but not part of the PS in Versal. With this change, processors
in the Adaptable Engines in Versal cannot run full operating systems
until DDR (and the necessary NoC connectivity) have been configured.

The **Classic SoC Boot** flow is a solution that emulates the Zynq boot
process in Versal, enabling users to run Linux or other operating
systems without having to fully configure the programmable logic, either
prior to OS bring-up or even at all. This solution is designed to:

* Allow for transition from Zynq UltraScale+ to Versal

* Continue to support current Zynq UltraScale+ Linux boot-first use cases
in Versal

* Allow user to make any generic Linux platform with user specified DDR
configuration

* Allow for continued development of more advanced incremental
configuration features

Here is a brief summary of differences between Zynq UltraScale+ devices
and Versal ACAP devices that lead to the desire to create and use the
Classic SoC Boot solution.

In Zynq UltraScale+ MPSoC and RFSoC:

* DDR is part of the PS and configuration settings are all included in
PCW.

* Configuring PS also configures DDR.   All hardware components required
to boot Linux, including DDR, are initialized at the same time by
psu_init in FSBL.

* The boundary between PS and PL is very clear-cut.  PS and PL are
mutually exclusive; PL programming will not disturb Linux as all
hardware components required are in the PS.

* PL programming is equivalent to CFRAME programming.

<p align="center">
  <img src="./images/zynq_us_plus.png?raw=true">
</p>
<p align="center">
 Figure 1: Zynq UltraScale+ architecture
</p>

In Versal:

* DDR components (DDRMC, XPIO, XPHY, XDCI, etc.) are moved out of the PS
and into the NoC Power Domain (NPD).  All hardware components required
to boot into Linux are no longer just in the PS.

* The boundary of PS and PL is more complicated.  There are components in
NPD and PLPD (PL power domain).  Not PS is henceforth referred to as PLD
(PL Device).

* PLM models PLDevices.  Non-PS is modeled as a PLDevice (i.e. PLD0). 
Reconfigurable Partitions are also modeled as PLDevices (PLD1 .... PLDn)

* PLD programming is whatever programming has to be done to get the PLD up
and running.  It may involve both CFRAME programming and NPI writes or
just NPI writes (for example, it is possible to bring up DDR with only
NPI writes).

<p align="center">
  <img src="./images/versal_arch.png?raw=true">
</p>
<p align="center">
 Figure 2: Versal architecture
</p>

##

## Classic SoC Boot Design Considerations

In order to cleanly segment the design along power domains to boot the
Scalar Engines and associated NoC and DDR memory without requiring any
programmable logic, certain restrictions must be imposed. This allows
the design to align to a DFX-enabled flow to create separate programming
images for each part of the design. These requirements include:

* Use of the **CPM4** is prohibited. All PCIe, DMA and debug features
enabled via CPM are incompatible with Classic SoC Boot, as most modes
infer static PL resource usage.

* Use of the **PL** **Flow (no PS)** is prohibited, as this configuration
is the opposite of what Classic SoC Boot will enable.

* Use of HSDP debug is currently prohibited. Without a CPM4 PCIe or Aurora
pathway these solutions will not be possible. The latter may be
considered for a future release.

* Some CIPS-based clock buffer inference must be disabled, replaced by
instantiation within the PL hierarchy.

* Some PL IO components must be instantiated in the PL hierarchy.

Even though users may never plan to dynamically reconfigure the programmable logic once the full device is up and running, 
the Dynamic Function eXchange (DFX) flow is **required** to use Classic SoC Boot.  This flow enables Vivado to logically and
physically separate the sections of the design into the two programming images necessary to delay PL configuration. Users 
may create multiple versions of the PL and choose one to load upon initial device boot, or reload a new PL image
on the fly, or users may choose to never even load the PL.  But in any case, the DFX solution is required to isolate the 
PS and DDR information so it can be contained in its own boot image.  Users must understand the fundamentals of DFX to 
embark on the Classic SoC Boot solution.  
More information can be found on the [DFX page on Xilinx.com](http://www.xilinx.com/tools/vivado/dfx)

# Example Design Tutorial

This tutorial design was verified with Vivado 2021.2 and PetaLinux BSP
on a VCK190 with engineering and production silicon. The Versal VMK180
can also be targeted -- clearly you must change any references within
this document as appropriate to use this alternate board.

### Prerequisites

In order to run these scripts, make sure you have the VCK190 board files
from the [Xilinx Board Store](https://github.com/Xilinx/XilinxBoardStore) 
if they are not included in your local installation.

## Create the base block design in Vivado

This section of the document walks through the steps to create and then
process the Classic SoC Boot design in Vivado. Comments throughout note
specific requirements and limitations associated with the solution,
including changes expected in future versions of Vivado when this
solution moves to production status. In general, however, many steps can
be altered to meet specific needs for your connectivity, memory usage,
or other design requirements.

Sections of this tutorial can be created via script as well as run
interactively. The entire Vivado flow can be run via the `run_all.tcl`
script. Before launching, be sure to set the number of RMs to be compiled;
the default is two.

The supplied `create_flat_bd.tcl` script automates steps 1
through 25, avoiding manually creating and customizing the IP and all
design connectivity for the base design.

1.  Open the Vivado IDE and create a new project. Use the following
    settings as you step through project creation

* Project Type = RTL Project
* Do not specify sources = checked
* Default Part = Versal VCK190 (under Boards tab)

2.  Select **Tools > Settings** to open the project settings. Under the General tab, 
click the **Project is a Classic SoC Boot project** option.
This property changes the project properties such that design rule
checks and other settings unique to the Class SoC Boot flow are called.

<p align="center">
  <img src="./images/project_options_anno.png?raw=true">
</p>
<p align="center">
Figure 3: Create a new project called "top"
 </p>

This sets the `classic_soc_boot` property behind the scenes. You could also 
enable the Classic SoC Boot flow by setting the following property in the Tcl Console:

```
set_property classic_soc_boot 1 [current_project]
```

**TIP:**  Disable this property to validate block designs and compile designs
without encountering Classic SoC Boot DRCs.  This allows you to temporarily have static 
PL logic or process designs to confirm functionality, etc.  Re-enable the property 
after running any intermediate tests.  However, note that once a Block Design
Container is created, that new lower block design cannot be folded back into the
top level, and once Design Runs have switched over to DFX mode, they cannot 
revert to a flat flow.

3.  In the Flow Navigator, under the IP INTEGRATOR heading, click
    **Create Block Design**. Call this design "top" and leave other
    options default.

<p align="center">
  <img src="./images/new_project.png?raw=true">
</p>
<p align="center">
Figure 4: Create a new project called "top"
 </p>

4.  Click the + on the blank canvas and enter "CIPS" in the search field
    to find the **Control, Interfaces and Processing System** IP. Add
    this to the block diagram.

5.  Click **Run Block Automation** in the green banner. Set the **Design
    Flow** to **Full System**, then define **1 DDR Memory Controller**.  Use defaults for
    everything else. Click **OK** to continue.

<p align="center">
  <img src="./images/cips_automation_classic.png?raw=true">
</p>
<p align="center">
Figure 5: Run block automation to connect the CIPS IP
 </p>

The initial block design will look like this:

<p align="center">
  <img src="./images/initial_bd_classic.png?raw=true">
</p>
<p align="center">
Figure 6: Initial block design after automation
 </p>

6.  After block automation completes, open the CIPS IP (versal_cips_0) for further
    customization for the VCK190 target. Click **Next**, then click **PS
    PMC** to configure this module.

<p align="center">
  <img src="./images/cips_ps_pmc.png?raw=true">
</p>
<p align="center">
Figure 7: Customize the CIPS IP
</p>

**IMPORTANT**: With the `classic_soc_boot` property enabled for this
project, the CPM customization module is not available, given that CPM
is incompatible with the Classic SoC Boot flow. If the hardened PCIe
Controllers or any other functionality in the CPM4 are desired, another
design solution must be used.

7.  Under the **Clocking** options, select the **Output Clocks** tab.
    Expand **PMC Domain Clocks** then **PL Fabric Clocks**, then select
    **PL CLK 0**.

<p align="center">
  <img src="./images/cips_pl_clk_0.png?raw=true">
</p>
<p align="center">
Figure 8: Enable PL CLK 0
 </p>

8.  Under the PS PL Interfaces options, set the Number of PL Resets to 1.

<p align="center">
  <img src="./images/cips_pl_reset.png?raw=true">
</p>
<p align="center">
Figure 9: Set the number of PL Resets to 1
 </p>

9. Under the **NoC** options, check the boxes for the two **Non
    Coherent** **PS** **to NoC Interfaces**.

<p align="center">
  <img src="./images/cips_noc.png?raw=true">
</p>
<p align="center">
Figure 10: Enable both Non Coherent PS to NoC Interfaces
 </p>

10. Click **Finish** then **Finish** again to submit these customization edits.

11. Open the AXI NoC IP (axi_noc_0) configuration and under the **Board** tab, confirm
    that **CH0_DDR4_0** is set to **ddr dimm1** and **sys_clk0** to
    **ddr4 dimm1 sma clk** for the VCK190 board.

<p align="center">
  <img src="./images/noc_board.png?raw=true">
</p>
<p align="center">
Figure 11: Customize the AXI NoC IP
 </p>

12. Under the General tab, set both the Number of AXI Slave Interfaces
    and Number of AXI Clocks to 8.

<p align="center">
  <img src="./images/noc_general.png?raw=true">
</p>
<p align="center">
Figure 12: Increase the number of AXI Slave Interfaces and AXI Clocks to 8
 </p>

13. Under the **Inputs** tab, assign the two new AXI Slave Interface
    ports to the two PS Non-Coherent interfaces using the two new AXI
    Clocks, aclk6 and aclk7.

<p align="center">
  <img src="./images/noc_inputs.png?raw=true">
</p>
<p align="center">
Figure 13: Connect the PS Non-Coherent interfaces to the new AXI Slave ports
 </p>

14. Under the **Connectivity** tab, assign the two new AXI Slave ports
    to Memory Controller ports 1 and 2 as shown below.

<p align="center">
  <img src="./images/noc_connectivity.png?raw=true">
</p>
<p align="center">
Figure 14: Assign AXI Slave ports to Memory Controller ports
 </p>

15. Click **OK** to finish the NoC IP customization.

16. Back on the top.bd canvas, make the following connections:

* FPD_AXI_NOC_0 on CIPS to S06_AXI on NoC
* FPD_AXI_NOC_1 on CIPS to S07_AXI on NoC
* fpd_axi_noc_axi0_clk on CIPS to aclk6 on NoC
* fpd_axi_noc_axi1_clk on CIPS to aclk7 on NoC

The block design should look like this now. The four new connections are
highlighted in orange.

<p align="center">
  <img src="./images/top_bd_cips_noc.png?raw=true">
</p>
<p align="center">
Figure 15: Block design after CIPS and NoC customization
 </p>

17. On the **Address Editor** tab, click the Assign All
    (<img src="./images/assign_all.png?raw=true">) button to assign all unassigned
    addresses.

18. **Validate** (<img src="./images/validate.png?raw=true">) and then **Save** the block design.

19. Add more IP to the block design to complete the PL portion of the
    design. Add the following four IP to the canvas:

* AXI SmartConnect
* Embedded Memory Generator
* AXI BRAM Controller
* Processor System Reset

20. Configure the AXI SmartConnect to have 1 Master and 1 Slave port.

<p align="center">
  <img src="./images/smartconnect_anno.png?raw=true">
</p>
<p align="center">
Figure 16: Configure the AXI SmartConnect IP
 </p>

21. Configure the CIPS with the following settings. After clicking
    **Next** then **PS PMC**,

Select the **PS PL Interfaces** group. **Check** the box for AXI Master
Interfaces **M_AXI_FPD**, leaving the Data Width at 128.

<p align="center">
  <img src="./images/AXI_master_FPD.png?raw=true">
</p>
<p align="center">
Figure 17: Continue the CIPS IP customization by setting the PL-PS interfaces
 </p>

Select the **Clocking** group and click the **Output Clocks**. Expand
down into **PMC Domain Clocks** then **PL Fabric Clocks**. The box for
**PL0** **CLK** **0** is already checked, so set the requested frequency
to **100 MHz**.

<p align="center">
  <img src="./images/PL_clk_100.png?raw=true">
</p>
<p align="center">
Figure 18: Continue the CIPS IP customization by setting the PL
reference clock frequency
 </p>

22. Click **Finish** and then **Finish** again to finish customization
    of the CIPS.

23. Click on the **Run** **Connection Automation** link in the green
    banner. First check the All Automation box to select all boxes. The
    make the following adjustments:

-   Select **S_AXI** and set **Master interface** to
    **/versal_cips_0/M_AXI_FPD**.

<p align="center">
  <img src="./images/connection_S_AXI.png?raw=true">
</p>
<p align="center">
Figure 19: Connection Automation for S_AXI
 </p>

-   Select **ext_reset_in** and set **Select Reset Source** to
    **/versal_cips_0/pl0_resetn**.

<p align="center">
  <img src="./images/connection_reset.png?raw=true">
</p>
<p align="center">
Figure 20: Connection Automation for ext_reset_in
 </p>

-   Select **slowest_sync_clk** and set the **Clock Source** to
    **/versal_cips_0/pl0_ref_clk**.

<p align="center">
  <img src="./images/connection_pl_clk.png?raw=true">
</p>
<p align="center">
Figure 21: Connection Automation for the slowest_sync_clk
 </p>

24. Click **OK** to run connection automation.

At this point, after regenerating the layout, the block design should
look like this:

<p align="center">
  <img src="./images/bd_after_automation.png?raw=true">
</p>
<p align="center">
Figure 22: Block Design after Connection Automation
 </p>

25. **Validate** and then **Save** the block design.

At this point you have a complete flat Versal design that could be
processed using a standard implementation flow. However, if you attempt
to compile the design as is (starting by generating an HDL wrapper for
top.bd), a DRC will report that the design is missing a block design
container module. This is triggered because the **classic_soc_boot**
property is set.

The Classic SoC Boot solution requires that all resources in the
programmable logic realm (CLBs, BRAM, DSP, etc., plus VNoC and AIE) be
enclosed in a Reconfigurable Partition. This allows Vivado to separate
programming images, isolating the PL power domain elements in a separate
PDI.

## Convert the Flat Design to DFX

Block Design Containers (BDC) are used to define dynamic regions for the
DFX flow, among other uses. These are based on design hierarchy and
separate a level of hierarchy into a new block design. Once a container
is created, multiple variants can be added for flat or DFX use cases.

The supplied `create_pl_bdc_dfx.tcl` script automates steps 1 through 6.

1.  In the block design canvas, ctrl-click to select all blocks other
    than the CIPS and AXI NoC IP.

<p align="center">
  <img src="./images/top_bd_pre_hier.png?raw=true">
</p>
<p align="center">
Figure 23: Select the IP to be placed in the PL hierarchy
 </p>

2. Right-click on one of these highlighted blocks and select **Create
    Hierarchy**. Given the hierarchy a name of **PL** and click **OK**.

<p align="center">
  <img src="./images/create_hier.png?raw=true">
</p>
<p align="center">
Figure 24: Create the PL hierarchy
 </p>

3. **Validate** and **Save** the design.

4. Next convert the PL hierarchical block to a Block Design Container.
    This step is irreversible, so you may want to archive this project
    first, in case you need to return to the original design.
    Right-click on the PL hierarchical block and select **Create Block
    Design Container**. Give the Block Design Container the name
    **bram_bd**, then click **OK**.

<p align="center">
  <img src="./images/create_bdc.png?raw=true">
</p>
<p align="center">
Figure 25: Convert the PL hierarchy to be a Block Design Container
 </p>

**Tip:** Give the Block Design Container a descriptive name, as this will
help to identify it from others if you create more Reconfigurable
Modules later.

Note that the PL hierarchy has a new icon, indicating that it is a Block
Design Container. If you push into this level of hierarchy from top.bd
by clicking the + sign in the corner of that block, you are looking at a
read-only copy of this block design.

<p align="center">
  <img src="./images/PL_BDC.png?raw=true">
</p>
<p align="center">
Figure 26: The standard Block Design Container
 </p>

To edit this block design, you must open the new source, bram_bd.bd from
the Sources window. This is a unique block design file separate from
top.bd.

5. Double-click on the PL BDC to configure the Block Design Container.
    On the General tab, check the boxes for **Enable Dynamic Function
    eXchange on this container** and **Freeze the boundary of this
    container**. Click **OK**.

<p align="center">
  <img src="./images/bdc_dfx_anno.png?raw=true">
</p>
<p align="center">
Figure 27: Block Design Container customization to enable DFX
 </p>

At this point you will see that the PL icon has changed again, this time
to indicate that the module is a DFX Reconfigurable Partition.

<p align="center">
  <img src="./images/pl_bdc_dfx.png?raw=true">
</p>
<p align="center">
Figure 28: The DFX Block Design Container
 </p>

The block design should now look like this:

<p align="center">
  <img src="./images/final_bdc_bd.png?raw=true">
</p>
<p align="center">
 Figure 29: The final block design
 </p>

6. **Validate** and **Save** the design.

## Add a Second Reconfigurable Module

At this point, if a second Reconfigurable Module is desired, continue
here. If only one programmable logic image is required, jump ahead to
step 14 in this section. The supplied `create_second_rm.tcl` script automates steps 7 through 13.

7. To create a new Reconfigurable Module, right click on the PL block
    design container and select **Create Reconfigurable Module**. Give
    the RM a unique name, timer_bd, and click **OK**.

<p align="center">
  <img src="./images/create_timer_bd.png?raw=true">
</p>
<p align="center">
Figure 30: Create Reconfigurable Module called timer_bd
 </p>

This action creates a new block design that is added to the project. The
canvas contains no IP, but shows the full port list matching the
Reconfigurable Partition instance. In order to remain compatible with
the block design container, the port list must be identical among all
design sources. Port lists may be altered, but the changes must be
applied to all Reconfigurable Modules.

8. Add the following IP to the block design:
* AXI Timer
* Processor System Reset
* AXI SmartConnect

9. Configure the SmartConnect to have 1 Master and 1 Slave port.

<p align="center">
  <img src="./images/smartconnect_anno.png?raw=true">
</p>
<p align="center">
Figure 31: AXI SmartConnect with one master and one slave
 </p>

10. Connect the IP to match the following image.

<p align="center">
  <img src="./images/timer_bd.png?raw=true">
</p>
<p align="center">
 Figure 32: Completed timer_bd block design
 </p>

11. On the **Address Editor** tab, click the Assign All
    (<img src="./images/assign_all.png?raw=true">) button to assign all unassigned
    addresses. Then change the **Master Base** **Address** to
    **0x000_A400_0000**

12. **Validate** (<img src="./images/validate.png?raw=true">) and then **Save** the block design.

13. Switch to the top block design, then **Validate** and **Save** there
    as well.

## Compile the Design through Vivado

The supplied Tcl scripts automates steps 14 through 19. Use `run_impl_oneRM.tcl`
if you did NOT create a second RM, `run_impl_twoRM.tcl` if you did.

14. In the Source window, right-click on top.bd and select **Create HDL
     Wrapper**. In the subsequent dialog box, leave the **Let Vivado
     manage wrapper** option selected and click **OK**.

15. In the Flow Navigator, under the IP INTEGRATOR heading, click on
     **Generate Block Design**. Leave the option to synthesize **Out of
     context per IP** and click **Generate**.

<p align="center">
  <img src="./images/generate_output_products.png?raw=true">
</p>
<p align="center">
Figure 33: Generate Output Products for top.bd
 </p>

This will generate and synthesize each IP throughout the entire project.
It does not yet run top-level synthesis. This step also converts the IP
Integrator project into a DFX project. This is an irreversible action
initiated by the decision to enable DFX on the PL BDC.

The DFX flow consists of multiple passes through place and route, each
pass beyond the first using the locked static design as context to
implement new Reconfigurable Modules (RM). This design currently only
has the single RM, but configurations must still be defined to set up
out-of-context synthesis runs and implementation settings in case
additional RMs come along.

16. In the Flow Navigator, click on the **Dynamic Function eXchange
     Wizard**, then click **Next** twice. On the next two menus, click
     the **automatically create...** links to automatically generate
     the one or two configurations (depending on if you chose to build a
     second RM) then the one or two configurations run for this project.
     Click **Next** until the last menu, and then click **Finish**.

<p align="center">
  <img src="./images/wiz_runs.png?raw=true">
</p>
<p align="center">
Figure 34: Run the DFX Wizard to create Configuration Runs
 </p>

If the second RM was not created, the DFX Wizard would show just the
parent configuration and run, but the Wizard must still be run to define
this. To learn more about the standard DFX flow through IP Integrator,
please see the general BDC DFX tutorials in UG947.


The DFX flow requires a pblock for each Reconfigurable Partition. For
the Classic SoC Boot flow, Vivado will automatically create a pblock to
contain the dynamic region of the design. This is by definition the
entire PL for the entire design that is not the PS + HNoC + DDR
Controllers that are identified as the base processing system.

17.  In the Flow Navigator, under the PROGRAM AND DEBUG header, click
     **Generate Device Image**. Click Yes then OK to start the Vivado
     flow.

This action pulls the entire design through synthesis (of the bram_bd
module, of the timer_bd module if created, then top), implementation 
and device image creation for the entire design.

During implementation, inferred logic is added to the design. For
example, PL Fabric Clock instances requested within the CIPS IP will be
inserted as BUFG_PS instances. The Vivado DFX flow automatically manages
these instances by allowing them to be placed as static instances within
the Reconfigurable Partition. Basic input and output buffers connected
to the RP are also managed automatically, but more specific or complex
buffers, such as IOBUF, must be inserted by the user in the
Reconfigurable Module block design; this can be done via the Utility
Buffer IP. place_design will flag an error if inserted static instances
need attention, as there will be no static sites in the PL to place
them.

18. When the Write Device Image step finishes, click **Open Implemented
     Design** for impl_1.

Examining the files generated in the project_1/project_1.runs/impl_1
directory, you will see two .pdi files.

**top_wrapper.pdi** is the device image for the PS + NoC + DDR that is
used to initially bring the device up.

**top_i_PL_bram_bd_inst_0_partial.pdi** contains the NPI and CFI
programming information to program the remainder of the device (PL + NoC) with 
the bram design functionality.

Likewise for the second Reconfigurable Module, you will see unique results in
the project_1/project_1.runs/child_0_impl_1.  In this directory, you will see two .pdi files.

**top_wrapper.pdi** is the device image for the PS + NoC + DDR that is
used to initially bring the device up.  The information here is the same as
for the parent configuration, as the static part of the design (in this case,
everything except the PL portion of the device) is the same.  Either .pdi can be
used for the initial boot of the device.

**top_i_PL_timer_bd_inst_0_partial.pdi** contains the NPI and CFI
programming information to program the remainder of the device (PL + NoC) with
the timer design functionality.

19. With the impl_1 design open, select **File → Export → Export Hardware** to export a Hardware
     Platform for PetaLinux. Click **Next**, then select the **Include
     device image** option then **Next**. Set the **Export to** location
     for the XSA to be <path>/project_1.runs/impl_1 and click **Next**
     and **Finish**.

<p align="center">
  <img src="./images/export_hw.png?raw=true">
</p>
<p align="center">
Figure 35: Export the Hardware Platform with the top-level PDI
 </p>

<p align="center">
  <img src="./images/export_parent_xsa.png?raw=true">
</p>
<p align="center">
Figure 36: Place the XSA in the implementation directory
 </p>

The .xsa that is created includes the initial programming image
(top_wrapper.pdi) for the device, but does not contain the programming
image for the programmable logic.

20. For designs with multiple RMs, repeat this Export Hardware process for each child run.
Open the implemented child_0_impl_1 run and export the XSA with the top-level
PDI, storing the XSA in its implementation run directory.  Keep the same top_wrapper.xsa name;
the file location will keep it unique from the first top_wrapper.xsa instance.

These two top_wrapper.xsa are very similar but do have unique differences.  The top_wrapper.pdi
are functionally equivalent, and either one could be used within the initial boot image used 
to bring up the PS and boot Linux.  But each .xsa has hardware handoff information specific to the 
Reconfigurable Module contained in each version of the design.

The primary differences between the Classic SoC Boot standard DFX in terms of design and
device image structure are:
1. Classic SoC Boot designs have no programmable logic in the static region, as the static 
region is only the processing system without PL; standard DFX designs will have some static 
PL logic, even if it is minimal.
2. Classic SoC Boot designs have no PL programming in the initial .pdi, only the processing system; 
standard DFX designs have initial .pdi that covers the entire Versal device, both PS and PL 
(plus NoC, DDRMC, AIE, etc.).

For this reason, it makes sense to refer to the initial .pdi image for Classic SoC Boot as 
the **static PDI** whereas for standard DFX it is a **full PDI**.  Each flow will have **partial PDI**
that dynamically change the configuration within the Programmable Logic.

At this point you are ready to build a PetaLinux image.


## Generating PetaLinux Images

This section shows the PetaLinux build process tailored to the Classic
SoC Boot solutions. For more information on this general topic, please
refer to the PetaLinux Tool Reference Guide
[UG1144](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_2/ug1144-petalinux-tools-reference-guide.pdf).

The following artifacts from the hardware design build are used in the
PetaLinux build process:

* Primary XSA: One of the XSA will be used for generating overall
PetaLinux project and BOOT.BIN, using the static PDI from the xsa. This
file has been written to project_1.runs/impl_1/top_wrapper.pdi as noted
earlier.

* Partial XSA(s): One or more partial XSA files (it can be the primary XSA
as well) will be created to extract and include RM PDI and corresponding
DTBO. This example design only has one configuration.

If a full DFX flow with multiple configurations (i.e. more than one
Reconfigurable Module has been implemented for the PL Reconfigurable
Partition) is used, static PDI for all the XSA will be same; any XSA can
act as the primary XSA.

In Vivado 2021.2, XSA generated from a DFX project will only contain the
static PDI (e.g. top_wrapper.pdi). Generation of partial XSA partial PDI
(ending with *_partial.pdi e.g top_i_PL_bram_bd_inst_0_partial.pdi)
will be introduced in a future Vivado release.

Step through the following instructions from a bash shell starting in the 
project_1 directory where the Vivado design has been processed.

1.  Repackage the XSA file(s) to include the corresponding partial PDI file.
```
$ zip -j project_1.runs/impl_1/*.xsa project_1.runs/impl_1/*partial.pdi
```
and (if applicable, repeat for each child_X_impl_1)
```
$ zip -j project_1.runs/child_0_impl_1/*.xsa project_1.runs/child_0_impl_1/*partial.pdi
```

This ensures both PDI are included in each XSA for delivery. For designs
with multiple RMs, this process must be repeated for each configuration,
adding the respective RM partial PDI to the XSA for that child run, to
build a complete collection of complete XSA files.

2. Set up the PetaLinux environment for 2021.2.
```
$ source <path_to_installed_petalinux>/settings.sh
```

3. Create a PetaLinux Versal temple project.
```
# Name of the project
$ petalinux-create -t project -n vck190-classic-soc-tutorial --template versal 
$ cd vck190-classic-soc-tutorial
```

4. Configure the project using the primary xsa (top_wrapper.xsa) created from 
the Vivado DFX build flow.
```
$ PRIMARY_XSA=$(pwd)/../project_1.runs/impl_1/
$ RM_ONE_XSA=$(pwd)/../project_1.runs/impl_1/top_wrapper.xsa
$ RM_TWO_XSA=$(pwd)/../project_1.runs/child_0_impl_1/top_wrapper.xsa
$ petalinux-config --get-hw-description=${PRIMARY_XSA}
```

5. Set board dtsi files, Enable Device Tree Overlays, Disable switch_root and Set Yocto 
board name in the PetaLinux project. This can be done either by using menu options or via the command line.

Menuconfig method:
```
$ petalinux-config ---> DTG Settings ---> (versal-vck190-reva-x-ebm-01-reva) MACHINE_NAME
$ petalinux-config ---> DTG Settings ---> [*] Devicetree overlay
$ petalinux-config ---> Image Packaging Configuration ---> (petalinux-image-minimal) INITRAMFS/INITRD Image name
$ petalinux-config ---> Yocto Settings ---> Yocto board settings ---> (vck190) YOCTO_BOARD_NAME
```
<p align="center">
  <img src="./images/plnx_dtg_settings.png?raw=true">
</p>
<p align="center">
  <img src="./images/plnx_image_minimal.png?raw=true">
</p>
<p align="center">
  <img src="./images/plnx_yocto_board.png?raw=true">
</p>
<p align="center">
Figure 37: PetaLinux customization settings
 </p>
 
Command line method:
```
$ sed -i '/CONFIG_SUBSYSTEM_MACHINE_NAME/ c\CONFIG_SUBSYSTEM_MACHINE_NAME="versal-vck190-reva-x-ebm-01-reva"' project-spec/configs/config
$ sed -i '/CONFIG_SUBSYSTEM_DTB_OVERLAY/ c\CONFIG_SUBSYSTEM_DTB_OVERLAY=y' project-spec/configs/config
$ sed -i '/CONFIG_SUBSYSTEM_INITRAMFS_IMAGE_NAME/ c\CONFIG_SUBSYSTEM_INITRAMFS_IMAGE_NAME="petalinux-image-minimal"' project-spec/configs/config
$ sed -i '/CONFIG_YOCTO_BOARD_NAME/ c\CONFIG_YOCTO_BOARD_NAME="vck190"' project-spec/configs/config
$ petalinux-config --silentconfig
```

6. Add fpga-overlays to MACHINE_FEATURES.
```
echo 'MACHINE_FEATURES += "fpga-overlay"' >> project-spec/meta-user/conf/petalinuxbsp.conf
```

7. Copy the fpgamanager_dtg_dfx bitbake class from versal-partial-pdi-template/classes to meta-user layer.  
Be sure to unzip the versal-partial-pdi-template.zip before copying from it.

This archive is not included in the Vivado 2021.2 install image and therefore
must be used from this tutorial archive area. This
template is generic for all Classic SoC Boot designs and is used to link
the PL device tree blob (DTB) with the with the partial PDI (with a file
name ending in *_partial.pdi) within an XSA.
```
$ mkdir project-spec/meta-user/classes
$ cp -r <path_to_template>/versal-partial-pdi-template/classes/fpgamanager_dtg_dfx.bbclass project-spec/meta-user/classes
```

8. Create FPGA Manager DTG apps using the template flow for RM BRAM and RM TIMER xsa.
If only one RM has been defined, only perform the first two commands.
```
$ petalinux-create -t apps --template fpgamanager_dtg -n pr0-rm1-bram --enable
$ cp ${RM_ONE_XSA} project-spec/meta-user/recipes-apps/pr0-rm1-bram/files/pr0-rm1-bram.xsa
$ petalinux-create -t apps --template fpgamanager_dtg -n pr0-rm2-timer --enable
$ cp ${RM_TWO_XSA} project-spec/meta-user/recipes-apps/pr0-rm2-timer/files/pr0-rm2-timer.xsa
```

9. Modify the FPGA Manager DTG bitbake class for the RM BRAM and RM TIMER recipes.
```
$ sed -i '/inherit fpgamanager_dtg/ c\inherit fpgamanager_dtg_dfx' project-spec/meta-user/recipes-apps/pr0-rm1-bram/pr0-rm1-bram.bb
$ sed -i '/inherit fpgamanager_dtg/ c\inherit fpgamanager_dtg_dfx' project-spec/meta-user/recipes-apps/pr0-rm2-timer/pr0-rm2-timer.bb
```

10. Build the images and packaage the boot.bin
```
$ petalinux-build
$ petalinux-package --boot --format BIN --plm --psmfw --u-boot --dtb --force
```


Output/Build images are available within the images/linux directory.

<table>
  <tr>
    <th>Image Name</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>boot.bin</td>
    <td>Boot image with static PDI & u-boot (also includes other required images, like atf, plm, etc)</td>
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
    <td>Image</td>
    <td rowspan="3">Separate images for Kernel, dtb and rootfs</td>
  </tr>
  <tr>
    <td>system.dtb</td>
  </tr>
  <tr>
    <td>rootfs.cpio.gz.u-boot</td>
  </tr>
</table>

Partial PDI and the corresponding DTBO are included in the rootfs in
this manner (as can be seen in rootfs.tar.gz in the Linux image area):

```
  lib/
     └── firmware
         └── xilinx
             └── rm-bram
                 ├── rm-bram.dtbo
                 └── rm-bram.pdi
             └── rm-timer
                 ├── rm-timer.dtbo
                 └── rm-timer.pdi
```

Designs with more than one RM will have more RM instances at the rm-bram
level, each with its own .dtbo and .pdi files.

## Testing Static and Partial PDIs without PetaLinux

To check if the Classic SoC Boot design has been built properly before
building the Linux images, a quick check can be done by downloading the
PDI files from XSDB and checking for access to the PL memory locations.

1.  Connect to a VCK190, locally or remotely.

2. Open an xterm window and use this for UART console. In the xterm
     window type:
```
systest# connect com0
```

3. Open another xterm window and use this for XSDB console. In the xterm window, type:
```
systest# xsdb
xsdb% connect
xsdb% ta 1
```

4. In the XSDB console, change directory to the Vivado project
     location. Download the static PDI by typing:
```
xsdb% device program project_1.runs/impl_1/top_wrapper.pdi
```

You should see text scrolling on the UART console with no errors.

5. Next verify that the BRAM is NOT accessible when only the static
     portion of Versal loaded:
```
xsdb% mrd -force 0xa4000000
Memory read error at 0xA4000000. AP transaction timeout
```

At this point you have confirmed that the memory location does not yet
exist. Plus Linux has hung.

6. Power cycle the board. If accessing the board remotely, type the following
     in the systest console:
```
Systest# power 0
Systest# power 1
```

7. Wait for system controller to boot up before moving on. You will
     also need to restart the UART console again, by executing the
     'connect com0' command again. Up arrow will also bring up the
     last command.

8. Download the static again (step 4), then program the partial image:
```
xsdb% device program project_1.runs/impl_1/top_wrapper.pdi
xsdb% device program project_1.runs/impl_1/top_i_PL_bram_bd_inst_0_partial.pdi
```

9. Now you should be able to access the BRAM:
```
xsdb% mrd -force 0xa4000000
A4000000: 00000000
xsdb% mwr -force 0xa4000000 0xdeadbeef
xsdb% mrd -force 0xa4000000
A4000000: DEADBEEF
```

You have now verified that the static PDI does not contain the BRAM
portion of the PL, and the partial PDI does contain the BRAM.

## Booting Linux and Downloading Partial PDI

Ultimately the desired flow (for most use cases using this solution)
will be to load the static PDI from a primary boot interface, boot
Linux, then later deliver the PL PDI image.

1.  Connect to a VCK190 board, either locally or remotely.
```
~$ /proj/systest/bin/systest vck190
```

2. Start the Hardware Server (note the hw server address, normally `<MachineName>:3121`)
```
Systest# hw_server
```

3. Add the TFTP root path to the Linux images repository within the
     project area.

```
Systest# tftpd "<path_to_example>/my_petalinux_project/images/linux"
```

4. Connect to the com port.
```
Systest 2# connect com0
```

5. Back in the primary terminal (in the example directory), run
     following make command
```
petalinux-boot --jtag --u-boot --hw_server-url <MachineName>:3121
```

On the systest terminal 2, Linux will boot

At the Linux prompt, program the partial PDI file using the fpgautil
command.
```
fpgautil -b /lib/firmware/xilinx/pr0-rm1-bram/pr0-rm1-bram.pdi -o /lib/firmware/xilinx/pr0-rm1-bram/pr0-rm1-bram.dtbo
```

At this point, Linux has been booted and the memory location in the PL
is accessible. You can use an XSDB console to read from and write to the
memory location as was done in the prior section of this tutorial. Or
you can interact with memory directly via Linux:
```
devmem 0xa4000000
0x00000000
devmem 0xa4000000 32 0xdeadbeef
devmem 0xa4000000
0xDEADBEEF
```

6. If you have created a second RM, you can load this in now.  If not you can reload the same RM, emulating a full PL reconfiguration.
```
# Remove the existing RM (required for reprogramming new RM)
fpgautil -R

# Program new RM
fpgautil -b /lib/firmware/xilinx/pr0-rm2-timer/pr0-rm2-timer.pdi -o /lib/firmware/xilinx/pr0-rm2-timer/pr0-rm2-timer.dtbo
```

Verify that reading 0xa4000000 returns 0x0 instead of whatever was written to the BRAM
```
devmem 0xa4000000
0x00000000

```
Then enable the timer, and check that the write was successful.
```
devmem 0xa4000000 32 0xD0
devmem 0xa4000000
```
Read the timer register which should change each time it is read
```
devmem 0xa4000008
```
You should be able to read and write to the AXI Timer registers now.

This concludes the tutorial portion of this document.

# Classic SoC Boot Design Structure

## Valid Connections

The Classic SoC Boot flow assumes that only certain connections will be
made between the static and reconfigurable regions. The following are
valid connections that are supported in the tools with this flow.

<p align="center">
  <img src="./images/CIPS_to_PL_via_FPD.png?raw=true">
</p>
<p align="center">
Figure 38 -- CIPS to PL via FPD and LPD ports
 </p>

<p align="center">
  <img src="./images/CIPS_to_PL_via_INI.png?raw=true">
</p>
<p align="center">
Figure 39 -- CIPS to PL via NOC INI ports
 </p>

<p align="center">
  <img src="./images/PL_to_CIPS_via_FPD.png?raw=true">
</p>
<p align="center">
Figure 40 -- PL to CIPS via FPD and LPD ports
 </p>

<p align="center">
  <img src="./images/CIPS_to_PL_via_INI.png?raw=true">
</p>
<p align="center">
Figure 41 -- PL to CIPS via NOC INI ports
 </p>

# Supported/Unsupported Features

As this is the initial release of the BDC DFX solution, not all features
and capabilities are complete. This section lists the current lists of
supported and unsupported features for DFX Block Design Container Projects.

## Supported Features

-   Support for Versal Prime devices enabled for the DFX flow -- in Vivado
    2021.2 this is limited to the Versal AI Core VC1902 and Versal Prime
    VM1802
    
    - Other Versal devices (Versal AI Core and Versal Premium, for example)
      are not yet supported

-   Production support of the Block Design Containers solution in IP Integrator

-   Automation of full-PL pblock generation

## Unsupported Features

Some features are not yet implemented but may be considered for future releases.

-   Selection of the Classic SoC Boot flow via project property in the
    IDE or CIPS IP GUI is planned for an upcoming release

-   Support for Aurora-based debug is planned for a future release

-   Additional DRCs and tool guidance are planned for upcoming releases

# Known Issues/Limitations and other Considerations

These are the issues and limitations with the Classic SoC Boot solution
in the Vivado 2021.2 release. Some of these issues may be fixed in
future releases, though plans are subject to change.

## Known Issues

-   A crash has been seen in opt_design for certain use cases.
The failure occurs towards the end of this design phase during auto-pblock creation.
A patch is required to work around this issue.
More information and the patch can be found in [Answer Record 76650](https://www.xilinx.com/support/answers/71079.html).

-   The classic_soc_boot property is not kept in memory for device image creation.
If users would like to directly open a routed design checkpoint (that has been implemented using the DFX flow with the
classic_soc_boot property enabled through place and route) to generate programming images,
they must reapply the property prior to calling write_device_image.
```
set_property classic_soc_boot 1 [current_project]
```

-   Not all IO elements are flagged for inclusion in the dynamic region.
The Classic SoC Boot flow will automatically pull top-level IO buffers connected to the Reconfigurable Partition (RP) into that dynamic region.  
Even though they are "static" elements they are included in that region and programmed with everything else in the Programmable Logic domain.  
IO instances that are not directly connected to the RP are not automatically included, so users must disable their top-level inference and 
instantiate them in each RM via the Utility Buffer IP.

-   The CIPS IP generates logic that is inserted in the wrapper layer. Some of this logic (e.g. vcc/gnd tie-offs) is
managed automatically by the flow, but some situations will require user intervention in this release. For example, use of 
extended multiplexed I/O (EMIO) by default uses tristate control that requires an inversion that is implemented in the PL.
This usage can lead to the following error:
```
[DRC HDPR-120] General Check for Classic SoC Boot: Cell 'top_i/versal_cips_0/inst/pspmc_0/inst/pmc_gpio_oe[0]_INST_0' 
with type 'LUT1' cannot be included in static logic in Classic_SoC_Boot. 
```
To avoid this error, set the following property on the CIPS instance to disable the inversion from CIPS IP generation.
```
set_property CONFIG.PS_PMC_CONFIG { PS_TRISTATE_INVERTED {0} } [get_bd_cells /versal_cips_0]
```
You will see the "t" pin on the CIPS IP (PMC_GPIO_t or LPD_GPIO_t) change to a "tn" pin (PMC_GPIO_tn or LPD_GPIO_tn) to 
indicate the inversion. Then to reapply the inversion, add a Utility Vector Logic IP instance set to "not" on this port 
to ensure this LUT-based inversion occurs within the Reconfigurable Partition.

-   DDRMC instances can be assigned to the dynamic region. However, not all scenarios adjust the floorplan for the 
Reconfigurable Partition correctly, leading to an error:
```
HDPR #1 Error Reconfigurable logic 'u_ddrmc_riu' is placed at site 'DDRMC_RIU_X1Y0' outside reconfigurable Pblock 'auto_pblock_PR'.
```
In this release, avoid this error by adjusting the auto-generated pblock by adding this site to the pblock prior to opt_design.
Reference this tcl.pre hook script before opt_design.
```
resize_pblock auto_pblock_PR -add {DDRMC_RIU_X1Y0}
```

-   Application of a PL POR reset through the use of the RST_PS (CRP) register is not yet supported.
Use of this register may result in a crash.


## Known Limitations

-   Use of the CPM4 (including PCIe Controller and DMA features) is not supported.

-   Use of Debug cores and the High Speed Debug Port (HSDP) is supported, but not debug via Aurora.
    
-   The CoreSight Trace Port Interface Unit is not supported with Classic SoC Boot. 
    Support for this feature, first via PMC MIO pins and later via the EMIO pins to the PL,
    may be considered in a future Vivado release.
    
-   Use of the auxiliary (analog) input pins for System Monitor (SYSMON) is not 
    supported, as these pins are routed through the PL to MIO or HDIO banks.
    Support for this feature may be considered in a future Vivado release.
    
-   Use of MBUFG primitives must account for reset handling. If this primitive is 
    used in /2, /4 or /8 mode to create divided clocks, the CLRB_LEAF input must be
    asserted to ensure proper clock synchronization after reset is released.
    More information can be found in [Answer Record 73639](https://support.xilinx.com/s/article/73639).

-   Only a single dynamic region (the full PL) is currently supported.
    While Vivado supports a Nested DFX solution that allows users to
    subdivide a dynamic region into lower-level dynamic regions, this
    capability is not yet supported in IP Integrator (project mode) or
    for Versal devices.

-   The initial boot of the PS + NoC + DDR portion of the device keeps
    the PL power domain in a powered-down state until it is programmed.
    There is currently no way to return this domain to a powered-down
    state after it has been programmed (without completely resetting the
    entire device). This capability may be considered for a future
    release.
    
## Other Considerations

-   The size of the initial boot image will depend on the amount of NoC usage in the design.
    NPS (NoC Packet Switches) and other NPI programming information is included in the .rnpi 
    in the initial .pdi image, so the greater the overall NoC usage throughout the design, the
    larger this will be. Only the CFRAME (CFI) programming information is limited to the 
    partial .pdi images.
