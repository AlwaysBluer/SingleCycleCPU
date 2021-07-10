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
    input wire rst_n,
    output wire[31:0]PC
    );
    wire [31:0]Rs1_value;
    wire [31:0]PC_out;
    wire [1:0]PCsel;//�����ź�,���Ƶ�Ԫ����
     wire [2:0]ImmSel;//�����ź�,���Ƶ�Ԫ����
     wire [31:0]instruction;
    wire [31:0]Data1;//Rs1_value
    wire [31:0]Data2;//Rs2_value
    wire [31:0]SelectedImm;//Imm
    wire [31:0]DataIn;// ��Mem��ALU�н��֮һ�������ȥ��ͨ��WDataSelѡ��д��rd����PC+4����DataIn
    wire WDataSel;//�����ź�,���Ƶ�Ԫ����
    wire WEn;//�����ź�,���Ƶ�Ԫ����
    assign PC = PC_out;

     wire Asel;//�����ź�,���Ƶ�Ԫ����
    wire Bsel;//�����ź�,���Ƶ�Ԫ����
    wire [4:0]ALUop;//�����ź�,���Ƶ�Ԫ����
    wire [31:0]value;//������
    wire Branch;
    wire zero;
    Top_PC pc(
    .PCsel(PCsel),
    .clk(clk),
    .rst_n(rst_n),
    .Rs1_value(Data1),
    .Imm(SelectedImm),
    .PC_out(PC_out)
    );
    
    
    IROM  irom(
    .PC(PC_out),
    .instruction(instruction)
    );
    
   

    ImmGenerator ImmGen(
    .Inst(instruction[31:7]),
    .ImmSel(ImmSel),
    .SelectedImm(SelectedImm)
    );
    
  
   
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
    
   
    ALU alu(
    .A(Data1),
    .PC_out(PC_out),
    .Asel(Asel),
    .Imm(SelectedImm),
    .Bsel(Bsel),
    .B(Data2),
    .ALUop(ALUop),
    .value(value),
    .Branch(Branch),
    .zero(zero)
    );
    
    wire [31:0]rd_data_o;
    wire MemWriteEn;//�����ź�,���Ƶ�Ԫ����
    DRAM dram(
    .clk_i(clk),
    .addr_i(value), //��ַ���Ǿ���ALU��������Ľ��
    .rd_data_o(rd_data_o),
    .memwr_i(MemWriteEn),
    .wr_data_i(Data2)//д�����ʵ����rs2
    );
    
    wire MemSel;//�����ź�,���Ƶ�Ԫ����
    assign DataIn = (MemSel == 1)? rd_data_o : value;
    
    CTRL_Unit ctrlunit(
    .opcode(instruction[6:0]),
    .rs1(instruction[19:15]),
    .rs2(instruction[24:20]),
    .func3(instruction[14:12]),
    .Branch(Branch),
    .func7(instruction[31:25]),
    .ImmSel(ImmSel),
    .op_A_sel(Asel),
    .op_B_sel(Bsel),
    .ALUop(ALUop),
    .WDataSel(WDataSel),
    .MemSel(MemSel),
    .MemWriteEn(MemWriteEn),
    .RegWriteEn(WEn),
    .PCSel(PCsel)
    );
    
endmodule
