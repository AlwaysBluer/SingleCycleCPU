
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


module top(
    input wire clk,
    input wire rst_n,
	output        debug_wb_have_inst,   // WB闃舵鏄惁鏈夋寚浠?(瀵瑰崟鍛ㄦ湡CPU锛屾flag鎭掍负1)
    output [31:0] debug_wb_pc,          // WB闃舵鐨凱C (鑻b_have_inst=0锛屾椤瑰彲涓轰换鎰忓€?
    output        debug_wb_ena,         // WB闃舵鐨勫瘎瀛樺櫒鍐欎娇鑳?(鑻b_have_inst=0锛屾椤瑰彲涓轰换鎰忓€?
    output [4:0]  debug_wb_reg,         // WB闃舵鍐欏叆鐨勫瘎瀛樺櫒鍙?(鑻b_ena鎴杦b_have_inst=0锛屾椤瑰彲涓轰换鎰忓€?
    output [31:0] debug_wb_value        // WB闃舵鍐欏叆瀵勫瓨鍣ㄧ殑鍊?(鑻b_ena鎴杦b_have_inst=0锛屾椤瑰彲涓轰换鎰忓€?
    );
    wire [31:0]PC_out;
    wire [1:0]PCsel;//鎺у埗淇″彿,鎺у埗鍗曞厓鐢熸垚
    wire [2:0]ImmSel;//鎺у埗淇″彿,鎺у埗鍗曞厓鐢熸垚
    wire [31:0]instruction;
    wire [31:0]Data1;//Rs1_value
    wire [31:0]Data2;//Rs2_value
    wire [31:0]SelectedImm;//Imm
    wire [31:0]DataIn;// 鍦∕em鍜孉LU涓粨鏋滀箣涓€锛岃緭鍏ヨ繘鍘诲悗閫氳繃WDataSel閫夋嫨鍐欏叆rd鐨勬槸PC+4杩樻槸DataIn
    wire WDataSel;//鎺у埗淇″彿,鎺у埗鍗曞厓鐢熸垚
    wire WEn;//鎺у埗淇″彿,鎺у埗鍗曞厓鐢熸垚
    
    wire Asel;//鎺у埗淇″彿,鎺у埗鍗曞厓鐢熸垚
    wire Bsel;//鎺у埗淇″彿,鎺у埗鍗曞厓鐢熸垚
    wire [4:0]ALUop;//鎺у埗淇″彿,鎺у埗鍗曞厓鐢熸垚
    wire [31:0]value;//璁＄畻缁撴灉
    wire Branch;
    wire zero;
	
	assign debug_wb_have_inst = 1'b1;
	assign debug_wb_pc = PC_out;
	assign debug_wb_ena = WEn;
	assign debug_wb_reg = instruction[11:7];
	assign debug_wb_value = (WDataSel == 1)? DataIn : PC_out + 4;
	
    Top_PC pc(
    .PCsel(PCsel),
    .clk(clk),
    .rst_n(rst_n),
    .Rs1_value(Data1),
    .Imm(SelectedImm),
    .PC_out(PC_out)
    );
    
    
    inst_mem imem(
    .a(PC_out[15:2]),
    .spo(instruction)
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
    wire MemWriteEn;//鎺у埗淇″彿,鎺у埗鍗曞厓鐢熸垚
	
    data_mem dmem(
    .clk(clk),
    .a(value[15:2]), //鍦板潃灏辨槸缁忚繃ALU璁＄畻杈撳嚭鐨勭粨鏋?
    .spo(rd_data_o),
    .we(MemWriteEn),
    .d(Data2)//鍐欏叆鐨勫叾瀹炲氨鏄痳s2
    );
    
    wire MemSel;//鎺у埗淇″彿,鎺у埗鍗曞厓鐢熸垚
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
