`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/06 10:21:44
// Design Name: 
// Module Name: CTRL_Unit
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

//控制单元，组合逻辑实现
module CTRL_Unit(
    input wire[6:0] opcode,
    input wire[4:0] rs1,
    input wire[4:0] rs2,
    input wire[2:0] func3,
    input wire[6:0] func7,
    output reg[1:0] ImmSel,//立即数输出选择信号,对应I, S，U, B
    output reg op_A_sel,// A路输入信号选择，0为PC，1为rs1
    output reg op_B_sel,// B路输入信号选择，0为立即数，1为rs2
    output reg[5:0] ALUop, //ALU控制信号
    output reg WDataSel,//控制写入rd的是PC+4 还是 ALU_value / Mem_data 选择输出值
    output reg MemSel,  //控制输出为ALU_value-0 / Mem_data-1中的一个
    output reg MemWriteEn, //写入Mem的使能信号
    output reg Branch, //分支控制信号,这个信号我觉得可有可无，因为在给出op或者func3,func7的时候，就已经告诉了执行的是跳转指令
    output reg RegWriteEn, //寄存器写使能信号
    output reg[1:0]PCSel
    );
    
    always@(*) begin
        case(opcode)
        //R型指令
        7'b0110011:
             begin
                ImmSel <= 2'b00; //不涉及立即数操作，所以无所谓
                op_A_sel <= 1;
                op_B_sel <= 1;//全部为寄存器操作数
                WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                MemSel <= 0; //控制输出为ALU_value-0 
                MemWriteEn <= 0;//不写入内存
                Branch <= 0;//不分支
                RegWriteEn <= 1;//存入rd
                PCSel <= 2'b00;//PC = PC + 4
                if(func3 == 3'b000 && func7 == 7'b0000000) //add
                    ALUop <= 5'b00000;
                else if(func3 == 3'b000 && func7 == 7'b0100000)//sub
                    ALUop <= 5'b00001;
                else if(func3 == 3'b111 && func7 == 7'b0000000)//and
                    ALUop <= 5'b00101;
                else if(func3 == 3'b110 && func7 == 7'b0000000)//or
                    ALUop <= 5'b00100;
                else if(func3 == 3'b100 && func7 == 7'b0000000)//xor
                    ALUop <= 5'b00110;
                else if(func3 == 3'b001 && func7 == 7'b0000000)//sll
                    ALUop <= 5'b00010;
                else if(func3 == 3'b101 && func7 == 7'b0000000)//srl
                    ALUop <= 5'b00011;
                else if(func3 == 3'b101 && func7 == 7'b0100000)//算数右移sra
                    ALUop <= 5'b00111;
             end
         //I型指令
         7'b0010011:
            begin
                if(func3 == 3'b000) begin//addi
                    ALUop <= 5'b00000;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    Branch <= 0;//不分支
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                 end
                else if(func3 == 3'b111) begin//andi
                    ALUop <= 5'b00101;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    Branch <= 0;//不分支
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b110) begin//ori
                    ALUop <= 5'b00100;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    Branch <= 0;//不分支
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b100) begin//xori
                    ALUop <= 5'b00110;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    Branch <= 0;//不分支
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                 end
                else if(func3 == 3'b001 && func7 == 7'b0000000) begin//slli
                    ALUop <= 5'b00010;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    Branch <= 0;//不分支
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                 end
                else if(func3 == 3'b101 && func7 == 7'b0000000) begin//srli
                    ALUop <= 5'b00011;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    Branch <= 0;//不分支
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b101 && func7 == 7'b0100000) begin//srai
                    ALUop <= 5'b00111;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    Branch <= 0;//不分支
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b010) begin // lw:从地址(rs1)+sext(offset)读取四个字节，经符号扩展后写入寄存器rd
                    ALUop <= 5'b00000; 
                    ImmSel = 2'b00;
                    op_A_sel <= 1;
                    op_B_sel <= 0;//立即数
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 1;//选择Mem_data
                    MemWriteEn <= 0;
                    Branch <= 0;
                    RegWriteEn <= 1;
                    PCSel <= 2'b00;// PC = PC + 4；
                end
                else if(func3 == 3'b000) begin //jalr：将PC设置为(rs1)+sext(offset)，把计算出的地址的最低位设为0，并将原PC+4的值写入寄存器rd。rd默认为1。
                    ImmSel = 2'b00;
                    ALUop <= 5'b00000;
                    op_A_sel <= 1;
                    op_B_sel <= 0;
                    WDataSel <= 0; //写入rd的为PC+4
                    MemSel <= 0;
                    MemWriteEn <= 0;
                    Branch <= 0;
                    RegWriteEn <= 1;
                    PCSel <= 2'b11; //写入PC的为PCC
                end
            end
         7'b0100011: begin //S型指令 sw：将寄存器rs2存入内存地址(rs1)+sext(offset),这个指令通过ALU计算地址，不需要写入寄存器中
            if(func3 == 3'b010) begin
                ImmSel = 2'b01;//S型立即数
                ALUop <= 5'b00000;//add操作
                op_A_sel <= 1;//rs1
                op_B_sel <= 0;//立即数
                WDataSel <= 1;
                MemSel <= 1;//这两个信号其实没什么用？
                MemWriteEn <= 1;
                Branch <= 0;
                RegWriteEn <= 0;
                PCSel <= 2'b00;// PC = PC + 4；
            end
            else  begin end
            end
         7'b1100011:begin//B型指令
         end
         
         7'b0110111:begin//U型指令
         end
         7'b1101111:begin//j型指令            
         end
        endcase
    end
    
    
endmodule
