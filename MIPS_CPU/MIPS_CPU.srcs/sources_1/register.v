`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:49:00 03/29/2016 
// Design Name: 
// Module Name:    register 
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
module register(
    input clk,
    input rst_n,
    input [4:0] r1_addr,
    input [4:0] r2_addr,
    input [4:0] r3_addr,
    input [31:0] r3_din,
    input r3_wr,
    output [31:0] r1_dout,
    output [31:0] r2_dout
    );
	 
	 reg [31:0] mem[31:0];
	 reg [7:0] i;			
	 assign r1_dout = (r1_addr == 5'b0)?32'b0:mem[r1_addr];
	 assign r2_dout = (r2_addr == 5'b0)?32'b0:mem[r2_addr];
	 always @(posedge clk or negedge rst_n)
	 begin
		if (~rst_n) 
		begin
			for (i=0;i<32;i=i+1) mem[i] <= 0;
		end
		else begin
			if (r3_wr && (r3_addr != 5'b0))
				mem[r3_addr] <= r3_din;
		end
	 end
	

endmodule
