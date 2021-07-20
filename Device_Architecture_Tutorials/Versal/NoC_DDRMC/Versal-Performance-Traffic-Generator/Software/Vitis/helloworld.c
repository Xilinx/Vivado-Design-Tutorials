/*
# Copyright 2020 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
*/

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
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_io.h"
#include "xgpio.h"

#define Gpio_out 0x01

#define GPIO_EXAMPLE_DEVICE_ID  XPAR_GPIO_0_DEVICE_ID

XGpio Gpio;

#define ptg_baseaddr 0xA4000000


int main()
{

	//read
	//	unsigned int *ptg_load_instr1[] = {0x3E000000,0x00000000,0x00000000,0x00000000,0x00000000,0x1ffffffe,0x00000000,0x00000000,0x00000040,0x8032002a,0x00001};
	//	unsigned int *ptg_load_instr2[] = {0x00000000,0x00002000,0x00000000,0x00000000,0x00000000,0x1ffffffe,0x00000000,0x00000000,0x00000040,0x0032002a,0x00001};

	// write
	unsigned int *ptg_load_instr1[] = {0x3E200000,0x00080000,0x00000000,0x00000000,0x00000000,0x1ffffffe,0x00000000,0x00000000,0x00000040,0x8032002a,0x00001,0x00000404};
	unsigned int *ptg_load_instr2[] = {0x00000000,0x00002000,0x00000000,0x00000000,0x00000000,0x1ffffffe,0x00000000,0x00000000,0x00000040,0x0032002a,0x00001};

	unsigned int bram_addr=0x00008000;
	unsigned int load_addr=0x00000000;
	char check_input;
	int Status;
	XGpio_Config *ConfigPtr;
	int loop;

	init_platform();

    	print("Hello World\n\r");
	Status = XGpio_Initialize(&Gpio, GPIO_EXAMPLE_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Gpio Initialization Failed\r\n");
		return XST_FAILURE;
	}

	/* Set the direction for all signals as inputs except the LED output */
	XGpio_SetDataDirection(&Gpio,1,~Gpio_out);
    	print("loading PTG parameters");

    	// reset performance traffic generator
    	Xil_Out32(0xA4004000,0x00000000);
    	Xil_Out32(0xA4004000,0x00000001);
    	load_addr = ptg_baseaddr+0x00008000;
    	for (loop=0;loop<12;loop++,load_addr+=4)
    	{
    		Xil_Out32(load_addr,ptg_load_instr1[loop]);
    	}
    	load_addr = ptg_baseaddr+0x00008040;
    	for (loop=0;loop<12;loop++,load_addr+=4)
        {
        	Xil_Out32(load_addr,ptg_load_instr2[loop]);

        }
   	 //start TG
    	Xil_Out32(ptg_baseaddr+0x4004,0x00000001);
    	XGpio_DiscreteWrite(&Gpio,1, Gpio_out);

    	cleanup_platform();
    	return 0;
}
