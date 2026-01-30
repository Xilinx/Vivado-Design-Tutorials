<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://raw.githubusercontent.com/Xilinx/Image-Collateral/main/xilinx-logo.png" width="30%"/><h1>AMD Vivado™ Design Suite Tutorials</h1>
    <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
    </td>
 </tr>
</table>

# Modular NoC DFX: Advanced
<b><i>Version: Vivado 2024.2</b></i><p>

# Introduction
Many NoC parameters (BW, traffic class, etc.) are defined on the connection or path between a NMU(s) and NSU(s). In DFX designs, the path is segmented between the static and dynamic regions. Path ownership defines where these parameters are defined, for example in the static or dynamic region. If the path ownership is in the static, no changes to the NoC path can be made in the dynamic region. If the path ownership is in the dynamic region, no changes to the NoC path can be made in the static region. This tutorial demonstrates the changes in the NoC compiler result between parent and child implementations depending on where the path ownership is defined. 

# Building The Design

This design has the following build options:
- all (executes builds sequentially)
- fast_compile (executes builds in parallel)
- synth_static
- synth_rm1
- impl_static_with_rm1
- create_shells
- synth_rm2
- impl_rm2_full_shell
- impl_rm2_abs_shell

To choose one, execute:
```bash
make <build option>
```

# Design Flow

1. Static Region Synthesis
2. Out of Context Synthesis of First Reconfigurable Module
3. Parent Implementation
4. Shell Creation
5. Out of Context Synthesis of Second Reconfigurable Module
6. Child Implementation 

# Hardware Validation

The following steps can be carried out: 

- Download full PDI from first implementation and ensure that it works in the hardware. This validates the functionality of static region with the first reconfigurable module. 
- Keep the peripherals in reset to disable the traffic impacting reconfigurable partition and download partial PDI from the child implementation. This validates that partial PDI from child implementation continues to work with the static region from parent implementation. 
<p>

<p class="sphinxhide" align="center"><sub>Copyright © 2024 Advanced Micro Devices, Inc.</sub></p>
<!-- # SPDX-License-Identifier: X11 -->  