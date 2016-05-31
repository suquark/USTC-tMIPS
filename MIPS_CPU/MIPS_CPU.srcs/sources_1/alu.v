`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Tianyi Cui
// 
// Create Date:    22:43:38 03/21/2016 
// Design Name: 
// Module Name:    top 
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
module alu(
    input signed [31:0] alu_a,
    input signed [31:0] alu_b,
    input [4:0] alu_op,
    output reg signed [31:0] alu_out
    );
	`include "param.v"
	always @(*)
		case (alu_op[4:0])
			A_ADD: alu_out <= alu_a + alu_b;
			A_NOP: alu_out <= alu_a;
			A_SUB: alu_out <= alu_a - alu_b;
			A_AND: alu_out <= alu_a & alu_b;
			A_OR:  alu_out <= alu_a | alu_b;
			A_XOR: alu_out <= alu_a ^ alu_b;
			A_NOR: alu_out <= ~(alu_a | alu_b);
			A_SLL: alu_out <= alu_a << alu_b[4:0];
            A_SRA: alu_out <= alu_a >>> alu_b[4:0];
            A_SRL: alu_out <= alu_a >> alu_b[4:0];
			default: alu_out <= 32'b0;
		endcase
	
endmodule
