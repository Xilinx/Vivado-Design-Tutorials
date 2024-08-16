<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ NoC/DDRMC Design Flow Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>


# Synthesis and Implementing the Design

***Version: Vivado 2024.1***

This tutorial outlines the utilization of IP Integrator to incorporate an AXI-NoC IP, granting access to an integrated DDRMC. 
The subsequent steps involve the addition and configuration of the Controls Interface and Processing system to link with the DDRMC via the NoC.
The target DDR4 memory bank on the VCK190 board file will be utilized. Lastly, the design will be implemented and the PDI uploaded onto the board.
The basic flow of the tutorial is as follows:
1. Start AMD Vivado™.
2. Create a new project.
3. Open a new block design.
4. Add an AXI_NoC IP to the block design.
5. Enable one Memory Controller with four ports, and specify its Address Regions.
6. Use board file to connect the NoC to DDR4 memory on the VCK190.
7. Validate the design.
8. Synthesize the design.
9. Implement the design.
10. Target VCK190 on Hardware Manager and program device.


# Description of the Design
This design uses a Control, Interface & Processing System connected directly to the NoC through an integrated DDR4 Memory Controller (MC) block. The CIPS is capable of reading and writing data through the NoC instance. This will show a simple way to get from design to implementation and to creating a PDI file using hardware manager to flash onto a VCK190.

**Note**: This design is provided as an example only. Figures and information depicted here might vary from the
current version.

# Create a Project
## Start Vivado
1. Open the Vivado GUI. Make sure the banner at the top of the window identifies the Vivado
2024.1 release.
2. From the Quick Start buttons, click **Create Project**.
3. Step through the pop-up menus to the **Default Part** menu.
4. On the Default Part pop-up menu, search for and select board **VCK190**.
5. Step through to the Finish stage to create the new project and open Vivado.


6. In the Vivado Flow Navigator, click **IP Integrator** → **Create Block Design**. A popup dialog
displays to create the block design
7. Click **OK**. An empty block design diagram canvas opens.


# NoC IP Configuration
The NoC IPs act as logical representations of the AMD Versal™ network on chip. The `axi_noc`
supports the AXI memory mapped protocol. Each instance specifies a set of connections to be
mapped onto the physical NoC, along with the QoS requirements for each connection. A given
HDL design may have any number of instances of the NoC IP. Vivado automatically aggregates
the connectivity and QoS information from all of the logical NoC instances to form a unified
traffic specification for the NoC compiler.

The integrated Memory Controllers (MCs) are integrated into the `axi_noc` core. An instance of
the `axi_noc` IP can be configured to include one, two, or four instances of the integrated MC. If
two or four instances of the MC are selected, they are configured to form a single interleaved
memory. In this case, the memory controllers are configured identically and mapped to the same
address. Interleaving is controlled by the NoC.

1. Add an instance of the Versal AXI NoC IP by right-clicking anywhere on the block design
canvas and selecting **Add IP** from the context menu.
2. Click **Run Block Automation** where you need to configure the NoC as shown. Then Click **OK**.
![image](https://github.com/HunterRDavis/Vivado-Design-Tutorials/blob/2023.1/Device_Architecture_Tutorials/Versal/NoC_DDRMC/Intro_Design_Flow/Module_05_Synthesis_and_Implementing_Design/images/Block_automation_NoC.png?raw=true)
3. Double-click the Axi NoC where the GUI will pop up. Select the **General** tab and change the DDR Address Region 1 to DDR CH1 and click **OK**.
4. Your Block Design should be looking similar to this:
![image](https://github.com/HunterRDavis/Vivado-Design-Tutorials/blob/2023.1/Device_Architecture_Tutorials/Versal/NoC_DDRMC/Intro_Design_Flow/Module_05_Synthesis_and_Implementing_Design/images/Block_Design_NoC.png?raw=true)
5. Select the Address Editor and click **Assign all**, then validate design.
6. When Validation is complete go to the Source tab, right-click on your design and **Create HDL Wrapper**.
7. After the wrapper has been generated, click **Run Implementation**. The Launch Runs menus should appear, click **OK**.
8. Click **OK** when implementation is complete to open the Implemented Design.
![image](https://github.com/HunterRDavis/Vivado-Design-Tutorials/blob/2023.1/Device_Architecture_Tutorials/Versal/NoC_DDRMC/Intro_Design_Flow/Module_05_Synthesis_and_Implementing_Design/images/Implmentation_Design.png?raw=true)

As you have now finished your design, you can open Device Viewer and see the CIPS block directly connected to the NoC. This simple setup avoids fabric resources by utilizing the hardened IP components.

Note: Because this tutorial uses the board flow, there is no need to generate a pinout. To create a pinout for custom boards follow the Memory Pinouts tutorial (https://github.com/Xilinx/Vivado-Design-Tutorials/tree/2023.2/Device_Architecture_Tutorials/Versal/PCB_Design/Memory_Pinouts), specifically steps 29 through 37. 

# Generate Device Image and Open Hardware Manager

In this section, you will generate a Device Image (PDI) and use the Hardware Manager for device programming. Transitioning from Vivado to the Hardware Manager GUI provides precise device targeting and programming capabilities. The Hardware Manager also offers essential insights, including device status, calibration, and properties, streamlining the programming process.
1. Click **Generate Device Image**. When the Launch Runs menu pops up, click **OK**.
2. After the PDI file is generated click **Open Hardware manager**. You will be directed out of Vivado and into a new GUI.
3. In the Hardware Manager GUI go to the green banner at the top, click **Open target** and then **Auto Connect**.
![image](https://github.com/HunterRDavis/Vivado-Design-Tutorials/blob/2023.1/Device_Architecture_Tutorials/Versal/NoC_DDRMC/Intro_Design_Flow/Module_05_Synthesis_and_Implementing_Design/images/Target_Device_HW_Mngr.png?raw=true)
You can see from the image above, the red highlighted area shows the device you're connected to and the status of whether the device is programmed or not.
4. Once connected to the device, click **Program device**. The Program Device menu will pop up. From here, select the PDI file that you generated and then click **Program**.
4. Once programmed, the Hardware Manager should show something similar to this:
![image](https://github.com/HunterRDavis/Vivado-Design-Tutorials/blob/2023.1/Device_Architecture_Tutorials/Versal/NoC_DDRMC/Intro_Design_Flow/Module_05_Synthesis_and_Implementing_Design/images/Programed_Device.png?raw=true)

# Design Conclusion

This tutorial provided a comprehensive walkthrough of FPGA system design using Vivado 2024.1, emphasizing the integration of an AXI-NoC IP for DDR4 memory access on the VCK190 board. From project initialization to programming the board, you learned the sequential steps of creating a block design, configuring IPs, validating the design, and implementing it onto the FPGA. This tutorial highlighted the significance of understanding hardware design workflows, IP integration, validation processes, and FPGA programming for engineers learning to use the NoC IP for memory contoller applications. 
# 
MIT License

Copyright (c) 2020-2024 Advanced Micro Devices, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice (including the next paragraph) shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sub>XD028</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>

