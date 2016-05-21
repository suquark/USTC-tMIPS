`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/21 16:39:49
// Design Name: 
// Module Name: branch_de
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


module branch_de(
    input [31:0] a,
    input [31:0] b,
    output reg n,
    output reg z,
    output reg p
    );
    always @(*) begin
        if (a > b) begin
            n <= 0; z <= 0; p <= 1;
        end
        if (a == b) begin
            n <= 0; z <= 1; p <= 0;
        end
        if (a < b) begin
            n <= 1; z <= 0; p <= 0;
        end
    end
endmodule
