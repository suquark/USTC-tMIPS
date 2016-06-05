`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:34:07 10/18/2015 
// Design Name: 
// Module Name:    test 
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
module ssegout(
    input            clk,
    input 		[7:0] in3,
    input 		[7:0] in2,
    input 		[7:0] in1,
    input 		[7:0] in0,
    output reg [7:0] outs,
	 output reg [3:0] an = 4'b0111
    );

always@(posedge clk) begin
	case(an)
		4'b0111: begin an = 4'b1011; outs = in2; end
		4'b1011: begin an = 4'b1101; outs = in1; end
		4'b1101: begin an = 4'b1110; outs = in0; end
		4'b1110: begin an = 4'b0111; outs = in3; end
		default: begin an = 4'b0111; outs = in3; end
	endcase
end

endmodule
