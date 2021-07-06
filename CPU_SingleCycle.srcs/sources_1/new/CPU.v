`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/06 20:45:59
// Design Name: 
// Module Name: CPU
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


module CPU(
    input wire clk,
    input wire rst_n
    );
    wire [31:0]Rs1_value;
    wire [31:0]Imm;
    wire [31:0]PC_out;
    wire [1:0]PCsel;//�����ź�,���Ƶ�Ԫ����
    
    Top_PC pc(
    .PCsel(PCsel),
    .clk(clk),
    .rst_n(rst_n),
    .Rs1_value(Rs1_value),
    .Imm(Imm),
    .PC_out(PC_out)
    );
    
    wire [31:0]instruction;
    IROM  irom(
    .PC(PC_out),
    .instruction(instruction)
    );
    
    wire [2:0]ImmSel;//�����ź�,���Ƶ�Ԫ����
    wire [31:0]SelectedImm;
    ImmGenerator ImmGen(
    .Inst(instruction[31:7]),
    .ImmSel(ImmSel),
    .SelectedImm(SelectedImm)
    );
    
    wire [31:0]DataIn;// ��Mem��ALU�н��֮һ�������ȥ��ͨ��WDataSelѡ��д��rd����PC+4����DataIn
    wire WDataSel;//�����ź�,���Ƶ�Ԫ����
    wire WEn;//�����ź�,���Ƶ�Ԫ����
    wire [31:0]Data1;
    wire [31:0]Data2;
    RF regfile(
    .clk(clk),
    .rst_n(rst_n),
    .rd(instruction[11:7]),
    .rs1(instruction[19:15]),
    .rs2(instruction[24:20]),
    .PC(PC_out),
    .DataIn(DataIn),
    .WDataSel(WDataSel),
    .WEn(WEn),
    .Data1(Data1),
    .Data2(Data2)
    );
    
    wire Asel;//�����ź�,���Ƶ�Ԫ����
    wire Bsel;//�����ź�,���Ƶ�Ԫ����
    wire [4:0]ALUop;//�����ź�,���Ƶ�Ԫ����
    wire [31:0]value;//������
    wire Branch;
    wire zero;
    ALU alu(
    .A(Data1),
    .PC_out(PC_out),
    .Asel(Asel),
    .Imm(SelectedImm),
    .Bsel(Bsel),
    .ALUop(ALUop),
    .value(value),
    .Branch(Branch),
    .zero(zero)
    );
    
    wire [31:0]rd_data_o;
    wire MemWriteEn;//�����ź�,���Ƶ�Ԫ����
    DRAM dram(
    .clk(clk),
    .addr_i(value), //��ַ���Ǿ���ALU��������Ľ��
    .rd_data_o(rd_data_o),
    .memwr_i(MemWriteEn),
    .wr_data_i(Data2)//д�����ʵ����rs2
    );
    
    wire MemSel;//�����ź�,���Ƶ�Ԫ����
    assign DataIn = (MemSel == 1)? rd_data_o : value;
    
    
    
    
    
endmodule
