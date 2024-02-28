//--------------------------------------------------------------------------------------
//
// MIT License
// 
// Copyright (c) 2023 Advanced Micro Devices, Inc.
// 
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the 
// Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice (including the 
// next paragraph) shall be included in all copies or substantial portions 
// of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
//
//--------------------------------------------------------------------------------------
// 
// DO NOT MODIFY THIS FILE.


`ifndef axiseg_v1_0
`define axiseg_v1_0

interface axiseg_v1_0();
  logic [127:0] tdata;                                     // 
  logic tuser_ena;                                       // 
  logic tuser_sop;                                       // 
  logic tuser_eop;                                       // 
  logic tuser_err;                                       // 
  logic [3:0] tuser_mty;                                 // 

  modport MASTER (
    output tdata, tuser_ena, tuser_sop, tuser_eop, tuser_err, tuser_mty
    );

  modport SLAVE (
    input tdata, tuser_ena, tuser_sop, tuser_eop, tuser_err, tuser_mty
    );

  modport MONITOR (
    input tdata, tuser_ena, tuser_sop, tuser_eop, tuser_err, tuser_mty
    );

endinterface // axiseg_v1_0

`endif