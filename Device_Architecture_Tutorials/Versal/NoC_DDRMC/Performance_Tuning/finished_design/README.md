<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ NoC/DDRMC Design Flow Tutorials</h1>
    <a href="https://www.xilinx.com/products/design-tools/vivado.html">See Vivado™ Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# Performance Tuning: Building and Running the Final Design

***Version: Vivado 2024.1***

## Introduction
This design uses seven AXI Performance Traffic Generators, and two AXI NoC instances, each with a 2x32 LPDDR4-3930 memory controller, to model the DDR traffic requirements on VCK190.

## DDR Traffic Model
One LPDDR4 memory controller handles all the random access memory traffic.  One traffic generator writes to random memory addresses at 2.77 GB/s.  Concurrently, three other traffic generators send read requests to random addresses in three subblocks of same address space to which 2.27GB/s writes are occurring, each at 2.8 GB/s.

In parallel, a second LPDDR4 memory controller handles eight simultaneous linear traffic threads, four writes and four reads, each accessing a unique bank in memory.  All of these threads are running at 2.77 GB/s.

The DDR Traffic Model is summarized below:

| DDR Operation  | Burst Length | Access Pattern | Throughput (GB/s) |
| -------------- | ------------ | -------------- | ----------------- |
| Linear Write 1 | 256          | Sequential     | 2.77              |
| Linear Write 2 | 256          | Sequential     | 2.77              |
| Linear Write 3 | 256          | Sequential     | 2.77              |
| Linear Write 4 | 245          | Sequential     | 2.77              |
| Linear Read 1  | 256          | Sequential     | 2.77              |
| Linear Read 2  | 256          | Sequential     | 2.77              |
| Linear Read 3  | 256          | Sequential     | 2.77              |
| Linear Read 4  | 256          | Sequential     | 2.77              |
| Random Write   | 128          | Random         | 2.27              |
| Random Read 1  | 128          | Random         | 2.8               |
| Random Read 2  | 128          | Random         | 2.8               |
| Random Read 3  | 128          | Random         | 2.8               |
## Build the Design
* cd into design directory
* Follow the instructions in the README in that directory to build the design

The complete design appears as follows:
![Block Design](images/final_block_design.PNG)
The linear traffic generators and NoC instance are highlighted in red.  The random traffic generators and NoC instance are highlighted in blue.  The other blocks are necessary for clock generation and controlling the traffic generators.

## Load Design into Versal
* Launch Vivado
* Open Hardware Manager
* Open New Target to connect to the VCK190
* Tools -> Program device
  * PDI: Tutorials/NoC_DDRMC/Performance_Tuning/finished_design/design/myproj/project_1.runs/impl_1/design_1_wrapper.pdi
  * LTX: Tutorials/NoC_DDRMC/Performance_Tuning/finished_design/design/myproj/project_1.runs/impl_1/design_1_wrapper.ltx
* Hardware Manager should show that DDRMC calibration passed

## Launch Traffic Generators and Performance Counters
* In Vivado Tcl Console:
```tcl
cd ./scripts
source ./total_flow_7tg_inf.tcl
```
This script accomplishes the following:
1. Reads the traffic patterns descriptions in scripts/4TG_LIN_MC1_3TG_RND_MC3_M*.csv
2. Converts them to .mem format
3. Loads the patterns into BRAM
4. Sets up performance counters in the traffic generators
5. Launches the traffic pattern
6. Reads the results from the performance counters
7. Writes the results to RESULT.csv

More information about the traffic generators can be found in the *Performance AXI Traffic Generator Product Guide* (PG381).
## Outputs:
* Results will be captured in ./scripts/RESULT.csv, a sample of which is shown below:
![Sample Results](images/sample_results.PNG)
* Random write BW (GB/s) is in cell F6
* Random read 1 BW (GB/s) is in cell E6
* Random read 2 BW (GB/s) is in cell E7
* Random read 3 BW (GB/s) is in cell E8
* Linear write BW (GB/s) is in cells F2, F3, F4, and F5
* Linear read BW (GB/s) is in cells E2, E3, E4, and E5



<hr class="sphinxhide"></hr>

<p class="sphinxhide" align="center"><sub>Copyright © 2020–2024 Advanced Micro Devices, Inc.</sub></p>

<p class="sphinxhide" align="center"><sup><a href="https://www.amd.com/en/corporate/copyright">Terms and Conditions</a></sup></p>
