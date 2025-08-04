<table>
 <tr>
   <td align="center"><img src="https://d3cy9zhslanhfa.cloudfront.net/media/6D972F55-8581-42E9-B19004B4B9C6882E/3DD2D00D-F761-4236-83D03E37BE7F68B2/webimage-82094271-A5DD-425A-A6F4B96AEEECFDC5.jpg" width="30%"/><h1>2023.2 Versal™ Synthesis and Implementing the Design</h1>
   </td>
 </tr>
 <tr>
 <td align="center"><h1></h1>
 </td>
 </tr>
</table>

# Synthesis and Implementing the Design
This tutorial outlines the utilization of IP Integrator to incorporate an AXI-NoC IP, granting access to an integrated DDRMC. 
The subsequent steps involve the addition and configuration of the Controls Interface and Processing system to link with the DDRMC via the NoC.
The target DDR4 memory bank on the VCK190 board file will be utilized. Lastly, the design will be implemented and the PDI uploaded onto the board.
The basic flow of the tutorial is as follows:
1. Start Vivado®.
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
1. Open the Vivado® GUI. Make sure the banner at the top of the window identifies the Vivado
2023.2 release.
2. From the Quick Start buttons, click **Create Project**.
3. Step through the pop-up menus to the **Default Part** menu.
4. On the Default Part pop-up menu, search for and select board **VCK190**.
5. Step through to the Finish stage to create the new project and open **Vivado**.


6. In the Vivado Flow Navigator, click IP Integrator → Create Block Design. A popup dialog
displays to create the block design
7. Click OK. An empty block design diagram canvas opens.
The Tcl commands to create the project and initial block design are as follows:

# NoC IP Configuration
The NoC IPs act as logical representations of the Versal™ network on chip. The `axi_noc`
supports the AXI memory mapped protocol. Each instance specifies a set of connections to be
mapped onto the physical NoC, along with the QoS requirements for each connection. A given
HDL design may have any number of instances of the NoC IP. Vivado® automatically aggregates
the connectivity and QoS information from all of the logical NoC instances to form a unified
traffic specification for the NoC compiler.

The integrated Memory Controllers (MCs) are integrated into the `axi_noc` core. An instance of
the `axi_noc` IP can be configured to include one, two, or four instances of the integrated MC. If
two or four instances of the MC are selected, they are configured to form a single interleaved
memory. In this case, the memory controllers are configured identically and mapped to the same
address. Interleaving is controlled by the NoC.

1. Add an instance of the Versal™ AXI NoC IP by right-clicking anywhere on the block design
canvas and selecting **Add IP** from the context menu.
2. Click on the Run Block Automation where you need to configure the NoC as shown. Then Click **OK**.
![image](https://github.com/HunterRDavis/Vivado-Design-Tutorials/blob/2023.1/Device_Architecture_Tutorials/Versal/NoC_DDRMC/Intro_Design_Flow/Module_05_Synthesis_and_Implementing_Design/images/Block_automation_NoC.png?raw=true)
3. Double Click on the Axi NoC where the Gui will pop up. Click on the General tab and change the DDR Address Region 1 to DDR CH1 and hit OK.
4. Your Block Design should be looking similar to this:
![image](https://github.com/HunterRDavis/Vivado-Design-Tutorials/blob/2023.1/Device_Architecture_Tutorials/Versal/NoC_DDRMC/Intro_Design_Flow/Module_05_Synthesis_and_Implementing_Design/images/Block_Design_NoC.png?raw=true)
5. Click on Address Editor and hit **Assign all**, then validate design.
6. Once Validation is complete go to the source tab and right click on your design and Ceate HDL Wrapper.
7. After the wrapper had been generated hit **Run Implementation**. The Launch Runs menus should appear and hit **OK**.
8. Click **OK** when implementation is complete to open the Implemented Design.
![image](https://github.com/HunterRDavis/Vivado-Design-Tutorials/blob/2023.1/Device_Architecture_Tutorials/Versal/NoC_DDRMC/Intro_Design_Flow/Module_05_Synthesis_and_Implementing_Design/images/Implmentation_Design.png?raw=true)
Now since you finished your design you can open Device Viewer and see the CIPS block directly connected to the NoC. This simple setup avoids fabric resources by utilizing the hardened IP components.
# Generate Device Image and Open Hardware Manager

In this tutorial section, we'll generate a Device Image (PDI) and use the Hardware Manager for device programming. Transitioning from Vivado to the Hardware Manager GUI provides precise device targeting and programming capabilities. The Hardware Manager also offers essential insights, including device status, calibration, and properties, streamlining the programming process.
1. Click on **Generate Device Image**. Once the Launch Runs Menu pops up click **OK**.
2. After the PDI file is generated click on **Open Hardware manager**. You will be directed out of Vivado and into a new GUI.
3. In the Hardware Manager GUI go to the green banner at the top and click on **Open target** and hit Auto Connect.
![image](https://github.com/HunterRDavis/Vivado-Design-Tutorials/blob/2023.1/Device_Architecture_Tutorials/Versal/NoC_DDRMC/Intro_Design_Flow/Module_05_Synthesis_and_Implementing_Design/images/Target_Device_HW_Mngr.png?raw=true)
You can see from the image above, the red highlighted area shows the device you're connected to and the status of whether the device is programmed or not.
4. Once you're connected to your device click on **Program device**. The Program Device menu will pop up where you can choose the PDI file that you generated and then click **Program**.
4. Once programmed Hardware Manager should show something similar to this:
![image](https://github.com/HunterRDavis/Vivado-Design-Tutorials/blob/2023.1/Device_Architecture_Tutorials/Versal/NoC_DDRMC/Intro_Design_Flow/Module_05_Synthesis_and_Implementing_Design/images/Programed_Device.png?raw=true)

# Design Conclusion

This tutorial provided a comprehensive walkthrough of FPGA system design using Vivado 2023.2, emphasizing the integration of an AXI-NoC IP for DDR4 memory access on the VCK190 board. From project initialization to programming the board, users learned the sequential steps of creating a block design, configuring IPs, validating the design, and implementing it onto the FPGA. This tutorial highlighted the significance of understanding hardware design workflows, IP integration, validation processes, and FPGA programming for engineers learning to use the NoC IP for memory contoller applications. 
# 
MIT License

Copyright (c) 2020-2023 Advanced Micro Devices, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice (including the next paragraph) shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2023 Advanced Micro Devices, Inc</sub></p>
<p class="sphinxhide" align="center"><sub>XD028</sub></p>
<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>

