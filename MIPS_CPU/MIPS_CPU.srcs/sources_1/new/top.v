`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/21 12:15:46
// Design Name: 
// Module Name: top
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
    input clk,
    input rst_n
    );
    wire [31:0] imem_a, imem_d;
    processor processor1
    (
        .clk    (clk),
        .rst_n  (rst_n),
        .imem_a    (imem_a),
        .imem_d     (imem_d)
    );
    rom rom1(
        .a  (imem_a[7:2]),
        .spo    (imem_d)
    );
endmodule
