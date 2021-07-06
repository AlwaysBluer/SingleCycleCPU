`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 20:38:17
// Design Name: 
// Module Name: ImmGenerator
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

//立即数生成单元，组合逻辑实现
module ImmGenerator(
    input wire[31:7] Inst,
    input wire[2:0] ImmSel,
    output reg[31:0] SelectedImm//经过ImmSel信号选择后输出的生成立即数
    );

wire [31:0]i_Imm;
wire [31:0]s_Imm;
wire [31:0]u_Imm;
wire [31:0]b_Imm;
wire [31:0]j_Imm;

//I型立即数生成，
assign i_Imm = (Inst[31] == 1'b1)? {20'b1, Inst[31:20]} : {20'b0,Inst[31:20]};
//s型立即数
assign s_Imm = (Inst[31] == 1'b1)? {20'b1, Inst[31:25], Inst[11:7]} : {20'b1, Inst[31:25], Inst[11:7]};
//U型立即数
assign u_Imm = {Inst[31:12]  ,12'b0};
//b型立即数
assign b_Imm = (Inst[31] == 1'b1)? {21'b1, Inst[7], Inst[30:25], Inst[11:8]}: {21'b0, Inst[7], Inst[30:25], Inst[11:8]};
//j
assign j_Imm = (Inst[31] == 1'b1)? {21'b1, Inst[19:12], Inst[20], Inst[30:21]}:{21'b0, Inst[19:12], Inst[20], Inst[30:21]};

always@(*)begin
    case(ImmSel)
    3'b000: SelectedImm <= i_Imm;
    3'b001: SelectedImm <= s_Imm;
    3'b010: SelectedImm <= u_Imm;
    3'b011: SelectedImm <= b_Imm;
    3'b100: SelectedImm <= j_Imm;
    default: SelectedImm <= 32'b0;
    endcase
end

endmodule
