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
    wire [1:0]PCsel;//控制信号,控制单元生成
    
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
    
    wire [2:0]ImmSel;//控制信号,控制单元生成
    wire [31:0]SelectedImm;
    ImmGenerator ImmGen(
    .Inst(instruction[31:7]),
    .ImmSel(ImmSel),
    .SelectedImm(SelectedImm)
    );
    
    wire [31:0]DataIn;// 在Mem和ALU中结果之一，输入进去后通过WDataSel选择写入rd的是PC+4还是DataIn
    wire WDataSel;//控制信号,控制单元生成
    wire WEn;//控制信号,控制单元生成
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
    
    wire Asel;//控制信号,控制单元生成
    wire Bsel;//控制信号,控制单元生成
    wire [4:0]ALUop;//控制信号,控制单元生成
    wire [31:0]value;//计算结果
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
    wire MemWriteEn;//控制信号,控制单元生成
    DRAM dram(
    .clk(clk),
    .addr_i(value), //地址就是经过ALU计算输出的结果
    .rd_data_o(rd_data_o),
    .memwr_i(MemWriteEn),
    .wr_data_i(Data2)//写入的其实就是rs2
    );
    
    wire MemSel;//控制信号,控制单元生成
    assign DataIn = (MemSel == 1)? rd_data_o : value;
    
    
    
    
    
endmodule
