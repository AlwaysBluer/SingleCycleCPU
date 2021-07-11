
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/06 08:56:31
// Design Name: 
// Module Name: NPC
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

//PC�ĸ����źţ��ֱ���������PC��ֵ��������PC���ӣ�����PC�У� ����߼�ʵ��
module NPC(
    input  wire [31:0]PC,
    input  wire [31:0]Imm,
    input  wire [31:0]Rs1_value,
    output wire [31:0]PC4,
    output wire [31:0]PC_offset,
    output wire [31:0]Rs1_offset,
    output wire [31:0]PCC //����ź��Ǹ����:jalrָ���PC����Ϊ(rs1)+sext(offset)���Ѽ�����ĵ�ַ�����λ��Ϊ0
    );
    assign PC_offset = PC + Imm;
    assign Rs1_offset = Rs1_value + Imm;
    assign PC4 = PC + 4;
    assign PCC = (Rs1_value + Imm) & (~1);
    
endmodule