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
    input wire clk_i,//时钟信号？干嘛的
    input wire [31:0]addr_i,//地址（写入或者读出）
    output wire [31:0]rd_data_o,//读出的数据
    input wire memwr_i, //内存写使能型号
    input wire[31:0]wr_data_i //要写入的数据
    );
    wire ram_clk;
    assign ram_clk = !clk_i; // 因为芯片的固有延迟，DRAM的地址线来不及在时钟上升沿准备好,
// 使得时钟上升沿数据读出有误。所以采用反相时钟，使得读出数据比地址准备好要晚大约半个时钟,
// 从而能够获得正确的数据。
    dataRam U_dram(
    .clk(clk_i),
    .a(addr_i[15:2]),
    .qspo(rd_data_o),
    .we(memwr_i),
    .d(wr_data_i)
    );
endmodule
