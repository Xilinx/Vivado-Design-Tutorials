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
#include "xil_cache.h"

uint32_t cycle_cnt = 0;

unsigned int addr_dc0_perf_mon_out = NOC_DDR_DC_PERF_MON_OUT;

static uint64_t ddr_cntpct_start;
static uint64_t ddr_cntpct_end;

// Offsets for each k-Means block from base address
uint64_t ACC_OFFSETS[] = {0x0,
						  0x10000,
						  0x40000000,
						  0x40010000,
						  0x80000000,
						  0x80010000,
						  0xC0000000,
						  0xC0010000,
						  0x100000000,
						  0x100010000,
						  0x140000000,
						  0x140010000,
						  0x180000000,
						  0x180010000,
						  0x1C0000000,
						  0x1C0010000,
						  0x200000000,
						  0x200010000,
						  0x240000000,
						  0x240010000,
						  0x280000000,
						  0x280010000,
						  0x2C0000000,
						  0x2C0010000,
						  0x300000000,
						  0x300010000,
						  0x340000000,
						  0x340010000,
						  0x10380000000,
						  0x10380010000,
						  0x103C0000000,
						  0x103C0010000,
						  0x10400000000,
						  0x10400010000,
						  0x10440000000,
						  0x10440010000,
						  0x10480000000,
						  0x10480010000,
						  0x104C0000000,
						  0x104C0010000,
						  0x10500000000,
						  0x10500010000,
						  0x10540000000,
						  0x10540010000,
						  0x10580000000,
						  0x10580010000,
						  0x105C0000000,
						  0x105C0010000,
						  0x10600000000,
						  0x10600010000,
						  0x10640000000,
						  0x10640010000,
						  0x10680000000,
						  0x10680010000,
						  0x106C0000000,
						  0x106C0010000};


/*
  Read the A72 cycle counter
*/
uint64_t read_cntpct() {
  uint64_t cntpct = 0;
  __asm__ __volatile__ (
    "ISB\n\r"
    "MRS %0, cntpct_el0\n\r"
    "DSB SY\n\r"
    "ISB SY\n\r" : "=r" (cntpct)
  );
  return cntpct;
}


/*
  Write arguments into the config registers for a single k-Means accelerator block
*/
void kmeans_acc_config (
  uint32_t kmeans_block_n,
  uint32_t n,
  uint32_t k,
  uint32_t buf_nx_addr,
  uint32_t buf_ny_addr,
  uint32_t buf_ng_addr,
  uint32_t buf_cx_addr,
  uint32_t buf_cy_addr,
  uint32_t buf_ing_addr,
  uint32_t buf_icx_addr,
  uint32_t buf_icy_addr,
  uint32_t max_itr,
  uint32_t sub_itr,
  uint32_t opts) {

  uint64_t block_offset = KMEANS_BASE;
  if (kmeans_block_n < 56) block_offset = (KMEANS_BASE + ACC_OFFSETS[kmeans_block_n]);

  // Control registers
  uint64_t ctlr   = (KMEANS_CTLR  + block_offset);
  uint64_t gier   = (KMEANS_GIER  + block_offset);
  uint64_t ipier  = (KMEANS_IPIER + block_offset);
  uint64_t ipisr  = (KMEANS_IPISR + block_offset);
  uint64_t nr     = (KMEANS_NR    + block_offset);
  uint64_t kr     = (KMEANS_KR    + block_offset);
  uint64_t mir    = (KMEANS_MIR   + block_offset);
  uint64_t optr   = (KMEANS_OPTS  + block_offset);
  uint64_t sir    = (KMEANS_SIR   + block_offset);

  // Buffer pointers
  uint64_t buf_nx  = (KMEANS_BUF_NX + block_offset);
  uint64_t buf_ny  = (KMEANS_BUF_NY + block_offset);
  uint64_t buf_ng  = (KMEANS_BUF_NG + block_offset);
  uint64_t buf_cx  = (KMEANS_BUF_CX + block_offset);
  uint64_t buf_cy  = (KMEANS_BUF_CY + block_offset);
  uint64_t buf_ing = (KMEANS_BUF_ING + block_offset);
  uint64_t buf_icx = (KMEANS_BUF_ICX + block_offset);
  uint64_t buf_icy = (KMEANS_BUF_ICY + block_offset);

  Xil_Out32(ctlr,  0x0);
  Xil_Out32(gier,  0x0);
  Xil_Out32(ipier, 0x0);
  Xil_Out32(nr,    n);
  Xil_Out32(kr,    k);
  Xil_Out32(mir,   max_itr);
  Xil_Out32(optr,  opts);
  Xil_Out32(sir,   sub_itr);

  Xil_Out32(buf_nx,  buf_nx_addr);
  Xil_Out32(buf_ny,  buf_ny_addr);
  Xil_Out32(buf_ng,  buf_ng_addr);
  Xil_Out32(buf_cx,  buf_cx_addr);
  Xil_Out32(buf_cy,  buf_cy_addr);
  Xil_Out32(buf_ing, buf_ing_addr);
  Xil_Out32(buf_icx, buf_icx_addr);
  Xil_Out32(buf_icy, buf_icy_addr);

  return;
}


/*
  Start timer for reading performance registers from DDR
  Set sngl bit to enable performance monitors
*/
void perf_ddr_start (void) {
	unsigned int addr_dc0_perf_mon;

	printf("~~~~~~~~~~ PERF START ~~~~~~~~~~~~~ \n");
	Xil_DCacheDisable();

	//Unlock NPI registers by writing to DDRMC_MAIN_n.pcsr_lock register
	while ((Xil_In32(DDRMC_MAIN_1_BASE + PCSR_LOCK_OFFSET))) {
	    Xil_Out32((DDRMC_MAIN_1_BASE + PCSR_LOCK_OFFSET), PCSR_UNLOCK_CODE);
	}
	
	while ((Xil_In32(DDRMC_MAIN_3_BASE + PCSR_LOCK_OFFSET))) {
	    Xil_Out32((DDRMC_MAIN_3_BASE + PCSR_LOCK_OFFSET), PCSR_UNLOCK_CODE);
	}

	for (int mc = 0; mc < 2; mc++) {
		for (int dc = 0; dc < 2; dc++) {
			addr_dc0_perf_mon = DDRMC_MAIN_1_BASE + DC0_PERF_MON_OFFSET 
					    + dc * (DC1_PERF_MON_OFFSET - DC0_PERF_MON_OFFSET)
					    + mc * (DDRMC_MAIN_3_BASE - DDRMC_MAIN_1_BASE);
			
			//Set sngl bit
			while ((Xil_In32(addr_dc0_perf_mon)) !=  0x0002003e) {
				Xil_Out32(addr_dc0_perf_mon, 0x0002003e);
			}
	
			//Set enable bit
			while( !( Xil_In32(addr_dc0_perf_mon) & 0x00000001 ) ) {
				Xil_Out32(addr_dc0_perf_mon, 0x0002003f);
			}
		}
	}

	ddr_cntpct_start = read_cntpct();
}

/*
  Stop timer for reading performance registers from DDR
  Set sngl bit to enable performance monitors
*/
void perf_ddr_stop () {
	unsigned int addr_dc0_perf_mon = NOC_DDR_DC_BASE + 0x13C0 ;
	unsigned int addr_ddr_dc = NOC_DDR_DC_BASE + 0x13C4 ;
	unsigned int data_ddr_dc[12];
	unsigned int addr_ddr_dc_out = NOC_DDR_DC_OUT_BASE + 0x4;
	unsigned int data_ddr_dc_out[12];
	int i = 0;
	uint32_t cycles = 0;

	volatile unsigned int data_dc0_perf_mon;

	for (int mc = 0; mc < 2; mc++) {
		for (int dc = 0; dc < 2; dc++) {
			addr_dc0_perf_mon = DDRMC_MAIN_1_BASE + DC0_PERF_MON_OFFSET 
					    + dc * (DC1_PERF_MON_OFFSET - DC0_PERF_MON_OFFSET)
					    + mc * (DDRMC_MAIN_3_BASE - DDRMC_MAIN_1_BASE);
			
			//Unset enable bit
			while (Xil_In32(addr_dc0_perf_mon) !=  0x0002003e) {
				Xil_Out32(addr_dc0_perf_mon, 0x0002003e);
			}
		}
	}

	ddr_cntpct_end = read_cntpct();
	cycles = ((ddr_cntpct_end-ddr_cntpct_start) & 0xFFFFFFF0);

	Xil_Out32(NOC_DDR_DC_OUT_BASE, data_dc0_perf_mon);
	Xil_Out32(addr_dc0_perf_mon_out, cycles + Xil_In32(addr_dc0_perf_mon_out));
	cycle_cnt = cycle_cnt + 1;
	Xil_Out32((NOC_DDR_DC_OUT_BASE + 0x34), cycle_cnt);


	//Read all NoC DDR DC Perf Registers into data_ddr_dc array
	for (int mc = 0; mc < 2; mc++) {
		for (int dc = 0; dc < 2; dc++) {
			for (i = 0; i < 3; i++) { //0=ACT, 1=READ, 2=WRITE
				data_ddr_dc[i + (dc * 3) + (mc * 6)] = Xil_In32(addr_ddr_dc + i*0x4
							+ dc * (DC1_PERF_MON_OFFSET - DC0_PERF_MON_OFFSET)
							+ mc * (DDRMC_MAIN_3_BASE - DDRMC_MAIN_1_BASE));
			}
		}
	}

	//Read prior result totals from all NoC DDR DC XSDB Scratch Registers
	for (i = 0; i < 12; i++) {
		data_ddr_dc_out[i] = Xil_In32(addr_ddr_dc_out);
		addr_ddr_dc_out = addr_ddr_dc_out + 0x4;
	}

	//Sum this data with prior totals and Write to all NoC DDR DC XSDB Scratch Registers
	addr_ddr_dc_out = NOC_DDR_DC_OUT_BASE + 0x4;
	for (i = 0; i < 12; i++) {
		Xil_Out32(addr_ddr_dc_out, data_ddr_dc[i] + data_ddr_dc_out[i]);
		addr_ddr_dc_out = addr_ddr_dc_out + 0x4;
	}

	//Clear counters for next accumulation period
	volatile unsigned int addr_cleared = DDRMC_MAIN_1_BASE + DC0_PERF_MON_OFFSET ;
	for (int mc = 0; mc < 2; mc++) {
		for (int dc = 0; dc < 2; dc++) {
			for (i = 4; i <= 12; i+=4) {
				addr_cleared = DDRMC_MAIN_1_BASE + DC0_PERF_MON_OFFSET + i 
						+ dc * (DC1_PERF_MON_OFFSET - DC0_PERF_MON_OFFSET)
						+ mc * (DDRMC_MAIN_3_BASE - DDRMC_MAIN_1_BASE);
				while (Xil_In32(addr_cleared) !=  0x0) {
				    Xil_Out32(addr_cleared, 0x0);
				}
			}
		}
	}
	Xil_DCacheEnable();
	printf("~~~~~~~~~~ PERF STOP ~~~~~~~~~~~~~ \n");
}


/*
  Start a single k-Means accelerator block
*/
void kmeans_acc_run (uint32_t kmeans_block_n) {

  uint64_t ctlr = KMEANS_BASE + KMEANS_CTLR;
  uint32_t ctlr_val = 0;
  if (kmeans_block_n < 56) ctlr = (ctlr + ACC_OFFSETS[kmeans_block_n]);
  ctlr_val = Xil_In32(ctlr);
  Xil_Out32(ctlr, (ctlr_val | 0x1));
  return;
}


/*
  Check whether a single k-Means accelerator block is done
*/
uint32_t kmeans_acc_done (uint32_t kmeans_block_n) {

  uint64_t ctlr = KMEANS_BASE + KMEANS_CTLR;
  uint32_t ctlr_val = 0;
  uint32_t is_done = 0;
  if (kmeans_block_n < 56) ctlr = (ctlr + ACC_OFFSETS[kmeans_block_n]);
  ctlr_val = Xil_In32(ctlr);
  is_done = (((ctlr_val & 0x2) > 0) ? 1 : 0);

  return is_done;
}


/*
  Start all k-Means accelerator blocks and wait for them to complete
  stage: set bit 0 to run the bottom N-1 blocks, bit 1 to run the Nth block
*/
uint32_t kmeans_run_hw (uint32_t n, uint32_t k, uint32_t stage) {

  int i = 0;

  uint32_t done[N_KMEANS];
  uint32_t n_done   = 0;
  uint32_t time_out = 0xFFFFFFF;

  uint32_t active_blocks;

  active_blocks = (n<N_KMEANS) ? n : N_KMEANS-1;

  for (i = 0; i < N_KMEANS; i++) {
    done[i] = 1;
  }
  n_done = N_KMEANS;

  perf_ddr_start();
  if (stage & 0x1) {
    for (i = 0; i < active_blocks; i++) {
      done[i] = 0;
      n_done--;
      kmeans_acc_run(i);
    }
  }

  if (stage & 0x2) {
    done[N_KMEANS-1] = 0;
    n_done--;
    kmeans_acc_run(N_KMEANS-1);
  }

  while (n_done < N_KMEANS) {
    if (time_out-- < 1) break;
    for (i = 0; i < N_KMEANS; i++) {
      if (done[i] == 0) {
        if (kmeans_acc_done(i)) {
          done[i] = 1;
          n_done++;
        }
      }
    }
  }
  perf_ddr_stop();

  return (n_done == N_KMEANS) ? 1 : 0;
}


/*
  Calculate Rand index to show level of similarity between HW and SW clusterings.
*/
float randIndex (
	uint64_t* gs_hw,
	uint64_t* gs_sw,
	uint32_t n) {

	int i = 0;
	int j = 0;
	int a = 0;
	int b = 0;

	float r = 0.0;

	for (i=0; i<n-1; i++) {
		for (j=i+1; j<n; j++) {
			if((gs_hw[i] == gs_hw[j]) && (gs_sw[i] == gs_sw[j])) a++;
			if((gs_hw[i] != gs_hw[j]) && (gs_sw[i] != gs_sw[j])) b++;
		}
	}

	r = (a+b) / (n*(n-1) / 2.0f);

	return r;
}


/*
  Get a random 64-bit integer less than RAND_MAX
*/
uint64_t kmeans_rand_int (void) {
  return (uint64_t) (rand() % RAND_MAX);
}


/*
  Populate node x and y buffers with random data
*/
void kmeans_gen_xyg (
  uint64_t *xs,
  uint64_t *ys,
  uint64_t *gs,
  uint32_t n,
  uint32_t rm) {

  int i = 0;

  for (i = 0; i < n; i++) {
    xs[i] = kmeans_rand_int() % rm;
    ys[i] = kmeans_rand_int() % rm;
    gs[i] = 0;
  }

  return;
}


/*
  Get absolute of difference between v0 and v1
*/
uint64_t absDiff(
  uint64_t v0,
  uint64_t v1) {
  return (v0 < v1) ? (v1-v0) : (v0-v1);
}


/*
  Simple 2D distance
*/
uint64_t kmeans_dist (
  uint64_t x1,
  uint64_t x2,
  uint64_t y1,
  uint64_t y2) {

  return (absDiff(x1, x2))*(absDiff(x1, x2)) + (absDiff(y1, y2))*(absDiff(y1, y2));
}


/*
  Get the centroid nearest to the given node
  Returns the index of the nearest centroid, stores the min distance in the d2 pointer
*/
uint32_t kmeans_nearest (
  uint64_t nx,
  uint64_t ny,
  uint64_t ng,
  uint64_t *cxs,
  uint64_t *cys,
  int k,
  uint64_t *d2) {

  int i;
  uint64_t d;
  uint32_t min_i;
  uint64_t min_d;

  min_d = HUGE_VAL;
  min_i = ng;

  for (i = 0; i < k; i++) {
    d = kmeans_dist(cxs[i], nx, cys[i], ny);
    if (d < min_d) {
      min_d = d;
      min_i = i;
    }
  }

  if (d2) {
    *d2 = min_d;
  }

  return min_i;
}


/*
  Initial centroid placement using k-Means++
*/
void kmeans_place_centroids (
  uint64_t *xs,
  uint64_t *ys,
  uint64_t *gs,
  uint64_t *cxs,
  uint64_t *cys,
  uint32_t n,
  uint32_t k) {

  int i;
  int j;
  int c;
  uint64_t s;
  uint64_t* d = (uint64_t*)(DIST_BUFFER_ADDR);
  uint64_t r = 0;

  // (1) Choose one center uniformly at random among the data points.
  for (c = 0; c < k; c++) {
    cxs[c] = xs[rand()%n];
    cys[c] = ys[rand()%n];
  }

  // (4) Repeat Steps 2 and 3 until k centers have been chosen.
  for (c = 1; c < k; c++) {
    s = 0;
    // (2) For each data point x, compute D(x),
    // the distance between x and the nearest center that has already been chosen.
    for (j = 0; j < n; j++) {
      kmeans_nearest(xs[j], ys[j], gs[j], cxs, cys, c, d+j);
      s += d[j];
    }
    // (3) Choose one new data point at random as a new center, 
    // using a weighted probability distribution where a point 
    // x is chosen with probability proportional to D(x)^2.
    r = (s*rand()) / (RAND_MAX-1);
    s = r;
    for (j = 0; j < n; j++) {
      if ((s -= d[j]) > 0) {
        continue;
      }
      cxs[c] = xs[j];
      cys[c] = ys[j];
      break;
    }
  }

  // (5) Assign initial cluster mappings
  for (j = 0; j < n; j++) {
    gs[j] = kmeans_nearest(xs[j], ys[j], gs[j], cxs, cys, k, 0);
  }

  return;
}


/*
  Initialize all k-Means blocks

  randomize: Fill buffer with randomized data
  rand_max:  Max value to use for random data (64-bit)
*/
void kmeans_init (
  uint32_t n,
  uint32_t k,
  uint32_t unified,
  uint32_t randomize,
  uint32_t rand_max,
  uint32_t max_itr,
  uint32_t sub_itr,
  uint32_t no_copy) {

  int i = 0;

  uint64_t* kmeansdata_hw = (uint64_t*)(START_ADDR_HW);
  uint64_t* kmeansdata_sw = (uint64_t*)(START_ADDR_SW);
  uint64_t* kmeansdata;
  uint64_t* intdata;

  uint32_t active_blocks;

  active_blocks = (n<N_KMEANS) ? n : N_KMEANS-1;

  uint32_t n_per_acc = (n / active_blocks);
  uint32_t n_rem_acc = (n % active_blocks);
  uint32_t n_acc = n_per_acc;
  uint32_t n_offset = 0;
  uint32_t c_offset = 0;
  uint32_t n_int_range = (((max_itr/sub_itr)+1)*((n+(2*k))));
  uint32_t n_int_offset = 0;


  if (unified) {
    n_per_acc = (n / active_blocks);
    n_rem_acc = (n % active_blocks);
    n_acc = n_per_acc;
  }

  uint64_t dataSizeWords = ((3*n + 2*k));
  uint64_t dataSizeBytes = (sizeof(uint64_t)*dataSizeWords);

  Xil_Out32((REGR_DBG), (0xDB91217D));

  if (unified) {
    for (i = 0; i < active_blocks; i++) {

      if (i==(active_blocks-1)) {
        n_acc = n_per_acc + n_rem_acc;
      } else {
        n_acc = n_per_acc;
      }

      Xil_Out32((REGR_DBG), (0xDB900001 + (i<<12)));

      n_offset = (i*n_per_acc);
      c_offset = (i*k);
      n_int_offset = (i*n_int_range);

      uint64_t* xs  = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*(n_offset));
      uint64_t* ys  = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*(n_offset + (1*n)));
      uint64_t* gs  = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*(n_offset + (2*n)));
      uint64_t* cxs = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*(c_offset + (2*k) + (3*n)));
      uint64_t* cys = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*(c_offset + (2*k) + (3*n) + (k*active_blocks)));
      uint64_t* igs  = (uint64_t*) (START_ADDR_INT + sizeof(uint64_t)*(n_int_offset));
      uint64_t* icxs = (uint64_t*) (START_ADDR_INT + sizeof(uint64_t)*(n_int_offset + n));
      uint64_t* icys = (uint64_t*) (START_ADDR_INT + sizeof(uint64_t)*(n_int_offset + n + k));

      if (randomize) {
        kmeans_gen_xyg (xs, ys, gs, n_acc, rand_max);
      }

      Xil_Out32((REGR_DBG), (0xDB900002 + (i<<12)));

      kmeans_place_centroids (xs, ys, gs, cxs, cys, n_acc, k);

      Xil_Out32((REGR_DBG), (0xDB900003 + (i<<12)));

      kmeans_acc_config (i, n_acc, k, xs, ys, gs, cxs, cys, igs, icxs, icys, max_itr, sub_itr, (UPDATE_GS | UPDATE_CS));
    }

    n_acc = (active_blocks*k);
    n_int_offset = (active_blocks*n_int_range);
    uint64_t* xs  = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*((2*k) + (3*n)));
    uint64_t* ys  = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*((2*k) + (3*n) + (k*active_blocks)));
    uint64_t* gs  = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*((2*k) + (3*n) + (2*k*active_blocks)));
    uint64_t* cxs = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*((3*n)));
    uint64_t* cys = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*((3*n) + k));
    uint64_t* igs  = (uint64_t*) (START_ADDR_INT + sizeof(uint64_t)*(n_int_offset));
    uint64_t* icxs = (uint64_t*) (START_ADDR_INT + sizeof(uint64_t)*(n_int_offset + n));
    uint64_t* icys = (uint64_t*) (START_ADDR_INT + sizeof(uint64_t)*(n_int_offset + n + k));

    Xil_Out32((REGR_DBG), (0xDB900006 + (i<<12)));

    kmeans_place_centroids (xs, ys, gs, cxs, cys, n_acc, k);

    Xil_Out32((REGR_DBG), (0xDB900007 + (i<<12)));

    kmeans_acc_config ((N_KMEANS-1), n_acc, k, xs, ys, gs, cxs, cys, igs, icxs, icys, max_itr, sub_itr, (UPDATE_GS | UPDATE_CS));

    if (no_copy != 1) {
      for (i = 0; i < (dataSizeWords+(k*2*(active_blocks+1))); i++) {
        kmeansdata_sw[i] = kmeansdata_hw[i];
      }
    }
  } else {
    for (i = 0; i < N_KMEANS; i++) {

      kmeansdata = (uint64_t*)(START_ADDR_HW + (i*dataSizeBytes));
      intdata = (uint64_t*)(START_ADDR_INT + sizeof(uint64_t)*(i*n_int_range));

      Xil_Out32((REGR_DBG), (0xDB900001 + (i<<12)));

      uint64_t* xs = kmeansdata;
      uint64_t* ys = kmeansdata+(n);
      uint64_t* gs = kmeansdata+(2*n);
      uint64_t* cxs = kmeansdata+(3*n);
      uint64_t* cys = kmeansdata+((3*n)+k);
      uint64_t* igs = intdata;
      uint64_t* icxs = intdata+(n);
      uint64_t* icys = intdata+(n+k);

      if (randomize) {
        kmeans_gen_xyg (xs, ys, gs, n, rand_max);
      }

      Xil_Out32((REGR_DBG), (0xDB900002 + (i<<12)));

      kmeans_place_centroids (xs, ys, gs, cxs, cys, n, k);

      Xil_Out32((REGR_DBG), (0xDB900003 + (i<<12)));

      kmeans_acc_config (i, n, k, xs, ys, gs, cxs, cys, igs, icxs, icys, max_itr, sub_itr, (UPDATE_GS | UPDATE_CS));
    }
    if (no_copy != 1) {
      for (i = 0; i < (N_KMEANS*(dataSizeWords+(k*2))); i++) {
        kmeansdata_sw[i] = kmeansdata_hw[i];
      }
    }
  }

  Xil_Out32(REGR_DBG, 0xDB900004);

  Xil_DCacheFlush();
  Xil_Out32(REGR_DBG, 0xDB900005);

  return;
}


/*
  Run collection step for unified clustering.
*/
uint32_t kmeans_collect (
  uint32_t n,
  uint32_t k,
  uint32_t max_itr,
  uint32_t sub_itr) {

  uint32_t active_blocks;

  active_blocks = (n<N_KMEANS) ? n : N_KMEANS-1;

  uint32_t n_per_acc = (n / active_blocks);
  uint32_t n_rem_acc = (n % active_blocks);
  uint32_t n_acc = n_per_acc;
  uint32_t n_offset = 0;
  uint32_t c_offset = 0;
  uint32_t n_int_range = (((max_itr/sub_itr)+1)*((n+(2*k))));
  uint32_t n_int_offset = 0;

  int i = 0;

  for (i = 0; i < active_blocks; i++) {

    if (i==(active_blocks-1)) {
      n_acc = n_per_acc + n_rem_acc;
    } else {
      n_acc = n_per_acc;
    }

    Xil_Out32((REGR_DBG), (0xDB900011 + (i<<12)));

    n_offset = (i*n_per_acc);
    n_int_offset = (i*n_int_range);

    uint64_t* xs  = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*(n_offset));
    uint64_t* ys  = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*(n_offset + (1*n)));
    uint64_t* gs  = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*(n_offset + (2*n)));
    uint64_t* cxs = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*(3*n));
    uint64_t* cys = (uint64_t*) (START_ADDR_HW + sizeof(uint64_t)*((3*n) + k));
    uint64_t* igs  = (uint64_t*) (START_ADDR_INT + sizeof(uint64_t)*(n_offset));
    uint64_t* icxs = (uint64_t*) (START_ADDR_INT + sizeof(uint64_t)*(n));
    uint64_t* icys = (uint64_t*) (START_ADDR_INT + sizeof(uint64_t)*(n+k));

    Xil_Out32((REGR_DBG), (0xDB900012 + (i<<12)));
    kmeans_acc_config (i, n_acc, k, xs, ys, gs, cxs, cys, igs, icxs, icys, 1, 1, (UPDATE_GS));

  }

  return kmeans_run_hw(n, k, 1);
}


/*
  S/W reference implementation
  Single k-Means iteration 
*/
void kmeans_step (
  uint64_t *xs,
  uint64_t *ys,
  uint64_t *gs,
  uint64_t *cxs,
  uint64_t *cys,
  uint32_t n,
  uint32_t k,
  uint32_t update_centroids) {

  int i = 0;
  int j = 0;
  int min_i = 0;
  uint64_t c_d = 0;
  uint64_t min_d = 0;

  uint64_t* n_cxs = (uint64_t*)(N_C_BUF_ADDR);
  uint64_t* n_cys = (uint64_t*)(N_C_BUF_ADDR+8*BUFFER_SIZE);
  uint64_t* n_cns = (uint64_t*)(N_C_BUF_ADDR+2*8*BUFFER_SIZE);

  for (i = 0; i < k; i++) {
    n_cns[i] = 0;
    n_cxs[i] = 0;
    n_cys[i] = 0;
  }

  for (i = 0; i < n; i++) {
    min_i = 0;
    min_d = kmeans_dist(xs[i], cxs[0], ys[i], cys[0]);
    for (j = 1; j < k; j++) {
      c_d = kmeans_dist(xs[i], cxs[j], ys[i], cys[j]);
      if (c_d <= min_d) {
        min_i = j;
        min_d = c_d;
      }
    }
    gs[i] = min_i;
    n_cxs[min_i] += xs[i];
    n_cys[min_i] += ys[i];
    n_cns[min_i]++;
  }

  if (update_centroids) {
    for (i = 0; i < k; i++) {
      if(n_cns[i] > 0) {
        cxs[i] = (n_cxs[i] / n_cns[i]);
        cys[i] = (n_cys[i] / n_cns[i]);
      }
    }
  }
}


/*
  S/W version of the collection step
*/
void kmeans_sw_collect (
  uint64_t *xs,
  uint64_t *ys,
  uint64_t *gs,
  uint64_t *cxs,
  uint64_t *cys,
  uint32_t n,
  uint32_t k) {

  int i = 0;
  int j = 0;
  int min_i = 0;
  uint64_t c_d = 0;
  uint64_t min_d = 0;

  for (i = 0; i < n; i++) {
    min_i = 0;
    min_d = kmeans_dist(xs[i], cxs[0], ys[i], cys[0]);
    for (j = 0; j < k; j++) {
      c_d = kmeans_dist(xs[i], cxs[j], ys[i], cys[j]);
      if (c_d <= min_d) {
        min_i = j;
        min_d = c_d;
      }
    }
    gs[i] = min_i;
  }

}


/*
  S/W reference implementation
*/
void kmeans_algo (
  uint64_t *xs,
  uint64_t *ys,
  uint64_t *gs,
  uint64_t *cxs,
  uint64_t *cys,
  uint32_t n,
  uint32_t k,
  uint32_t collect,
  uint32_t max_itr) {

  int converged = 0;
  int i = 0;
  int iterations = 0;

  // Save centroid positions and group mappings before running kmeans
  uint64_t* cxs_q = (uint64_t*)(Q_BUF_ADDR);
  uint64_t* cys_q = (uint64_t*)(Q_BUF_ADDR+8*BUFFER_SIZE);
  uint64_t* gs_q = (uint64_t*)(Q_BUF_ADDR+2*8*BUFFER_SIZE);

  while (!converged && (iterations < max_itr)) {
    iterations++;
    converged = 1;

    for (i = 0; i < k; i++)
      cxs_q[i] = cxs[i];
    for (i = 0; i < k; i++)
      cys_q[i] = cys[i];
    for (i = 0; i < n; i++)
      gs_q[i] = gs[i];

    kmeans_step (xs, ys, gs, cxs, cys, n, k, collect);

    for (i = 0; i < k; i++) {
      if (cxs_q[i] != cxs[i]) {
        converged = 0;
        break;
      }
    }

    if (converged) {
      for (i = 0; i < k; i++) {
        if (cxs_q[i] != cxs[i]) {
          converged = 0;
          break;
        }
      }
    }

    if (converged) {
      for (i = 0; i < n; i++) {
        if (gs_q[i] != gs[i]) {
          converged = 0;
          break;
        }
      }
    }
  }
}


/*
  Top-level wrapper for S/W reference implementation
*/
uint32_t kmeans_check (
  uint32_t n,
  uint32_t k,
  uint32_t unified,
  uint32_t max_itr) {

  int i = 0;
  int j = 0;
  int testErr = 0;

  uint64_t dataSizeWords = ((3*n+2*k));
  uint64_t dataSizeBytes = (sizeof(uint64_t)*dataSizeWords);

  uint64_t* kmeansdata_hw = (uint64_t*)(START_ADDR_HW);
  uint64_t* kmeansdata_sw = (uint64_t*)(START_ADDR_SW);
  uint64_t* kmeansdata;

  uint32_t active_blocks;

  active_blocks = (n<N_KMEANS) ? n : N_KMEANS-1;

  uint32_t n_per_acc = (n / active_blocks);
  uint32_t n_rem_acc = (n % active_blocks);
  uint32_t n_acc = n_per_acc;
  uint32_t n_offset = 0;
  uint32_t c_offset = 0;
  
  uint64_t* xs;
  uint64_t* ys;
  uint64_t* gs;
  uint64_t* cxs;
  uint64_t* cys;


  if (unified) {

    for (i = 0; i < active_blocks; i++) {

      Xil_Out32((REGR_DBG), (0xC1480100 + i));
      if (i==(active_blocks-1)) {
       n_acc = n_per_acc + n_rem_acc;
      } else {
        n_acc = n_per_acc;
      }

      n_offset = (i*n_per_acc);
      c_offset = (i*k);

      xs  = (((uint64_t*) (START_ADDR_SW)) + (n_offset));
      ys  = (((uint64_t*) (START_ADDR_SW)) + (n_offset + (1*n)));
      gs  = (((uint64_t*) (START_ADDR_SW)) + (n_offset + (2*n)));
      cxs = (((uint64_t*) (START_ADDR_SW)) + (c_offset + (2*k) + (3*n)));
      cys = (((uint64_t*) (START_ADDR_SW)) + (c_offset + (2*k) + (3*n) + (k*active_blocks)));

      kmeans_algo(xs, ys, gs, cxs, cys, n_acc, k, 1, max_itr);
      Xil_Out32((REGR_DBG), (0xC1480200 + i));
    }

    xs  = (((uint64_t*) (START_ADDR_SW)) + ((2*k) + (3*n)));
    ys  = (((uint64_t*) (START_ADDR_SW)) + ((2*k) + (3*n) + (k*active_blocks)));
    gs  = (((uint64_t*) (START_ADDR_SW)) + ((2*k) + (3*n) + (2*k*active_blocks)));
    cxs = (((uint64_t*) (START_ADDR_SW)) + ((3*n)));
    cys = (((uint64_t*) (START_ADDR_SW)) + ((3*n) + (k)));

    kmeans_algo(xs, ys, gs, cxs, cys, (k*active_blocks), k, 1, max_itr);

    for (i = 0; i < active_blocks; i++) {

      Xil_Out32((REGR_DBG), (0xC1480100 + i));
      if (i==(active_blocks-1)) {
        n_acc = n_per_acc + n_rem_acc;
      } else {
        n_acc = n_per_acc;
      }

      n_offset = (i*n_per_acc);
      c_offset = (i*k);

      xs  = (((uint64_t*) (START_ADDR_SW)) + (n_offset));
      ys  = (((uint64_t*) (START_ADDR_SW)) + (n_offset + (1*n)));
      gs  = (((uint64_t*) (START_ADDR_SW)) + (n_offset + (2*n)));
      cxs = (((uint64_t*) (START_ADDR_SW)) + (3*n));
      cys = (((uint64_t*) (START_ADDR_SW)) + (k + (3*n)));

      // Assign final cluster mappings
      for (j = 0; j < n_acc; j++) {
        gs[j] = kmeans_nearest(xs[j], ys[j], gs[j], cxs, cys, k, 0);
      }
    }

    Xil_Out32((REGR_DBG), (0xC1480200 + i));

    for (j = (2*n); j < (dataSizeWords-1); j++) {
      if ((kmeansdata_sw[j]) != (kmeansdata_hw[j])) {
        testErr++;
        break;
      }
    }
  } else {

    for (i = 0; i < N_KMEANS; i++) {

      Xil_Out32((REGR_DBG), (0xC1480100 + i));
      uint64_t* kmeansdata_hw = (uint64_t*)(START_ADDR_HW + (i*dataSizeBytes));
      uint64_t* kmeansdata_sw = (uint64_t*)(START_ADDR_SW + (i*dataSizeBytes));
      uint64_t xsum_hw = 0;
      uint64_t ysum_hw = 0;
      uint64_t xsum_sw = 0;
      uint64_t ysum_sw = 0;
      uint64_t gsum_sw = 0;
      uint64_t gsum_hw = 0;

      kmeansdata = (uint64_t*)(START_ADDR_SW + (i*dataSizeBytes));

      xs = kmeansdata;
      ys = kmeansdata+(n);
      gs = kmeansdata+((2*n));
      cxs = kmeansdata+((3*n));
      cys = kmeansdata+((3*n+k));

      kmeans_algo(xs, ys, gs, cxs, cys, n, k, 1, max_itr);
      Xil_Out32((REGR_DBG), (0xC1480200 + i));

      Xil_DCacheFlush();

      if (randIndex((kmeansdata_hw+(2*n)), (kmeansdata_sw+(2*n)), n) < 0.99) {
    	  testErr++;
    	  Xil_Out32(0xFFFFD000+(i*4), 0xBAD00000+i+1);
      }

      for (j=0; j<k; j++) {
    	  xsum_sw += kmeansdata_sw[(3*n)+j];
    	  ysum_sw += kmeansdata_sw[(3*n)+j+k];
    	  xsum_hw += kmeansdata_hw[(3*n)+j];
    	  ysum_hw += kmeansdata_hw[(3*n)+j+k];
      }
      if ((xsum_sw != xsum_hw) || (ysum_sw != ysum_hw)) {
    	  testErr++;
    	  Xil_Out32(0xFFFFC000+(i*4), 0xBAD00000+i+1);
      }

    }
  }

  return testErr;
}
