`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/07 21:26:59
// Design Name: 
// Module Name: cpu_sim
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


module cpu_sim(
    );
    
    reg clk = 1;
    reg rst_n = 1;
    always #10 clk = ~clk;
    
    CPU mycpu(
    .clk(clk),
    .rst_n(rst_n)
    );
endmodule
