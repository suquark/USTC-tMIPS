`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:08 11/23/2015 
// Design Name: 
// Module Name:    debounce 
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
module debounce(
    input clk,
    input in,
    output reg out = 1'b0
    );

reg [19:0] cnt = 20'd0;

always @(posedge clk) begin
	if (in != out) begin
		cnt <= cnt + 20'd1;
		if (cnt == 20'd1000000) begin
			out <= in;
			cnt <= 20'd0;
		end
	end
	else begin
		cnt <= 20'b0;
	end
end

endmodule
