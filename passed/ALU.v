
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
   wire [31:0]temp;
   assign op_A = (Asel == 1)? A: PC_out; //A��ѡ���ź�Ϊ1��ʱ�򣬲�����ΪA,����ΪNPC
   assign op_B = (Bsel == 1)? B: Imm; //B��ѡ���ź�Ϊ1��ʱ�򣬲�����ΪB������Ϊ������Imm
   assign temp = op_A - op_B;

    //�Ƚ���ָ�����Ʒ�ΪBranchCompare �ͼ���ģ�飬ǰһ��ģ��������ǱȽϼ���Ľ�����Ҹ�����Ӧ�ķ���λ������ģ���������ת�ĵ�ַ
    always@(*)begin
        case(ALUop)
        5'b00000: value <= op_A + op_B; // �ӷ� add
        5'b00001: value <= op_A - op_B; //���� sub
        5'b00010: value <= op_A << op_B[4:0]; //��������
        5'b00011: value <= op_A >> op_B[4:0]; //�������㣬����
        5'b00100: value <= op_A|op_B;    //������
        5'b00101: value <= op_A & op_B;  //������
        5'b00110: value <= op_A ^ op_B;  //�������
        5'b00111: value <= ($signed(op_A)) >>> op_B[4:0];//�߼�����:sraָ���ǽ�rs1����������rs2λ�����ǣ�rs2)λ������ôʵ�֣���
        5'b01000: Branch <= (op_A == op_B)? 1 : 0;//beq
        5'b01001: Branch <= (op_A != op_B)? 1 : 0;//bne
        5'b01010: Branch <= (temp[31] == 1'b1)? 1'b1 : 1'b0;               // (op_A < op_B)? 1 : 0;//blt
        5'b01011: Branch <= (temp[31] == 1'b0)? 1'b1 : 1'b0;//bge branchΪ1������������Ƶ�Ԫ�������п����źŵ�ʱ��ͱ���Ҫע�����PCSel������
        5'b01100: value <= op_B; //luiָ�ֱ�Ӱ����ɵ�u��������д�뵽�Ĵ����ļ���
        default: value <= 0;
        endcase
    end
endmodule