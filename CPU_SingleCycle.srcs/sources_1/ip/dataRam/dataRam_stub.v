// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Thu Jul  1 22:15:09 2021
// Host        : 612-14 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/Administrator/CPU_SingleCycle/CPU_SingleCycle.srcs/sources_1/ip/dataRam/dataRam_stub.v
// Design      : dataRam
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.3" *)
module dataRam(a, d, clk, we, qspo)
/* synthesis syn_black_box black_box_pad_pin="a[13:0],d[31:0],clk,we,qspo[31:0]" */;
  input [13:0]a;
  input [31:0]d;
  input clk;
  input we;
  output [31:0]qspo;
endmodule
