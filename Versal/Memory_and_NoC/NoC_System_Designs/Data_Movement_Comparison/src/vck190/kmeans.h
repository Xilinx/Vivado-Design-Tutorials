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

#include <assert.h>
#include <errno.h>
#include <getopt.h>
#include <limits.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <math.h>
#include "xil_io.h"
#include "xil_cache.h"

// General settings and hard-coded memory locations
#define N_KMEANS         56
#define BUFFER_SIZE      0x4000
#define START_ADDR_HW    0xF20000
#define START_ADDR_SW    0x1F20000
#define START_ADDR_INT   0x4800000
#define KMEANS_BASE      0x20100000000
#define Q_BUF_ADDR       0x3020000
#define N_C_BUF_ADDR     0x3520000
#define DIST_BUFFER_ADDR 0x3A20000

// Default settings
#define DEFAULT_MAX_ITERATIONS   0x64
#define DEFAULT_SUB_ITERATIONS   0xA

// ==============================================================
// KMEANS ACCELERATOR BLOCK
// Config and Control Registers
//
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read)
//        bit 7  - auto_restart (Read/Write)
//        others - reserved
#define KMEANS_CTLR      0x0
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
#define KMEANS_GIER      0x4
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0  - enable ap_done interrupt (Read/Write)
//        bit 1  - enable ap_ready interrupt (Read/Write)
//        others - reserved
#define KMEANS_IPIER     0x8
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0  - ap_done (COR/TOW)
//        bit 1  - ap_ready (COR/TOW)
//        others - reserved
#define KMEANS_IPISR     0xC
// 0x10 : Data signal of n
//        bit 31~0 - n[31:0] (Read/Write)
#define KMEANS_NR        0x10
// 0x14 : reserved
// 0x18 : Data signal of k
//        bit 31~0 - k[31:0] (Read/Write)
#define KMEANS_KR        0x18
// 0x1c : reserved
// 0x20 : Data signal of control
//        bit 31~0 - control[31:0] (Read/Write)
#define KMEANS_OPTS      0x20
// 0x24 : reserved
// 0x28 : Data signal of bufaddr_nx
//        bit 31~0 - bufaddr_nx[31:0] (Read/Write)
// 0x2c : Data signal of bufaddr_nx
//        bit 31~0 - bufaddr_nx[63:32] (Read/Write)
#define KMEANS_BUF_NX    0x28
// 0x30 : reserved
// 0x34 : Data signal of bufaddr_ny
//        bit 31~0 - bufaddr_ny[31:0] (Read/Write)
// 0x38 : Data signal of bufaddr_ny
//        bit 31~0 - bufaddr_ny[63:32] (Read/Write)
#define KMEANS_BUF_NY    0x34
// 0x3c : reserved
// 0x40 : Data signal of bufaddr_ng
//        bit 31~0 - bufaddr_ng[31:0] (Read/Write)
// 0x44 : Data signal of bufaddr_ng
//        bit 31~0 - bufaddr_ng[63:32] (Read/Write)
#define KMEANS_BUF_NG    0x40
// 0x48 : reserved
// 0x4c : Data signal of bufaddr_cx
//        bit 31~0 - bufaddr_cx[31:0] (Read/Write)
// 0x50 : Data signal of bufaddr_cx
//        bit 31~0 - bufaddr_cx[63:32] (Read/Write)
#define KMEANS_BUF_CX    0x4C
// 0x54 : reserved
// 0x58 : Data signal of bufaddr_cy
//        bit 31~0 - bufaddr_cy[31:0] (Read/Write)
// 0x5c : Data signal of bufaddr_cy
//        bit 31~0 - bufaddr_cy[63:32] (Read/Write)
#define KMEANS_BUF_CY    0x58
// 0x60 : reserved
// 0x64 : Data signal of bufaddr_ing
//        bit 31~0 - bufaddr_ing[31:0] (Read/Write)
// 0x68 : Data signal of bufaddr_ing
//        bit 31~0 - bufaddr_ing[63:32] (Read/Write)
#define KMEANS_BUF_ING    0x64
// 0x6c : reserved
// 0x70 : Data signal of bufaddr_icx
//        bit 31~0 - bufaddr_icx[31:0] (Read/Write)
// 0x74 : Data signal of bufaddr_icx
//        bit 31~0 - bufaddr_icx[63:32] (Read/Write)
#define KMEANS_BUF_ICX    0x70
// 0x78 : reserved
// 0x7c : Data signal of bufaddr_icy
//        bit 31~0 - bufaddr_icy[31:0] (Read/Write)
// 0x80 : Data signal of bufaddr_icy
//        bit 31~0 - bufaddr_icy[63:32] (Read/Write)
#define KMEANS_BUF_ICY    0x7C
// 0x84 : reserved
// 0x88 : Data signal of max_itr
//        bit 31~0 - max_itr[31:0] (Read/Write)
// 0x8c : Data signal of max_itr
//        bit 31~0 - max_itr[63:32] (Read/Write)
#define KMEANS_MIR       0x88
// 0x90 : reserved
// 0x94 : Data signal of sub_itr
//        bit 31~0 - sub_itr[31:0] (Read/Write)
// 0x98 : Data signal of sub_itr
//        bit 31~0 - sub_itr[63:32] (Read/Write)
#define KMEANS_SIR       0x94
// 0x9c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define KMEANS_RANGE     0x10000

#define UPDATE_NS 0x4
#define UPDATE_GS 0x2
#define UPDATE_CS 0x1

// XSDB Control and Status Registers
#define REGR_RES 0xF1110050
#define REGR_RUN 0xF1110054
#define REGR_RND 0xF1110058
#define REGR_DBG 0xF111005C
#define REGR_STS 0xF1110060

// Status Codes
#define CODE_BAD 0xBAD00BAD
#define CODE_GOD 0x900D900D
#define CODE_STA 0x57A127ED
#define CODE_INI 0x11717000
#define CODE_NGO 0x00017090
#define CODE_RUN 0x12171179
#define CODE_CHK 0x7570C148
#define CODE_DNE 0x757D017E
#define CODE_INV 0xBAD00CF9
#define CODE_ZRO 0x5E120CF9

// NoC Performance Register
#define NOC_NMU_BASE      0xF6D90000
#define NOC_NMU_OUT_BASE  0xF1110064

// DDR Performance Register
#define NOC_DDR_DC_BASE 0xF62C0000
#define DDRMC_MAIN_1_BASE 0xF62C0000
#define DDRMC_MAIN_3_BASE 0xF65A0000
#define PCSR_LOCK_OFFSET 0x000C
#define PCSR_UNLOCK_CODE 0xF9E8D7C6
#define DC0_PERF_MON_OFFSET 0x13C0
#define DC1_PERF_MON_OFFSET 0x13E8
#define NOC_DDR_DC_OUT_BASE 0xFFFC0000
#define NOC_DDR_DC_PERF_MON_OUT 0xFFFC0038

// Buffer Initialization
void kmeans_init (
  uint32_t n,
  uint32_t k,
  uint32_t unified,
  uint32_t randomize,
  uint32_t rand_max,
  uint32_t max_itr,
  uint32_t sub_itr,
  uint32_t no_copy);

// Launch accelerator run
uint32_t kmeans_run_hw (
  uint32_t n,
  uint32_t k,
  uint32_t stage);

// Check result and compare against SW reference
uint32_t kmeans_check (
  uint32_t n,
  uint32_t k,
  uint32_t unified,
  uint32_t max_itr);

// Collection stage
uint32_t kmeans_collect (
  uint32_t n,
  uint32_t k,
  uint32_t max_itr,
  uint32_t sub_itr);

// Read the A72 Cycle Counter
uint64_t read_cntpct();
