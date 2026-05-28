<table>
 <tr>
   <td align="center"><img src="https://github.com/Xilinx/Image-Collateral/blob/main/xilinx-logo.png?raw=true" width="30%"/><h1>AMD Versal™ Adaptive SoC: Performance Analysis in Simulation Tutorial (XD200)</h1>
   <h2 align="left"><i>Version: 2025.2</i></h2>
   </td>
 </tr>
</table>

# Introduction to Performance Analysis in Simulation

This tutorial covers a design that was generated to experiment with the
default NoC placement with six traffic generators sending linear data to four
interleaved memory controllers. The tutorial will start with outlining
the basic bandwidth spec for the design and then you will use the AMD Vivado™ IP
integrator to build the design and simulate. You will review the
performance and introduce a Command Decode tool to analyze the commands
and different command counters to better understand the design. Based on
the analysis, the original design will be optimized to enhance the
performance. The two primary goals of this tutorial are to:

* Highlight the Command Decode tool
* Show the significance of simulating your design and how major performance issues can be found in the
simulation phase.

# Description of the Design

This design uses six Performance AXI Traffic Generator (TG) instances and one AXI NoC instance, with an
integrated DDR4 Memory Controller with four interleaved MCs. All six of the
TGs write and read 256-byte transactions with a linear addressing
pattern, and each TG targets a unique address space. The design
process consists of the following phases:

1. Understand the DDR spec.
2. Define a CSV file to control the Performance AXI TGs.
3. Build and simulate an initial version of the design using Designer
Assistance.
4. Simulate the design and learn how to use the Command Decode tool to
better analyze simulation waveforms.
5. Revise the design with the information gathered from the tool.
6. Rerun and analyze the updated design to see if it meets spec.

# Specification

Six Performance TGs writing data to one AXI NoC configured
with four interleaved DDR4 Memory controllers (however, only three of the
MC ports are connected to the slave AXI ports). The goal is to
reach 8000 MB/s Read/Write bandwidth per TG. The transaction spec is 256-
byte transactions with a linear addressing pattern.

## Using a CSV File to Control the Traffic Generator

<img src="media/image1.png"  width="100%" height="100%">

A total of six CSV files are used, each controlling one TG to perform 256-
byte write and read transactions. The above screenshot shows the data in
all six CSVs collated together. Each individual CSV will be split per
unique `TG_NUM`. As the CSV shows, each of the TGs targets a unique
address space with linear addressing and the size and length parameters
are set accordingly for 256-byte transaction. The six CSVs are provided in
the files section. Note that the `TG_NUM` value needs to match the number of
TGs in the block design. Following is a screenshot of an
individual CSV.

<img src="media/image2.png"  width="100%" height="100%">

# Building and Simulating the First Design Iteration

1. As described in previous tutorials, create a new project with the **xcvc1902-vsva2197-2MP-e-S** part, and create a new block design.
2. Add one AXI NoC instance, and run block automation, with the following
settings:

    * **Control, Interface and Processing System**: Unchecked
    * **AXI Traffic Generator**: 6
    * **External Sources**: None
    * **AXI BRAM Controller**: None
    * **Memory Controller Type**: DDR
    * **Number of Interleaved Memory Controllers**: 4
    * **AXI Performance Monitor for PL-2-NoC AXI-MM pins**: Checked
    * **AXI Clk Source**: New/Reuse Simulation Clock and Reset Generator

3. Run **Connection Automation** twice, selecting **All Automation** both times.
4. Regenerate the layout.
5. Edit the `axi_noc_0` properties.

## General Tab

* **Number of AXI Slave Interfaces**: 6

* **Number of AXI Master Interfaces**: 0

* **Number of AXI Clocks**: 1

* **DDR Address Region 0**: DDR CH1 This matches the address range selected in the CSV file.

Following is a screenshot of how the **General** settings should look.

<img src="media/image3.png"  width="70%" height="70%">

## Connectivity Tab

Following is a screenshot of how the **Connectivity** settings should look.

![Graphical user interface, text, application, email Description
automatically generated](media/image4.png)

## QOS Tab

Following is a screenshot of how the **QoS** settings should look.

![Graphical user interface, text, application, email Description
automatically generated](media/image5.png)

## DDR Basic Tab

* **Controller Type**: DDR4 SDRAM

* **Input System Clock Period (ps)**: 5000 (200 MHz) VCK190 uses a 200 MHz
`sys_clk`.

Following is a screenshot of how the **DDR Basic** settings should look.

![Graphical user interface, text, application, email Description
automatically generated](media/image6.png)

## DDR Memory

* **Number of Channels**: Single

Following is a screenshot of how the **DDR Memory** settings should look.

![Graphical user interface, application Description automatically
generated](media/image7.png)

## DDR Address Mapping

Following is a screenshot of the default selection for **DDR Address Mapping**.

![Table Description automatically
generated](media/image8.png)

6. Edit the NOC_TG properties:

* **Performance TG for Simulation**: SYNTHESIZABLE
* **AXI Data Width**: 512
* **AXI User Width (in csv)**: 11
* **Enable Traffic Shaping**: Unchecked

Following is a screenshot of the NOC_TG selections.

![Graphical user interface, application, email Description automatically
generated](media/image9.png)

## Synthesizable TG Options

* **Path to User Defined Pattern File (CSV) for Synthesizable TG**: Enter path
* **Insert VIO for debug status signals**: Unchecked

Following is a screenshot of the **Synthesizable TG Options** selection:

![Graphical user interface, text, application, email Description
automatically generated](media/image10.png)

Repeat the same for all six TGs.

7. Edit the noc_clk_gen properties:

* **Sys Clock -- 0 Frequency (MHz)**: **200**: This corresponds to the Input System Clock Period set in step 5.
* **Sys Clock -- 1 Frequency (MHz)**: **200**
* **Sys Clock -- 2 Frequency (MHz)**: **200**
* **Sys Clock -- 3 Frequency (MHz)**: **200**
* **AXI-0 Clock Frequency (MHz)**: **250**: This is the frequency used when determining the `start_delay` values in the CSV.

![Graphical user interface, table Description automatically
generated](media/image11.png)

8. Edit the noc_sim_trig properties

* **Enable Traffic Shaping**: Uncheck this option.

Complete Block Design

![Diagram, engineering drawing Description automatically
generated](media/image12.png)

9. Mark `noc_tg_M_AXI` for simulation.
10.	In the **Address Editor**, Assign **All Addresses**.
11.	Validate the design.
12.	Create an HDL Wrapper for the block design.
13.	Generate Block Design.
14.	Simulate the Design.

When simulation completes, the waveform should be fully populated. In
the console there should be a report of the bandwidth information. Based
on the report, notice that the bandwidth is much slower than
requested.

# Bandwidth Results

```tcl
=========================================================
>>>>>> SRC_ID 0 :: AXI_PMON :: BW ANALYSIS >>>>>>
=========================================================
AXI Clock Period = 4000 ps
Min Write Latency = 22 axi clock cycles
Max Write Latency = 601 axi clock cycles
Avg Write Latency = 382 axi clock cycles
Actual Achieved Write Bandwidth = 2240.112006 MBps
***************************************************
Min Read Latency = 36 axi clock cycles
Max Read Latency = 740 axi clock cycles
Avg Read Latency = 454 axi clock cycles
Actual Achieved Read Bandwidth = 1900.237530 MBps
=========================================================
>>>>>> SRC_ID 1 :: AXI_PMON :: BW ANALYSIS >>>>>>
=========================================================
AXI Clock Period = 4000 ps
Min Write Latency = 22 axi clock cycles
Max Write Latency = 592 axi clock cycles
Avg Write Latency = 354 axi clock cycles
Actual Achieved Write Bandwidth = 2365.988909 MBps
***************************************************
Min Read Latency = 31 axi clock cycles
Max Read Latency = 687 axi clock cycles
Avg Read Latency = 442 axi clock cycles
Actual Achieved Read Bandwidth = 1940.570042 MBps
=========================================================
>>>>>> SRC_ID 2 :: AXI_PMON :: BW ANALYSIS >>>>>>
=========================================================
AXI Clock Period = 4000 ps
Min Write Latency = 36 axi clock cycles
Max Write Latency = 655 axi clock cycles
Avg Write Latency = 394 axi clock cycles
Actual Achieved Write Bandwidth = 1978.973408 MBps
***************************************************
Min Read Latency = 57 axi clock cycles
Max Read Latency = 680 axi clock cycles
Avg Read Latency = 459 axi clock cycles
Actual Achieved Read Bandwidth = 1894.051495 MBps
=========================================================
>>>>>> SRC_ID 3 :: AXI_PMON :: BW ANALYSIS >>>>>>
=========================================================
AXI Clock Period = 4000 ps
Min Write Latency = 23 axi clock cycles
Max Write Latency = 611 axi clock cycles
Avg Write Latency = 381 axi clock cycles
Actual Achieved Write Bandwidth = 2227.636617 MBps
***************************************************
Min Read Latency = 44 axi clock cycles
Max Read Latency = 725 axi clock cycles
Avg Read Latency = 465 axi clock cycles
Actual Achieved Read Bandwidth = 1885.680613 MBps
=========================================================
>>>>>> SRC_ID 4 :: AXI_PMON :: BW ANALYSIS >>>>>>
=========================================================
AXI Clock Period = 4000 ps
Min Write Latency = 22 axi clock cycles
Max Write Latency = 616 axi clock cycles
Avg Write Latency = 381 axi clock cycles
Actual Achieved Write Bandwidth = 1979.585524 MBps
***************************************************
Min Read Latency = 32 axi clock cycles
Max Read Latency = 682 axi clock cycles
Avg Read Latency = 443 axi clock cycles
Actual Achieved Read Bandwidth = 1948.842875 MBps
=========================================================
>>>>>> SRC_ID 5 :: AXI_PMON :: BW ANALYSIS >>>>>>
=========================================================
AXI Clock Period = 4000 ps
Min Write Latency = 22 axi clock cycles
Max Write Latency = 685 axi clock cycles
Avg Write Latency = 369 axi clock cycles
Actual Achieved Write Bandwidth = 1939.981813 MBps
***************************************************
Min Read Latency = 44 axi clock cycles
Max Read Latency = 656 axi clock cycles
Avg Read Latency = 438 axi clock cycles
Actual Achieved Read Bandwidth = 1964.395335 MBps
```
The design achieved a bandwidth around 2,000 MB/s, which is much less than our goal of 8,000.

To improve the performance of the design, a better understanding of the
DDR commands issued is required. The DDR signals can be viewed by
probing the nets in the responder model. The following screenshot shows the window to add the DDR signals into the waveform.

![Graphical user interface Description automatically
generated](media/image13.png)

After adding the signals, you can run simulation again and all the DDR
signals should be populated in the waveform. When simulation completes,
the waveform window will look as follows:

![A screenshot of a computer Description automatically generated with
medium confidence](media/image14.png)

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

A manual method of analysis would be to zoom into the waveform and
analyze the signals cycle-by-cycle with the command truth table to
understand what command is occurring at what time. However, this method
is both error-prone and time-intensive, hence we developed an in-house
RTL tool that can be added to an existing DDR4/LPDDR4/DDR5/LPDDR5 project to
visualize the commands in the waveform. Below is the procedure to
add the RTL module to the project.

# Manual Instantiation and Connection of the DDR4 Command_Decode.v

These are the steps to manually connect the module.

1. Use the **Add Sources** dialog, **Add or create design sources**, and **Add Files** to add `Command_Decode.v` into the project sources.
   Command_Decode.v an be found in CommandDecodeModuleFiles/DDR4 Files.

![Add Sources](media/add_sources.png)

**Note**: This tutorial illustrates the steps for DDR4.  For other memory types, use the Command_Decode that corresponds to that memory type.

2. Right click on **Command_Decode.v** and choose **Set Global Include**.

3. Click **Run Simulation**, and after generating all the necessary
items for simulation, Vivado will open the simulation window.

4. In the simulation window under the sources windowpane, expand the hierarchy as below to find the responder model; right click and
choose **Go to Source Code** to open the `.sv` file. The figure below highlights the option.


![Go to Source Code](media/image15.png)

Figure 1: Opening Responder Model Source Code

**Note**: For DDR5 and LPDDR5, the responder model is no longer embedded in the axi_noc.  Instead it will appear under design_1_wrapper_sim_wrapper->design_1_wrapper_i->design_1_i->ddrmc5_responder

5. In the responder model add the following output signals to the
module header. Refer to figure 2 below for the correct placement of the
signals.

```verilog
module bd_8be5_MC0_ddrc_0_phy_ddr_responder (
     input  [16 : 0]       ddr4_adr
    ,input  [1 : 0]         ddr4_bg
    ,input  [1 : 0]         ddr4_ba
    ,input  [0 : 0]        ddr4_cke
    ,input  [0 : 0]         ddr4_ck_t
    ,input  [0 : 0]         ddr4_ck_c
    ,input  [0 : 0]         ddr4_cs_n
    ,inout   [7 : 0]         ddr4_dm_dbi_n
    ,inout   [63 : 0]         ddr4_dq
    ,inout   [7 : 0]        ddr4_dqs_c
    ,inout   [7 : 0]        ddr4_dqs_t
    ,input  [0 : 0]        ddr4_odt
    ,input  ddr4_reset_n
    ,input  ddr4_act_n,
// DDR4 output signals added below this point
    ,output write 
    ,output read
    ,output prechargeSingle 
    ,output prechargeAll 
    ,output refresh
    ,output activate 
    ,output other
    ,output [16:0] write_c
    ,output [16:0] read_c
    ,output [16:0] prechargeSingle_c
    ,output [16:0] prechargeAll_c
    ,output [16:0] refresh_c
    ,output [16:0] activate_c
    ,output [16:0] other_c
    ,output [9:0] Column_adr
    ,output [16:0] Row_adr
);
```
Figure 2 : Adding DDR4 Output Signals to Responder Module

**Note**: This tutorial is for DDR4. If using this tool for LPDDR4, add the following signals:
```verilog
output write,  
output read,
output precharge,
output prechargeAll,
output refresh,
output refreshAll,
output activate,
output [9:0]  colAddrOut,
output [18:0] rowAddrOut,
output [2:0] BA,
output [16:0] write_c,
output [16:0] read_c,
output [16:0] precharge_c,
output [16:0] prechargeAll_c,
output [16:0] refresh_c,
output [16:0] refreshAll_c,
output [16:0] activate_c
```

For LPDDR5, add the following signals:
```verilog
output reg write16,
output reg write32,
output reg read16,
output reg read32,
output reg cas,
output reg precharge,
output reg prechargeAll,
output reg refresh,
output reg refreshAll,
output reg activate1,
output reg activate2,
output reg modeRegister1,
output reg modeRegister2,
output reg refreshManagement,
output reg autoPrecharge,
output reg maskWrite,
output reg [16:0] write_c,
output reg [16:0] read_c,
output reg [16:0] cas_c,
output reg [16:0] precharge_c,
output reg [16:0] prechargeAll_c,
output reg [16:0] refresh_c,
output reg [16:0] refreshAll_c,
output reg [16:0] activate1_c,
output reg [16:0] activate2_c,
output reg [16:0] refreshManagement_c,
output reg [16:0] modeRegister1_c,
output reg [16:0] modeRegister2_c
```

For DDR5, add the following signals:
```verilog
output writePattern,
output writePatternAutoPre,
output write,
output writeAutoPre,
output modeRegWrite,
output modeRegRead,
output read,
output readAutoPre,
output prechargeSameBank,
output prechargeAll,
output precharge,
output refreshManagementAll,
output refreshAll,
output refreshSameBank,
output refreshManagementSameBank,
output activate,
output [1:0] BA,
output [2:0] BG,
output [17:0] row,
output [10:0] col,
output [7:0] OP,
output [16:0] write_c,
output [16:0] read_c,
output [16:0] precharge_c,
output [16:0] prechargeAll_c,
output [16:0] refresh_c,
output [16:0] refreshAll_c,
output [16:0] activate_c,
output [16:0] refreshManagement_c,
output [16:0] modeRegRead_c,
output [16:0] modeRegWrite_c
```

6. Add the following line at the end of the file right before the
`endmodule` keyword in the responder. Refer to Figure 3 for the
placement of the instantiation.
For DDR4:
```verilog
,.ddr4_dqs_c(ddr4_dqs_c)
,.ddr4_dqs_t(ddr4_dqs_t)
,.ddr4_odt(ddr4_odt)
,.ddr4_reset_n(ddr4_reset_n)
,.ddr4_act_n(ddr4_act_n)     
);

Command_Decode Command_Decode (
    .CS_n(ddr4_cs_n), 
    .ACT_n(ddr4_act_n), 
    .adr(ddr4_adr), 
    .clk(ddr4_ck_t), 
    .write(write), 
    .read(read), 
    .prechargeSingle(prechargeSingle), 
    .prechargeAll(prechargeAll), 
    .refresh(refresh), 
    .activate(activate), 
    .other(other), 
    .write_c(write_count), 
    .read_c(read_count), 
    .prechargeSingle_c(prechargeSingle_count), 
    .prechargeAll_c(prechargeAll_count), 
    .refresh_c(refresh_count), 
    .activate_c(activate_count), 
    .other_c(other_count), 
    .Row_adr(Row_adr), 
    .Column_adr(Column_adr), 
    .ba(ddr4_ba), 
    .bg(ddr4_bg)
);

endmodule
```
Figure 3: Instantiating the DDR4 Decoder Module

**Note**: This tutorial is for DDR4. If using this tool for LPDDR4 add following instantiation:

```verilog
Command_Decode_LP Command_Decode_LP (
     .clk(lpddr4_ck_t_a),
     .CS(lpddr4_cs_a),
     .CA(lpddr4_ca_a),
     .write(write),
     .read(read),
     .precharge(precharge),
     .refresh(refresh),
     .prechargeAll(prechargeAll),
     .refreshAll(refreshAll),
     .activate(activate),
     .colAddrOut(colAddrOut),
     .rowAddrOut(rowAddrOut),
     .BA(BA),
     .write_c(write_count),
     .read_c(read_count),
     .precharge_c(precharge_count),
     .refresh_c(refresh_count),
     .activate_c(activate_count),
     .refreshAll_c(refreshAll_c),
     .prechargeAll_c(prechargeAll_c)
);
```

For LPDDR5, use the following:

```verilog
Command_Decode_LP5 Command_Decode_LP5(
     .clk(ch0_lpddr5_ck_t),
     .CS(ch0_lpddr5_cs),
     .CA(ch0_lpddr5_ca),
     .write16(write16),
     .write32(write32),
     .read16(read16),
     .read32(read32),
     .precharge(precharge),
     .prechargeAll(prechargeAll),
     .refresh(refresh),
     .refreshAll(refreshAll),
     .activate1(activate1),
     .activate2(activate2),
     .modeRegister1(modeRegister1),
     .modeRegister2(modeRegister2),
     .refreshManagement(refreshManagement),
     .autoPrecharge(autoPrecharge),
     .maskWrite(maskWrite),
     .write_c(write_c),
     .read_c(read_c),
     .cas_c(cas_c),
     .precharge_c(precharge_c),
     .prechargeAll_c(prechargeAll_c),
     .refresh_c(refresh_c),
     .refreshAll_c(refreshAll_c),
     .activate1_c(activate1_c),
     .activate2_c(activate2_c),
     .refreshManagement_c(refreshManagement_c),
     .modeRegister1_c(modeRegister1_c),
     .modeRegister2_c(modeRegister2_c)
);
```

For DDR5 component, UDIMM, or SODIMM, use the following:

```verilog
Command_Decode_DDR5 Command_Decode_DDR5(
.clk(ddr5_ck_t),
.CS(ddr5_cs_n),
.CA(ddr5_ca),
.writePattern(writePattern),
.writePatternAutoPre(writePatternAutoPre),
.write(write),
.writeAutoPre(writeAutoPre),
.modeRegWrite(modeRegWrite),
.modeRegRead(modeRegRead),
.read(read),
.readAutoPre(readAutoPre),
.prechargeSameBank(prechargeSameBank),
.prechargeAll(prechargeAll),
.precharge(precharge),
.refreshManagementAll(refreshManagementAll),
.refreshAll(refreshAll),
.refreshSameBank(refreshSameBank),
.refreshManagementSameBank(refreshManagementSameBank),
.activate(activate),
.BA(BA),
.BG(BG),
.row(row),
.col(col),
.OP(OP),
.write_c(write_c),
.read_c(read_c),
.precharge_c(precharge_c),
.prechargeAll_c(prechargeAll_c),
.refresh_c(refresh_c),
.refreshAll_c(refreshAll_c),
.activate_c(activate_c),
.refreshManagement_c(refreshManagement_c),
.modeRegRead_c(modeRegRead_c),
.modeRegWrite_c(modeRegWrite_c)
);
```

For DDR5 RDIMM, use the following:

```verilog
Command_Decode_DDR5_RDIMM Command_Decode_DDR5_RDIMM(
.clk(ddr5_ck_t),
.CS(ddr5_cs_n_a),
.CA(ddr5_ca_a),
.writePattern(writePattern),
.writePatternAutoPre(writePatternAutoPre),
.write(write),
.writeAutoPre(writeAutoPre),
.modeRegWrite(modeRegWrite),
.modeRegRead(modeRegRead),
.read(read),
.readAutoPre(readAutoPre),
.prechargeSameBank(prechargeSameBank),
.prechargeAll(prechargeAll),
.precharge(precharge),
.refreshManagementAll(refreshManagementAll),
.refreshAll(refreshAll),
.refreshSameBank(refreshSameBank),
.refreshManagementSameBank(refreshManagementSameBank),
.activate(activate),
.BA(BA),
.BG(BG),
.row(row),
.col(col),
.OP(OP),
.write_c(write_c),
.read_c(read_c),
.precharge_c(precharge_c),
.prechargeAll_c(prechargeAll_c),
.refresh_c(refresh_c),
.refreshAll_c(refreshAll_c),
.activate_c(activate_c),
.refreshManagement_c(refreshManagement_c),
.modeRegRead_c(modeRegRead_c),
.modeRegWrite_c(modeRegWrite_c)
);
```

7. Save changes.  If you rerun simulation now, Vivado will overwrite the changes you just made to the responder model.  To prevent this from happening, issue the following command in a linux window:
```csh
find <project_directory> -name <name of the file you just edited above> -print
```
For example, this might look something like what follows:
```csh
find project_1 -name bd_8be5_MC0_ddrc_0_phy_ddr_responder.sv -print
project_1/project_1.ip_user_files/bd/design_1/ip/design_1_axi_noc_0_0/bd_0/ip/ip_9/ip_0/hdl/bd_8be5_MC0_ddrc_0_phy_ddr_responder.sv
project_1/project_1.gen/sources_1/bd/design_1/ip/design_1_axi_noc_0_0/bd_0/ip/ip_9/ip_0/hdl/bd_8be5_MC0_ddrc_0_phy_ddr_responder.sv
```
Now copy the file we just edited to overwrite the other copy that was just found.  Sticking with the same example, this would look like:
```csh
cp project_1/project_1.ip_user_files/bd/design_1/ip/design_1_axi_noc_0_0/bd_0/ip/ip_9/ip_0/hdl/bd_8be5_MC0_ddrc_0_phy_ddr_responder.sv project_1/project_1.gen/sources_1/bd/design_1/ip/design_1_axi_noc_0_0/bd_0/ip/ip_9/ip_0/hdl/bd_8be5_MC0_ddrc_0_phy_ddr_responder.sv
```

8. Now click **Run Simulation** again.

9. After the waveform view opens up, on the left side open the
**Scope** tab and expand the hierarchy as shown in Figure 4.

![Graphical user interface, application Description automatically
generated](media/image18.png)

Figure 4: Hierarchy with Command Decode Module Instantiated and Connected

Click **Command_Decode**, and in the **Objects** tab, add the following
signals for DDR4:

![Scope with Command Decode](media/image19.png)

For LPDDR4: 

![Graphical user interface, application Description automatically
generated with medium
confidence](media/image25.PNG)

10. Click **Run All** to simulate.

**Note**: This process has to repeated to see the commands for the other memory controllers. In
most cases, designers can get a good understanding of their performance
by first instantiating this module on one MC.

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

When the waveform is populated, you can see the counts of the different
commands and when they occur. For this design, notice that the counts are:

![Graphical user interface, text, application, chat or text message
Description automatically
generated](media/image20.png)

From the above data, you can see that there are a tremendous number
of precharges and activates which are referred to as page misses. Page
misses reduce the overall bandwidth and are dependent on customizations
such as address mapping, number of memory controllers, channel
interleaving, and whether the TGs are writing and reading
data as systematically as possible. In this design the TGs, memory controllers, and address regions are customized to
meet the spec. The one major customization option that needs attention
is address mapping.

In this design, the address mapping option that was selected is the default
**ROW BANK COLUMN BG0**. The following screenshot of the CSV shows the
address regions targeted, and the screenshot of the address
mapping tab in Vivado shows how the bits are mapped for the default
mapping chosen before.

![](media/image21.png)

![Address Mapping Tab](media/address_mapping_tab.png)

Looking at the `base_addr` column, notice that bits 28 to 31
change from row to row as well as bit 32 which changes from 0 to 1. To
decrease the number of page misses, each of the TGs
should be accessing different banks. Arranging the address map such that
address bits 29 and 30 are mapped to the bank group bits, and address bits 31 and 32 are
mapped to the bank address bits will reduce the number of page misses. With
that in mind we came up with the following custom mapping.

![](media/image22.png)

To change the address mapping go back to the block design and double
click the NoC, then under the **DDR Address Mapping** tab, choose **User Defined
Address Map** and set to `2RA-2BA-2BG-14RA-10CA`. The following figure shows what this will
look like.

![Table Description automatically
generated](media/image23.png)

After changing the address mapping, you can re-run simulation and repeat
step 6 onwards to reinitialize the Command Decode module as mentioned in
the note of the **Manual Instantiation** section. With the modified address
mapping the counts after simulation are as follows.

![Text Description automatically
generated](media/image24.png)

Notice that the precharge and activate counts are significantly
lower than earlier when the default mapping was used.

The updated bandwidth from the performance monitor:

```csh
=========================================================
>>>>>> SRC_ID 0 :: AXI_PMON :: BW ANALYSIS >>>>>>
=========================================================
AXI Clock Period = 4000 ps
Min Write Latency = 23 axi clock cycles
Max Write Latency = 90 axi clock cycles
Avg Write Latency = 49 axi clock cycles
Actual Achieved Write Bandwidth = 7390.300231 MBps
***************************************************
Min Read Latency = 33 axi clock cycles
Max Read Latency = 156 axi clock cycles
Avg Read Latency = 86 axi clock cycles
Actual Achieved Read Bandwidth = 6881.720430 MBps
=========================================================
>>>>>> SRC_ID 1 :: AXI_PMON :: BW ANALYSIS >>>>>>
=========================================================
AXI Clock Period = 4000 ps
Min Write Latency = 22 axi clock cycles
Max Write Latency = 112 axi clock cycles
Avg Write Latency = 50 axi clock cycles
Actual Achieved Write Bandwidth = 7064.017660 MBps
***************************************************
Min Read Latency = 35 axi clock cycles
Max Read Latency = 144 axi clock cycles
Avg Read Latency = 85 axi clock cycles
Actual Achieved Read Bandwidth = 6896.551724 MBps
=========================================================
>>>>>> SRC_ID 2 :: AXI_PMON :: BW ANALYSIS >>>>>>
=========================================================
AXI Clock Period = 4000 ps
Min Write Latency = 30 axi clock cycles
Max Write Latency = 110 axi clock cycles
Avg Write Latency = 60 axi clock cycles
Actual Achieved Write Bandwidth = 7064.017660 MBps
***************************************************
Min Read Latency = 33 axi clock cycles
Max Read Latency = 161 axi clock cycles
Avg Read Latency = 95 axi clock cycles
Actual Achieved Read Bandwidth = 6830.309498 MBps
=========================================================
>>>>>> SRC_ID 3 :: AXI_PMON :: BW ANALYSIS >>>>>>
=========================================================
AXI Clock Period = 4000 ps
Min Write Latency = 23 axi clock cycles
Max Write Latency = 85 axi clock cycles
Avg Write Latency = 48 axi clock cycles
Actual Achieved Write Bandwidth = 7331.042383 MBps
***************************************************
Min Read Latency = 33 axi clock cycles
Max Read Latency = 158 axi clock cycles
Avg Read Latency = 91 axi clock cycles
Actual Achieved Read Bandwidth = 6859.592712 MBps
=========================================================
>>>>>> SRC_ID 4 :: AXI_PMON :: BW ANALYSIS >>>>>>
=========================================================
AXI Clock Period = 4000 ps
Min Write Latency = 21 axi clock cycles
Max Write Latency = 100 axi clock cycles
Avg Write Latency = 47 axi clock cycles
Actual Achieved Write Bandwidth = 7314.285714 MBps
***************************************************
Min Read Latency = 34 axi clock cycles
Max Read Latency = 147 axi clock cycles
Avg Read Latency = 83 axi clock cycles
Actual Achieved Read Bandwidth = 6889.128095 MBps
=========================================================
>>>>>> SRC_ID 5 :: AXI_PMON :: BW ANALYSIS >>>>>>
=========================================================
AXI Clock Period = 4000 ps
Min Write Latency = 19 axi clock cycles
Max Write Latency = 125 axi clock cycles
Avg Write Latency = 73 axi clock cycles
Actual Achieved Write Bandwidth = 6639.004149 MBps
***************************************************
Min Read Latency = 36 axi clock cycles
Max Read Latency = 131 axi clock cycles
Avg Read Latency = 79 axi clock cycles
Actual Achieved Read Bandwidth = 6933.911159 MBps
```

Analyzing the bandwidth statistics also shows significantly higher bandwidth using the custom address mapping. The
bandwidth is much closer to that requested than without custom address
mapping. After simulating the original design and using the Command
Decode module you were able to analyze the DDR commands and determine
whether the chosen address mapping can be further optimized. If
simulation was skipped and the design was directly tested on hardware,
the debug time to reach the spec would be significantly longer.

# Revision history

* June 2023 - Initial Release.
* March 2026 - Updated for 2025.2

<p dir="auto" align="center"><br>Copyright © 2023-2026 Advanced Micro Devices, Inc<br></p>

<p dir="auto" align="center"><br><sup>XD200</sup><br></p>
