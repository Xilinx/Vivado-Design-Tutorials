<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Adaptive SoC High Speed Serial Tutorials</h1>
    <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
    </td>
 </tr>
</table>

# Aurora GT Migration Tutorial

***Version: AMD Vivado 2024.2***

## Introduction

The new Versal Adaptive SoC Transceivers Wizard Subsystem IP is now the default tool for instantiating, configuring and connecting the multiple types of high-speed serial transceivers found in Versal Adaptive SoCs. With native support for both Vivado IP Integrator (IPI) and RTL design flows, the Transceivers Wizard Subsystem IP offers a wide range of features that facilitate sharing GTY, GTYP or GTM transceiver quads between multiple interfacing IP or incorporating multiple transceiver quads into a single IP interface.

While the existing IPI-based Versal Adaptive SoC Transceivers Wizard will always continue to be supported, users looking to leverage the new features or transition to an RTL-centric flow are encouraged to migrate their IP connections to the Versal Adaptive SoC Transceivers Wizard Subsystem.

This document aims to explain the components and IP involved, provide a general tutorial for migrating to the new IP, and serve as a resource for migrating either AMD or custom IP into the new flow.

## Versal Adaptive SoC Transceivers Wizard Flow Comparison: IPI vs. IPI and RTL

The Versal Adaptive SoCs Transceivers Wizard Subsystem IP is the successor to the Versal Adaptive SoCs Transceivers Wizard IP. From a functional perspective, the Subsystem IP is not solely an instantiation of the GT*_QUAD primitive, but also a wrapper surrounding the GT*_QUAD primitive in addition to clock and reset architecture that was previously external to the IP.

## IP Naming Distinctions

The Versal Adaptive SoCs Transceivers Wizard and the Versal Adaptive SoCs Transceivers Wizard Subsystem are two distinct IPs available in the Vivado IP Catalog. The basic details of each IP are as follows:

**Versal Adaptive SoCs Transceivers Wizard (gt_quad_base), 2024.1 and earlier** - The Versal Adaptive SoC Transceivers Wizard provides a simple and robust method for configuring one serial transceiver quad in Versal devices.

**Versal Adaptive SoCs Transceivers Wizard Subsystem (gtwiz_veral), 2024.2 and later** - The Versal Adaptive SoC Transceivers Wizard Subsystem provides a method for configuring one or multiple serial transceivers for one or multiple protocol interfaces. You can customize configurations on a per-interface basis, either manually within the Subsystem, by importing parameter files, or by sourcing directly from AMD IP.

You can use it in both IPI and standalone RTL flows to generate a customized core with RTL source files that incorporate resets and, optionally, the necessary clocks. It also produces an example design for basic simulation and hardware usage demonstrations.

## Customization Interface for the prior Transceivers Wizard (2024.1 and earlier)

Selecting the Versal Adaptive SoCs Transceivers Wizard IP from the IP catalog opens the IP Customization interface. The Versal Adaptive SoCs Transceivers Wizard shows the default customization interface.

![GT Quad Base](images/gt_quad_base_1p1.png)

The gt_quad_base customization interface shows four important selections of information. The register interface and transceiver type parameters are set at the top of the configuration wizard, as shown below:

![Register and GT Type](images/reg_type.png)

The **protocol configuration** settings contain information on each protocol connected to the gt_quad_base. Multiple protocols can connect to the same gt_quad_base, with each protocol mapped to different RX and TX ports of the GT. Each protocol has a separate selection of configuration options. The following figure displays the GT protocol interface:

![Protocol Configuration](images/protocol_config.png)

Selecting the **Transceiver Configs Protocol** under each protocol opens the Transceiver Configuration Protocol interface, where you can adjust protocol-specific settings such as encoding, data rates and widths, clocking, and PLL types. The following figure shows the Transceiver Configuration Protocol interface.

![Transceiver Configuration](images/transceiver_config.png)

## Customization Interface for the New Transceivers Subsystem Wizard (2024.2 and later)

Selecting the Versal Adaptive SoCs Transceivers Wizard Subsystem IP from the IP catalog opens the IP customization interface. The default interface for the Versal Adaptive SoCs Transceivers Wizard Subsystem is shown in the following figure:

![GT Wizard](images/gtwiz_versal.png)

The IP Customization menu for the Versal Adaptive SoCs Transceivers Wizard Subsystem allows the user to customize the IP similar to the prior Versal Adaptive SoCs Transceivers Wizard. However, several elements are relocated or updated with new options.

The new wizard retains all functionality from the previous version while introducing additional interfaces, settings, and implementation methods made possible by enhanced Subsystem IP capabilities.

The following section provides a description of each new configuration panel.

## Wrapper Configuration Settings

The Wrapper Configuration menu is the default view when accessing the IP Customization interface. This menu was shown in the preceding section. It allows users to configure several key settings, as described below:

**Transceiver Type**: Select from supported types such as GTYP, GTM, etc.  
**Number of Interfaces**: Defines the number of GT compatible parent IPs connected to the GT*_QUAD instantiation. Supports up to 8 different or duplicate protocols. You can map each protocol to different RX/TX ports of the GT*_QUAD primitive.
**Number of Quad Interfaces**: The Versal Adaptive SoCs Transceivers Wizard Subsystem supports the instantiation of several GT*_QUAD primitives within a single wrapper.

>Note:  Prior to 2024.2, the tool allowed only one GT*_QUAD primitive per wrapper.

**Register Access**: Enable register access for the GT*_QUAD using either AXI-Lite or APB3. The IP generates the APB3 clock architecture internally, and it runs at a default frequency of 200 MHz.
**Interface Configuration**: This section, previously called Protocol Configuration Settings in the prior wizard, lists each protocol connected to the GT_QUAD along with its configuration. Make sure the settings of the external parent IP match those of the GT_QUAD interface to ensure proper functionality.

You can open the Transceiver Configuration interface to adjust or preset the settings so they match the parent IP. This interface operates the same manner in both the prior Versal Adaptive SoCs Transceivers Wizard IP and the new Versal Adaptive SoCs Transceivers Wizard Subsystem IP.

## Interface Configuration Settings

The Interface Configuration settings allow you to set and configure the transceiver configuration for both receive and transmit. Users can select up to eight different interfaces, each of which can map to an RX or TX port of the transceiver. To add additional interfaces to the Versal Adaptive SoCs Transceivers Wizard Subsystem, enter the desired number in the Number of Interfaces section, as illustrated below:

![GT Wizard Interfaces](images/gtwiz_versal_interfaces.png)

The **GT Direction** option lets you specify the configuration as Duplex, Simplex RX, or Simplex TX.

The **Number of Lanes** setting defines how many lanes connect the transmit or receive transceiver ports. Ensure that the selections for **GT Direction** and **Number of Lanes** align with the **Quad Interface Mapping** section of the IP instantiation.

Selecting the **Transceiver Configs Interface** button opens a panel where you can configure the transmit and receive settings (as shown above). A single interface instantiation can support multiple configurations, enabling the design to switch dynamically between them (for example, the rate change feature). You can also apply a preset to automatically assign standard settings for a specific protocol. Alternatively, you can import configuration settings using the **Import Settings Interface**, as described below:

![GT Wizard Import](images/gtwiz_versal_import.png)

When selecting the **Import Settings Interface**, a new menu appears allowing users to choose either an AMD Peer-IP in the project or a protocol configuration file. Vivado automatically scans AMD Peer-IP files added to the project and adds them to the list of available import options under Peer-IP. The File selection option enables importing a protocol configuration file for easy integration of third-party IP configurations into the GT*_QUAD.

The following figure shows the Import Interface Settings menu.

![GT Wizard Import](images/gtwiz_versal_import_settings.png)

Vivado 2024.1 supports only the PRBS checker transceiver Peer IP (e.g., the QDMA IP for PCIe). Future versions will expand support to include more AMD Peer-IPs. Vivado 2024.2 now supports nearly all AMD parent IPs for import. The guidelines recommend using the **Import Interface Settings** when working with supported AMD Peer-IP.

## Quad Interface Mapping Settings

The Quad Interface Mapping settings allow you to specifically map each interface to the transmit and receive lanes of the transceiver.

You can also assign the transmit and receive master clocks, as seen from the Versal Adaptive SoCs Transceivers Wizard Subsystem, to specific ports. The following figure illustrates the Quad Interface Mapping settings:

![Quad Interface Mapping](images/quad_interface_mapping.png)

Lane selection of an interface must match the set description in the **Wrapper Configuration** settings.

## Structural Options

If you are familiar with the previous Versal Adaptive SoCs Transceivers Wizard IP, you will notice that the new Versal Adaptive SoCs Transceivers Wizard Subsystem IP includes fewer available I/O ports when instantiated. It disables many IP ports unless you explicitly enable them using the Structural Options settings. You can also choose whether to include clocking buffers within the IP core. The recommended customization is to leave the clocking buffers inside the IP to simplify the design. Additionally, the new version includes dedicated input ports for reset architecture.

Refer to the <a href="https://docs.amd.com/r/en-US/pg442-gtwiz-versal">Versal Adaptive SoCs Transceivers Wizard Subsystem Product Guide (PG442)</a> for recommendations on using external clocking buffers. The following figure shows the Structural Options interface:

![Structural Options](images/structural_options.png)

## IP Instantiation in IPI Flow

To open the IP catalog for block designs, click on the block design canvas and press Ctrl+I, or right-click the plus icon in the block design window. Use the search box to find the IP by typing **gtwiz_versal**. Select **Versal Adaptive SoCs Transceivers Wizard Subsystem** to add the IP to your design. The following images show the IP catalog and the block for the design interface:

![Create Block Design](images/create_block_design.png)
![IP Select](images/ip_select.png)

![Block Design with Wizard](images/bd_wizard.png)

Double-click the Versal Adaptive SoCs Transceivers Wizard Subsystem block (gtwiz_versal_0) on the canvas to open the IP Customization interface.

![GT Wizard](images/gtwiz_versal.png)

## IP Instantiation in RTL Flow

To instantiate the IP in RTL-focused designs, open the **IP Catalog** from the Project Manager section in the Flow Navigator. In the search box, type "gtwiz_versal" to locate the Versal Adaptive SoCs Transceivers Wizard Subsystem. When prompted, select "Customize IP". Once configured, the IP appears in the Sources panel.

![IP Catalog](images/ip_catalog.png)

![GTWIZ_Versal RTL](images/gtwiz_versal_rtl.png)

![Customize IP](images/customize_ip.png)

![RTL Sources](images/rtl_sources.png)

## Migration Example:  Aurora 64b66B Example Design

This migration tutorial uses the Vivado 2024.1 example design of the Aurora 64B66B IP interconnection to the to the Versal Adaptive SoCs Transceivers Wizard. It demonstrates how to configure and connect the new Versal Adaptive SoCs Transceivers Wizard Subsystem IP in Vivado 2024.2 to replace the older Wizard IP from 2024.1. This specific example is built using one duplex channel between the Aurora IP and the Transceiver Wizard. You can refer to the following link for instructions on creating the 2024.1 example design: <a href="https://github.com/Xilinx/Vivado-Design-Tutorials/tree/2024.2/Versal/GT_Design/Aurora_Overview">Aurora 64B/66B LogiCore IP Example Design Tutorial</a>. The following block diagram shows the example design from 2024.1:

![2024.1 Example](images/2024_1_example_design.png)

When you first open the design in 2024.2, a window appears indicating that it will upgrade the design to the Advanced Implementation Flow. Click ***Upgrade**.

![Upgrade Advanced](images/upgrade_advanced.png)

After a few moments, the tool displays another window indicating that the AMD IP might need to be upgraded. Click **Report IP Status**.

![Upgrade IP](images/upgrade_ip.png)

A window appears stating that IP in the design has been extensively updated. Click **OK**.

![Upgrade Major](images/upgrade_major.png)

At the bottom of the window, the IP Status tab shows the IP blocks with major upgrades in 2024.2. The Aurora IP and Versal Adaptive SoC GT Transceiver Wizard appear among them. The tool preselects all IP blocks that require upgrading. Click **Upgrade Selected**.

![IP Status](images/ip_status.png)

Click **OK** on the subsequent window:

![IP Status OK](images/upgrade_ip_yes.png)

After a few moments, the tool displays a window related to output product generation. Click **Generate**.

![Generate Output Products](images/generate_output_products.png)

While the tool processes the design, it displays a window indicating that the process has started. Click **OK**.

![Generate Output Products OK](images/generate_ok.png)

If a window appears with "Critical Message", click **OK**. The tools address this automatically.

![Critical Message](images/critical_message.png)

Once the tool generates the output products, the Block Design might still appear unchanged. To complete the upgrade, you need to open and re-customize the Aurora IP block.

## Upgrading Aurora IP

Double-click on the **aurora_64b66b_0** block in the block design window.

![Aurora IP](images/aurora_ip.png)

In the **Re-customize IP** window, select **GT Wizard Subsystem** as the GT Wizard Implementation and click **OK**.

![Wizard Implementation](images/wizard_implementation.png)

In the block design, two new reset ports appear in the **aurora_64b66b_0** block:

![Aurora Reset Done](images/aurora_reset_done.png)

## Adding new GT Wizard Subsystem

You cannot upgrade the old gt_quad_base directly to the new subsystem. Instead, add the new GT Wizard Subsystem to the design. Then, delete the old gt_quad_base and connect the new subsystem.

To add the new GT Wizard Subsystem, right-click in an open area of the block design and choose **Add IP...**

![Add IP](images/add_ip.png)

Type **gt wiz** in the search bar, and double-click on **Versal Adaptive SoC Transceivers Wizard Subsystem**.

![GT WIZ](images/gt_wiz.png)

After a few moments, the new GT Wizard appears:

![New GT Wizard](images/new_gtwiz.png)

Configure the new GT Wizard Subsystem to match the settings of the Aurora parent IP.

Double-click the new GT Wizard block (**gtwiz_versal_0**). The **Re-Customize IP** window opens. Apply the following settings, which are specific to this Aurora example design:

- Transceiver Type: GTY
- Number of Interfaces:  1
- Number of Quad Instances:  1

Under "Interface Configuration/Interface 0":

- GT Direction:  Duplex
- Number of Lanes:  1

![Wrapper Configuration](images/wrapper_config.png)

To import the Aurora interface settings click **Import Settings Interface 0**, select the **aurora_64b66b_0...** Peer-IP, and click **OK**.

>Note: The tool provides no visual feedback after clicking OK.

![Import Settings](images/import_settings.png)

Update the Quad interface mapping to match the number of lanes.

Select **Quad Interface Mapping** and configure the settings as shown below.

![Quad Interface](images/quad_interface.png)

There is an option to include BUFGT clock buffers inside the GT Wizard Subsystem to avoid explicit instantiation at the block level, as required with the old gt_quad_base.

To include the buffers, click **Structural Options** and configure as shown below:

![New Structural Options](images/new_structural_options.png)

Click **OK** to finish customization.

After a few moments, the new wizard appears in the block design.

![Updated Wizard](images/updated_wizard.png)

## Editing Block Design to Connect New Wizard

Remove the old gt_quad_base, and connect the new wizard to the parent IP.

Right-click the **gt_quad_base** cell and select **Delete**.

![Delete GT Quad Base](images/delete_gt_quad_base.png)

Also delete the two BUFG_GT blocks, as the new wizard IP already includes them (based on the Structural Options step).

![Delete BUFG_GT](images/delete_bufg_gt.png)

Now, the block design should show only the Aurora parent IP, new GT Wizard, reference clock buffer, MMCM, and CIPS blocks.

![After Deletes](images/bd_after_deletes.png)

Click the **Regenerate Layout** button to compress the block design layout for better readability.

![Regenerate Layout](images/regen_layout.png)

After regeneration, the block design should appear similar to the following:

![After Regenerate](images/after_regen.png)

To simplify the next manual changes, rearrange the block diagram as shown. (Make note of the position of the GT_Serial pin.)

![Rearrange BD](images/rearange_bd.png)

Connect the following ports as follows:

- GT_Serial pin to "Quad0_GT_Serial" port:

![GT Serial](images/GT_Serial.png)

- "TX_LANE0" (aurora_64b66b0) to "INF0_TX0_GT_IP_Interface" (gtwiz_versal_0)
- "RX_LANE0" (aurora_64b66b0) to "INF0_RX0_GT_IP_Interface" (gtwiz_versal_0)

![TX RX Lane](images/tx_rx_lane.png)

- "gtpowergood" (gtwiz_versal_0) to "gt_powergood_in" (aurora_64b66b_0)

![GT Power Good](images/gt_powergood.png)

- "INTF0_rst_all_in" (gtwiz_versal_0) to "pma_init" (aurora_64b66b_0) to "pma_init" pin

![PMA_INIT](images/pma_init.png)

- "gtwiz_freerun_clk" (gtwiz_versal_0) to "clk_out1" (clk_wizard_1)

![GT Wiz Freerun](images/gtwiz_freerun.png)

- "INTF0_rst_rx_datapath_in" (gtwiz_versal_0) to "link_reset_out" (aurora_64b66b_0) to "link_reset_out" pin

![Link Reset](images/link_reset.png)

<hr size =2>

- "INTF0_RX_usrclk" (versal_gtwiz_0) to "rxusrclk_in" (aurora_64b66b_0)
- "INTF0_TX_usrclk" (versal_gtwiz_0) to "user_clk" (aurora_64b66b0_0) to "usrclk_out" pin

![User Clocks](images/user_clock.png)

- "INTF0_rst_tx_done_out" (versal_gtwiz_0) to "tx_reset_done" (aurora_64b66b0_0)
- "INTF0_rst_rx_done_out" (versal_gtwiz_0) to "rx_reset_done" (aurora_64b66b0_0)

![TX RX Reset](images/tx_rx_reset.png)

- "QUAD0_GTREFCLK0" (versal_gtwiz_0) to "IBUF_OUT[0:0]" (util_ds_buf)

![Quad REF Clock](images/quad_refclk.png)

Click **Regenerate Layout** again to consolidate the Block Design. The updated Block Design should now look similar to the following:

![Final Block Design](images/final_bd.png)

Click **Validate Design**, then click **Save**.

![Validate Save](images/validate_save.png)

Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
SPDX-License-Identifier: X11

<p align="center"><sup>XD321 | Copyright&copy; 2025 AMD, Inc.</sup></p>