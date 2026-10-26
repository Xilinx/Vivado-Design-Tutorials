//
// Copyright (C) 2024, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: X11
//

`timescale 1 ns / 1 ps

(* black_box *) module RP1
   (
    clk,
    rstb,
    dbg_hub_rstb,
    error);
  input clk;
  input rstb;
  input dbg_hub_rstb;
  output [15:0] error;

endmodule
