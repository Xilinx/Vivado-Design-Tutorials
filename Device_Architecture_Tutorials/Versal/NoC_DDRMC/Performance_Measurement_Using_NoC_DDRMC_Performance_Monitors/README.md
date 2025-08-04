<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>Versal™ NoC/DDRMC Design Flow Tutorials</h1>
    <a href="https://www.amd.com/en/products/software/adaptive-socs-and-fpgas/vivado.html">See Vivado™ Development Environment on amd.com</a>
    </td>
 </tr>
</table>

# Performance Measurement using NoC/DDRMC Performance Monitors

***Version: Vivado 2024.1***

This tutorial presents how to measure bandwidth using the NoC and DDRMC performance monitors. The design presented in the Performance Tuning tutorial is also used in this tutorial to set up the performance monitors and report bandwidth at the NoC and DDRMC components. First, the performance monitor registers for each of the blocks are highlighted, including the setup of the registers. This is followed by a description of how to calculate bandwidth using the data. Then, a Tcl script is presented to automate the data capture using XSDB. Finally, a bare-metal application is created to capture performance results using the APU.

# Pre-requisites 

Use Vivado 2024.1 & Vitis Unified 2024.1 to complete the [Performance Tuning Design](../Performance_Tuning) tutorial as well as validate on hardware using traffic reloading. Performance results or optimization are not discussed in this tutorial. 


# Specification

Six Performance TGs write data to a single AXI NoC, which is configured with four interleaved DDR4 Memory Controllers (MC). It should be noted that only three of the MC ports have connections to the slave AXI ports. The goal is to reach 8000 Mb/s Read/Write bandwidth per TG. The transaction spec is 256 byte transactions with a linear addressing pattern.

# Background

There are performance monitors in the NoC components (NMU, NSU, NPS), DDRMC NSU ports, and inside the DDRMC block. The high-level architecture of the Performance Monitor blocks are very similar and is highlighted in the following figure. 


<img src="media/High_level_performance_monitor_architecture.PNG"  width="100%" height="100%">


The following three diagrams highlight the different clock sources and input data to each of these modules. 


<img src="media/NoC_performance_monitor_arch.PNG"  width="100%" height="100%">

<img src="media/ddrmc_noc_module.PNG"  width="100%" height="100%">

<img src="media/ddrmc_main.PNG"  width="100%" height="100%">

# Overview of Performance Monitor Registers

There are various Performance Monitor counters such as byte count and burst count for the NoC and DDRMC that can be used to calculate bandwidth and latency (minimum, maximum, and accumulated) at different components of a design. The Performance Monitor registers for the NoC components and DDRMC are available in the NPI register space and can be found in the *NoC and Integrated Memory Controller NPI Register Reference* (AM019). Below are few of the registers per-module which will be used in this tutorial. You can customize and take advantage of the counters/filters for various measurements. 

**<u> NMU/NSU Performance Monitors </u>**

<u>NMU/NSU Performance Monitor Registers </u>
| Register Name | Offset Address | Description |  
| -------- | -------- | -------- |  
| REG_PERF_MON_TBASE  | 0x000000086C | Monitor timebase selection index  |  
| REG_PERF_MON0_LATENCY_MIN    | 0x0000000870     | Monitor-0 Minimum latency   |  
| REG_PERF_MON0_LATENCY_MAX	   | 0x0000000874     | Monitor-0 Maximum latency	|  
| REG_PERF_MON0_LATENCY_ACC_UPR		| 0x0000000878  | Monitor-0 Accumulated latency (upper part) |
| REG_PERF_MON0_LATENCY_ACC_LWR	 | 0x000000087C  | Monitor-0 Accumulated latency (lower part) |
| REG_PERF_MON0_BURST_CNT	| 0x0000000880 | Monitor-0 burst count |
| REG_PERF_MON0_CNT_AND_OFL	| 0x0000000884 | Monitor-0 overflows & byte count (upper) |
| REG_PERF_MON0_BYTE_CNT_LWR	| 0x0000000888 | Monitor-0 byte count (lower part) |
| REG_PERF_MON0_CTRL	| 0x000000088C  | Monitor-0 control |
| REG_PERF_MON1_LATENCY_MIN	| 0x0000000890 | Monitor-1 Minimum latency |
| REG_PERF_MON1_LATENCY_MAX	 | 0x0000000894	| Monitor-1 Maximum latency |
| REG_PERF_MON1_LATENCY_ACC_UPR | 0x0000000898	| Monitor-1 Accumulated latency (upper part) |
| REG_PERF_MON1_LATENCY_ACC_LWR | 0x000000089C	| Monitor-1 Accumulated latency (lower part) |
| REG_PERF_MON1_BURST_CNT	| 0x00000008A0	| Monitor-1 burst count |
| REG_PERF_MON1_CNT_AND_OFL	 | 0x00000008A4 | Monitor-1 overflows & byte count (upper) |
| REG_PERF_MON1_BYTE_CNT_LWR | 0x00000008A8 | Monitor-1 byte count (lower part) |
| REG_PERF_MON1_CTRL	| 0x00000008AC | Monitor-1 control |


There are two Performance Monitors for each NMU/NSU which can be used for measuring both read and writes. The NMU/NSU registers are referenced to the NPI clock domain and are updated every timebase period (2<sup>timebase</sup> * NPI clk period). For example, if timebase 3 is selected and the NPI clk is 300 MHz the sampling period would be 2 <sup> 22 </sup> * (3.33 * 10 <sup> -9 </sup>) which would result in 0.01398 seconds. There are six different timebase options to select from using the `reg_perf_mon_tbase register`. The timebase index can be set in the `reg_timebase_sel` register from the `NPI_NIR` module. 


<u>REG_TIMEBASE_SEL (NPI_NIR) Register Bit-Field Summary </u>
| Field Name | Bits | Reset Value |  Description |
| -------- | -------- | -------- |  -------- | 
| tb5  | 29:25 | 0x1C | Selects one bit of a 32 bit counter to drive npi_timebase_5   |
| tb4  | 24:20 | 0x18 | Selects one bit of a 32 bit counter to drive npi_timebase_4   |  
| tb3  | 19:15 | 0x16 | Selects one bit of a 32 bit counter to drive npi_timebase_3   | 
| tb2  | 14:10 | 0x8 | Selects one bit of a 32 bit counter to drive npi_timebase_2   | 
| tb1  | 9:5 | 0x18 | Selects one bit of a 32 bit counter to drive npi_timebase_1   | 
| tb0  | 4:0 | 0x10 | Selects one bit of a 32 bit counter to drive npi_timebase_0   | 


The performance monitor can be setup for read or write, start of latency count, and is enabled using the `reg_perf_mon0_ctrl` register as shown below. Filters can also be applied to only capture transactions with a certain AxSize, AxBurst, etc. 


<u>REG_PERF_MON0_CTRL (NOC_NMU) Register Bit-Field Summary </u>
| Field Name | Bits | Reset Value |  Description |
| -------- | -------- | -------- |  -------- | 
| rw_sel  | 3 | 0x0 | Read/Write Select 0:Read 1:Write  |
| flt_sel  | 2 | 0x0 | Filter Select 0:Filter0 1:Filter1  |  
| lat_sel  | 1 | 0x0 | Latency Select 0:Start of Burst 1:End of Burst   | 
| mon_en  | 0 | 0x0 | Monitor Enable 0:Disable 1:Enable   | 



The `reg_perf_mon0_burst_cnt` register contains the total number of bursts counted in the timebase period and can be used to calculate the B/W.


<u>REG_PERF_MON0_BURST_CNT (NOC_NMU) Register Bit-Field Summary </u>
| Field Name | Bits | Reset Value |  Description |
| -------- | -------- | -------- | -------- |    
| nmu  | 31:0 | 0x0 | Total burst count within a time slot  |



For AXI Memory Mapped traffic all the count registers are valid for NMU/NSUs; however, for AXI-stream traffic only burst count applies for all NMU/NSUs. The `reg_perf_monX_cnt_and_ofl` register contains fields to indicate if the burst and byte counts have overflowed past the 32-bit counter range. These fields should be monitored and if the overflow bit is asserted, the time base needs to be adjusted. As per internal testing these flags have never been asserted. 

**<u> DDRMC_NOC Performance Monitors </u>**

There are four NSU ports per MC and each of the DDRMC_NSU ports has two performance monitors. The following table shows a single set of registers which are applicable for all four ports. The following registers are clocked on the NoC clock domain. After configuring all the filter and control registers, the monitor needs to be disabled and then enabled in order for the configuration changes to apply. 


<u>DDRMC_NoC Performance Monitor Registers </u>
| Register Name | Offset Address | Description |  
| -------- | -------- | -------- |
| perf_mon_timebase_scale	  | 0x00000004D4 | Performance monitor measurement Interval  |  
| nsu0_perf_mon_ctl_0_0    | 0x00000004D8 | Performance monitor 0 control NSU0   |  
| nsu0_perf_mon_ctl_0_1	   | 0x00000004DC | Performance monitor 0 control NSU0	|  
| nsu0_perf_filter_0_0		| 0x00000004E0  | Performance monitor filter set 0 NSU0 |
| nsu0_perf_filter_0_1		 | 0x00000004E4  | Performance monitor filter set 0 NSU0 |
| nsu0_perf_filter_en_0		| 0x00000004E8	 | Performance monitor filter set 0 enable NSU0 |
| nsu0_perf_mon_0_0		| 0x00000004EC | Accumulated Latency NSU0 |
| nsu0_perf_mon_0_1		| 0x00000004F0 | Burst count NSU0 |
| nsu0_perf_mon_0_2		| 0x00000004F4  | Transaction count NSU0 |
| nsu0_perf_mon_ctl_1_0		| 0x00000004F8 | Performance monitor 1 control NSU0 |
| nsu0_perf_mon_ctl_1_1		 | 0x00000004FC		| Performance monitor 1 control NSU0 |
| nsu0_perf_filter_1_0	 | 0x0000000500	| Performance monitor filter set 1 NSU0 |
| nsu0_perf_filter_1_1	 | 0x0000000504	|Performance monitor filter set 1 NSU0 |
| nsu0_perf_filter_en_1		| 0x0000000508	| Performance monitor filter set 1 enable NSU0 |
| nsu0_perf_mon_1_0		 | 0x000000050C | Accumulated Latency NSU0 |
| nsu0_perf_mon_1_1	 | 0x0000000510 | Burst count NSU0 |
| nsu0_perf_mon_1_2		| 0x0000000514 | Transaction count NSU0 |




Similar to the NMU/NSU registers the different timebases can be configured using the `perf_mon_timebase_scale` register as shown in the following table. The DDRMC NoC registers are referenced to the NoC clock domain and are updated every timebase period (2<sup>timebase</sup> * NoC clk period). For example, if default timebase of 0x17 is selected and the NoC clk is 1000 MHz the sampling period would be 2 <sup> 23 </sup> * (1 * 10 <sup> -9 </sup>) which would result in 0.0083886 seconds.


<u>perf_mon_timebase_scale (DDRMC_NOC) Register Bit-Field Summary </u>
| Field Name | Bits | Reset Value |  Description |
| -------- | -------- | -------- | -------- |
| tb3_scale  | 19:15 | 0x17 | These bits control the interval for timebase3. The period is set as 2**n * NOC clock period divided by 2, where n is the value in this field. The period set here should be fairly large (i.e. usecs).  |
| tb2_scale  | 14:10 | 0x17 | These bits control the interval for timebase2. The period is set as 2**n * NOC clock period divided by 2, where n is the value in this field. The period set here should be fairly large (i.e. usecs).  |  
| tb1_scale  | 9:5 | 0x17 | These bits control the interval for timebase1. The period is set as 2**n * NOC clock period divided by 2, where n is the value in this field. The period set here should be fairly large (i.e. usecs).   | 
| tb0_scale  | 4:0 | 0x17 | These bits control the interval for timebase0. The period is set as 2**n * NOC clock period divided by 2, where n is the value in this field. The period set here should be fairly large (i.e. usecs).   | 



The two registers to configure and enable the performance monitor are `perf_mon_ctrl_X_0` and `perf_mon_ctrl_X_1`. The performance monitor can be configured for single shot or continuous mode using the **sngl** field of the `perf_mon_ctl_X_0` register. Single shot mode is used to manually control the period in which the sampling occurs; whereas in continuous mode the monitors are continuously running and the counts are updated every timebase period. To calculate bandwidth, continuous mode is always used. Single shot mode can be used to verify traffic flow at different phases. The time base can be selected using the `ctrl_X_1` register as shown in the register descriptions below. 


<u>nsu0_perf_mon_ctl_0_0 (DDRMC_NOC) Register Bit-Field Summary </u>
| Field Name | Bits | Reset Value |  Description |
| -------- | -------- | -------- |  -------- |  
| sngl  | 1 | 0x0 | This bit controls the enabling of performance counter captures based on mon_en only. If this bit is set to 1 the performance monitoring starts when mon_en is set to 1 , and ends when mon_en is set to 0. The timebase edge is ignored, for performance monitor captures, when this bit is set to 1. 0: disable 1: enable  |
| mon_en  | 0 | 0x0 | This bit controls the enabling of performance monitor 0. All other control and filter settings should be programmed 1st. This bit should be set to 1 after all other filter and control registers are programmed. Also, this bit should be set to 0 and then 1 for any new filter and control setting to take effect: 0: disable 1: enable   |  




<u>nsu0_perf_mon_ctl_0_1 (DDRMC_NOC) Register Bit-Field Summary </u>
| Field Name | Bits | Reset Value |  Description |
| -------- | -------- | -------- |  -------- | 
| bew  | 7 | 0x0 | Best effort write QoS class |
| isow  | 6 | 0x0 | Isochronous write QoS class |
| ber  | 5 | 0x0 | Best effort read QoS class |
| isor  | 4 | 0x0 | Isochronous read QoS class |
| llr  | 3 | 0x0 | Low latency read QoS class |
| lat_sel  | 2 | 0x0 | 0:start of burst 1:end of burst |
| tb_sel | 1:0 | 0x0 | Select one of 4 available intervals: 0:timebase0 1:timebase1 2:timebase2 3:timebase3 |




The counters are 31-bit counters. The registers are 32 bits where the 32nd bit indicates an overflow. When the counter has overflowed, the 32nd bit is asserted, and the counter does not increment any further. This bit needs to be polled to ensure the timebase is selected for continuous mode or the sampling time interval in single shot mode is not too long. 

**<u> DDRMC_Main Performance Monitors </u>**

The MC has two performance monitors for each of the channels which are clocked on the MC clock. The following table details registers associated with a single MC. Each of the monitors counts various commands in the specified timebase period. 


<u>DDRMC_Main Performance Monitor Registers </u>
| Register Name | Offset Address | Description |  
| -------- | -------- | -------- |  
| dc0_perf_mon	  | 0x00000013C0 | DC monitor channel 0  |  
| dc0_perf_mon_0    | 0x00000013C4 |  DC monitor 0 channel 0   |  
| dc0_perf_mon_1	   | 0x00000013C8 | DC monitor 1 channel 0	|  
| dc0_perf_mon_2		| 0x00000013CC  | DC monitor 2 channel 0 |
| dc0_perf_mon_3		 | 0x00000013D0  | DC monitor 3 channel 0 |
| dc0_perf_mon_4		| 0x00000013D4	 | DC monitor 4 channel 0 |
| dc0_perf_mon_5		| 0x00000013D8 | DC monitor 5 channel 0 |
| dc0_perf_mon_6		| 0x00000013DC | DC monitor 6 channel 0 |
| dc0_perf_mon_7		| 0x00000013E0  | DC monitor 7 channel 0 |
| dc0_perf_mon_8		| 0x00000013E4 | DC monitor 8 channel 0 |
| dc1_perf_mon		 | 0x00000013E8		| DC monitor channel 1   |
| dc1_perf_mon_0	 | 0x00000013EC	| DC monitor 0 channel 1   |
| dc1_perf_mon_1	 | 0x00000013F0	|DC monitor 1 channel 1 |
| dc1_perf_mon_2		| 0x00000013F4	| DC monitor 2 channel 1 |
| dc1_perf_mon_3		 | 0x00000013F8 | DC monitor 3 channel 1 |
| dc1_perf_mon_4	 | 0x00000013FC | DC monitor 4 channel 1 |
| dc1_perf_mon_5		| 0x0000001400 | DC monitor 5 channel 1 |
| dc1_perf_mon_6		| 0x0000001404 | DC monitor 6 channel 1 |
| dc1_perf_mon_7		| 0x0000001408 | DC monitor 7 channel 1 |
| dc1_perf_mon_8		| 0x000000140C | DC monitor 8 channel 1 |




The `dcX_perf_mon` register is used to configure and enable the performance monitor. Similar to the DDRMC_NoC registers the ‘sngl’ field in this register controls single shot or continuous mode. Unlike the NoC registers the timebase is set in the **accum_period** field of the register. The ``DDRMC_Main`` registers are referenced to the MC clock and are updated every timebase period (2<sup>Accumulation Period</sup> * MC clk period/2). For example, if the accumulation period is set to the default of 1F and the MC clk is 1964 MHz the sampling period would be 2 <sup> 31 </sup> * (2.565 * 10 <sup> -10 </sup>) which would result in 0.5509 seconds.


<u>dc0_perf_mon(DDRMC_MAIN) Register Bit Field Summary </u>
| Field Name | Bits | Reset Value |  Description |
| -------- | -------- | -------- |  -------- | 
| sngl  | 17 | 0x0 | This bit controls the enabling of performance counter captures based on the enable bit only. If this bit is set to 1 the performance monitorring starts when enable is set to 1, and ends when enable is set to 0. The accum_period value is ignored, for performance monitor captures, when this bit is set to 1: 0: disable 1: enable |
| num_ro_of  | 16 | 0x0 | When set this bit indicates the roll-over counter has overflowed. Software should clear this field when enabling the performance monitor.  |
| num_ro  | 15:6 | 0x0 | Number of times the accumulation period has rolled over since the monitor was enabled. Software should clear this field when enabling the performance monitor.  |
| accum_period  | 5:1 | 0x1F | These bits control the performance monitor accumulation period. The period is set as 2**n * MC clock period divided by 2, where n is the value in this field. The period set here should be fairly large (i.e., µsecs). |
| enable  | 0 | 0x0 | 0: Channel 0 perf mon disabled  1: Channel 0 perf mon enabled |



There are many command counters in the DDRMC. The counter registers per channel are `dcX_perf_mon_0` to `dcX_perf_mon_8`. According to the *NoC and Integrated Memory Controller NPI Register Reference* (AM019) each counter’s 32nd bit is an overflow bit; however, it does not work as intended. The counter is essentially just a 32-bit counter with no overflow bit. 

# Acquiring Clock Frequencies from Vivado
As described in the previous section, the NPI, NoC, and MC clock frequencies are required to perform calculations using the different monitor values. 

NPI and NoC Clock Frequencies can be found under **CIPs** -> **PS PMC** -> **Clocking** -> **Output Clocks** as shown below.

<img src="media/cips_noc_npi_clk_tab.PNG"  width="100%" height="100%">

MC clock frequency can be found under the **NoC** -> **DDRMC Basic** tab as shown below. 

<img src="media/noc_mc_clk_period.PNG"  width="100%" height="100%">



# Acquiring the Base Address from Vivado
Before developing the code, the base address of the sites to configure the performance monitors has to be acquired from Vivado. 

Step 1: Open the implemented design. 

Step 2: Run the Tcl Command: `report_noc_addresses`.

Sample Output

<img src="media/report_noc_addresses_output.png"  width="100%" height="100%">

This snippet only shows a partial output. The format of the result is: NoC Site, Base Address, PMC Alias Offset, Absolute Address. In this tutorial we are writing from the PS to a single SLR device, so the base addresses can be used.

# Pseudocode

The following sequence of steps shows how to set up the performance monitors in the different modules to calculate bandwidth at each of the sites for the performance tuning design. The method to measure and calculate minimum, maximum, and average latency for the NMU components is also described.  There are three scripts which are developed for the three different modules. The complete code is attached to the scripts folder. Note the scripts will have print statements for logging purposes which are not discussed here. 


*Script 1: Unlock the NPI_NIR_Lock and configure the timebase in the NPI_NIR module. Unlock the NMU_PCSR_Lock, Select timebase and configure the NMU performance monitor and calculate bandwidth using the burst count*

a) Address setting.

```TCL
set NPI_NIR_Base 0xF6000
set NPI_NIR_Lock ${NPI_NIR_Base}00C
set NPI_NIR_Time ${NPI_NIR_Base}100
set NoC_NMUX0Y6_Base 0xF6AC
set NoC_NMUX0Y6_Lock ${NoC_NMUX0Y6_Base}000C
set NoC_NMUX0Y6_TBSel ${NoC_NMUX0Y6_Base}086C
set NoC_NMUX0Y6_MonCtrlEn_RD ${NoC_NMUX0Y6_Base}088C 		#Monitor 0 is used for Read Operation
set NoC_NMUX0Y6_MonCtrlEn_WR ${NoC_NMUX0Y6_Base}08AC 		#Monitor 1 is used for Write Operation
set NoC_NMU_X0Y6_Mon0_BurstCount ${NoC_NMUX0Y6_Base}0880 	#Number of read bursts
set NoC_NMU_X0Y6_Perf_Mon0_Latency_Min ${NoC_NMUX0Y6_Base}0890 #Minimum Latency Register
set NoC_NMU_X0Y6_Perf_Mon0_Latency_Max ${NoC_NMUX0Y6_Base}0894 #Maximum Latency Register 
set NoC_NMU_X0Y6_Perf_Mon0_Acc_Lat_Upr ${ NoC_NMUX0Y6_Base}0898 #Accumulated Latency Upper 16 bits
set NoC_NMU_X0Y6_Perf_Mon0_Acc_Lat_Lwr ${ NoC_NMUX0Y6_Base}089C #Accumulated Latency Lower 32 bits
```


b) Unlock the write protect.

```TCL
mwr $NPI_NIR_Lock    0xf9e8d7c6
```

c) Configure Timebase. In this tutorial we are not modifying the timebase options, so this register write is not necessary.

Six sets of timebases are available

The sampling period is 2^n*(NPI Clock Period)

```TCL
mwr $NPI_NIR_Time <Timebase>
```

d) Unlock the write protect of ``NoC_NMU``.

```TCL
mwr $NPI_NIR_Lock    0xf9e8d7c6
```

e) Select the timebase to use. For this tutorial the default timebase 3 is used. Timebase 3 is bit 22 of the counter.

```TCL
mwr $NoC_NMUX0Y6_TBSel 0x3
```

f) Enable Performance monitor.

```TCL
mwr $NoC_NMUX0Y6_MonCtrlEn_RD 0x1
mwr $NoC_NMUX0Y6_MonCtrlEn_WR 0x9
#Bit [0]: 0=Disable 1=Enable
#Bit [3]: 0=Read 1=Write
```

g) Read Burst Count.

```TCL
set reg_perf_mon_burst_count_npi [mrd -force $NoC_NMU_X0Y6_Mon0_BurstCount ]
```

h) Calculating Bandwidth. 

<img src="media/noc_bw_calculation.PNG"  width="100%" height="100%">

```TCL
set timebase [expr {2**22}] 
set NPIFreqMHz 300 #This can be found in the CIPs clocking configuration
set NMU_X0Y6_BW [expr {[expr {$reg_perf_mon_burst_count * 256 * $NPIFreqMHz}] / $timebase }] 
```

Note this is just one way to calculate bandwidth. For a specific design the default timebase might need to be adjusted to get a better resolution. The calculation needs to be repeated for both read and write monitors across all the NMU/NSU in the data path.

i)	Report Minimum and Maximum Latency and Calculate Average Latency 

The minimum and maximum latency values can be obtained from the registers.

Minimum Latency 
```TCL
set reg_perf_mon0_latency_min [mrd -force $NoC_NMU_X0Y6_Perf_Mon0_Latency_Min]
```

Maximum Latency
```TCL
set reg_perf_mon0_latency_max [mrd -force $ NoC_NMU_X0Y6_Perf_Mon0_Latency_Max]
```

Average Latency Calculation

<img src="media/latencyEquations.PNG"  width="100%" height="100%">

```TCL
set averageLatency [expr {[expr {$NoC_NMU_X0Y6_Perf_Mon0_Acc_Lat_Lwr + $ NoC_NMU_X0Y6_Perf_Mon0_Acc_Lat_Upr}] / $reg_perf_mon_burst_count_npi }]
```

**Note**: All register reads report address and a hex value. In attached scripts the ‘scan’ function is used to save the decimal equivalent and perform the necessary calculation. This is applicable to all three scripts. 


*Script 2: Unlock DDRMC_NoC_PCSR_Lock, select timebase and configure the DDRMC NSU performance monitors and calculate bandwidth*

a) Address Setting.

```TCL
set NoC_DDR1_Base          0xF621
set NoC_DDR1_Lock         ${NoC_DDR0_Base}000C
set NoC_DDR1_Time         ${NoC_DDR0_Base}04D4
set NoC_DDR1_Mon0_Ctrl_0        ${NoC_DDR0_Base}04D8 
set NoC_DDR1_Mon1_Ctrl_0       ${NoC_DDR0_Base}04F8
set NoC_DDR1_Mon0_Ctrl_1     ${NoC_DDR0_Base}04DC
set NoC_DDR1_Mon1_Ctrl_1     ${NoC_DDR0_Base}04FC
set NoC_DDR1_Mon0_BurstCount  ${NoC_DDR0_Base}04F0 
set NoC_DDR1_Mon1_BurstCount  ${NoC_DDR0_Base}0510
```

b) Unlock the write protect.

```TCL
mwr $NoC_DDR1_Lock    0xf9e8d7c6
```

c) Configure timebase.

The sampling period is 2^n*(NoC Clock Period)

The default of 0x17 is changed to 0x19

```TCL
mwr $NoC_DDR1_Time  0x000CE739
```

d)	Monitors need to be disabled before making any changes to the configuration. Otherwise, the changes made won’t take any effect.

```TCL
mwr -force $NoC_DDR1_Mon0_Ctrl_0  0x0; 
mwr -force $NoC_DDR1_Mon1_Ctrl_0 0x0;
```

e)	Set perf_mon_0 to Best Effort Read and perf_mon_1 to Best Effort Write.

```TCL
mwr -force NoC_DDR1_Mon0_Ctrl_1   0x023; #Monitor 0 of NSU 0 is used for tracking reads
mwr -force NoC_DDR1_Mon1_Ctrl_1    0x083; #Monitor 1 of NSU 1 is used for tracking writes
```

f)	Enable the monitors. 

```TCL
mwr -force $NoC_DDR1_Mon0_Ctrl_0  0x1; 
mwr -force $NoC_DDR1_Mon1_Ctrl_0 0x1;
```

g)	Capture Burst Counts from the read and write monitors for this NSU.

```TCL
set DDR1_Mon0_ReadBurstCountNPI [mrd -force $NoC_DDR1_Mon0_BurstCount ]
scan $ DDR1_Mon0_ReadBurstCountNPI {%x%[:]%x} address - DDR1_Mon0_ReadBurstCount #The scan function is used to save just the burst count value as XSDB returns the address for every ‘mrd’
set DDR1_Mon1_WriteBurstCountNPI [mrd -force $NoC_DDR1_Mon1_BurstCount]
scan $ DDR1_Mon1_WriteBurstCountNPI {%x%[:]%x} address - DDR1_Mon1_WriteBurstCount
```

Once the counter value is read it should be analyzed to ensure the overflow flag is not asserted. If it is asserted, the timebase needs to be adjusted. In this design we analyzed the overflow status and decided the timebase is fine.


h) Calculate Read and Write Bandwidth 

The bandwidth is a measure of MB/s and is calculated similarly to the NMU shown above. However, `DDRMC_NoC` monitors are tracking NoC packet flits, and the registers are clocked on the NoC clock domain. Each burst in the case of the `DDRMC_NSU` ports is 16 bytes and the NoC clock is 1000 MHz.



<img src="media/ddrmc_noc_bw_calc.PNG"  width="100%" height="100%">

```TCL
set timebase [expr {2**25}] 
set NoCFreqMHz 1000 #This can be found in the CIPs clocking configuration
set NSU0_Write_BW [expr {[expr {$DDR1_Mon1_WriteBurstCount * 16 * $NoCFreqMHz}] / $timebase }] 
```

The same process is followed for all the monitors across all the NSU ports for a specific MC.


*Script 3: Unlock DDRMC_Main_PCSR_Lock, configure timebase and performance monitor and calculate bandwidth using the CAS counts*

a)	Address setting.

```TCL
set DDRMC_Main1_Base 0xF62C
set DDRMC_Main1_Lock ${DDRMC_Main1_Base}000C
set DDRMC_Main1_Mon0_PerfMon ${DDRMC_Main1_Base}13C0 #Each MC has 2 monitors for dual channel configurations. This is channel 0 of MC1 
set DDRMC_Main1_Mon1_PerfMon ${DDRMC_Main1_Base}13E8 #This is channel 1 of MC1
set DDRMC_Main1_Mon0_ReadBurst ${DDRMC_Main1_Base}13C8 #Read CAS commands going through channel 0
set DDRMC_Main1_Mon0_WriteBurst ${DDRMC_Main1_Base}13CC #Write CAS commands going through channel 0
set DDRMC_Main1_Mon1_ReadBurst ${DDRMC_Main1_Base}13F0 #Read CAS commands going through channel 1
set DDRMC_Main1_Mon1_WriteBurst ${DDRMC_Main1_Base}13F4 #Write CAS commands going through channel 1
```

b)	Unlock the write protect.

```TCL
mwr $DDRMC_Main1_Lock    0xf9e8d7c6
```

c)	Configure both channel's monitors.

```TCL
#Disable the counter
#Set continuous mode
#Default accumulation period: 0x1F
#Monitors are disabled 
mwr -force DDRMC_Main1_Mon0_PerfMon 0x3E; 
mwr -force DDRMC_Main1_Mon1_PerfMon 0x3E;
```

d) Each channel’s monitor has nine counters to track various DDR commands. All counters need to be cleared before sampling. Write 0x0 to all nine counters.

e) Start counters dc0_perf_mon and dc1_perf_mon enable 

```TCL
mwr -force DDRMC_Main1_Mon0_PerfMon 0x3F; 
mwr -force DDRMC_Main1_Mon1_PerfMon 0x3F;
```

f)	Add wait command to make sure the register reads happen after the results are ready. 

```TCL
after 20000
```

g) Capture read and write commands counts. The MC counts the number of read and write CAS commands issued in the sampling period. These counts will be used to calculate the bandwidth.

```TCL
set MC1_Ch0_Read [mrd -force $DDRMC_Main1_Mon0_ReadBurst]
scan $MC1_Ch0_Read{%x%[:]%x}address – MC1_Ch0_Rd_Count #mrd returns address along with data. Store the data
set MC1_Ch0_Write [mrd -force $DDRMC_Main1_Mon0_WriteBurst]
scan $MC1_Ch0_Read{%x%[:]%x}address – MC1_Ch0_Wr_Count #mrd returns address along with data. Store the data
set MC1_Ch1_Read [mrd -force $DDRMC_Main1_Mon1_ReadBurst]
scan $MC1_Ch1_Read{%x%[:]%x}address – MC1_Ch1_Rd_Count #mrd returns address along with data. Store the data
set MC1_Ch1_Write [mrd -force $DDRMC_Main1_Mon1_WriteBurst]
scan $MC1_Ch1_Write{%x%[:]%x}address – MC1_Ch1_Wr_Count #mrd returns address along with data. Store the data
```

h) Calculate Read and Write Bandwidth. 
The bandwidth is a measure of MB/s. The `MC_Main` registers are clock on the MC clock period. The counters provide the number of Read and Write commands sampled during the time interval. This data needs to be converted to number of bytes transferred. 
The memory configuration used in this design is Dual Channel x32 LPDDR4 with a MC clock of 1964 MHz. LPDDR4 has a default burst length of 16. 

<img src="media/ddrmc_main_bw_calc.PNG"  width="100%" height="100%">


```TCL
set timebase [expr {2**31}] 
set MCFreqMHz 1964 #This can be found in the MC settings tab of the NoC
set Main1Ch1_Write_BW [expr {[expr {$ MC1_Ch0_Wr_Count * 64 * $NoCFreqMHz}] / $timebase}] 
```

The same process is followed for all monitors across all the MCs.


# Load Design on Hardware and Capture Results 

Load the final Performance Tuning design on hardware and load traffic using the Traffic Reloading scripts provided. 

Bandwidth at all NMU sites can be captured using the first script.

1) Launch xsdb and enter the following sequence of commands
   
	a. connect 
	b. ta 1
	c. source ./NMUPerfMonitorScript.tcl
	
2) Output 

<img src="media/noc_bw_latency_xsdb_output.PNG"  width="100%" height="100%">
<img src="media/noc_bw_latency_xsdb_output_2.PNG"  width="100%" height="100%">

Bandwidth at the DDRMC NSU ports can be captured using the second script:

1) source `./ddrmc_nsu_perf_mon.tcl`

2) Output

<img src="media/ddrmc_nsu_bw.PNG"  width="100%" height="100%">

Bandwidth at the DDRMC can be captured using the third script:

1) source `./ddrmc_main_bw.tcl`

2) Output

<img src="media/ddrmc_main_bw.png"  width="100%" height="100%">

# Use Vitis Unified Flow to Create a Bare-Metal Application

The first step is to generate the device image.

Export the hardware (.xsa). Under **File** -> **Export** -> **Export Hardware** -> Press **Next** -> Select **include device image** -> Press **Next** -> **Use Defaults** -> **Finish**

The first two steps in creating the bare-metal application are to create a platform and then a 'HelloWorld' application project. The instructions to create a platform and application project in Vitis Unified are outlined in the *Versal Adaptive SoC Embedded Design Tutorial* (UG1305) and are also included below. 

**Note**: The XSA file is the Vivado design that was exported. 

**Note**: The Vitis Unified foftware Platform has been completely redesigned and differs from the previous generations of Vitis, It is the official standard moving forward. If you are creating this design in a previous version, the instructions will differ. 

Steps to Create Platform:

1.	Select a folder to create the workspace by clicking **Open Workspace**.

<img src="media/vitis_unified_1.PNG"  width="100%" height="100%">

2. Select **File** -> **New Component** -> Set **Component Name** to **: Vck190_platform.

<img src="media/vitis_unified_2.PNG"  width="100%" height="100%">

3. Click **Next**.
Click the **Browse** button to add the XSA file generated through Vivado. 

<img src="media/vitis_unified_3.PNG"  width="100%" height="100%">

4. Click **Next**.
Ensure the Operating System is set as Standalone and Processor is set as **Psv_cortexa72_0**.

<img src="media/vitis_unified_4.PNG"  width="100%" height="100%">

5. Ensure the Platform Component Summary is as follows and click **Finish**.

<img src="media/vitis_unified_5.PNG"  width="100%" height="100%">

After creating the platform, the HelloWorld application is created using the template. 
Steps to Create HelloWorld Application using template:

1.	Select **File** -> **New Component** -> **From Example**.

2.	Select **Hello World** and click **Create Application Component from Template**.

<img src="media/vitis_unified_6.PNG"  width="100%" height="100%">

3. Set Component Name as **hello_world_a72** and component location to the appropriate directory. 

<img src="media/vitis_unified_7.PNG"  width="100%" height="100%">

4. Select the **Vck190_platform**.

<img src="media/vitis_unified_8.PNG"  width="100%" height="100%">

5. Verify Domain and Processor as follows.

<img src="media/vitis_unified_9.PNG"  width="100%" height="100%">

6. Verify **Summary** as follows and click **Finish**.

<img src="media/vitis_unified_10.PNG"  width="100%" height="100%">

By default, the template will place the HelloWorld application in the CIPs on chip memory (OCM). The application code will be under the main function, which is in the ``helloworld.c`` file, found under ``hello_world_a72->Sources->src``.

<img src="media/vitis_unified_11.PNG"  width="100%" height="100%">

The code for the C application is very similar to the Tcl code developed earlier. The exact same logic and flow can be used. The following snippet shows the conversion of one block of the ``NMUPerfMon.tcl`` script to C code. 

<img src="media/tclCode.PNG"  width="100%" height="100%">

<img src="media/c_code_vitis_unified.PNG" width="100%" height="100%">

In the C code all the variables to read the registers are declared as ``u64`` and the variables for the calculations are float. The ``printf`` function can be used in the place of ``puts``. To write to the registers ``Xil_out32`` is used and to read from registers the ``Xil_In32`` function is used. All three Tcl scripts are converted to C code in the same manner. The C code is attached to the scripts directory. For code without latency measurements, refer to ``helloworld.c`` and with latency measurements refer to ``helloworld_latency.c``.

When the C code is complete, the application is ready to be executed. Re-build the ``hello_world`` application by clicking 'Build' in the lower left flow window with the above changes. 

<img src="media/vitis_unified_12.PNG"  width="100%" height="100%">

**Note**: The platform default in this example is set up to use hard UART for input and output. If your set up uses JTAG UART instead of the hardened UART, then change stdin and stdout in the vck190_platform -> settings -> vitis-comp.json file to coresight. 

<img src="media/vitis_unified_13.PNG"  width="100%" height="100%">

Now the HelloWorld Bare-metal Application is ready to be run on hardware. 

# Debugging and Running the Bare-Metal Application 

Click the gear icon next to **Debug** to create a debug session. 

<img src="media/vitis_unified_14.PNG"  width="100%" height="100%">

Connect to the board by clicking **New** next to **Target connection**. 

<img src="media/vitis_unified_15.PNG"  width="100%" height="100%">

When connected to the board, ensure connection to the correct com port for UART and click **Debug**. 

The JTAG Output should look as follows:

<img src="media/vitis_output_1.PNG"  width="100%" height="100%">

If latency code is included then output will have additional latency measurements such as:

<img src="media/vitis_output_1_5.PNG"  width="100%" height="100%">

<img src="media/vitis_output_2.PNG"  width="100%" height="100%">


# Revision History

* Feb 2025 - Initial Release.

<p dir="auto" align="center"><br>Copyright © 2025 Advanced Micro Devices, Inc<br></p>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

<p dir="auto" align="center"><br><sup>XD318</sup><br></p>
