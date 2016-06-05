`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:18:37 11/16/2015 
// Design Name: 
// Module Name:    sseg_clock_gen 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sseg_clock_gen(
    input clk_in,
    output reg clk1 = 0 // clk_in.period * 100000
    );

reg [31:0] counter = 0;

always@(posedge clk_in) begin
    if (counter >= 32'd49999999) counter <= 32'd0;
    else counter <= counter + 1;
    if (counter % 32'd50000 == 32'd0) clk1 <= ~clk1;
    else clk1 <= clk1;
end

endmodule
