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

//ALU��Ԫ������߼�ʵ��
module ALU(
    input wire[31:0] A,
    input wire[31:0] PC_out,//PC���������ź�
    input wire Asel,//A��·ѡ���ź�
    input wire[31:0] B,
    input wire[31:0] Imm,
    input wire Bsel,//B��·ѡ���ź�
    input wire [4:0] ALUop,
    output reg[31:0]value,
    output reg Branch, //��֧�ж��ź�
    output reg zero
    );
    
   wire [31:0]op_A;
   wire [31:0]op_B;
   assign op_A = (Asel == 1)? A: PC_out; //A��ѡ���ź�Ϊ1��ʱ�򣬲�����ΪA,����ΪNPC
   assign op_B = (Bsel == 1)? B: Imm; //B��ѡ���ź�Ϊ1��ʱ�򣬲�����ΪB������Ϊ������Imm
    
   wire [31:0] Arithmetic; //��������ALU������
   wire [31:0] Logistic; //�߼�����ALU������
   wire [31:0] Bitmov; //��λ����ALU������
    //�Ƚ���ָ�����Ʒ�ΪBranchCompare �ͼ���ģ�飬ǰһ��ģ��������ǱȽϼ���Ľ�����Ҹ�����Ӧ�ķ���λ������ģ���������ת�ĵ�ַ
    always@(*)begin
        case(ALUop)
        5'b00000: value <= op_A + op_B; // �ӷ� add
        5'b00001: value <= op_A - op_B; //���� sub
        5'b00010: value <= op_A << op_B; //��������
        5'b00011: value <= op_A >> op_B; //�������㣬����
        5'b00100: value <= op_A|op_B;    //������
        5'b00101: value <= op_A & op_B;  //������
        5'b00110: value <= op_A ^ op_B;  //�������
        5'b00111: value <= ($signed(op_B)) >>> op_A;//�߼�����
        //b��ָ���ü���ָ��ʵ�֣�
        endcase
    end
endmodule
