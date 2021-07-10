`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 14:36:39
// Design Name: 
// Module Name: RF
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

//�Ĵ���ģ�飬ʱ���߼���·,����32��32λ�Ĵ���
module RF(
    input wire clk,
    input wire rst_n,
    input wire [4:0]rd,
    input wire [4:0]rs1,
    input wire [4:0]rs2,
    input wire [31:0]PC, //�������PC_out,Ҫ����ΪPC + 4
    input wire [31:0]DataIn,
    input wire WDataSel,//���ź�����ѡ��д��rd����PC+4����ALU������������Mem�ж�ȡ������,���Ƶ�Ԫ����
    input wire WEn,//дʹ���ź�
    output reg [31:0]Data1,//��Ӧ��rs1����������
    output reg [31:0]Data2 //��Ӧ��rs2����������
    );
//���ǵ�����߼�ʹ�ù����ж��ģ��֮������ӳ٣����Զ��Ĵ���������Ҫ�Ӻ��Ű�����ڣ��������ظ���PC���½��ض�RF
//�Ĵ����ļ���д��pc������������һ�£���ͬ�����ػ���ͬ�½���
reg [31:0]DataReg[31:0];
wire [31:0]DataW;
integer i;
assign DataW = (WDataSel == 1)? DataIn : PC+4;

//ûд������֮ǰȫ����ʼ��Ϊ0
initial begin
    for(i = 1;i<32;i = i+1)
        DataReg[i] = 0;
end

//������PC���£�ͬʱDataд��Ĵ���
always@(posedge clk)begin
    if(WEn == 1 && rd != 5'b0) //0�Ĵ��������޸�
        DataReg[rd] <= DataW;
end

//�½��ض�����
always@(negedge clk or negedge rst_n) begin
    if(rst_n == 0) begin
        for (i = 0;i < 32;i = i + 1)
            DataReg[i] = 0;
    end
    else begin 
        Data1 <= (rs1 == 5'b0)? 32'b0: DataReg[rs1];
        Data2 <= (rs2 == 5'b0)? 32'b0: DataReg[rs2];
    end
end

endmodule
