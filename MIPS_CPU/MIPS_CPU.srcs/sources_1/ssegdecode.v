`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:55:37 11/09/2015 
// Design Name: 
// Module Name:    ssegdecode 
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
module ssegdecode(
    input      [3:0] in,
    input            e,
    output reg [7:0] out
    );

always@(*) begin
    if (e) out <= 8'b1000_0110;
    else begin
        case(in[3:0])
            4'h0: out <= 8'b1100_0000;
            4'h1: out <= 8'b1111_1001;
            4'h2: out <= 8'b1010_0100;
            4'h3: out <= 8'b1011_0000;
            4'h4: out <= 8'b1001_1001;
            4'h5: out <= 8'b1001_0010;
            4'h6: out <= 8'b1000_0010;
            4'h7: out <= 8'b1111_1000;
            4'h8: out <= 8'b1000_0000;
            4'h9: out <= 8'b1001_0000;
            default: out <= 8'b0111_1111;
        endcase
    end
end

endmodule
