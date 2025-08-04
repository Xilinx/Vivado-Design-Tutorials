// © Copyright 2021 Xilinx, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "kmeans.h"

int main(int argc, char *argv[]) {

	int i = 0;

	uint32_t n        		= 0x1B4A6;
	uint32_t k        		= 0x40;
	uint32_t rand_max 		= 0xFFFFF;
	uint32_t done   		= 0;
	uint32_t result 		= 0;
	uint32_t rounds 		= 0;
	uint32_t cycles 		= 0;
	uint32_t max_itr 		= 0;
	uint32_t sub_itr 		= 0;
	uint32_t reg_run_val 	= 0;
	uint32_t randomize 		= 0;
	uint32_t unified 		= 0;
	uint32_t no_copy 		= 0;
	uint32_t REGR_RND_val 	= 0;

	uint64_t cntpct_start;
	uint64_t cntpct_end;

	Xil_Out32(REGR_RES, 0);
	Xil_Out32(REGR_STS, CODE_NGO);
	Xil_Out32(REGR_RUN, 0);

	reg_run_val = Xil_In32(REGR_RUN);

	while (1) {

		REGR_RND_val = Xil_In32(REGR_RND);
		REGR_RND_val = REGR_RND_val & 0xFFFFFF00;
		REGR_RND_val = REGR_RND_val | (rounds & 0xFF);

		Xil_Out32(REGR_RND, REGR_RND_val);

		reg_run_val = Xil_In32(REGR_RUN);
		reg_run_val = reg_run_val & 0xFFFFFFFE;

		Xil_Out32(REGR_RUN, reg_run_val);

		// Wait for run bit to be set (bit 0 of REGR_RUN)
		while (!(Xil_In32(REGR_RUN) & 0x1));

		done = 0;

		Xil_Out32(REGR_RES, 0);
		Xil_Out32(REGR_STS, CODE_INI);

		// Read in settings from REGR_RUN register
		n 			= ((Xil_In32(REGR_RUN) & 0xFFFFF000)>>12);
		k 			= ((Xil_In32(REGR_RUN) & 0x00000FF0)>>4);
		//unified 	= ((Xil_In32(REGR_RUN) & 0x00000002)>>1);
		randomize 	= ((Xil_In32(REGR_RUN) & 0x00000004)>>2);
		//no_copy 	= ((Xil_In32(REGR_RUN) & 0x00000008)>>3);
		//max_itr 	= ((Xil_In32(REGR_RND) & 0x000FFF00)>>8);
		//sub_itr 	= ((Xil_In32(REGR_RND) & 0xFFF00000)>>20);

		// Fix some parameters
		unified = 1;
		no_copy = 0;
		max_itr = 64;
		sub_itr = 1;

		// Fall back to defaults if maximum number of iterations not set
		if (max_itr == 0) max_itr = DEFAULT_MAX_ITERATIONS;
		if (sub_itr == 0) sub_itr = DEFAULT_SUB_ITERATIONS;

		// Check that parameters are valid
		if ((k >= 0) && (n >= 0) && (n < 229377) && (k < 64) && (n>k)) {

			// Set up hardware accelerators and initial data buffer
			kmeans_init(n, k, unified, randomize, rand_max, max_itr, sub_itr, no_copy);

			Xil_Out32(REGR_STS, CODE_RUN);

			// Get starting time
			//cntpct_start = read_cntpct();

			if (unified) {
				// Run first-stage clustering step
				done = kmeans_run_hw(n, k, 1);
				// Run second-stage clustering step
				done = kmeans_run_hw(n, k, 2);
				// Collect up the final centroids
				done = kmeans_collect(n, k, max_itr, sub_itr);
			} else {
				// Run all blocks individually
				done = kmeans_run_hw(n, k, 3);
			}

			// Get end time
			//cntpct_end = read_cntpct();

			//cycles = ((cntpct_end - cntpct_start) & 0xFFFFFFF0);

			Xil_Out32(REGR_STS, CODE_CHK);

			// Check hardware result against software reference implementation
			result = kmeans_check(n, k, unified, max_itr);
	    
	    	Xil_Out32((REGR_DBG), (cycles + done));
		} else {
			if ((k == 0) || (n == 0)) {
				Xil_Out32((REGR_DBG), CODE_ZRO);
				result = CODE_GOD;
			} else {
				Xil_Out32((REGR_DBG), CODE_INV);
				result = CODE_BAD;
			}
		}

		Xil_Out32(REGR_STS, CODE_DNE);
		Xil_Out32(REGR_RES, (result ? CODE_BAD : CODE_GOD));

		rounds++;
	}

	return 0;
}
