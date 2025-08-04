<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ NoC/DDRMC Design Flow Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# Introduction to Versal NoC/DDRMC

***Version: Vivado 2021.1***



The Xilinx® Versal™ programmable network on chip (NoC) is an AXI-interconnecting network used for sharing data between IP endpoints in the programmable logic (PL), the processing system (PS), and other hard blocks.
Each Versal™ device provides dedicated, hardware constructed, DDR memory controllers. These are not part of the NoC architecture, but are supported by the NoC structure. The DDR memory controller interface contains four dedicated NSU controllers. The DDR controllers are implemented using the NoC IP Wizard. To make optimal use of the available NoC features, the NoC structure provides support for interleaving across multiple physical DDR controllers (two or four).

---

## Description of the Design

This example connects many different DDR devices simultaneously in one design to communicate to PS through NoC. It connects one DDR4 device and two interleaved LPDDR4 devices, which requires one NoC instance to configure the DDRMC for the DDR4 device and another NoC instance to configure the two interleaved DDRMCs for the two LPDDR4 devices.

Following this tutorial, brings the following awareness:
- The required IPs to achieve such a design.
- How to configure NoC and DDRMC.
- How it's mandatory to instantiate a different NoC IP for each DDRMC (none interleaved controllers).
- The possibility to interleave multiple "similar" DDR devices (2 or 4 devices) and how to use only one NoC instance for that case.
- How to connect multiple NoC instances through Inter-NoC Interfaces.
- How to create a Vitis Project based on that design and to test a simple code that access all of these memory devices.

---

## Required Hardware

- Platform: Versal

- Board: VCK190 (same steps applied for VMK180)

- Tools: Vivado and Vitis 2021.1

---

## Block Diagram

![block_diagram](./Screenshots/block_diagram.png)

---

## Build Instructions - From GitHub

## ## Vivado

Enter the `Scripts` directory. From the command line run the following:

`vivado -source multiple_mc_design_bd.tcl`

The Vivado project will be built in the `Hardware` directory.

## Vitis
Create a HelloWorld project using the XSA file generated from the above Vivado project.
Replace the content of the helloworld.c with the content of ./Software/ddr4_lpddr4.c from this repo.

---

## Build Instructions - Manual Steps

### Vivado

  - Create a new Vivado project for VCK190.
  - Create a new Block Design:

  ![new_block_design](./Screenshots/new_block_design.png)

  ![new_block_design2](./Screenshots/new_block_design2.png)

  - Add CIPS IP:

  ![add_cips](./Screenshots/add_cips.png)

  - Run Block Automation:

    ![run_block_automation](./Screenshots/run_block_automation.png)
    - Set Design Flow as Full System.
    - Make sure to set Apply Board Preset to Yes.
    - Enable 1 Memory Controller, with type set to DDR and Number to 1 (this will be used to connect the DDR4 device on the board):

    ![run_block_automation2](./Screenshots/run_block_automation2.png)

    - This instantiates an AXI NoC IP and connect it to CIPS automatically:

    ![run_block_automation3](./Screenshots/run_block_automation3.png)

  - Double click on the AXI NoC instance to make further configurations:

    - On the General tab:
      - Enable 4 Inter-NoC Master Interfaces. These interfaces are needed to connect to the second AXI NoC instance that will be added later.
      - The Number of Memory Controller Ports is set to 4 for a maximum possible bandwidth.
      - Make sure that the first DDR region is mapped to DDR LOW0 (to access the first 2G of the DDR4).
      - Make sure that the second region is mapped to DDR LOW1 to be able to access the rest of the DDR4 device memory.

      ![noc_general](./Screenshots/noc_general.png)

    - On the Connectivity tab, apply the following settings:

    ![noc_connectivity](./Screenshots/noc_connectivity.png)

  - Add a new AXI NoC instance. This will be used to connect to the LPDDR4:

    ![noc2](./Screenshots/noc2.png)
  
    - For this case we don't need to Run Block Automation.

  - Double click on the new AXI NoC to do further configuration:

    - On the Board tab, connect the LPDDR4 IP interfaces to the board interfaces:

    ![noc2_board](./Screenshots/noc2_board.png)

    - On the General tab:
    
      - Set the number of AXI Slaves/Masters and Clocks to 0.
      - Enable 4 Inter-NoC Slave Interfaces. These interfaces are needed to connect to the first AXI NoC instance that we have added before.
      - Set the Number of Memory Controller Ports to 4 for a maximum possible bandwidth.
      - Set Interleave Size in Bytes to 256 at least, to match the NoC packet size.
      - Map the address region to a region different that the one we used to access the DDR4. In this example we choose the DDR CH1.

      ![noc2_general](./Screenshots/noc2_general.png)

    - On the Connectivity tab, apply the following settings:
    
    ![noc2_connectivity](./Screenshots/noc2_connectivity.png)

  - Run Connection Automation:

  ![run_2_connection_automation](./Screenshots/run_2_connection_automation.png)

  - Check All Automation:

  ![run_2_connection_automation2](./Screenshots/run_2_connection_automation2.png)


  - Connect both AXI NoC instances through the 4 INI interfaces:

  ![ini_connections](./Screenshots/ini_connections.png)

  - Regenerate Layout to get a BD layout similar to the one shown in the Block Diagram section:

  ![regenarate_layout](./Screenshots/regenarate_layout.png)

  - From Address Editor tab, Click on Assign All:

  ![address_editor_assign_all](./Screenshots/address_editor_assign_all.png)


  - Validate Design:

    ![validate_design](./Screenshots/validate_design.png)

    - You will get the following pop-up window if the design is valid:

    ![validation_successful](./Screenshots/validation_successful.png)

  - Create HDL Wrapper:

  ![hdl_wrapper](./Screenshots/hdl_wrapper.png)

  - Generate Output Products:

  ![generate_output_product](./Screenshots/generate_output_product.png)

  - Run Synthesis, Implementation and Generate Device Image:

  ![syn_imp_gen](./Screenshots/syn_imp_gen.png)

  - Export Hardware:

    ![export_hardware](./Screenshots/export_hardware.png)

    - Make sure to include the device image:

    ![export_hardware2](./Screenshots/export_hardware2.png)

    This generates the .XSA file to be used later with Vitis to create an application project.

### Vitis

  - Open Vitis and create an application project:

    ![application_project](./Screenshots/application_project.png)

    - Click Next.
    
    - From the following window select the "Create a new platform from hardware (XSA)" tab, then select the XSA file created previously:

    ![application_project2](./Screenshots/application_project2.png)

    - Click Next.

    - Name your project, in this example, we named it ddr4_lpddr4_access:

    ![application_project3](./Screenshots/application_project3.png)

    - Click Next, and keep the default settings for that window.

    - Chose Hello World template and click Finish:

    ![application_project4](./Screenshots/application_project4.png)

  - Open helloworld.c and replace its content with the content of ./Software/ddr4_lpddr4.c:

	![app_code](./Screenshots/app_code.png)

  - Click on the application project, then click on the build icon to build the project:

    ![build_app](./Screenshots/build_app.png)

  - Right click on the application project and open the Debug Configuration window:

    ![debug_app](./Screenshots/debug_app.png)

    - Double click on the "Single Application Debug" to create a new configuration:

    ![debug_app2](./Screenshots/debug_app2.png)

    - On the new debug configuration, do the following:

      - On the Main tab, make sure to set the right target on "Connection" where you have hw_server running:

      ![debug_app3](./Screenshots/debug_app3.png)

      - Uncheck "Stop at 'main'" option as we are not interested to stop at main:

      ![debug_app4](./Screenshots/debug_app4.png)

      - Click Debug, to run the application on your VCK190.

  - By running the application, we will get the following UART output, showing the reads and the writes to DDR4 then to LPDDR4:

  ![uart_output](./Screenshots/uart_output.png)
 
  - You could also try to access the DDR4 and LPDDR4 address ranges using XSCT:

  ![xsct](./Screenshots/xsct.png)

---
## Troubleshooting / Assistance**

If you find you are having difficulty bringing up one of the designs, or need some additional assistance, please reach out on the [Xilinx Community Forums](https://forums.xilinx.com).

Be sure to [search](https://forums.xilinx.com/t5/forums/searchpage/tab/message?advanced=false&allow_punctuation=false&inactive=false) the forums first before posting, as someone may already have the solution!


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
