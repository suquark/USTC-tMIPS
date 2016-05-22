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
    output BranchN,
    output BranchZ,
    output BranchP,
    output reg AddrSrc,
    output reg Branch
    );
    
    `include "param.v"
    
    parameter OP_REG_CALC = 6'b000000;
    parameter OP_LW       = 6'b100011;
    parameter OP_SW       = 6'b101011;
    parameter OP_ADDI     = 6'b001000;
    parameter OP_BGTZ     = 6'b000111;
    
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
                        BranchN = 0;
                        BranchZ = 0;
                        BranchP = 0;
                        AddrSrc = AddrSrc_IM;
                        Branch = PCSrcID_NORM;
                    end
                    FUNCT_JR:   begin
                        RegWrite = 0;
                        MemtoReg = MemtoReg_ALU;
                        MemWrite = 0;
                        ALUControl = A_NOP;
                        ALUSrc = ALUSrc_REG;
                        RegDst = RegDst_rt;
                        BranchN = 0;
                        BranchZ = 0;
                        BranchP = 0;
                        AddrSrc = AddrSrc_REG;
                        Branch = PCSrcID_BR;
                    end
                    default:    begin
                        RegWrite = 0;
                        MemtoReg = MemtoReg_ALU;
                        MemWrite = 0;
                        ALUControl = A_NOP;
                        ALUSrc = ALUSrc_REG;
                        RegDst = RegDst_rt;
                        BranchN = 0;
                        BranchZ = 0;
                        BranchP = 0;
                        AddrSrc = AddrSrc_IM;
                        Branch = PCSrcID_NORM;
                    end
                endcase
            end
            OP_LW:       begin
                RegWrite = 1;
                MemtoReg = MemtoReg_MEM;
                MemWrite = 0;
                ALUControl = A_ADD;
                ALUSrc = ALUSrc_IM;
                RegDst = RegDst_rt;
                BranchN = 0;
                BranchZ = 0;
                BranchP = 0;
                AddrSrc = AddrSrc_IM;
                Branch = PCSrcID_NORM;
            end
            OP_SW:       begin
                RegWrite = 0;
                MemtoReg = MemtoReg_ALU;
                MemWrite = 1;
                ALUControl = A_ADD;
                ALUSrc = ALUSrc_IM;
                RegDst = RegDst_rt;
                BranchN = 0;
                BranchZ = 0;
                BranchP = 0;
                AddrSrc = AddrSrc_IM;
                Branch = PCSrcID_NORM;
            end
            OP_ADDI:     begin
                RegWrite = 1;
                MemtoReg = MemtoReg_ALU;
                MemWrite = 0;
                ALUControl = A_ADD;
                ALUSrc = ALUSrc_IM;
                RegDst = RegDst_rt;
                BranchN = 0;
                BranchZ = 0;
                BranchP = 0;
                AddrSrc = AddrSrc_IM;
                Branch = PCSrcID_NORM;
            end
            OP_BGTZ:     begin
                RegWrite = 1;
                MemtoReg = MemtoReg_ALU;
                MemWrite = 0;
                ALUControl = A_ADD;
                ALUSrc = ALUSrc_IM;
                RegDst = RegDst_rt;
                BranchN = 0;
                BranchZ = 0;
                BranchP = 1;
                AddrSrc = AddrSrc_IM;
                Branch = PCSrcID_BR;
            end
            default:     begin
                RegWrite = 0;
                MemtoReg = MemtoReg_ALU;
                MemWrite = 0;
                ALUControl = A_NOP;
                ALUSrc = ALUSrc_REG;
                RegDst = RegDst_rt;
                BranchN = 0;
                BranchZ = 0;
                BranchP = 0;
                AddrSrc = AddrSrc_IM;
                Branch = PCSrcID_NORM;
            end
        endcase
    end
endmodule
