/******************************************************************************
*© Copyright 2021 Xilinx, Inc.

*Licensed under the Apache License, Version 2.0 (the "License");
*you may not use this file except in compliance with the License.
*You may obtain a copy of the License at

*    http://www.apache.org/licenses/LICENSE-2.0

*Unless required by applicable law or agreed to in writing, software
*distributed under the License is distributed on an "AS IS" BASIS,
*WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*See the License for the specific language governing permissions and
*limitations under the License.
******************************************************************************/


#include <stdio.h>
#include "xparameters.h"
#include "xil_printf.h"
#include "xuartps.h"


int main()
{
    //init_platform();

    XUartPs Uart_PS;		/* Instance of the UART Device */
    static u8 RecvBuffer[8];
    XUartPs_Config *Config;

    int *read_output_data;
    int *led_output;
    int *constant_data;
    int *output_data;
    int *dfx_shutdown_mgr;

    int Status;
    int i;
    int choice;

    int data_read;
    int count;
    u8 Input;

	Config = XUartPs_LookupConfig(XPAR_XUARTPS_0_DEVICE_ID);
	if (NULL == Config) {
		return XST_FAILURE;
	}

	Status = XUartPs_CfgInitialize(&Uart_PS, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	read_output_data = XPAR_AXI_GPIO_0_BASEADDR;
    led_output =  XPAR_AXI_GPIO_0_BASEADDR + 0x8;
    constant_data = XPAR_HIER_1_AXI_GPIO_1_BASEADDR;
    output_data = XPAR_HIER_1_AXI_GPIO_1_BASEADDR + 0x8;
    dfx_shutdown_mgr = XPAR_DFX_AXI_SHUTDOWN_MAN_0_BASEADDR;

    count = 0;

    xil_printf("\n\r\n\r ** DFX Shutdown application **\n\r\n\r");

    while(1){

		*led_output = count++;

		xil_printf("\n\r** DFX Shutdown Manager Menu **\n\r\n\r");
		xil_printf(" 1 - Read RM's constant value\n\r");
		xil_printf(" 2 - Write RM's output data (sets it to 0x12)\n\r");
		xil_printf(" 3 - Read output data from RM\n\r");
		xil_printf(" 4 - Read shutdown manager status register\n\r");
		xil_printf(" 5 - Enable shutdown manager\n\r");
		xil_printf(" 6 - Disable shutdown manager\n\r");
		xil_printf(" 7 - Increment LED output\n\r");
		xil_printf(" 8 - Increment LED output and read constant output data for 10 seconds\n\r");
		xil_printf("\n\r\n\r Choice: ");

		choice = 0;
		while (choice == 0){
			if (XUartPs_Recv(&Uart_PS, &RecvBuffer[0], 8)){
				choice = 1;
				Input = RecvBuffer[0];
				xil_printf("%s\n\r\n\r", RecvBuffer);
				switch(Input){
					case ('1') :
							data_read = *constant_data;
							xil_printf("    Constant = 0x%x\n\r", data_read);
							break;

					case ('2') :
							*output_data = 0x12;
							xil_printf("    Output data set to 0x12\n\r");
							break;

					case ('3') :
							data_read = *read_output_data;
							xil_printf("    Output data from RM = 0x%x\n\r", data_read);
							break;

					case ('4') :
					    data_read = *dfx_shutdown_mgr; //read status register
						xil_printf("    Shutdown Manager status = 0x%x\n\r", data_read);
						break;

					case ('5') :
						*dfx_shutdown_mgr = 0x1; //enable Shutdown manager
						data_read = *dfx_shutdown_mgr; //read status register
						xil_printf("    Shutdown Manager enabled, status = 0x%x\n\r", data_read);
						break;

					case ('6') :
						*dfx_shutdown_mgr = 0x0;
						data_read = *dfx_shutdown_mgr; //read status register
						xil_printf("    Shutdown Manager disabled, status = 0x%x\n\r", data_read);
						break;

					case ('7') :
						*led_output = count++;
						xil_printf("    LED outputs incremented\n\r");
						break;

					case ('8') :
						for (i = 0; i < 20; i++){
							*led_output = count++;
							xil_printf("    LED output increment %d\n\r", i+1);
							data_read = *constant_data;
							xil_printf("    Constant = 0x%x\n\r", data_read);
							data_read = *read_output_data;
							xil_printf("    Output data from RM = 0x%x\n\r", data_read);
							usleep(500000);
						}
						break;


					default :
						xil_printf("Unknown option\n\r");
						break;

				}

			}

		}
    }

    xil_printf("Exiting application\n\r");

    //cleanup_platform();
    return 0;
}
