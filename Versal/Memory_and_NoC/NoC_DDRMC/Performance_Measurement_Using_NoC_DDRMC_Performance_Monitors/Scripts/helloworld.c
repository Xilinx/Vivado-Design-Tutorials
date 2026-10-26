/******************************************************************************
* Copyright(C) 2025 Advanced Micro Devices, Inc. All rights reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */


#include <stdio.h>
#include "platform.h"
#include "/group/siapps/tvura/PerfMonitorTutorial/project_3/Vck190_platform/export/Vck190_platform/sw/standalone_psv_cortexa72_0/include/xil_printf.h"
#include "/group/siapps/tvura/PerfMonitorTutorial/project_3/Vck190_platform/export/Vck190_platform/sw/standalone_psv_cortexa72_0/include/xil_io.h"
#include "/group/siapps/tvura/PerfMonitorTutorial/project_3/Vck190_platform/export/Vck190_platform/sw/standalone_psv_cortexa72_0/include/sleep.h"

int main()
{
    

    init_platform();

    print("Performance Monitor Outputs\n\r");
    //print("Successfully ran Hello World application\n\r");



    u64 reg_perf_mon_burst_count_npi = 0, reg_perf_mon_burst_count = 0;  
    float timebaseOver22 = 0, NPIFreqMHz = 0, NMU_X0Y6_BW = 0, NMU_X0Y3_BW = 0, NMU_X0Y1_BW = 0, NMU_X2Y6_BW = 0, NMU_X2Y5_BW = 0, NMU_X0Y4_BW = 0;  
  
    printf("AXI NoC_1 NMUs (Linear Traffic)\n");  
  
    // NMU_X0Y6  
    Xil_Out32(0xF6F6000C, 0xF9E8D7C6);  
    Xil_Out32(0xF6F6088C, 0x0000000B);  
    Xil_Out32(0xF6F608AC, 0x00000003);  
    sleep(20);  
    reg_perf_mon_burst_count_npi = Xil_In32(0xF6F60880);  
    reg_perf_mon_burst_count = reg_perf_mon_burst_count_npi;  
    timebaseOver22 = (float)(1 << 22);  
    NPIFreqMHz = 300.00;  
    NMU_X0Y6_BW = (reg_perf_mon_burst_count * 256 * NPIFreqMHz) / timebaseOver22;  
    printf("NMU512_X0Y6 Write BW %f \r\n", NMU_X0Y6_BW);  
    reg_perf_mon_burst_count_npi = Xil_In32(0xF6F608A0);  
    reg_perf_mon_burst_count = reg_perf_mon_burst_count_npi;  
    NMU_X0Y6_BW = (reg_perf_mon_burst_count * 256 * NPIFreqMHz) / timebaseOver22;  
    printf("NMU512_X0Y6 Read BW %f \r\n", NMU_X0Y6_BW);  
  
    // NMU_X0Y3  
    Xil_Out32(0xF6EE000C, 0xF9E8D7C6);  
    Xil_Out32(0xF6EE088C, 0x0000000B);  
    Xil_Out32(0xF6EE08AC, 0x00000003);  
    sleep(20);  
    reg_perf_mon_burst_count_npi = Xil_In32(0xF6EE0880);  
    reg_perf_mon_burst_count = reg_perf_mon_burst_count_npi;  
    NMU_X0Y3_BW = (reg_perf_mon_burst_count * 256 * NPIFreqMHz) / timebaseOver22;  
    printf("NMU512_X0Y3 Write BW %f \r\n", NMU_X0Y3_BW);  
    reg_perf_mon_burst_count_npi = Xil_In32(0xF6EE08A0);  
    reg_perf_mon_burst_count = reg_perf_mon_burst_count_npi;  
    NMU_X0Y3_BW = (reg_perf_mon_burst_count * 256 * NPIFreqMHz) / timebaseOver22;  
    printf("NMU512_X0Y3 Read BW %f \r\n", NMU_X0Y3_BW);  
  
    // NMU_X0Y1  
    Xil_Out32(0xF6E9000C, 0xF9E8D7C6);  
    Xil_Out32(0xF6E9088C, 0x0000000B);  
    Xil_Out32(0xF6E908AC, 0x00000003);  
    sleep(20);  
    reg_perf_mon_burst_count_npi = Xil_In32(0xF6E90880);  
    reg_perf_mon_burst_count = reg_perf_mon_burst_count_npi;  
    NMU_X0Y1_BW = (reg_perf_mon_burst_count * 256 * NPIFreqMHz) / timebaseOver22;  
    printf("NMU512_X0Y1 Write BW %f \r\n", NMU_X0Y1_BW);  
    reg_perf_mon_burst_count_npi = Xil_In32(0xF6E908A0);  
    reg_perf_mon_burst_count = reg_perf_mon_burst_count_npi;  
    NMU_X0Y1_BW = (reg_perf_mon_burst_count * 256 * NPIFreqMHz) / timebaseOver22;  
    printf("NMU512_X0Y1 Read BW %f \r\n", NMU_X0Y1_BW);  
  
    printf("AXI NoC_3 NMUs (Random Traffic)\n");  
  
    // NMU_X2Y6  
    Xil_Out32(0xF6BC000C, 0xF9E8D7C6);  
    Xil_Out32(0xF6BC08AC, 0x00000003);  
    sleep(20);
    reg_perf_mon_burst_count_npi = Xil_In32(0xF6BC08A0);  
    reg_perf_mon_burst_count = reg_perf_mon_burst_count_npi;  
    NMU_X2Y6_BW = (reg_perf_mon_burst_count * 128 * NPIFreqMHz) / timebaseOver22;  
    printf("NMU512_X2Y6 Read BW %f \r\n", NMU_X2Y6_BW);  
  
    // NMU_X2Y5  
    Xil_Out32(0xF6B9000C, 0xF9E8D7C6);  
    Xil_Out32(0xF6B9088C, 0x0000000B);  
    Xil_Out32(0xF6B908AC, 0x00000003);  
    sleep(20);  
    reg_perf_mon_burst_count_npi = Xil_In32(0xF6B90880);  
    reg_perf_mon_burst_count = reg_perf_mon_burst_count_npi;  
    NMU_X2Y5_BW = (reg_perf_mon_burst_count * 128 * NPIFreqMHz) / timebaseOver22;  
    printf("NMU512_X2Y5 Write BW %f \r\n", NMU_X2Y5_BW);  
    reg_perf_mon_burst_count_npi = Xil_In32(0xF6B908A0);  
    reg_perf_mon_burst_count = reg_perf_mon_burst_count_npi;  
    NMU_X2Y5_BW = (reg_perf_mon_burst_count * 128 * NPIFreqMHz) / timebaseOver22;  
    printf("NMU512_X2Y5 Read BW %f \r\n", NMU_X2Y5_BW);  
  
    // NMU_X0Y4  
    Xil_Out32(0xF6F1000C, 0xF9E8D7C6);  
    Xil_Out32(0xF6F108AC, 0x00000003);  
    sleep(20);  
    reg_perf_mon_burst_count_npi = Xil_In32(0xF6F10880);  
    reg_perf_mon_burst_count = reg_perf_mon_burst_count_npi;  
    NMU_X0Y4_BW = (reg_perf_mon_burst_count * 128 * NPIFreqMHz) / timebaseOver22;  
    printf("NMU512_X0Y4 Write BW %f \r\n", NMU_X0Y4_BW);  
    reg_perf_mon_burst_count_npi = Xil_In32(0xF6F108A0);    
    reg_perf_mon_burst_count = reg_perf_mon_burst_count_npi;  
    NMU_X0Y4_BW = (reg_perf_mon_burst_count * 128 * NPIFreqMHz) / timebaseOver22;  
    printf("NMU512_X0Y4 Read BW %f \r\n", NMU_X0Y4_BW); 


    //DDRMC_NoC Module
    u64 c1Ch0BERBurstCount, c1Ch0BEWBurstCount, c1Ch1BERBurstCount, c1Ch1BEWBurstCount;  
    u64 c1Ch2BERBurstCount, c1Ch2BEWBurstCount, c1Ch3BERBurstCount, c1Ch3BEWBurstCount;  
    u64 c3Ch0BERBurstCount, c3Ch0BEWBurstCount, c3Ch1BERBurstCount, c3Ch1BEWBurstCount;  
    u64 c3Ch2BERBurstCount, c3Ch2BEWBurstCount, c3Ch3BERBurstCount, c3Ch3BEWBurstCount;  
    float c1Ch0BERBW, c1Ch1BERBW, c1Ch2BERBW, c1Ch3BERBW;  
    float c3Ch0BERBW, c3Ch1BERBW, c3Ch2BERBW, c3Ch3BERBW;  
    float c1Ch0BEWBW, c1Ch1BEWBW, c1Ch2BEWBW, c1Ch3BEWBW;  
    float c3Ch0BEWBW, c3Ch1BEWBW, c3Ch2BEWBW, c3Ch3BEWBW;  
    float NoCFreqMHz = 1000.00;  
    float timebaseOver16 = (float)(1 << 21);  
  
    // Unlock DDRMC_NOC_1 and 3 NPI registers pcsr_lock  
    Xil_Out32(0xF621000C, 0xF9E8D7C6);  
    Xil_Out32(0xF64F000C, 0xF9E8D7C6);  
  
    // Change all four timebases from default 0x17 to 0x19  
    Xil_Out32(0xF62104D4, 0x000CE739);  
    Xil_Out32(0xF64F04D4, 0x000CE739);  
  
    // Disable counters nsu0_perf_mon_ctl_0_0, nsu0_perf_mon_ctl_1_0, nsu1_perf_mon_ctl_0_0, nsu1_perf_mon_ctl_1_0,  
    // nsu2_perf_mon_ctl_0_0, nsu2_perf_mon_ctl_1_0, nsu3_perf_mon_ctl_0_0, nsu3_perf_mon_ctl_1_0  
    Xil_Out32(0xF62104D8, 0x0); Xil_Out32(0xF62104F8, 0x0);  
    Xil_Out32(0xF6210518, 0x0); Xil_Out32(0xF6210538, 0x0);  
    Xil_Out32(0xF6210558, 0x0); Xil_Out32(0xF6210578, 0x0);  
    Xil_Out32(0xF6210598, 0x0); Xil_Out32(0xF62105B8, 0x0);  
    Xil_Out32(0xF64F04D8, 0x0); Xil_Out32(0xF64F04F8, 0x0);  
    Xil_Out32(0xF64F0518, 0x0); Xil_Out32(0xF64F0538, 0x0);  
    Xil_Out32(0xF64F0558, 0x0); Xil_Out32(0xF64F0578, 0x0);  
    Xil_Out32(0xF64F0598, 0x0); Xil_Out32(0xF64F05B8, 0x0);  
  
    // Set perf_mon_0 to BER and perf_mon_1 to BEW  
    Xil_Out32(0xF62104DC, 0x023); Xil_Out32(0xF62104FC, 0x083);  
    Xil_Out32(0xF621051C, 0x023); Xil_Out32(0xF621053C, 0x083);  
    Xil_Out32(0xF621055C, 0x023); Xil_Out32(0xF621057C, 0x083);  
    Xil_Out32(0xF621059C, 0x023); Xil_Out32(0xF62105BC, 0x083);  
    Xil_Out32(0xF64F04DC, 0x023); Xil_Out32(0xF64F04FC, 0x083);  
    Xil_Out32(0xF64F051C, 0x023); Xil_Out32(0xF64F053C, 0x083);  
    Xil_Out32(0xF64F055C, 0x023); Xil_Out32(0xF64F057C, 0x083);  
    Xil_Out32(0xF64F059C, 0x023); Xil_Out32(0xF64F05BC, 0x083);  
  
    // Clear counters nsu[01]_perf_mon_[01]*  
    Xil_Out32(0xF62104EC, 0x0); Xil_Out32(0xF621050C, 0x0);  
    Xil_Out32(0xF621052C, 0x0); Xil_Out32(0xF621054C, 0x0);  
    Xil_Out32(0xF621056C, 0x0); Xil_Out32(0xF621058C, 0x0);  
    Xil_Out32(0xF62105AC, 0x0); Xil_Out32(0xF62105CC, 0x0);  
    Xil_Out32(0xF64F04EC, 0x0); Xil_Out32(0xF64F050C, 0x0);  
    Xil_Out32(0xF64F052C, 0x0); Xil_Out32(0xF64F054C, 0x0);  
    Xil_Out32(0xF64F056C, 0x0); Xil_Out32(0xF64F058C, 0x0);  
    Xil_Out32(0xF64F05AC, 0x0); Xil_Out32(0xF64F05CC, 0x0);  
  
    // Start counters nsu[01]_perf_mon_[01]  
    Xil_Out32(0xF62104D8, 0x1); Xil_Out32(0xF62104F8, 0x1);  
    Xil_Out32(0xF6210518, 0x1); Xil_Out32(0xF6210538, 0x1);  
    Xil_Out32(0xF6210558, 0x1); Xil_Out32(0xF6210578, 0x1);  
    Xil_Out32(0xF6210598, 0x1); Xil_Out32(0xF62105B8, 0x1);  
    Xil_Out32(0xF64F04D8, 0x1); Xil_Out32(0xF64F04F8, 0x1);  
    Xil_Out32(0xF64F0518, 0x1); Xil_Out32(0xF64F0538, 0x1);  
    Xil_Out32(0xF64F0558, 0x1); Xil_Out32(0xF64F0578, 0x1);  
    Xil_Out32(0xF64F0598, 0x1); Xil_Out32(0xF64F05B8, 0x1);  
  
    // Sleep for 50ms  
    sleep(100);  
  
    // Print perfmon register contents  
    printf("\nPrinting after enabling counts...\n");  
  
    // Sleep for 50ms  
    sleep(100);  
  
    // Read and print the register contents  
    c1Ch0BERBurstCount = Xil_In32(0xF62104F0);  
    c1Ch0BEWBurstCount = Xil_In32(0xF6210510);  
    c1Ch1BERBurstCount = Xil_In32(0xF6210530);  
    c1Ch1BEWBurstCount = Xil_In32(0xF6210550);  
    c1Ch2BERBurstCount = Xil_In32(0xF6210570);  
    c1Ch2BEWBurstCount = Xil_In32(0xF6210590);  
    c1Ch3BERBurstCount = Xil_In32(0xF62105B0);  
    c1Ch3BEWBurstCount = Xil_In32(0xF62105D0);  
    c3Ch0BERBurstCount = Xil_In32(0xF64F04F0);  
    c3Ch0BEWBurstCount = Xil_In32(0xF64F0510);  
    c3Ch1BERBurstCount = Xil_In32(0xF64F0530);  
    c3Ch1BEWBurstCount = Xil_In32(0xF64F0550);  
    c3Ch2BERBurstCount = Xil_In32(0xF64F0570);  
    c3Ch2BEWBurstCount = Xil_In32(0xF64F0590);  
    c3Ch3BERBurstCount = Xil_In32(0xF64F05B0);  
    c3Ch3BEWBurstCount = Xil_In32(0xF64F05D0);  
  
    // Calculate and print the bandwidth  
    c1Ch0BERBW = (c1Ch0BERBurstCount * NoCFreqMHz) / timebaseOver16;  
    c1Ch1BERBW = (c1Ch1BERBurstCount * NoCFreqMHz) / timebaseOver16;  
    c1Ch2BERBW = (c1Ch2BERBurstCount * NoCFreqMHz) / timebaseOver16;  
    c1Ch3BERBW = (c1Ch3BERBurstCount * NoCFreqMHz) / timebaseOver16;  
    c3Ch0BERBW = (c3Ch0BERBurstCount * NoCFreqMHz) / timebaseOver16;  
    c3Ch1BERBW = (c3Ch1BERBurstCount * NoCFreqMHz) / timebaseOver16;  
    c3Ch2BERBW = (c3Ch2BERBurstCount * NoCFreqMHz) / timebaseOver16;  
    c3Ch3BERBW = (c3Ch3BERBurstCount * NoCFreqMHz) / timebaseOver16;  
  
    printf("DDRMC_1 Port 0 Read BW %f\n", c1Ch0BERBW);  
    printf("DDRMC_1 Port 1 Read BW %f\n", c1Ch1BERBW);  
    printf("DDRMC_1 Port 2 Read BW %f\n", c1Ch2BERBW);  
    printf("DDRMC_1 Port 3 Read BW %f\n", c1Ch3BERBW);  
    printf("DDRMC_3 Port 0 Read BW %f\n", c3Ch0BERBW);  
    printf("DDRMC_3 Port 1 Read BW %f\n", c3Ch1BERBW);  
    printf("DDRMC_3 Port 2 Read BW %f\n", c3Ch2BERBW);  
    printf("DDRMC_3 Port 3 Read BW %f\n", c3Ch3BERBW);  
  
    c1Ch0BEWBW = (c1Ch0BEWBurstCount * NoCFreqMHz) / timebaseOver16;  
    c1Ch1BEWBW = (c1Ch1BEWBurstCount * NoCFreqMHz) / timebaseOver16;  
    c1Ch2BEWBW = (c1Ch2BEWBurstCount * NoCFreqMHz) / timebaseOver16;  
    c1Ch3BEWBW = (c1Ch3BEWBurstCount * NoCFreqMHz) / timebaseOver16;  
    c3Ch0BEWBW = (c3Ch0BEWBurstCount * NoCFreqMHz) / timebaseOver16;  
    c3Ch1BEWBW = (c3Ch1BEWBurstCount * NoCFreqMHz) / timebaseOver16;  
    c3Ch2BEWBW = (c3Ch2BEWBurstCount * NoCFreqMHz) / timebaseOver16;  
    c3Ch3BEWBW = (c3Ch3BEWBurstCount * NoCFreqMHz) / timebaseOver16;  
  
    printf("DDRMC_1 Port 0 Write BW %f\n", c1Ch0BEWBW);  
    printf("DDRMC_1 Port 1 Write BW %f\n", c1Ch1BEWBW);  
    printf("DDRMC_1 Port 2 Write BW %f\n", c1Ch2BEWBW);  
    printf("DDRMC_1 Port 3 Write BW %f\n", c1Ch3BEWBW);  
    printf("DDRMC_3 Port 0 Write BW %f\n", c3Ch0BEWBW);  
    printf("DDRMC_3 Port 1 Write BW %f\n", c3Ch1BEWBW);  
    printf("DDRMC_3 Port 2 Write BW %f\n", c3Ch2BEWBW);  
    printf("DDRMC_3 Port 3 Write BW %f\n", c3Ch3BEWBW);  



    //DDRMC Main Bandwidth Calculations 
    u64 c1Ch0RdCount, c1Ch0WrCount, c1Ch1RdCount, c1Ch1WrCount;  
    u64 c3Ch0RdCount, c3Ch0WrCount, c3Ch1RdCount, c3Ch1WrCount;  
    float c1Ch0RdBW, c1Ch0WrBW, c1Ch1RdBW, c1Ch1WrBW;  
    float c3Ch0RdBW, c3Ch0WrBW, c3Ch1RdBW, c3Ch1WrBW;  
    float MCClockFreqMHz = 1949.00 / 2;  
    float MCClockFreqMHzTimes64 = 64.0 * MCClockFreqMHz;  
    float timebaseDiv2 = (float)(1u << 31);  
  
    // Unlock DDRMC_MAIN_1 and 3 NPI registers pcsr_lock  
    Xil_Out32(0xF62C000C, 0xF9E8D7C6);  
    Xil_Out32(0xF65A000C, 0xF9E8D7C6);  
  
    // Disable counters dc0_perf_mon and dc1_perf_mon  
    Xil_Out32(0xF62C13C0, 0x3E); Xil_Out32(0xF62C13E8, 0x3E);  
    Xil_Out32(0xF65A13C0, 0x3E); Xil_Out32(0xF65A13E8, 0x3E);  
  
    // Clear counters dc0_perf_mon_accu_0 to dc1_perf_mon_8_hi  
    for (int i = 0; i < 9; i++) {  
        Xil_Out32(0xF62C13C4 + i * 4, 0x0);  
        Xil_Out32(0xF62C13EC + i * 4, 0x0);  
        Xil_Out32(0xF65A13C4 + i * 4, 0x0);  
        Xil_Out32(0xF65A13EC + i * 4, 0x0);  
    }  
  
    // Start counters dc0_perf_mon and dc1_perf_mon  
    Xil_Out32(0xF62C13C0, 0x3F); Xil_Out32(0xF62C13E8, 0x3F);  
    Xil_Out32(0xF65A13C0, 0x3F); Xil_Out32(0xF65A13E8, 0x3F);  
  
    // Sleep for 100ms  
    sleep(120);  
  
    // Read the register contents  
    c1Ch0RdCount = Xil_In32(0xF62C13C8);  
    c1Ch0WrCount = Xil_In32(0xF62C13CC);  
    c1Ch1RdCount = Xil_In32(0xF62C13F0);  
    c1Ch1WrCount = Xil_In32(0xF62C13F4);  
    c3Ch0RdCount = Xil_In32(0xF65A13C8);  
    c3Ch0WrCount = Xil_In32(0xF65A13CC);  
    c3Ch1RdCount = Xil_In32(0xF65A13F0);  
    c3Ch1WrCount = Xil_In32(0xF65A13F4);  
  
    // Calculate and print the bandwidth  
    c1Ch0RdBW = (c1Ch0RdCount * MCClockFreqMHzTimes64) / timebaseDiv2;  
    c1Ch0WrBW = (c1Ch0WrCount * MCClockFreqMHzTimes64) / timebaseDiv2;  
    c1Ch1RdBW = (c1Ch1RdCount * MCClockFreqMHzTimes64) / timebaseDiv2;  
    c1Ch1WrBW = (c1Ch1WrCount * MCClockFreqMHzTimes64) / timebaseDiv2;  
    c3Ch0RdBW = (c3Ch0RdCount * MCClockFreqMHzTimes64) / timebaseDiv2;  
    c3Ch0WrBW = (c3Ch0WrCount * MCClockFreqMHzTimes64) / timebaseDiv2;  
    c3Ch1RdBW = (c3Ch1RdCount * MCClockFreqMHzTimes64) / timebaseDiv2;  
    c3Ch1WrBW = (c3Ch1WrCount * MCClockFreqMHzTimes64) / timebaseDiv2;  
  
    printf("DDRMC_1 Channel 0 Read BW %f\n", c1Ch0RdBW);  
    printf("DDRMC_1 Channel 0 Write BW %f\n", c1Ch0WrBW);  
    printf("DDRMC_1 Channel 1 Read BW %f\n", c1Ch1RdBW);  
    printf("DDRMC_1 Channel 1 Write BW %f\n", c1Ch1WrBW);  
    printf("DDRMC_3 Channel 0 Read BW %f\n", c3Ch0RdBW);  
    printf("DDRMC_3 Channel 0 Write BW %f\n", c3Ch0WrBW);  
    printf("DDRMC_3 Channel 1 Read BW %f\n", c3Ch1RdBW);  
    printf("DDRMC_3 Channel 1 Write BW %f\n", c3Ch1WrBW); 














    cleanup_platform();
    return 0;







}
