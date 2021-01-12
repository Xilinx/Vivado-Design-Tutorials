# Introduction
This design uses 7 AXI Performance Traffic Generators, and 2 AXI NoC instances, each with a 2x32 LPDDR4-3930 memory controller, to model the DDR traffic requirements on VCK190.

# Load Design into Vivado
* Launch Vivado 2020.2 in this directory
* In Vivado Tcl Console:
```tcl
source ./vck190_4tg_lin_mc1_3tg_rnd_mc3.tcl
```

# Outputs:
* The resultant PDI is called Tutorials/NoC_DDRMC/Performance_Tuning/finished_design/design/myproj/project_1.runs/impl_1/design_1_wrapper.pdi

© Copyright 2019 – 2020 Xilinx, Inc. All rights reserved.

This file contains confidential and proprietary information of Xilinx, Inc. and is protected under U.S. and
international copyright and other intellectual property laws.

DISCLAIMER
This disclaimer is not a license and does not grant any rights to the materials distributed herewith.
Except as otherwise provided in a valid license issued to you by Xilinx, and to the maximum extent
permitted by applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR
STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether
in contract or tort, including negligence, or under any other theory of liability) for any loss or damage of
any kind or nature related to, arising under or in connection with these materials, including for any
direct, or any indirect, special, incidental, or consequential loss or damage (including loss of data,
profits, goodwill, or any type of loss or damage suffered as a result of any action brought by a third
party) even if such damage or loss was reasonably foreseeable or Xilinx had been advised of the
possibility of the same.

CRITICAL APPLICATIONS
Xilinx products are not designed or intended to be fail-safe, or for use in any application requiring fail-
safe performance, such as life-support or safety devices or systems, Class III medical devices, nuclear
facilities, applications related to the deployment of airbags, or any other applications that could lead to
death, personal injury, or severe property or environmental damage (individually and collectively,
"Critical Applications"). Customer assumes the sole risk and liability of any use of Xilinx products in
Critical Applications, subject only to applicable laws and regulations governing limitations on product
liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
