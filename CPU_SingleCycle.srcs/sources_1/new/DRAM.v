`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 22:17:37
// Design Name: 
// Module Name: DRAM
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


module DRAM(
    input wire clk_i,//ʱ���źţ������
    input wire [31:0]addr_i,//��ַ��д����߶�����
    output wire [31:0]rd_data_o,//����������
    input wire memwr_i, //�ڴ�дʹ���ͺ�
    input wire[31:0]wr_data_i //Ҫд�������
    );
    wire ram_clk;
    assign ram_clk = !clk_i; // ��ΪоƬ�Ĺ����ӳ٣�DRAM�ĵ�ַ����������ʱ��������׼����,
// ʹ��ʱ�����������ݶ����������Բ��÷���ʱ�ӣ�ʹ�ö������ݱȵ�ַ׼����Ҫ���Լ���ʱ��,
// �Ӷ��ܹ������ȷ�����ݡ�
    dataRam U_dram(
    .clk(clk_i),
    .a(addr_i[15:2]),
    .qspo(rd_data_o),
    .we(memwr_i),
    .d(wr_data_i)
    );
endmodule
