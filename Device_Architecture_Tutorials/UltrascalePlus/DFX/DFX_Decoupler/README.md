<table>
 <tr>
   <td align="center"><img src="https://www.xilinx.com/content/dam/xilinx/imgs/press/media-kits/corporate/xilinx-logo.png" width="30%"/><h1>DFX Tutorial</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1>Using the DFX Decoupler and DFX AXI Shutdown Manager IP</h1>
 </td>
 </tr>
</table>

## Table of Contents

[Overview](#overview)

[Section 1: Hardware Flow](#section-1-hardware-flow)

[Section 2: Vitis Application Flow](#section-2-vitis-application-flow)

[Section 3: Software Application Description](#section-3-software-application-description)

[Section 4: Performing Partial Reconfiguration from the Vivado Hardware Manager](#section-4-performing-partial-reconfiguration-from-the-vivado-hardware-manager)

[Conclusion](#conclusion)

[Addendum: Hardware Flow](#addendum---hardware-flow)

# Overview

Dynamic Function eXchange (DFX) in Xilinx silicon imposes new design
requirements. This document addresses the handling of interface signals
from the Reconfigurable Partition (RP) during the time that the dynamic
reconfiguration of the RP takes places. During the reconfiguration time
AXI bus control and status signals must remain in a valid state, AXI
reads/writes to the RP need to be handled, and status and control
signals driven by the RP might need to be assigned specific values. This
example design addresses these unique requirements using two DFX IP
cores, the DFX AXI Shutdown Manager and the DFX Decoupler, in an IP
Integrator flow.

## Flow Summary

You will start with an existing Vivado design, enable the DFX flow, add
in the DFX IP blocks and then walk through building and running a
software application while performing dynamic reconfiguration. The DFX
Decoupler provides a safe and managed boundary between the static design
the reconfigurable partition during dynamic reconfiguration. It supports
multiple interfaces per decoupler, supports all interface types used in
Vivado including AXI and custom interfaces, and supports unique
decoupling behavior (specific values for signals and interfaces can be
specified). The DFX AXI Shutdown Manger can be used to ensure that AXI
interfaces on RP boundary are kept in a safe state during dynamic
reconfiguration and it also supports the ability to terminate AXI
transactions, preventing an incomplete transaction that may stall or
hang the AXI bus. Using these two cores you will create a stable system
that continues to operate with AXI transactions to the RP occurring
during the dynamic reconfiguration time.

**DFX AXI Shutdown Manager**

-   Will be configured to allow AXI accesses to the RP to complete

-   Control of the Shutdown Manager will be via an AXI interface

-   An output from the Shutdown Manager will be used to enable an
    additional DFX IP core

**DFX Decoupler**

-   Supports all interface types supported by Vivado, including custom
    interfaces

-   Will be used to place an RP output to a known value during
    reconfiguration

-   Control will be signal-based

## DFX project within IP Integrator

The example design uses Vivado and Vitis 2021.1, and details the flow
for a Zynq UltraScale+ processor-based design along with Block Design Containers and
DFX concepts. These concepts are applicable to other device families,
including Versal, UltraScale+, UltraScale, and Zynq MPSoC and RFSoC.

This design is targeted to the ZCU106. The design can be completed by
hand or using tcl scripts. Detailed step by step instructions for
completing by hand are given in the addendum.

The design directory is as shown below. The three directories are as follows:

-   scripts -- contains all of the tcl files mentioned in this document.
    To source a script, create_bdc.tcl for example, in the Vivado tcl
    console type:

`source ./scripts/create_bdc.tcl`

-   sources -- contains pblock.xdc and dfx_appl.c

-   vitis_dfx_ws -- workspace directory to be used with Vitis. This directory is currently empty.

Note that the scripts supplied only augment the tutorial instructions. These four scripts 
build the project and block designs, but there are steps in between that are expected to be 
run interactively in the IP Integrator GUI.


# Section 1: Hardware Flow

The base design is shown in the figure below. There is a Zynq
UltraScale+ MPSoC processing block, a reset controller, and then two
GPIO IP cores connected via an AXI Interconnect. Each GPIO core is
configured to have two separate GPIO channels. The GPIO on the lower
right side of the block design (axi_gpio_0) allows controlling the 8
user LED's on the ZCU106 board, as well as reading the outputs from the
GPIO on the upper right side of the block design (axi_gpio_1).
axi_gpio_1 can read the value of a constant (xlconstant_0), as well as
output data to axi_gpio_0. Both axi_gpio_1 and xlconstant_0 will be in a
DFX-enabled Block Design Container that can be reconfigured by the user.

<p align="center">
  <img src="./images/base_block.png?raw=true">
</p>
<p align="center">
Figure 1: Base block design
</p>

## Create a Block Design Container

1.  **Clone** this repository to a writable location, referred to in this document as \<path_to_design>/dfx_shdn_dcplr. 
All path references in this document are relative to this root location.  

2.  **Launch** Vivado, and navigate to the root folder in the Tcl Console.

3.  **Run** the design project creation script for Vivado 2021.1. The block design shown above will be created.

`source ./scripts/dfx_shdn_dcplr_proj.tcl`

The next thing to do is to add the peripherals that will become a
Reconfigurable Module (RM) to a hierarchical block, and then turn that
block into a Block Design Container (BDC).

4.  **Source** create_bdc.tcl file from the scripts subdirectory to complete this step.

`source ./scripts/create_bdc.tcl`

Detailed steps are given in the [Addendum - Hardware Flow](#create-a-block-design-container-1), 
steps 1 to 4, if you wish to run through the process manually.

This Block Design Container, named gpio_rm1, contains a 2-channel GPIO.
Channel 1 is connected to constant that when read returns 0x11FACE11.
Channel 2 is an 8-bit output.

You will end up with a block design that looks like Figure 2. The BDC
will be labeled gpio_rm1.bd and will have an icon that
looks like a pyramid of six rectangles.

<p align="center">
  <img src="./images/top_with_bdc.png?raw=true">
</p>
<p align="center">
Figure 2: Base design with a Block Design Container for hier_1
</p>

In addition, the BDC will show up as a source in the Sources window of
Vivado.

<p align="center">
  <img src="./images/sources_with_gpio_rm1.png?raw=true">
</p>
<p align="center">
Figure 3: gpio_rm1 in the Sources window as a new block design
</p>

## Enable Dynamic Function eXchange

In this section you will enable DFX capabilities within IPI and add new
Reconfigurable Modules for the gpio_rm1 Block Design Container.

Note: Converting a project to Dynamic Function eXchange cannot be
undone. It is recommended that you save the existing project before
enabling Dynamic Function eXchange.

5.  In the Vivado IDE, enable the DFX flow by selecting **Tools > Enable
    Dynamic Function eXchange**. Select **Convert** in the dialog box
    that opens.
    
<p align="center">
  <img src="./images/convert_dfx.png?raw=true">
</p>
<p align="center">
Figure 4: Convert the project to a DFX project
</p>

Once this step has been performed you will see new menu items appear.
The Dynamic Function eXchange Wizard will be visible in the Flow Manager
as well as under the Tools menu.

6.  Back in the dfx_shdn_mgr block design, **double-click** on the
    hier_1 instance to edit the Block Design Container.

7.  Under the **General** tab, check the
    **Enable Dynamic Function eXchange on this container** checkbox.
    This turns the BDC into a Reconfigurable Partition.  
    Also check the **Freeze the boundary of this container** checkbox.

<p align="center">
  <img src="./images/bdc_dfx.png?raw=true">
</p>
<p align="center">
Figure 5: Enable DFX on this container
</p>

Until the boundary is frozen you can pass parameters through the
hierarchy into the Block Design Container. However, in order to
implement the DFX design the boundary must be frozen.

8.  Click **OK** to save the changes and return to the dfx_shdn_mgr
    block design.

9. **Validate** and then **Save** the design.

The hier_1 block container instance will now have a DFX label.

<p align="center">
  <img src="./images/top_with_dfx.png?raw=true">
</p>
<p align="center">
Figure 6: Base design with a BDC enabled for DFX
</p>

## Add DFX AXI Shutdown Manager and DFX Decoupler IP cores

Because you are reconfiguring logic that includes an AXI interface, you
will add a DFX AXI Shutdown Manager IP instance. This will allow the
processor to remain running and not hang if the AXI interface is
accessed during the time the dynamic reconfiguration is taking place.
You will configure the Shutdown Manager to respond with **OKAY** to any
AXI transaction that occurs on the Reconfigurable Partition boundary.

You also add a DFX Decoupler IP instance to force interface signals
coming from the Reconfigurable Partition to a safe state when the
dynamic reconfiguration takes place. This core will be configured to
output **0x3C** when enabled. This is to show how you can control
critical outputs from an RP so that during dynamic reconfiguration they
remain in a particular state or states. Also note that using signal
control for the decoupler allows it to be used in a design that does not
have AXI or AXI-based processor.

10. **Source** the add_dfx_ip.tcl file to complete these steps.

`source ./scripts/add_dfx_ip.tcl`

Detailed steps are given in the [Addendum - Hardware Flow](#Add-DFX-AXI-Shutdown-Manager-and-DFX-Decoupler)
steps 5 to 14.

The DFX AXI Shutdown Manager allows the designer to control how the
system will respond to AXI transactions when the RP is being
reconfigured. In the screen shot below you can see how you have
configured the DFX AXI Shutdown Manager IP instance in this design.

For the **Control/Status Interface Options**, the **Control Interface
Type** has been set to **AXI LITE**. In this design the processor will
enable/disable the DFX AXI Shutdown Manger.

For the Datapath Options you have selected **AXI4LITE** (this matches
the GPIO peripheral in the RM) for the Datapath Protocol, and **OKAY**
for the AXI Response to rejected transaction. With this setting, when
the Shutdown Manager is enabled, any read and writes to the RM will
complete. Reads will return 0x0 for the data, and the write will
complete but no data will be written. When the Shutdown Manager is
disabled the Shutdown Manager is in Pass Through mode and transactions
are passed unaltered.

<p align="center">
  <img src="./images/shutdown_mgr.png?raw=true">
</p>
<p align="center">
Figure 7: DFX AXI Shutdown Manager configuration
</p>

The DFX Decoupler in this design gives us the ability to output a
specific value when enabled. In a real-world DFX-based designs there are
often key status/control/data outputs that must be assume specific
values when reconfiguration occurs. The DFX Decoupler allows designers
to specify exactly what values these signals/interfaces go to when
enabled. In this design you have specified a GPIO for the interface, and
have defined that decoupled value for this interface will be 0x3C .

<p align="center">
  <img src="./images/dfx_decoupler.png?raw=true">
</p>
<p align="center">
Figure 8: DFX Decoupler configuration
</p>

The completed block design will look like Figure 9. Note the RP
interfaces and signals are connected to the DFX AXI Shutdown Manager and
DFX Decoupler. These two cores are in the static region and handle the
interfaces and signals when enabled. When disabled both cores are in
pass through mode and the RP's interfaces and signals are unaltered.
When the DFX Shutdown Manager is enabled, it blocks the AXI path, puts a
fence around other periphery signals, and enables the DFX Decoupler via
the DFX Shutdown Manager's in_shutdown output.

<p align="center">
  <img src="./images/complete_top_bd.png?raw=true">
</p>
<p align="center">
 Figure 9: DFX IP in the complete block design
</p>

## Add a new Reconfigurable Module

You will now create a second Reconfigurable Module. This RM will have a
different constant value that can be read by the processor.

11. Right-click on the heir_1 instance and select **Create
    Reconfigurable Module**. Use gpio_rm2 for the reconfigurable module
    name, then press **OK**.

<p align="center">
  <img src="./images/second_rm.png?raw=true">
</p>
<p align="center">
Figure 10: Create a second Reconfigurable Module
</p>

A new block design will be created with the interface pins defined by
the initial Reconfigurable Module. The interface pins between all RMs
for a given RP must be identical, even if some of the pins are not used
by each RM. Unused ports can be tied off.

12. With the gpio_rm2 block design open, **source** complete_gpio_rm2.tcl to complete this step.

`source ./scripts/complete_gpio_rm2.tcl`

Detailed steps are given in the [Addendum - Hardware Flow](#Complete-the-New-Reconfigurable-Module)
steps 15 to 22.

<p align="center">
  <img src="./images/second_rm_bd.png?raw=true">
</p>
<p align="center">
Figure 11: The second Reconfigurable Module
</p>

## Generate targets for the top block design

13. In the Sources window, right-click on the dfx_shdn_mgr block design,
    select **Generate Output Products**, then in the Generate Output
    Products dialog box select **Generate**.

<p align="center">
  <img src="./images/generate_output.png?raw=true">
</p>
<p align="center">
Figure 12: Generate Output Products for the block design
</p>

This creates the synthesizable output products for each IP in
dfx_shdn_mgr, building out-of-context synthesis runs for each IP. Under
the Design Runs tab, you will see the list of synthesis runs for all the
IP contained in static region of dfx_shdn_mgr. Note that variants for
gpio_rm1 and gpio_rm2 have been created but have not run yet. This will
happen later.

14. Right-click on the dfx_shdn_mgr block design again and select **Create HDL Wrapper***. 
In the subsequent dialog box, keep **Let Vivado manage wrapper and auto-update** selected
then click OK.

## Run the DFX Wizard to define the configurations

The Dynamic Function eXchange (DFX) Wizard is used to the define
relationships between the different parts of the DFX design. Using Block
Design Containers you have created a level of hierarchy for this design
that has more than one variant. In a DFX design, the BDC represents a
Reconfigurable Partition (RP), and each design source in a BDC (gpio_rm1
and gpio_rm2) is a Reconfigurable Module (RM).

Using the DFX Wizard you define configurations and runs. A configuration
is a full design image, with one RM per RP. In this design there are two
possible configurations, one using gpio_rm1, and the other using
gpio_rm2. A configuration run is a pass through the place and route
tools to create a routed checkpoint for that configuration. The DFX
Wizard also establishes parent-child relationships between configuration
runs, helping to automate the required parts of the flow including
static design locking and pr_verify. This also sets up dependencies
between runs, so Vivado knows what steps must be rerun when sources are
modified.

The general recommendation for a DFX design is that you use the most complicated
and/or largest RM in the initial design flow. The Vivado tools place
and route the entire design to create a parent implementation. From this initial
placed and routed design the static portion of the design is extracted
as a Design Check Point (DCP). Then for each subsequent RM (child
implementation), the static DCP is loaded, and then that RM is placed
and routed into the reconfigurable region connecting to the static
partition pins. Prior to bitstream generation for each child configuration, a
final verification is done, using pr_verify, to validate that the static
portions and partition pin placements are the same. Only after pr_verify
completes will partial bitstreams be produced.

15. Start the DFX Wizard by either clicking on **Dynamic Function
    eXchange Wizard** in the Flow Navigator, or by selecting that option
    from the **Tools** menu.

16. When the DFX Wizard starts, click **Next** to see the Edit
    Reconfigurable Modules step. You will see two RMs, gpio_rm1_inst_0
    and gpio_rm2_inst_0 that were created earlier.

<p align="center">
  <img src="./images/wiz1_rms.png?raw=true">
</p>
<p align="center">
Figure 13: Two Reconfigurable Modules available
</p>

Note that the Block Design Container flow differs from the RTL DFX flow
in that you cannot add new variants from within the DFX Wizard. With the Block
Design Container DFX flow new variants must be entered from the canvas
as you did when you created gpio_rm2, or by adding new block designs to the 
project and associating them with the Block Design Container.

17. Click **Next**, and in the Edit Configurations tab, click the
    **automatically create configurations** link to generate two
    configurations.

<p align="center">
  <img src="./images/wiz2_configs.png?raw=true">
</p>
<p align="center">
Figure 14: Two configurations for this project
</p>

You can create configurations by using the **+** button. But for designs
with a single RP, automatic creation is the easiest way to create
configurations covering all RMs. Note that you can edit the
configuration name(s) if desired.

18. Click **Next**, and in the Edit Configuration Runs step, click on
    the **automatically create configuration run** link to create one
    run per configuration.

<p align="center">
  <img src="./images/wiz3_runs.png?raw=true">
</p>
<p align="center">
Figure 15: Two configuration runs for this project
</p>

In the Edit Configuration Runs tab, you can see the parent-child
relationship under the Parent category. A Parent implementation starts
with a synthesis run. Then each child run must reference the parent
implementation. In this design the parent of child_0\_impl_1 is impl_1,
and the indentation of the child run illustrates this relationship.

19. Click **Next** then **Finish** to complete this section.

Note that the DFX Wizard can be run again at any time to create or
modify configurations and configuration runs in the project.

In the Design Runs window (tab on the bottom of the Vivado GUI), a new
child_0\_impl_1 implementation run has been created, and the indentation
shows its dependency on the impl_1 run above it.

## Add design constraints for the Reconfigurable Partition

All DFX designs require a floorplan, with each RM requiring a pblock
containing enough resources to implement any RM that may be used in that
partition. In this design, the pblock constraints have been created for
you.

20. In the Sources window, click the + sign to open the Add Source
    dialog box. Select **Add or create constraints** then **Next**.
    Click the **Add Files** and navigate to the project directory to
    find and add dfx_pblock.xdc. Click **Finish** to add this constraint
    file to the project.

Now all design sources have been added to the project, and all the
settings for a DFX design have been completed. It is time to implement
and generate the bitstreams.

21. Under the Flow Navigator, click on the **Generate Bitstream**
    option. Click **Yes** then **OK** in the resulting dialog boxes to
    begin synthesis and implementation of the design.

This will perform all runs necessary to implement both the parent and
child configurations, and then generate the full and partial bitstreams.
The flow is as follows.

-   Out-of-Context (OOC) synthesis will be run for the two RMs. These
    are launched in parallel as they do not depend on each other.

-   Synthesis of the top-level design launches after the OOC runs
    complete.

-   The parent run is implemented first, using the standard Vivado
    implementation flow that applies the DFX constraints. At the end of
    the run multiple design checkpoints are written:

    -   A standard placed and routed checkpoint for the full design is created

    -   A module level checkpoint for the placed and routed RM gpio_rm1

    -   A static-only design checkpoint, with all placement and routing locked, and a black box for gpio_rm1

-   The child run containing gpio_rm2 is started last, using the locked
    static-only checkpoint from the parent run.

## Export the XSA for Vitis application development

22. **Open** the implemented parent design run.

23. Export the hardware by selecting **File > Export > Export
    Hardware**. Select **Next**, then select **Include bitstream**.
    Select **Next**, leave the default name and directory, then select
    **Finish**.

<p align="center">
  <img src="./images/export_hw.png?raw=true">
</p>
<p align="center">
Figure 16: Export hardware platform information from the parent configuration
</p>

# Section 2: Vitis Application Flow

## Launch Vitis

1.  From the Vivado GUI, select **Tools > Launch Vitis IDE**. This will
    launch Vitis.

2. When the Vitis IDE Launcher dialog box opens, **browse** to the
    design directory to **select** the vitis_dfx_ws subdirectory and
    select **Launch**.

<p align="center">
  <img src="./images/launch.png?raw=true">
</p>
<p align="center">
Figure 17: Launch the Vitis IDE from the workspace directory
</p>

3. Select **Create Application Project** then click **Next**.

4. In the New Application Project dialog box that appears, select
    Browse under the **Create a new platform from hardware (XSA)** tab.

<p align="center">
  <img src="./images/browse.png?raw=true">
</p>
<p align="center">
Figure 18: Browse to find the XSA from the tutorial project
</p>

5. Browse to the design directory and select the XSA file that you just
    produced (dfx_shdn_mgr_wrapper.xsa) then select **Next**.

<p align="center">
  <img src="./images/wrapper.png?raw=true">
</p>
<p align="center">
Figure 19: dfx_shdn_mgr_wrapper selected
</p>

6. In the Application Project Details dialog, enter the Application
    project name as "dfx_shdn_appl" -- the System project name and
    Associated applications will be filled in automatically. Click
    **Next** to continue.

<p align="center">
  <img src="./images/app_name.png?raw=true">
</p>
<p align="center">
Figure 20: Enter the Application project name
</p>

7. Click **Next** again past the Domain page, keeping the default
    settings.

8. In the New Application Project Template dialog box, select **Empty
    Application(C)** and press **Finish**.

<p align="center">
  <img src="./images/empty_C.png?raw=true">
</p>
<p align="center">
Figure 21: Use the Empty Application template
</p>

9. In Vitis, click on the **build** button to build the initial
    project, using the build icon (hammer). Note this can take a long
    time.

<p align="center">
  <img src="./images/build.png?raw=true">
</p>
<p align="center">
Figure 22: Build the project in Vitis
</p>

10. After the build finishes, **import** the file dfx_appl.c file in the
    dfx_shdn_dcplr/sources directory, into the
    dfx_shdn_dcplr/vitis_dfx_ws/dfx_shdn_appl/src directory. This is done by: 
    - Expand in the Explorer window dfx_shdn_appl_system > dfx_shdn_appl to find **src**
    - Right-click on src to select **Import Sources**
    - Browse to the **sources** directory and click **Open**
    - **Check** the box for dfx_appl.c and click **Finish**

<p align="center">
  <img src="./images/c_prog.png?raw=true">
</p>
<p align="center">
Figure 23: Source C program copied from the sources directory
</p>

11. Click **build** again to build the application. This creates dfx_shdn_appl.elf.

12. Right-click on **dfx_shdn_appl \[ standalone_psu_cartexa53_0 \]** in
    the Explorer window and select **Run As > Launch on Hardware (Single
    Application Debug)**.

This will configure the Zynq MPSoC with the full bitstream, and run the
application. A connection to the ZCU106 target board is, of course, required at this point.

# Section 3: Software Application Description

The software application has a small menu that allows users to do some
basic tasks. The menu is shown in Figure 24. Refer to
[PG144](https://www.xilinx.com/support/documentation/ip_documentation/axi_gpio/v2_0/pg144-axi-gpio.pdf)
for details on the AXI GPIO IP for all the actions below.

<p align="center">
  <img src="./images/app_menu_initial.png?raw=true">
</p>
<p align="center">
Figure 24: Application menu
</p>

### 1 -- Read RM's constant value

This will read the constant value connected to the GPIO interface in the
RM. The function reads the GPIO_DATA register, address offset 0x0, of
the AXI GPIO core in the RM.

<p align="center">
  <img src="./images/read_init.png?raw=true">
</p>
<p align="center">
Figure 25: Value read with initial (gpio_rm1) configuration
</p>

### 2 -- Write RM's output data (sets it to 0x12)

This will write 0x12 to the GPIO 2 interface in the RM. The function
writes to the GPIO2_DATA register of the GPIO core, offset 0xC. The
output from GPIO 2 in the RM defaults to 0x0.

<p align="center">
  <img src="./images/uart_2.png?raw=true">
</p>
<p align="center">
Figure 26: UART output when option 2 is selected
</p>

### 3 -- Read Output data from RM

This will read the output data from the RM by reading the output of GPIO
2. The function reads the GPIO2_DATA register, offset 0xC, of the GPIO
core in the RM.

<p align="center">
  <img src="./images/data_read.png?raw=true">
</p>
<p align="center">
Figure 27: Output data read after configuration (before being set by
menu option 2)
</p>

<p align="center">
  <img src="./images/data_read_again.png?raw=true">
</p>
<p align="center">
Figure 28: Output data read after running option 2 to set to 0x12
</p>

### 4 -- Read DFX Shutdown Manager status register

This will read the status register of the Shutdown Manager. The status
register is a read-only register, offset 0x0, of the Shutdown Manager.

When not enabled the status register will read 0x0.

When enabled the status register will read 0xF.

Refer to
[PG374](https://www.xilinx.com/support/documentation/ip_documentation/dfx_controller/v1_0/pg374-dfx-controller.pdf)
for details on capabilities of the DFX AXI Shutdown Manager.

<p align="center">
  <img src="./images/read_reg.png?raw=true">
</p>
<p align="center">
Figure 29: Status register when shutdown manager disabled
</p>

<p align="center">
  <img src="./images/read_reg_again.png?raw=true">
</p>
<p align="center">
Figure 30: Status register when Shutdown Manager enabled
</p>

### 5 -- Enable the DFX Shutdown Manager

This will write 0x1 to the Shutdown Manager control register, enabling
it. The Control Register is a write-only register at offset 0x0 of the
Shutdown Manager. When enabled, any read or write of an AXI peripheral
in the RM will result in reading data = 0x0, and any writes will
complete but no data will be written to the peripheral.

With this design, when the Shutdown Manager is enabled, the DFX
Decoupler is also enabled and it will force the output data from the RM
to be = 0x3C. This is to show how you can force output signals from the
RP take on specific values, depending on your design needs, during
dynamic reconfiguration.

<p align="center">
  <img src="./images/enable_shutdown.png?raw=true">
</p>
<p align="center">
Figure 31: Enabling the Shutdown Manager
</p>

### 6 -- Disable the DFX Shutdown Manager

This will write a 0x0 to the Shutdown Manager control register,
disabling it. The control register is a write-only register at offset
0x0 of the Shutdown Manager. When disabled the AXI interface connects
directly to the AXI interface inside the current RM. When disabled the
DFX Decoupler is also disabled and the output data from the RM's GPIO 2
interface will be present on the output of the decoupler and can be
read.

<p align="center">
  <img src="./images/disable_shutdown.png?raw=true">
</p>
<p align="center">
Figure 32: Disabling the Shutdown Manager
</p>

### 7 -- Increment LED output

This will use the GPIO 2 interface in the static portion of the design
to write to the LEDs and increment the value displayed by 1.

<p align="center">
  <img src="./images/inc_led.png?raw=true">
</p>
<p align="center">
Figure 33: Incrementing the LED output
</p>

### 8 -- Increment LED output and read the RM constant and RM data output for 10 seconds

Every 0.5 seconds this will write to the LEDs in the static portion of
the design with an incrementing value, and read the RM's constant value
and output data.

When the Shutdown Manager is disabled the constant value and output data
read will be from the RM (as both the Shutdown Manager and DFX Decoupler
are disabled). When the Shutdown Manager is enabled the constant value
read will be 0x0 and the output data read will be 0x3C (the value that
the DFX Decoupler was configured to output when enabled).

The intention of this menu option is that you can have the Vivado
Hardware Manager open. From your terminal program, configure the
Shutdown Manager and output data as desired and then select this option.
Then in the Hardware Manager, program the MPSoC with one of the partial
bitstreams. The partial bitstream configuration time is much less than
10 seconds. This allows you to verify that the system continues to run
and the output data is at a known good state during partial
reconfiguration when the shutdown manager is enabled. Likewise, you can
also perform partial reconfiguration with the shutdown manager disabled
and you can hang the processor.

Figure 34 shows running this menu option when the MPSoC has gpio_rm1 and
the Shutdown Manager is disabled. Note that the constant is 0x11FACE11,
and the output data is 0x12.

<p align="center">
  <img src="./images/select_8.png?raw=true">
</p>
<p align="center">
Figure 34: Selecting option 8 with the Shutdown Manager disabled

Figure 35 shows running this menu option with the Shutdown Manager
enabled. Note the constant value read is 0x0 and the data output read is
0x3C.

<p align="center">
  <img src="./images/select_8_again.png?raw=true">
</p>
<p align="center">
Figure 35: Selecting option 8 with the Shutdown Manager enabled
</p>

# Section 4: Performing Partial Reconfiguration from the Vivado Hardware Manager

This section shows you how to perform partial reconfiguration of the
device with and without the DFX IP cores to see how the device behaves.
If the DFX Shutdown Manager is enabled, you can perform partial
reconfiguration, then disable the DFX Shutdown Manager and the processor
will be running. You can also perform partial reconfiguration with the DFX
Shutdown Manager disabled, and you will see how the processor stops
responding.

1.  From Vivado, open the Hardware Manager by clicking on **Open
    Hardware Manager** from the bottom of the Flow Navigator.

When the Hardware Manager windows opens, click on the **Open Target**
link and then select Auto connect. You will see a screen like this after
it connects.

<p align="center">
  <img src="./images/hw_mgr.png?raw=true">
</p>
<p align="center">
Figure 36: Vivado Hardware Manager connected to the target ZCU106

The bitstreams are located in the impl_1 and child_0\_impl_1 directories
under dfx_shdn_dcplr/dfx_shdn_dcplr.runs.

The impl_1 directory will contain 2 bitstreams for the initial RM
(gpio_rm1).

-   dfx_shdn_mgr_wrapper.bit -- full bitstream containing the static and
    gpio_rm1 in the RP

-   dfx_shdn_mgr_i\_hier_1\_gpio_rm1_inst_0\_partial .bit -- partial
    bitstream for gpio_rm1

<p align="center">
  <img src="./images/bitstreams.png?raw=true">
</p>
<p align="center">
Figure 37: Full and Partial bitstreams in the parent configuration run
directory

The child_0\_impl_1 subdirectory will also contain 2 bitstreams, but
these are for the child configuration (gpio_rm2).

-   dfx_shdn_mgr_wrapper.bit -- full bitstream containing the static and
    gpio_rm2 in the RP

-   dfx_shdn_mgr_i\_hier_1\_gpio_rm2_inst_0\_partial -- partial
    bitstream for gpio_rm2

<p align="center">
  <img src="./images/child_bitstreams.png?raw=true">
</p>
<p align="center">
Figure 38: Full and Partial bitstreams in the child configuration run directory
</p>

You can configure the Zynq MPSoC with either full bitstream, then once
configured, you can then partially reconfigure the programmable logic
using the partial bitstreams.

2. To deliver the partial bitstream for gpio_rm2, right-click on
    **xczu7_0(1)** in the Hardware Manager, select **program device**,
    then using the ... option on the right of the dialog box, browse to
    the child_0\_imp_1 directory and select
    **dfx_shdn_mgr_i\_hier_1\_gpio_rm_inst_0\_partial.bit**. Select
    **OK** to return to the Program Device dialog box.

<p align="center">
  <img src="./images/select_partial.png?raw=true">
</p>
<p align="center">
Figure 39: Select the partial bitstream in the child configuration run directory
</p>

3. Select Program in the dialog box to program the device with this
    partial bitstream.

<p align="center">
  <img src="./images/program_partial.png?raw=true">
</p>
<p align="center">
Figure 40: Program the ZCU106 with a partial bitstream
</p>

You can select either partial bitstream and reconfigure the MPSoC.

Note that once you have selected a bitstream for the device in the
Hardware Manager (either a full or partial bitstream), it will remain in
memory. When you right-click on xczu7_0(1) and select Program, that
bitstream will be used to configure the device. This means once you
select a partial bitstream, you can right-click and select Program.

4. After you have completed programming with a partial bitstream,
    disable the Shutdown Manager, then read the RM's constant value.

<p align="center">
  <img src="./images/read_RMs.png?raw=true">
</p>
<p align="center">
Figure 41: Reading the RM's constant value after reprogramming with the
gpio_rm2 partial bitstream

5. In your terminal program, select option 8. Then return to the Vivado
    Hardware Manager and right-click and perform a partial bitstream
    configuration.

If the Shutdown Manager has been enabled prior to the DFX configuration,
the processor will continue to display the shutdown enabled data (0x0
for the constant, and 0x3C for the output data). Once it completes
option 8, you can disable the Shutdown Manager and then read the
constant and output data from the RM.

You can also perform partial reconfiguration with the DFX Shutdown
Manager disabled, and you will see the process hang when the
reconfiguration starts. Figure 42 shows option 8 running and a partial
reconfiguration occurring with the Shutdown Manager disabled. In this
case the processor hangs, and will not respond via the terminal program.
The only way to recover is to perform a full reconfiguration using one
of the full bitstreams then restart the application.

<p align="center">
  <img src="./images/sw_hang.png?raw=true">
</p>
<p align="center">
Figure 42: The software application hangs if the decoupling is disabled
</p>

# Conclusion

This design shows how the use of the DFX Shutdown Manager and DFX
Decoupler IP cores to create a stable system. Through the use of these
two IP cores, this design allows for AXI interface access to occur
during reconfiguration, and also shows how to have outputs forced to
defined, known states.

The software application allows you to enable and disable these IP
cores. It provides a simple platform to play around with partial
reconfiguration with and without the cores enabled and see how the
system reacts.


# Addendum - Hardware Flow

This section describes the steps automated by the three enclosed Tcl
scripts.

## Create a Block Design Container

1.  In the block design canvas, ctrl-click to select both axi_gpio_1 and
    xlconsant_0, then right-click and select **Create Hierarchy**. Name
    the hierarchy hier_1. Press **OK** to return to the canvas.

<p align="center">
  <img src="./images/create_hier.png?raw=true">
</p>
<p align="center">
 Figure 43: Create a level of hierarchy called hier_1
</p>

The block design will now look like this:

<p align="center">
  <img src="./images/bd_hier.png?raw=true">
</p>
<p align="center">
Figure 44: Block design with hierarchy created
</p>

2.  **Validate** the block design (use the <img src="./images/check.png?raw=true">
icon) and then **save** the design.

3. Create the Block Design Container by right-clicking on hier_1,
    selecting **Create Block Design Container,** and giving it the name
    gpio_rm1. Click **OK** to complete the process.
    
<p align="center">
  <img src="./images/create_bdc.png?raw=true">
</p>
<p align="center">
Figure 45: Create a new Block Design Container from hier_1
</p>

This will convert the hierarchical instance into a Block Design
Container. This block will be labeled gpio_rm1.bd and
will have an icon that looks like a pyramid of six rectangles. Also, you
will see this new block design has been added to the project, visible in
the sources view.

<p align="center">
  <img src="./images/top_with_bdc.png?raw=true">
</p>
<p align="center">
Figure 46: hier_1 converted to a Block Design Container
</p>

<p align="center">
  <img src="./images/sources_with_gpio_rm1.png?raw=true">
</p>
<p align="center">
Figure 47: gpio_rm1.bd added to the project
</p>

This action created a new block design for the rm1 submodule. If you
expand the gpio_rm1 instance in the top-level block design, you will
notice that you cannot edit the design in that level. This is a
read-only copy. To edit this block design you must open the block design
from the sources view.

4. **Validate** then **save** the design

At this point the design is still a standard IP Integrator project,
except with two block designs instead of one. The Block Design Container
feature in IPI allows you to add multiple variants of the gpio_rm1 block
design through multiple design revisions, or to allow for team design by
sharing submodule block designs with team members.

Return to [Enable Dynamic Function eXchange](#Enable-Dynamic-Function-eXchange) to continue the tutorial.

## Add DFX AXI Shutdown Manager and DFX Decoupler

5. From the canvas click the **+** icon and using the search field add
    a **DFX Decoupler IP** instance.

6. Double-click to customize the IP, **customize** the Interface
    Options tab as shown in Figure 48.

-   Click **New Interface** to add the first interface to decouple.

-   Next set the **Interface VLNV** to xilinx.com:interface:gpio
    rtl:1.0. This will auto-fill most of the other settings shown below.

-   Uncheck the Decouple option for **TRI T** and **TRI I** ports.

-   Finally set **TRI O** to Manual, then set the **Width** to **8** and
    the **Decouple Value** to **0x3c**.

<p align="center">
  <img src="./images/customize_decoupler.png?raw=true">
</p>
<p align="center">
Figure 48: Customize the DFX Decoupler IP
</p>

7. Leave the Global Options tab as is and press **OK** to return to the
    canvas.

8. Delete the reconfig_gpio2_io_o signal that currently connects hier_1
    to axi_gpio_0. Connect the output of hier_1 to the
    rp_intf_0\_TRI_O\[7:0\] input of the DFX Decoupler, and the output
    of the s_intf_0\_TRI_O\[7:0\] output of the DFX Decoupler to the
    GPIO input of axi_gpio_0. Note that you'll have to expand bus ports to
    expose the O pins to connect.

<p align="center">
  <img src="./images/decoupler_added.png?raw=true">
</p>
<p align="center">
Figure 49: Top-level block design with the DFX Decoupler IP connected
</p>

9. From the canvas click to + icon and using the search field add a
    **DFX AXI Shutdown Manager IP** core to the design.

10. Double-click to customize the core.

-   Deselect the **Is the RP the Master of this AXI channel?** checkbox.

-   Set the **Control Interface Type** to **AXI LITE**.

-   Change the **Datapath Protocol** to **AXI4LITE**.

-   Set the **AXI Response to rejected transaction** option to **OKAY**.

    Press **OK** to return to the canvas.

<p align="center">
  <img src="./images/customize_shutdown.png?raw=true">
</p>
<p align="center">
Figure 50: Customize the DFX AXI Shutdown Manager IP
</p>

11. Double click on axi_interconnect_0 to customize, change to set the
    **Number of Master Interfaces** to **3**, then select **OK** to
    return to the canvas.

<p align="center">
  <img src="./images/customize_AXI_interconnect.png?raw=true">
</p>
<p align="center">
Figure 51: Update the AXI Interconnect IP to show 3 Master Interfaces
</p>

12. Modify the interfaces, clocks and resets to/from the shutdown
    manager, hier_1, and axi_interconnect_0 to match the following
    diagram.

-   Delete the axi_interconnect_0\_M01_AXI signal the currently connects
    axi_interconnect_0 and hier_1.

-   Connect the M01_AXI output of axi_interconnect_0 to the S_AXI input
    of dfx_axi_shutdown_man_0.

-   Connect the M_AXI output of dfx_axi_shutdown_man_0 to the S_AXI
    input of hier_1.

-   Connect the new M02_AXI output of axi_interconnect_0 to the
    S_AXI_CTRL input of dfx_axi_shutdown_man_0.

-   Connect the clk input of dfx_axi_shutdown_man_0 and the new
    M02_ACLK input of axi_interconnect_0 to the general clock (pl_clk0
    from zynq_ultra_ps_e\_0) in the design.

-   Connect the resetn input of dfx_axi_shutdown_man_0 and the new
    M02_ARESETN input of axi_interconnect_0 to the general reset
    (peripheral_aresetn output of rst_ps8_0\_99M) in the design.

-   Finally, connect the in_shutdown output of dfx_axi_shutdown_man_0 to
    the decouple input of dfx_decoupler_0.

<p align="center">
  <img src="./images/controller_added.png?raw=true">
</p>
<p align="center">
Figure 52: Top-level block design with the DFX AXI Shutdown Manager IP
connected

13. Under the Address Editor tab assign addresses using the Assign All
    Icon (<img src="./images/assign_all.png?raw=true">)

You will end up with the following in the Address Editor

<p align="center">
  <img src="./images/address_editor.png?raw=true">
</p>
<p align="center">
Figure 53: Address Editor with all peripherals assigned
</p>

14. **Validate** and then **save** the design.

Return to [Add a new Reconfigurable Module](#Add-a-new-Reconfigurable-Module) to continue the tutorial.

## Complete the New Reconfigurable Module

15. From the canvas click to + icon and using the search field add an
    **AXI GPIO** IP core to the design.

16. Double-click to customize and match what is shown below. Under the
    **IP Configuration** tab:

-   Check the **All Inputs** box for GPIO.

-   Check the **Enable Dual Channel** box.

-   Check the **All Outputs** for GPIO 2

-   Set the **GPIO Width** for GPIO 2 to **8**.

Press **OK** to return to the canvas.

<p align="center">
  <img src="./images/axi_gpio.png?raw=true">
</p>
<p align="center">
Figure 54: AXI GPIO IP Configuration options
</p>

17. From the canvas click the + icon and using the search field add a
    **Constant** core to the design.

18. Double-click on the Constant instance and customize to have **Const
    Width** = **32** and **Const Val** = **0x22dfec22**.

<p align="center">
  <img src="./images/const.png?raw=true">
</p>
<p align="center">
Figure 55: Customize the Constant IP
</p>

Press **OK** to return to the canvas.

19. Connect the Constant and AXI GPIO as shown in Figure 56.

-   Connect the dout port of the constant IP to the GPIO input.

-   Connect the GPIO2 output to the gpio2_io_o port of the block design.

-   Connect the S_AXI, s_axi_aclk and s_axi_aresetn ports to the
    corresponding pins on the AXI GPIO instance.

<p align="center">
  <img src="./images/gpio_bd.png?raw=true">
</p>
<p align="center">
Figure 56: Final gpio_rm2 block design
</p>

20. Under the Address Editor tab, assign addresses by using the Assign
    All Icon (<img src="./images/assign_all.png?raw=true">).

21. **Validate** then **save** the gpio_rm2 block design.

22. **Validate** then **save** the dfx_shdn_mgr block design.

Return to [Generate targets for the top block design](#Generate-targets-for-the-top-block-design) to continue the tutorial.
