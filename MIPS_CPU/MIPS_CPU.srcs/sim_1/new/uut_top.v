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
    reg irq;
    wire [15:0] led;
    top top1(
        .rst_n       (rst_n),
        .clk_orig    (clk),
        .led         (led),
        .irq        (irq)
    );
    initial begin
        rst_n = 0;
        clk = 0;
        irq = 0;
        #100;
        rst_n = 1;
        #350;
        irq = 1;
        #20;
        irq = 0;
    end
    always begin
        #5;
        clk = ~clk;
    end
endmodule
