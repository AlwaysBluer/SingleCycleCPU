`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/09 16:22:15
// Design Name: 
// Module Name: CPU_top
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


module CPU_top(
    input  wire         clk    ,
    input  wire         rst_n  ,
    output wire         led0_en,
    output wire         led1_en,
    output wire         led2_en,
    output wire         led3_en,
    output wire         led4_en,
    output wire         led5_en,
    output wire         led6_en,
    output wire         led7_en,
    output wire         led_ca ,
    output wire         led_cb ,
    output wire         led_cc ,
    output wire         led_cd ,
    output wire         led_ce ,
    output wire         led_cf ,
    output wire         led_cg ,
    output wire         led_dp
    );
    wire [31:0]PC;
    reg clk_lf;
    reg [22:0]divcount;
    
    initial begin
        clk_lf = 0;
    end
    
    always@(posedge clk)
    begin
        if(divcount == 23'd4999999) 
            begin
                divcount <= 23'd0;
                clk_lf <= ~clk_lf;
            end
         else
            divcount <= divcount + 1;
    end
    
    CPU mycpu(
    .clk(clk_lf),
    .rst_n(rst_n),
    .PC(PC)
    );
    
    display Display(
    .clk(clk),
    .rst_n(rst_n),
    .PC(PC),
    .led0_en(led0_en),
    .led1_en(led1_en),
    .led2_en(led2_en),
    .led3_en(led3_en),
    .led4_en(led4_en),
    .led5_en(led5_en),
    .led6_en(led6_en),
    .led7_en(led7_en),
    .led_ca(led_ca),
    .led_cb(led_cb),
    .led_cc(led_cc),
    .led_cd(led_cd),
    .led_ce(led_ce),
    .led_cf(led_cf),
    .led_cg(led_cg),
    .led_dp(led_dp)
    );
    
    
    
endmodule
