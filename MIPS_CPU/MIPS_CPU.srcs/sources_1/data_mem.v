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
    input [31:0] address,
    input [31:0] data_in,
    input write_enabled,
    output [31:0] data_out,
    output reg [15:0] led
    );
    
    wire [15:0] led_next = (address == 32'hffff0100 & write_enabled) ? data_in[15:0] : led; 
    
    always @(posedge clk) begin
        led <= led_next;
    end
    
    ram ram1(
        .a(address[11:2]),
        .d(data_in),
        .clk(clk),
        .we(write_enabled),
        .spo(data_out)
    );
    
endmodule
