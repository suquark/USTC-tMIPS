`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/30 17:34:38
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
    input [2:0] op,
    input [4:0] rt,
    input signed [31:0] a,
    input signed [31:0] b,
    input [5:0] funct,
    input br,
    output reg [1:0] AddrSrc,
    output reg WaitResult,
    output reg Branch,
    output reg link
    );
    `include "param.v"
    localparam BGEZ_OP = 3'b001;
    localparam BEQ_OP  = 3'b100;
    localparam BNE_OP  = 3'b101;
    localparam BLEZ_OP = 3'b110;
    localparam SPECIAL_OP = 3'b000;
    localparam J_OP = 3'b010;
    localparam JAL_OP = 3'b011;
    localparam JR_OP = 3'b000;
    localparam BLTZAL_OP = 3'b001;
    localparam BLTZ_OP   = 3'b001;
    localparam BGTZ_OP = 3'b111;
    
    always @(*) begin
        if (br) begin
            if (op == SPECIAL_OP) begin 
                AddrSrc <= AddrSrc_REG;
                Branch <= 1'b1;
            end else begin
                if ((op == JAL_OP) || (op == J_OP)) begin 
                    AddrSrc <= AddrSrc_J;
                    Branch <= 1'b1;
                end else begin
                    if (op == BGTZ_OP) begin
                        if (a > 0) begin
                            AddrSrc <= AddrSrc_I;
                            Branch <= 1'b1;
                        end else begin
                            AddrSrc <= AddrSrc_PCPlus4;
                            Branch <= 1'b0;
                        end
                    end else begin
                        if (op ==  BEQ_OP) begin
                            if (a == b) begin
                                AddrSrc <= AddrSrc_I;
                                Branch <= 1'b1;
                            end else begin
                                AddrSrc <= AddrSrc_PCPlus4;
                                Branch <= 1'b0;
                            end
                        end else begin   // I want to go die. If any of you have interests, please help me to complete it
                            AddrSrc <= AddrSrc_PCPlus4;
                            Branch <= 1'b0;
                        end
                    end
                end
            end
        end else begin
            AddrSrc <= AddrSrc_PCPlus4;
            Branch <= 1'b0;
        end
    end
    
    always @(*) begin
        if (br) begin
             if (op == JAL_OP) begin
                 link <= 1'b1;
             end else begin
                 link <= 1'b0;   // I choose to go die. Anyone could help me
             end
         end else begin
            link <= 1'b0;
         end
    end
    
    always @(*) begin
        if (br && (op != J_OP) && (op != JAL_OP)) WaitResult <= 1'b1;
        else WaitResult <= 1'b0;
    end
endmodule
