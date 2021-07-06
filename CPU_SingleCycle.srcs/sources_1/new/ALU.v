`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 15:47:18
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//ALU单元，组合逻辑实现
module ALU(
    input wire[31:0] A,
    input wire[31:0] PC_out,//PC传过来的信号
    input wire Asel,//A多路选择信号
    input wire[31:0] B,
    input wire[31:0] Imm,
    input wire Bsel,//B多路选择信号
    input wire [4:0] ALUop,
    output reg[31:0]value,
    output reg Branch, //分支判断信号
    output reg zero
    );
    
   wire [31:0]op_A;
   wire [31:0]op_B;
   assign op_A = (Asel == 1)? A: PC_out; //A的选择信号为1的时候，操作数为A,否则为NPC
   assign op_B = (Bsel == 1)? B: Imm; //B的选择信号为1的时候，操作数为B，否则为立即数Imm
    
   wire [31:0] Arithmetic; //算数运算ALU计算结果
   wire [31:0] Logistic; //逻辑运算ALU运算结果
   wire [31:0] Bitmov; //移位运算ALU运算结果
    //比较型指令的设计分为BranchCompare 和计算模块，前一个模块的作用是比较计算的结果并且更新相应的符号位，计算模块就是算跳转的地址
    always@(*)begin
        case(ALUop)
        5'b00000: value <= op_A + op_B; // 加法 add
        5'b00001: value <= op_A - op_B; //减法 sub
        5'b00010: value <= op_A << op_B; //左移运算
        5'b00011: value <= op_A >> op_B; //右移运算，算数
        5'b00100: value <= op_A|op_B;    //或运算
        5'b00101: value <= op_A & op_B;  //与运算
        5'b00110: value <= op_A ^ op_B;  //异或运算
        5'b00111: value <= ($signed(op_B)) >>> op_A;//逻辑右移
        //b型指令用减法指令实现，
        endcase
    end
endmodule
