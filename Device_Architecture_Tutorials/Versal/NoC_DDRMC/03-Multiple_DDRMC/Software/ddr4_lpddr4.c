// Copyright 2020 Xilinx Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"

#define DDR4_BASEADDR XPAR_AXI_NOC_DDR_LOW_0_BASEADDR
#define LPDDR4_BASEADDR XPAR_AXI_NOC_DDR_CH_1_BASEADDR

int main()
{

    init_platform();

    xil_printf("Versal Multiple DDRMCs Example Design\n\r");
    xil_printf("DDR4 Write Access \r\n");
    for(int i=0; i<10; i++)
    {
    	Xil_Out64(DDR4_BASEADDR + (8 * i),i);
    	xil_printf("0x%p  :  0x%x\r\n",DDR4_BASEADDR + (8 * i),i);
    }

    xil_printf("DDR4 Read Access \r\n");
    for(int i=0; i<10; i++)
    {
		xil_printf("0x%p  :  0x%x\r\n",DDR4_BASEADDR + (8 * i),Xil_In64(DDR4_BASEADDR + (8 * i)));
	}

    xil_printf("LPDDR4 Write Access \r\n");
    for(int i=0; i<10; i++)
    {
    	Xil_Out64(LPDDR4_BASEADDR + (8 * i),i);
    	xil_printf("0x%p  :  0x%x\r\n",LPDDR4_BASEADDR + (8 * i),i);
    }

    xil_printf("LPDDR4 Read Access \r\n");
    for(int i=0; i<10; i++)
    {
		xil_printf("0x%p  :  0x%x\r\n",LPDDR4_BASEADDR + (8 * i),Xil_In64(LPDDR4_BASEADDR + (8 * i)));
	}

    cleanup_platform();
    return 0;
}