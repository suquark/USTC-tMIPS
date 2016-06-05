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
    input clk,
    input rst_n,
    input [7:0] in3,
    input [7:0] in2,
    input [7:0] in1,
    input [7:0] in0,
    output reg [7:0] outs,
    output reg [3:0] an
    );

reg [31:0] cnt;

always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        an <= 4'b1111;
        outs <= 8'h0;
        cnt <= 32'd0;
    end
    else begin
        if (cnt == 32'd50000) begin
            cnt <= 32'd0;
            case(an)
                4'b0111: begin an <= 4'b1011; outs <= in2;  end
                4'b1011: begin an <= 4'b1101; outs <= in1;  end
                4'b1101: begin an <= 4'b1110; outs <= in0;  end
                4'b1110: begin an <= 4'b0111; outs <= in3;  end
                default: begin an <= 4'b0111; outs <= in3;  end
            endcase
        end
        else begin
            cnt <= cnt + 1;
            case(an)
                4'b0111: begin an <= 4'b0111; outs <= in3;  end
                4'b1011: begin an <= 4'b1011; outs <= in2;  end
                4'b1101: begin an <= 4'b1101; outs <= in1;  end
                4'b1110: begin an <= 4'b1110; outs <= in0;  end
                default: begin an <= 4'b1111; outs <= 8'h0; end
            endcase
        end
    end
end

endmodule
