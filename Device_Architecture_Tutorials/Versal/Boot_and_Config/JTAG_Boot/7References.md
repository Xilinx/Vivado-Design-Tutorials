<tr>
  <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>2021.2 Versal JTAG Boot Tutorial</h1>
  </td>
</tr>
</table>

# Table of Contents

1. [Introduction](README.md)

2. [Before You Begin](2BeforeYouBegin.md)

3. [Quick-Start Instructions](3QuickStartInstructions.md)

4. [Building Hardware Design](4BuildingHardwareDesign.md)

5. [Debug Resources](5DebugResources.md)

6. [Custom Board Bring-up Resources](6CustomBoardBringupResources.md)

7. References

# References

|Reference|Description|
|  ---  |  ---  |
|VCK190 User Guide (UG1366)|(https://www.xilinx.com/content/dam/xilinx/support/documentation/boards_and_kits/vck190/ug1366-vck190-eval-bd.pdf)|Contains Versal evaluation board information.|
|Vivado Design Suite (UG910)|(https://www.xilinx.com/content/dam/xilinx/support/documentation/sw_manuals/xilinx2021_2/ug910-vivado-getting-started.pdf)|Contains Vivado software related information.|
|Vitis Unified Software Platform Documentation Embedded Software Development User guide [(UG1400)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_2/ug1400-vitis-embedded.pdf)|Contains Vitis software platform related information.|
|[Vitis Unified Software Platform](https://www.xilinx.com/html_docs/xilinx2021_2/vitis_doc/index.html)|Contains Vitis related information.|
|Versal ACAP Design Guide [(UG1273)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_2/ug1273-versal-acap-design.pdf)|Contains top level methodology guidelines for design flow including boot.|
|Versal ACAP Technical Reference Manual [(AM011)](https://www.xilinx.com/support/documentation/architecture-manuals/am011-versal-acap-trm.pdf)|Contains information on Versal ACAP hardware architecture overview and PMC and PS hardware block information.|
|Versal ACAP System Software Developers User Guide [(UG1304)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_2/ug1304-versal-acap-ssdg.pdf)|Contains information about  PMC and PS software development.|
|CIPs IP LogiCore Product Guide [(PG352)](https://www.xilinx.com/support/documentation/ip_documentation/versal_cips/v3_1/pg352-cips.pdf)|Contains configuration information on MIO and PMC/PS peripherals and controllers settings.|
|Binary Counter LogiCORE IP Product Guide [(PG121)](https://www.xilinx.com/support/documentation/ip_documentation/counter_binary/v12_0/pg121-c-counter-binary.pdf)| Contains binary counter LogiCORE IP details.|
|SmartConnect LogiCORE IP Product Guide [(PG247)](https://www.xilinx.com/support/documentation/ip_documentation/smartconnect/v1_0/pg247-smartconnect.pdf)|Contains SmartConnect LogiCORE IP details.|
|AXI GPIO LogiCORE IP Product Guide [(PG144)](https://www.xilinx.com/support/documentation/ip_documentation/axi_gpio/v2_0/pg144-axi-gpio.pdf)|Contains AXI GPIO LogiCORE IP details.|
|Processor System Reset Module LogiCORE IP Product Guide [(PG164)](https://www.xilinx.com/support/documentation/ip_documentation/proc_sys_reset/v5_0/pg164-proc-sys-reset.pdf)|Contains Processor System Reset LogiCORE IP details.|
|Vivado Design Suite Tcl Command Reference Guide [(UG835)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_2/ug835-vivado-tcl-commands.pdf)|Contains Vivado TCL commands.|
|Vivado Design Suite User Guide [(UG908)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_2/ug908-vivado-programming-debugging.pdf)|Contains the hardware manager JTAG programming information and debug tools.|
|Xilinx Power Estimator User Guide for Versal ACAP [(UG1275)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_2/ug1275-xilinx-power-estimator-versal.pdf)|Contains information on power estimation for Versal ACAP devices.|
|Embedded Design Tutorial [(UG1305)](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=ug1305-versal-acap-edt.pdf)|Tutorial that covers Versal boot using SD and QSPI.|
|Versal BootGen User Guide [(UG1283)](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_2/ug1283-bootgen-user-guide.pdf)|Contains information on the programmable device image (PDI) format and PDI generation.|
|Versal ACAP PCB User Guide [(UG863)](https://www.xilinx.com/support/documentation/user_guides/ug863-versal-pcb-design.pdf)|Contains custom board PCB layout information, covers boot mode interfaces dedicated to MIO pins.|
|Versal Schematic Checklist [(XTP546)](https://www.xilinx.com/cgi-bin/docs/rdoc?v=latest;d=xtp546-versal-acap-schchklst.pdf)|Contains custom board checklist information, covers boot mode interface dedicated and MIO pins.|
|Versal Register Reference [(AM012)](https://www.xilinx.com/html_docs/registers/am012/am012-versal-register-reference.html)|Contains Versal PS and PMC related register information.|
|Versal AI Core Series Data Sheet: DC and AC Switching Characteristics [(DS957)](https://www.xilinx.com/support/documentation/data_sheets/ds957-versal-ai-core.pdf)|Contains Versal DC and AC switching characteristics.|
|[Xilinx Board Store](https://github.com/Xilinx/XilinxBoardStore)|Contains resources for Xilinx, Avnet, and other example evaluation boards.|

## Go To Table of Contents:  
[README](README.md)

© Copyright 2020-2022 Xilinx, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
