`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/21 12:12:09
// Design Name: 
// Module Name: processor
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


module processor(
    input clk,
    input rst,
    input irq,
    output [31:0] imem_a,
    input [31:0] imem_d,
    output [31:0] dmem_a,
    input [31:0] dmem_rd,
    output [31:0] dmem_wd,
    output [31:0] dmem_we
    );
endmodule
