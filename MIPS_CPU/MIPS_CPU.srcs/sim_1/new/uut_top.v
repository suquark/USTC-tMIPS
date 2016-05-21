`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/21 16:03:25
// Design Name: 
// Module Name: uut_top
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


module uut_top();
    reg rst_n;
    reg clk;
    top top1(
        .rst_n  (rst_n),
        .clk    (clk) 
    );
    initial begin
        rst_n = 0;
        clk = 0;
        #100;
        rst_n = 1;
    end
    always begin
        #5;
        clk = ~clk;
    end
endmodule
