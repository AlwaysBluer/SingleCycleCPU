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

//���Ƶ�Ԫ������߼�ʵ��
module CTRL_Unit(
    input wire[6:0] opcode,
    input wire[4:0] rs1,
    input wire[4:0] rs2,
    input wire[2:0] func3,
    input wire[6:0] func7,
    output reg[1:0] ImmSel,//���������ѡ���ź�,��ӦI, S��U, B
    output reg op_A_sel,// A·�����ź�ѡ��0ΪPC��1Ϊrs1
    output reg op_B_sel,// B·�����ź�ѡ��0Ϊ��������1Ϊrs2
    output reg[5:0] ALUop, //ALU�����ź�
    output reg WDataSel,//����д��rd����PC+4 ���� ALU_value / Mem_data ѡ�����ֵ
    output reg MemSel,  //�������ΪALU_value-0 / Mem_data-1�е�һ��
    output reg MemWriteEn, //д��Mem��ʹ���ź�
    output reg Branch, //��֧�����ź�,����ź��Ҿ��ÿ��п��ޣ���Ϊ�ڸ���op����func3,func7��ʱ�򣬾��Ѿ�������ִ�е�����תָ��
    output reg RegWriteEn, //�Ĵ���дʹ���ź�
    output reg[1:0]PCSel
    );
    
    always@(*) begin
        case(opcode)
        //R��ָ��
        7'b0110011:
             begin
                ImmSel <= 2'b00; //���漰��������������������ν
                op_A_sel <= 1;
                op_B_sel <= 1;//ȫ��Ϊ�Ĵ���������
                WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                MemSel <= 0; //�������ΪALU_value-0 
                MemWriteEn <= 0;//��д���ڴ�
                Branch <= 0;//����֧
                RegWriteEn <= 1;//����rd
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
                else if(func3 == 3'b101 && func7 == 7'b0100000)//��������sra
                    ALUop <= 5'b00111;
             end
         //I��ָ��
         7'b0010011:
            begin
                if(func3 == 3'b000) begin//addi
                    ALUop <= 5'b00000;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    Branch <= 0;//����֧
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                 end
                else if(func3 == 3'b111) begin//andi
                    ALUop <= 5'b00101;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    Branch <= 0;//����֧
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b110) begin//ori
                    ALUop <= 5'b00100;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    Branch <= 0;//����֧
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b100) begin//xori
                    ALUop <= 5'b00110;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    Branch <= 0;//����֧
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                 end
                else if(func3 == 3'b001 && func7 == 7'b0000000) begin//slli
                    ALUop <= 5'b00010;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    Branch <= 0;//����֧
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                 end
                else if(func3 == 3'b101 && func7 == 7'b0000000) begin//srli
                    ALUop <= 5'b00011;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    Branch <= 0;//����֧
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b101 && func7 == 7'b0100000) begin//srai
                    ALUop <= 5'b00111;
                    ImmSel <= 2'b00;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    Branch <= 0;//����֧
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b010) begin // lw:�ӵ�ַ(rs1)+sext(offset)��ȡ�ĸ��ֽڣ���������չ��д��Ĵ���rd
                    ALUop <= 5'b00000; 
                    ImmSel = 2'b00;
                    op_A_sel <= 1;
                    op_B_sel <= 0;//������
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 1;//ѡ��Mem_data
                    MemWriteEn <= 0;
                    Branch <= 0;
                    RegWriteEn <= 1;
                    PCSel <= 2'b00;// PC = PC + 4��
                end
                else if(func3 == 3'b000) begin //jalr����PC����Ϊ(rs1)+sext(offset)���Ѽ�����ĵ�ַ�����λ��Ϊ0������ԭPC+4��ֵд��Ĵ���rd��rdĬ��Ϊ1��
                    ImmSel = 2'b00;
                    ALUop <= 5'b00000;
                    op_A_sel <= 1;
                    op_B_sel <= 0;
                    WDataSel <= 0; //д��rd��ΪPC+4
                    MemSel <= 0;
                    MemWriteEn <= 0;
                    Branch <= 0;
                    RegWriteEn <= 1;
                    PCSel <= 2'b11; //д��PC��ΪPCC
                end
            end
         7'b0100011: begin //S��ָ�� sw�����Ĵ���rs2�����ڴ��ַ(rs1)+sext(offset),���ָ��ͨ��ALU�����ַ������Ҫд��Ĵ�����
            if(func3 == 3'b010) begin
                ImmSel = 2'b01;//S��������
                ALUop <= 5'b00000;//add����
                op_A_sel <= 1;//rs1
                op_B_sel <= 0;//������
                WDataSel <= 1;
                MemSel <= 1;//�������ź���ʵûʲô�ã�
                MemWriteEn <= 1;
                Branch <= 0;
                RegWriteEn <= 0;
                PCSel <= 2'b00;// PC = PC + 4��
            end
            else  begin end
            end
         7'b1100011:begin//B��ָ��
         end
         
         7'b0110111:begin//U��ָ��
         end
         7'b1101111:begin//j��ָ��            
         end
        endcase
    end
    
    
endmodule
