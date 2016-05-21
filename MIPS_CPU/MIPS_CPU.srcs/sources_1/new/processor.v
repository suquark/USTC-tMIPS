`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/21 12:12:09
// Design Name: 
// Module Name: processor
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


module processor(
    input clk,
    input rst_n,
    input irq,
    output [31:0] imem_a,
    input [31:0] imem_d,
    output [31:0] dmem_a,
    input [31:0] dmem_rd,
    output [31:0] dmem_wd,
    output [31:0] dmem_we
    );
    
    wire [31:0] nPC;
    reg [31:0] PC;
    wire PCSrcID;
    // segment registers
    reg [31:0] IFID_IR, IFID_PC;
    
    reg IDEX_RegWrite, IDEX_MemtoReg, IDEX_MemWrite, IDEX_ALUSrc, IDEX_RegDst, IDEX_Jump;
    reg [3:0] IDEX_ALUControl[3:0];
    reg [31:0] IDEX_IM, IDEX_A, IDEX_B, IDEX_IR;
    
    reg EXMEM_RegWrite, EXMEM_MemtoReg, EXMEM_MemWrite;
    reg [31:0] EXMEM_ALUOut, EXMEM_WriteData, EXMEM_WriteReg;
    
    reg MEMWB_RegWrite, MEMWB_MemtoReg;
    reg [31:0] MEMWB_ALUOut, MEMWB_ReadData, MEMWB_IR;
    
    wire [4:0] IFID_rd, IFID_rt, IFID_rs, IFID_op;
    wire [4:0] MEMWB_WriteReg;
    wire [31:0] MEMWB_Result;
    //stall signal
    wire StallIF, StallID;
    //forward sigmal
    wire ForwardAID, ForwardBID;
    //flush signal
    wire FlushEX;
    wire [31:0] PCBranch;
    `include "param.v"
    
    
    assign imem_a[31:0] = PC[31:0];
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) begin
            PC[31:0] <= BOOT_ADDR;
        end else begin
            if (~StallIF) begin
                PC <= nPC[31:0];
            end
        end
    end
    
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) begin
            IFID_IR <= 32'b0;
            IFID_PC <=  BOOT_ADDR;
        end else begin
            if (StallIF) begin
                IFID_IR[31:0] <= IFID_IR[31:0];
                IFID_PC[31:0] <= IFID_PC[31:0];
            end else begin
                IFID_IR[31:0] <= imem_d[31:0];
                IFID_PC[31:0] <= nPC[31:0];
            end
        end
    end
    
    wire [25:0] address;
    wire [5:0] IF_op;
    wire [31:0] jump_address;
    wire PCSrcIF;
    assign address = imem_d[25:0];
    assign IF_op = imem_d[31:26];
    assign jump_address =  {PC[31:28], address, 2'b0};
    assign PCSrcIF = (IF_op[5:1] == J_TYPE_OP)?PCSrcIF_J:PCSrcIF_ADD4;
    assign nPC = (PCSrcID == PCSrcID_NORM)?((PCSrcIF == PCSrcIF_ADD4)?PC+32'd4:jump_address):PCBranch;
    //DEBUG information
    assign StallIF = 1'b0;
    assign PCSrcID = PCSrcID_NORM;
  /*  assign IFID_op[5:0] = IFID_IR[31:26];
    assign IFID_rs[4:0] = IFID_IR[25:21];
    assign IFID_rt[4:0] = IFID_IR[20:16];
    assign IFID_rd[4:0] = IFID_ID[15:11];
    
    wire [31:0] reg_r1_dout, reg_r2_dout;
    register register1(
        .clk        (clk),
        .rst_n      (rst_n),
        .r1_addr    (IFID_rs),
        .r2_addr    (IFID_rd),
        .r3_addr    (MEMWB_WriteReg),
        .r3_din     (MEMWB_Result),
        .r3_wr      (MEMWB_RegWrite),
        .r1_dout    (reg_r1_dout),
        .r2_dout    (reg_r2_out)
    );
    wire cu_IDEX_RegWrite, cu_IDEX_MemtoReg, cu_IDEX_MemWrite, cu_IDEX_ALUSrc, cu_IDEX_RegDst;
    wire cu_IDEX_Branch, cu_IDEX_Jump;
    wire [3:0] cu_IDEX_ALUControl;
    
    
    cu cu1(
        .op     (IFID_op[5:0]),
        .RegWrite   (cu_IDEX_RegWrite),
        .MemtoReg   (cu_IDEX_MemtoReg),
        .MemWrite   (cu_IDEX_MemWrite),
        .ALUControl (cu_IDEX_ALUControl[3:0]),
        .ALUSrc     (cu_IDEX_ALUSrc),
        .RegDst     (cu_IDEX_RegDst),
        .Branch     (cu_IDEX_Branch),
        .Jump       (cu_IDEX_Jump) 
    );
    
    wire [15:0] immediate;
    wire [31:0] ext_immediate;
    assign immediate[15:0] = IFID_IR[15:0];
    assign ext_immediate[31:0] = {{16{immediate[15]}}, immediate[15:0]};
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) begin
            IDEX_RegWrite <= 1'b0;
            IDEX_MemtoReg <= MemtoReg_ALU;
            IDEX_MemWrite <= 1'b0;
            IDEX_ALUControl <= A_NOP;
            IDEX_ALUSrc <= ALUSrc_REG; 
            IDEX_RegDst <= RegDst_rt;
            IDEX_IM <= 32'b0;
            IDEX_A <= 32'b0;
            IDEX_B <= 32'b0;
            IDEX_IR[31:0] <= 32'b0;
        end else begin
            if (FlushEX) begin
                 IDEX_RegWrite <= 1'b0;
                 IDEX_MemtoReg <= MemtoReg_ALU;
                 IDEX_MemWrite <= 1'b0;
                 IDEX_ALUControl <= A_NOP;
                 IDEX_ALUSrc <= ALUSrc_REG; 
                 IDEX_RegDst <= RegDst_rt;
                 IDEX_IM <= 32'b0;
                 IDEX_A <= 32'b0;
                 IDEX_B <= 32'b0;
                 IDEX_IR[31:0] <= 32'b0;
            end else begin
                IDEX_RegWrite <= cu_IDEX_RegWrite;
                IDEX_MemtoReg <= cu_IDEX_MemtoReg;
                IDEX_MemWrite <= cu_IDEX_MemWrite;
                IDEX_ALUControl <= cu_IDEX_ALUControl;
                IDEX_ALUSrc <= cu_IDEX_ALUControl;
                IDEX_RegDst <= cu_IDEX_RegDst;
                IDEX_IM <= ext_immediate[31:0];
                IDEX_IR <= IDIF_IR;
                IDEX_A <= (ForwardAID?EXMEM_ALUOut:reg_r1_dout);
                IDEX_B <= (ForwardBID?EXMEM_ALUOut:reg_r2_dout);
            end
        end
    end*/
    
    
        
        
    
    
    
endmodule
