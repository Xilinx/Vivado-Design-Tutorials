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

© Copyright 2019 – 2021 Xilinx, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
