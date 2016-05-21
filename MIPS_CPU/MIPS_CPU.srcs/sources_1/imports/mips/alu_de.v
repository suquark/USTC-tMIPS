`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:46:28 04/25/2016 
// Design Name: 
// Module Name:    alu_de 
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
module alu_de(
    input [1:0] ALUOp,
    input [5:0] funct,
    output reg [4:0] ALUControl
    );
	 `include "param.v"
	 always @(*) begin
		case (ALUOp[1:0])
			2'b11: ALUControl <= A_NOP;
			2'b00: ALUControl <= A_ADD;
			2'b01: ALUControl <= A_SUB;
			2'b10: begin
				case (funct[5:0])
					6'b100000: ALUControl <= A_ADD;
					6'b100010: ALUControl <= A_SUB;
					6'b100100: ALUControl <= A_AND;
					6'b100101: ALUControl <= A_OR;
					default:   ALUControl <= A_NOP;
				endcase
			end
		endcase
	 end

endmodule
