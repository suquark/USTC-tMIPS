`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2016 05:11:11 PM
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input [5:0] op,
    input [5:0] funct,
    output reg RegWrite,
    output reg MemtoReg,
    output reg MemWrite,
    output reg [4:0] ALUControl,
    output reg ALUSrc,
    output reg RegDst,
    output reg Branch
    );
    
    `include "param.v"
    
    parameter OP_REG_CALC = 6'b000000;
    parameter OP_LW       = 6'b100011;
    parameter OP_SW       = 6'b101011;
    parameter OP_ADDI     = 6'b001000;
    parameter OP_BGTZ     = 6'b000111;
    parameter OP_JAL      = 6'b000011;
    parameter OP_J        = 6'b000010;
    parameter OP_BEQ      = 6'b000100;
    parameter OP_BNE      = 6'b000101;
    
    parameter FUNCT_ADD   = 6'b100000;
    parameter FUNCT_JR    = 6'b001000;
    
    always @(*)
    begin
        case (op)
            OP_REG_CALC: begin
                case(funct)
                    FUNCT_ADD:  begin
                        RegWrite = 1;
                        MemtoReg = MemtoReg_ALU;
                        MemWrite = 0;
                        ALUControl = A_ADD;
                        ALUSrc = ALUSrc_REG;
                        RegDst = RegDst_rd;
                        Branch = 1'b0;
                    end
                    FUNCT_JR:   begin
                        RegWrite = 0;
                        MemtoReg = MemtoReg_ALU;
                        MemWrite = 0;
                        ALUControl = A_NOP;
                        ALUSrc = ALUSrc_REG;
                        RegDst = RegDst_rt;
                        Branch = 1'b1;
                    end
                    default:    begin
                        RegWrite = 0;
                        MemtoReg = MemtoReg_ALU;
                        MemWrite = 0;
                        ALUControl = A_NOP;
                        ALUSrc = ALUSrc_REG;
                        RegDst = RegDst_rt;
                        Branch = 1'b0;
                    end
                endcase
            end
            OP_JAL:     begin
                RegWrite = 1;
                MemtoReg = MemtoReg_ALU;
                MemWrite = 0;
                ALUControl = A_NOP;
                ALUSrc = ALUSrc_REG;
                RegDst = RegDst_rt;
                Branch = 1'b1;
            end
            OP_J, OP_BNE, OP_BEQ, OP_BGTZ:       begin
                 RegWrite = 0;
                 MemtoReg = MemtoReg_ALU;
                 MemWrite = 0;
                 ALUControl = A_NOP;
                 ALUSrc = ALUSrc_REG;
                 RegDst = RegDst_rt;
                 Branch = 1'b1;
            end
            OP_LW:       begin
                RegWrite = 1;
                MemtoReg = MemtoReg_MEM;
                MemWrite = 0;
                ALUControl = A_ADD;
                ALUSrc = ALUSrc_IM;
                RegDst = RegDst_rt;
                Branch = 1'b0;
            end
            OP_SW:       begin
                RegWrite = 0;
                MemtoReg = MemtoReg_ALU;
                MemWrite = 1;
                ALUControl = A_ADD;
                ALUSrc = ALUSrc_IM;
                RegDst = RegDst_rt;
                Branch = 1'b0;
            end
            OP_ADDI:     begin
                RegWrite = 1;
                MemtoReg = MemtoReg_ALU;
                MemWrite = 0;
                ALUControl = A_ADD;
                ALUSrc = ALUSrc_IM;
                RegDst = RegDst_rt;
                Branch = 1'b0;
            end
            default:     begin
                RegWrite = 0;
                MemtoReg = MemtoReg_ALU;
                MemWrite = 0;
                ALUControl = A_NOP;
                ALUSrc = ALUSrc_REG;
                RegDst = RegDst_rt;
                Branch = 1'b0;
            end
        endcase
    end
endmodule
