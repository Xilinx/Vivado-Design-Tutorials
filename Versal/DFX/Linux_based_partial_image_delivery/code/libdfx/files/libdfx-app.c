/*
Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
SPDX-License-Identifier: X11
*/

/*This example programs the FPGA to have The base FPGA Region(static)
 * with  One PR region (This PR region has two RM's).
 *
 * Configure Base Image
 * 	-->Also called the "static image"
 * 	   An FPGA image that is designed to do full reconfiguration of the FPGA
 * 	   A base image may set up a set of partial reconfiguration regions that
 *	   may later be reprogrammed. 
 *	-->DFX_EXTERNAL_CONFIG flag should be set if the FPGA has already been
 *	   configured prior to OS boot up.
 *
 * Configure the PR Images
 *	-->An FPGA set up with a base image that created a PR region.
 *	   The contents of each PR may have multiple Reconfigurable Modules
 *	   This RM's(PR0-RM0, PR0-RM1) are reprogrammed independently while
 *	   the rest of the system continues to function.
 */

#include <stdio.h>
#include "libdfx.h"
#include <stdlib.h>
#include <unistd.h>

int system(const char *command);

int main()
{
	int  package_id_full, package_id_pr0_rm0, package_id_pr0_rm1, package_id_pr0_rm2, ret;

	/* package static Initilization */
    	package_id_full = dfx_cfg_init("/lib/firmware/xilinx/static-app/", 0, DFX_EXTERNAL_CONFIG_EN);
    	if (package_id_full < 0)
		return -1;
	printf("dfx_cfg_init: static Package completed successfully\r\n");

        /* package rp1rm1 Initilization */
        package_id_pr0_rm0 = dfx_cfg_init("/lib/firmware/xilinx/static-app/rp1rm1-app/", 0, 0);
        if (package_id_pr0_rm0 < 0)
                return -1;
	printf("dfx_cfg_init: rp1rm1 Package completed successfully\r\n");

	/* package rp1rm2 Initilization */
        package_id_pr0_rm1 = dfx_cfg_init("/lib/firmware/xilinx/static-app/rp1rm2-app/", 0, 0);
        if (package_id_pr0_rm1 < 0)
                return -1;
	printf("dfx_cfg_init: rp1rm2 Package completed successfully\r\n");

	/* package rp1rm3 Initilization */
        package_id_pr0_rm2 = dfx_cfg_init("/lib/firmware/xilinx/static-app/rp1rm3-app/", 0, 0);
        if (package_id_pr0_rm1 < 0)
                return -1;
	printf("dfx_cfg_init: rp1rm3 Package completed successfully\r\n");	
	
	/* Package static load */
	ret = dfx_cfg_load(package_id_full);
	if (ret) {
		dfx_cfg_destroy(package_id_full);
		return -1;
    	}
	printf("\n--------------------------------------------------------------\r\n");
	printf("/ \t dfx_cfg_load: static Package completed successfully\r\n");
	
	printf("/ \t DFX Decoupler ENABLED\r\n");
	system("devmem 0xA4400000 32 1");
	sleep(3);
	printf("\n--------------------------------------------------------------\r\n");
	
        /* Package rp1rm1 load */
        ret = dfx_cfg_load(package_id_pr0_rm0);
        if (ret) {
                dfx_cfg_destroy(package_id_pr0_rm0);
                return -1;
        }
	printf("\n--------------------------------------------------------------\r\n");
	printf("/ \t dfx_cfg_load: rp1rm1 Package completed successfully\r\n");

        /* Check gpio memory address, expecting 0xFACEFEED */
	printf("/ \t DFX Decoupler DISABLED\r\n");
	system("devmem 0xA4400000 32 0");
	sleep(3);
	
	printf("/ \t checking gpio memory address, expecting 0xFACEFEED\r\n");
	system("devmem 0xA4420000");
	sleep(3);
	
        /* Remove rp1rm1 package */
        ret = dfx_cfg_remove(package_id_pr0_rm0);
        if (ret)
                return -1;
	printf("/ \t dfx_cfg_remove: rp1rm1 Package completed successfully\r\n");

	printf("/ \t DFX Decoupler ENABLED\r\n");
	system("devmem 0xA4400000 32 1");
	sleep(3);
	printf("\n--------------------------------------------------------------\r\n");

        /* Package rp1rm2 load */
        ret = dfx_cfg_load(package_id_pr0_rm1);
        if (ret) {
                dfx_cfg_destroy(package_id_pr0_rm1);
                return -1;
        }
	printf("\n--------------------------------------------------------------\r\n");
	printf("/ \t dfx_cfg_load: rp1rm2 Package completed successfully\r\n");

	/* Check gpio memory address, expecting 0xC0000000 */
	printf("/ \t DFX Decoupler DISABLED\r\n");
	system("devmem 0xA4400000 32 0");
	sleep(3);

	printf("/ \t checking gpio memory address, expecting 0xC0000000\r\n");
	system("devmem 0xA4420000");
	sleep(3);	
	
	/* Remove rp1rm2 package */
    	ret = dfx_cfg_remove(package_id_pr0_rm1);
	if (ret)
		return -1;
	printf("/ \t dfx_cfg_remove: rp1rm2 Package completed successfully\r\n");

	printf("/ \t DFX Decoupler ENABLED\r\n");
	system("devmem 0xA4400000 32 1");
	sleep(3);
	printf("\n--------------------------------------------------------------\r\n");

        /* Package rp1rm3 load */
        ret = dfx_cfg_load(package_id_pr0_rm2);
        if (ret) {
                dfx_cfg_destroy(package_id_pr0_rm2);
                return -1;
        }
	printf("\n--------------------------------------------------------------\r\n");
	printf("/ \t dfx_cfg_load: rp1rm3 Package completed successfully\r\n");

	/* Check that uartlites are feeding into eachother */	
	printf("/ \t DFX Decoupler DISABLED\r\n");
	system("devmem 0xA4400000 32 0");
	
	printf("/ \t testing that uartlites are looped\r\n");
	sleep(3);
	
	printf("/ \t executing cat /dev/ttyUL0 & \r\n");
	system("cat /dev/ttyUL0 &");

	printf("/ \t executing echo Hello ttyUL1! > /dev/ttyUL1\r\n");
	system("echo Hello ttyUL1! > /dev/ttyUL1");
	sleep(3);
	
	printf("/ \t killing cat command\r\n");
	system("killall -9 cat");

	printf("/ \t running cat /dev/ttyUL1 &\r\n");
	system("cat /dev/ttyUL1 &");

	printf("/ \t executing echo Hello ttyUL0! > /dev/ttyUL0\r\n");
	system("echo Hello ttyUL0! > /dev/ttyUL0");
	sleep(3);
	
	printf("/ \t killing cat command\r\n");
	system("killall -9 cat");
	
	printf("\n--------------------------------------------------------------\r\n");
	
	/* Remove rp1rm3 package */
    	ret = dfx_cfg_remove(package_id_pr0_rm2);
	if (ret)
		return -1;
	printf("/ \t dfx_cfg_remove: rp1rm3 Package completed successfully\r\n");

        /* Remove static package */
        ret = dfx_cfg_remove(package_id_full);
        if (ret)
                return -1;
	printf("/ \t dfx_cfg_remove: static Package completed successfully\r\n");	
	printf("\n--------------------------------------------------------------\r\n");

	/* Destroy rp1rm1 package */
    	ret = dfx_cfg_destroy(package_id_pr0_rm0);
	if (ret)
		return -1;
	printf("dfx_cfg_destroy: rp1rm1 Package completed successfully\r\n");

        /* Destroy rp1rm2 package */
        ret = dfx_cfg_destroy(package_id_pr0_rm1);
        if (ret)
                return -1;
	printf("dfx_cfg_destroy: rp1rm2 Package completed successfully\r\n");

        /* Destroy rp1rm3 package */
        ret = dfx_cfg_destroy(package_id_pr0_rm2);
        if (ret)
                return -1;
	printf("dfx_cfg_destroy: rp1rm3 Package completed successfully\r\n");	

        /* Destroy static package */
        ret = dfx_cfg_destroy(package_id_full);
        if (ret)
                return -1;
	printf("dfx_cfg_destroy: static Package completed successfully\r\n");

	
	return 0;
}	
