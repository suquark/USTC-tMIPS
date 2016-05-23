`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2016 08:54:36 PM
// Design Name: 
// Module Name: data_mem
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


module data_mem(
    input clk,
    input rst_n,
    input [31:0] address,
    input [31:0] data_in,
    input write_enabled,
    output [31:0] data_out,
    output reg [15:0] led
    );
    
    wire [15:0] led_next = (address == 32'h0000204C & write_enabled) ? data_in[15:0] : led; 
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) led <= 16'h0000;
        else led <= led_next;
    end
    
    ram ram1(
        .a(address[11:2]),
        .d(data_in),
        .clk(clk),
        .we(write_enabled),
        .spo(data_out)
    );
    
endmodule
