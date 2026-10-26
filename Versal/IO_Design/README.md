<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ Adaptive SoC Architecture Tutorials</h1>
    <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
    </td>
 </tr>
</table>

# XPHY I/O Source Synchronous Interfaces in Versal Adaptive SoCs

## Summary

These tutorials describe how to construct source synchronous high-speed I/O interfaces using the Advanced I/O Wizard (AIOW) on Versal™ devices. The wizard instantiates and configures I/O and clocking logic such as XPHY nibbles and XPLL blocks that are included in the physical-side interface (PHY) architecture. The designs in this tutorial are tested on the VCK190 evaluation board using the FMC XM107 loopback card.

## Introduction

These tutorials cover designs for a source-synchronous application using the AIOW:

* Single-bank source synchronous design (tested on the VCK190 evaluation board using the FMC XM107 loopback card)
* Multi-bank source synchronous design (tested on the VCK190 evaluation board using the FMC XM107 loopback card)
* VP1902 bidirectional with bypassed FIFO and deskewing (tested on the VP1902)

The AIOW provides the option to choose the number of banks, but not to exceed three banks. The wizard creates one bank instance for each bank. Both designs use low-voltage differential signaling (LVDS) for data transmission speeds at 1800 Mb/s.

For the speeds supported that can transmit and receive the LVDS standard, see [AC Switching Characteristics](https://docs.amd.com/access/sources/dita/topic?url=ds957-versal-ai-core&resourceid=gzy1500674155441.html&ft:locale=en-US) and [DC Characteristics](https://docs.amd.com/access/sources/dita/topic?url=ds957-versal-ai-core&resourceid=try1518555215662.html&ft:locale=en-US) in the *Versal AI Core Series Data Sheet: DC and AC Switching Characteristics* ([DS957](https://docs.amd.com/go/en-US/ds957-versal-ai-core)).

The underlying I/O and XPLL clocking architecture for these designs can be found in the *Versal Adaptive SoC SelectIO Resources Architecture Manual* ([AM010](https://docs.amd.com/go/en-US/am010-versal-selectio)) and *Versal Adaptive SoC Clocking Resources Architecture Manual* ([AM003](https://docs.amd.com/go/en-US/am003-versal-clocking-resources)), respectively.

## Single-Bank Source Synchronous Design

[...more](./Single_bank_source_synchronous_design)

## Multi-Bank Source Synchronous Design

[...more](./Multi_bank_source_synchronous_design)

## VP1902 Bidirectional with Bypassed FIFO and Deskewing

[...more](./VP1902_bidirectional_with_bypassed_fifo_and_deskewing)

## References

These documents provide supplemental material useful with this tutorial:

1. *Versal Architecture and Product Data Sheet: Overview* ([DS950](https://docs.amd.com/go/en-US/ds950-versal-overview))
2. *Versal AI Core Series Data Sheet: DC and AC Switching Characteristics* ([DS957](https://docs.amd.com/go/en-US/ds957-versal-ai-core))
3. *Versal Adaptive SoC Clocking Resources Architecture Manual* ([AM003](https://docs.amd.com/go/en-US/am003-versal-clocking-resources))
4. *Versal Adaptive SoC SelectIO Resources Architecture Manual* ([AM010](https://docs.amd.com/go/en-US/am010-versal-selectio))
5. *Advanced IO Wizard LogiCORE IP Product Guide* ([PG320](https://docs.amd.com/access/sources/dita/map?Doc_Version=1.0%20English&url=pg320-advanced-io-wizard))
6. *VCK190 Evaluation Board User Guide* ([UG1366](https://docs.amd.com/go/en-US/ug1366-vck190-eval-bd))


<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2025 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
