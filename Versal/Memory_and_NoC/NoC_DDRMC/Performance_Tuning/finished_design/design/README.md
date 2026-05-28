<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ NoC/DDRMC Design Flow Tutorials</h1>
    <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
    </td>
 </tr>
</table>

# Introduction
This design uses 7 AXI Performance Traffic Generators, and 2 AXI NoC instances, each with a 2x32 LPDDR4-3930 memory controller, to model the DDR traffic requirements on VCK190.

# Load Design into Vivado
* Launch Vivado 2024.1 in this directory
* In Vivado Tcl Console:
```tcl
source ./vck190_4tg_lin_mc1_3tg_rnd_mc3.tcl
```

# Outputs:
* The resultant PDI is called Tutorials/NoC_DDRMC/Performance_Tuning/finished_design/design/myproj/project_1.runs/impl_1/design_1_wrapper.pdi



<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>

