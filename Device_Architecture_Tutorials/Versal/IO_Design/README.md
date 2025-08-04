<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Adaptive SoC Architecture Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# XPHY I/O Source Synchronous Interfaces in Versal Adaptive SoCs


## Summary

This tutorial describes how to construct source synchronous high-speed I/O interfaces using the Advanced I/O Wizard (AIOW) on Versal™ devices. The wizard instantiates and configures I/O and clocking logic such as XPHY nibbles and XPLL blocks that are included in the physical-side interface (PHY) architecture. The designs in this tutorial are tested on the VCK190 evaluation board using the FMC XM107 loopback card.


<hr style="height:2px;border-width:0;background-color:brown">

## Introduction

This tutorial covers two designs for a source-synchronous application using the AIOW:

  * Single-bank source synchronous design
  * Multi-bank source synchronous design

The AIOW provides the option to choose the number of banks, but not to exceed three banks. The wizard creates one bank instance for each bank. Both designs use low-voltage differential signaling (LVDS) for data transmission speeds at 1800 Mb/s. See the Versal AI Core Series Data
Sheet: DC and AC Switching Characteristics (<a href="https://www.xilinx.com/support/documentation/data_sheets/ds957-versal-ai-core.pdf">DS957</a>) for the speeds supported that can transmit
and receive the LVDS standard. The underlying I/O and XPLL clocking architecture for these designs can be found in the Versal Adaptive SoC SelectIO Resources Architecture Manual (<a href="https://www.xilinx.com/support/documentation/architecture-manuals/am010-versal-selectio.pdf">AM010</a>) and Versal Adaptive SoC Clocking Resources Architecture Manual (<a href="https://www.xilinx.com/support/documentation/architecture-manuals/am003-versal-clocking-resources.pdf">AM003</a>), respectively.


<hr style="height:2px;border-width:0;background-color:brown">

## Single-Bank Source Synchronous Design
<a href="./Single_bank_source_synchronous_design">...more</a>

## Multi-Bank Source Synchronous Design
<a href="./Multi_bank_source_synchronous_design">...more</a>

## References
These documents provide supplemental material useful with this tutorial:
 1. Versal Architecture and Product Data Sheet: Overview (<a href="https://www.xilinx.com/support/documentation/data_sheets/ds950-versal-overview.pdf">DS950</a>)
 2. Versal AI Core Series Data Sheet: DC and AC Switching Characteristics (<a href="https://www.xilinx.com/support/documentation/data_sheets/ds957-versal-ai-core.pdf">DS957</a>)
 3. Versal Adaptive SoC Clocking Resources Architecture Manual (<a href="https://www.xilinx.com/support/documentation/architecture-manuals/am010-versal-selectio.pdf">AM010</a>)
 4. Versal Adaptive SoC SelectIO Resources Architecture Manual (<a href="https://www.xilinx.com/support/documentation/architecture-manuals/am003-versal-clocking-resources.pdf">AM003</a>)
 5. Advanced I/O Wizard LogiCORE IP Product Guide (<a href="https://www.xilinx.com/support/documentation/ip_documentation/advanced_io_wizard/v1_0/pg320-advanced-io-wizard.pdf">PG320</a>)
 6. VCK190 Evaluation Board User Guide (<a href="https://www.xilinx.com/support/documentation/boards_and_kits/vck190/ug1366-vck190-eval-bd.pdf">UG1366</a>)


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
