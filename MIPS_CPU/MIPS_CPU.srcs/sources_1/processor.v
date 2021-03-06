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
    output wire interrupt,
    output [31:0] imem_a,
    input [31:0] imem_d,
    output [31:0] dmem_a,
    input [31:0] dmem_rd,
    output [31:0] dmem_wd,
    output dmem_we
    );
    
    reg [31:0] nPC;
    reg [31:0] PC;
    wire PCSrcID;
    // segment registers
    reg [31:0] IFID_IR, IFID_PC;
    
    reg IDEX_RegWrite, IDEX_MemtoReg, IDEX_MemWrite, IDEX_RegDst, IDEX_link;
    reg [1:0] IDEX_ALUSrc;
    reg [4:0] IDEX_ALUControl;
    reg [31:0] IDEX_IM, IDEX_A, IDEX_B, IDEX_IR, IDEX_PC;
    
    reg EXMEM_RegWrite, EXMEM_MemtoReg, EXMEM_MemWrite, EXMEM_link;
    reg [31:0] EXMEM_ALUOut, EXMEM_WriteData, EXMEM_PC;
    reg [4:0] EXMEM_WriteReg;
    
    reg MEMWB_RegWrite, MEMWB_MemtoReg;
    reg [31:0] MEMWB_ALUOut, MEMWB_ReadData;
    
    wire [4:0] IFID_rd, IFID_rt, IFID_rs;
    wire [5:0] IFID_funct, IFID_op;
    reg [4:0] MEMWB_WriteReg;
    wire [31:0] MEMWB_Result;
    //stall signal
    wire StallIF, StallID;
    //forward sigmal
    wire ForwardAID, ForwardBID;
    wire [1:0] ForwardAEX, ForwardBEX;
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
    //wire IFID_rst_n;
    //assign IFID_rst_n = rst_n && ~PCSrcID;
    wire [31:0] PCPlus4;
    assign PCPlus4[31:0] = PC[31:0] + 32'd4;
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) begin
            IFID_IR <= 32'b0;
            IFID_PC <=  BOOT_ADDR;
        end else begin
				if (StallID) begin
					 IFID_IR[31:0] <= IFID_IR[31:0];
					 IFID_PC[31:0] <= IFID_PC[31:0];
				end else begin
				    if (PCSrcID || interrupt) begin
                    IFID_IR <= 32'b0;
                    IFID_PC <= BOOT_ADDR;
                end else begin
					     IFID_IR[31:0] <= imem_d[31:0];
					     IFID_PC[31:0] <= PCPlus4;
                end
				end
                
        end
    end
    
    //wire [25:0] address;
    //wire [5:0] IF_op;
    //wire [31:0] jump_address;
    //wire [31:0] ext_immediate;
    //wire PCSrcIF;
    //assign IF_op = imem_d[31:26];
    //assign PCSrcIF = (IF_op[5:1] == J_TYPE_OP)?PCSrcIF_J:PCSrcIF_ADD4;
    //assign nPC = interrupt?ISR_ADDR:((PCSrcID == PCSrcID_NORM)?
    //((PCSrcIF == PCSrcIF_ADD4)?PC+32'd4:jump_address):PCBranch);
    
    //nPC logic
    
    
    
    //DEBUG information
    //assign StallIF = 1'b0;
    //assign PCSrcID = PCSrcID_NORM;
    wire [5:0] IFIF_funct;
    assign IFID_op[5:0] = IFID_IR[31:26];
    assign IFID_rs[4:0] = IFID_IR[25:21];
    assign IFID_rt[4:0] = IFID_IR[20:16];
    assign IFID_rd[4:0] = IFID_IR[15:11];
    assign IFID_funct[5:0] = IFID_IR[5:0];
    
    wire [31:0] reg_r1_dout, reg_r2_dout;
    register register1(
        .clk        (~clk),
        .rst_n      (rst_n),
        .r1_addr    (IFID_rs),
        .r2_addr    (IFID_rt),
        .r3_addr    (MEMWB_WriteReg),
        .r3_din     (MEMWB_Result),
        .r3_wr      (MEMWB_RegWrite),
        .r1_dout    (reg_r1_dout),
        .r2_dout    (reg_r2_dout)
    );
    wire cu_IDEX_RegWrite, cu_IDEX_MemtoReg, cu_IDEX_MemWrite, cu_IDEX_RegDst;
    wire [1:0] cu_IDEX_ALUSrc;
    wire cu_br;
    wire [4:0] cu_IDEX_ALUControl;
    
    control_unit cu1(
        .op         (IFID_op[5:0]),
        .funct      (IFID_funct[5:0]),
        .RegWrite   (cu_IDEX_RegWrite),
        .MemtoReg   (cu_IDEX_MemtoReg),
        .MemWrite   (cu_IDEX_MemWrite),
        .ALUControl (cu_IDEX_ALUControl[4:0]),
        .ALUSrc     (cu_IDEX_ALUSrc),
        .RegDst     (cu_IDEX_RegDst),
        .Branch     (cu_br)
    );
    
    wire [15:0] immediate;    
    wire [25:0] address;
    wire [31:0] jump_address;
    wire [31:0] ext_immediate;
    wire [1:0] AddrSrc;
    assign immediate[15:0] = IFID_IR[15:0];
    assign ext_immediate[31:0] = {{16{immediate[15]}}, immediate[15:0]};
    assign address = IFID_IR[25:0];
    assign jump_address =  {CHK_IFID_PC[31:28], address, 2'b0};
    wire [31:0] DE_real_a, DE_real_b;
    wire [31:0] MEM_ALUOut;
    assign DE_real_a = ForwardAID?MEM_ALUOut:reg_r1_dout;
    assign DE_real_b = ForwardBID?MEM_ALUOut:reg_r2_dout;

    always @(*)
    begin
            if (interrupt) begin
                nPC <= ISR_ADDR;
            end else begin
                case (AddrSrc)
                    AddrSrc_PCPlus4: nPC <= PCPlus4;
                    AddrSrc_J: nPC <= jump_address;
                    AddrSrc_I: nPC <= {ext_immediate[29:0], 2'b0} + IFID_PC;
                    AddrSrc_REG: nPC <= DE_real_a;
                endcase
            end
    end
    
    
    //Branch logic
    wire ID_link, ID_WaitResult;
    branch_de branch_de1(
        .op     (IFID_op[2:0]),
        .rt     (IFID_rt[4:0]),
        .a      (DE_real_a[31:0]),
        .b      (DE_real_b[31:0]),
        .funct  (IFID_funct[5:0]),
        .br     (cu_br),
        .AddrSrc    (AddrSrc),
        .WaitResult (ID_WaitResult),
        .Branch     (PCSrcID),
        .link       (ID_link)
    );
        
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
            IDEX_PC[31:0] <= BOOT_ADDR;
            IDEX_link <= 1'b0;
        end else begin
            if (FlushEX || interrupt) begin
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
                 IDEX_PC[31:0] <= BOOT_ADDR;
                 IDEX_link <= 1'b0;
            end else begin
                IDEX_RegWrite <= cu_IDEX_RegWrite || ID_link;
                IDEX_MemtoReg <= cu_IDEX_MemtoReg;
                IDEX_MemWrite <= cu_IDEX_MemWrite;
                IDEX_ALUControl <= cu_IDEX_ALUControl;
                IDEX_ALUSrc <= cu_IDEX_ALUSrc;
                IDEX_RegDst <= cu_IDEX_RegDst;
                IDEX_IM <= ext_immediate[31:0];
                IDEX_IR <= IFID_IR;
                IDEX_A <= DE_real_a;
                IDEX_B <= DE_real_b;
                IDEX_PC[31:0] <= IFID_PC[31:0];
                IDEX_link <= ID_link;
            end
        end
    end

    wire [31:0] ALU_in_a, ALU_in_b, ALU_ALUOut;
    alu alu1
    (
        .alu_a  (ALU_in_a),
        .alu_b  (ALU_in_b),
        .alu_op (IDEX_ALUControl[4:0]),
        .alu_out (ALU_ALUOut)
    );
        
    wire [4:0] EX_rd, EX_rt, EX_shamt;
    assign EX_rt[4:0] = IDEX_IR[20:16];
    assign EX_rd[4:0] = IDEX_IR[15:11];
    assign EX_shamt[4:0] = IDEX_IR[10:6];
    
    assign ALU_in_a = (ForwardAEX == ForwardAEX_NONE)?IDEX_A:((ForwardAEX == ForwardAEX_ALU)?MEM_ALUOut:MEMWB_Result);
    wire [31:0] EX_real_b;
    assign EX_real_b = (ForwardBEX == ForwardBEX_NONE)?IDEX_B:((ForwardBEX == ForwardBEX_ALU)?MEM_ALUOut:MEMWB_Result);
    assign ALU_in_b = (IDEX_ALUSrc == ALUSrc_IM)?IDEX_IM:((IDEX_ALUSrc == ALUSrc_SHAMT)?EX_shamt:EX_real_b);

    
    assign MEMWB_Result = (MEMWB_MemtoReg == MemtoReg_ALU)?MEMWB_ALUOut:MEMWB_ReadData;
    wire [4:0] EX_WriteReg = IDEX_link?
    5'd31:((IDEX_RegDst == RegDst_rt)?EX_rt[4:0]:EX_rd[4:0]);
    
    
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) begin
            EXMEM_MemtoReg <= MemtoReg_ALU;
            EXMEM_RegWrite <= 5'b0;
            EXMEM_MemWrite <= 1'b0;
            EXMEM_ALUOut <= 32'b0;
            EXMEM_WriteData <= 32'b0;
            EXMEM_WriteReg <= 1'b0;
            EXMEM_PC[31:0] <= BOOT_ADDR;
            EXMEM_link <= 1'b0;
        end else begin
            if (interrupt) begin
                EXMEM_MemtoReg <= MemtoReg_ALU;
                EXMEM_RegWrite <= 1'b1;
                EXMEM_MemWrite <= 1'b0;
                EXMEM_ALUOut <= CHK_IDEX_PC;
                EXMEM_WriteData <= 32'b0;
                EXMEM_WriteReg <= EPC_REG;
                EXMEM_PC[31:0] <= BOOT_ADDR;
                EXMEM_link <= 1'b0;
            end else begin
                EXMEM_MemtoReg <= IDEX_MemtoReg;
                EXMEM_RegWrite <= IDEX_RegWrite;
                EXMEM_MemWrite <= IDEX_MemWrite;
                EXMEM_ALUOut <= ALU_ALUOut;
                EXMEM_WriteData <= EX_real_b;
                EXMEM_WriteReg <= EX_WriteReg;
                EXMEM_PC[31:0] <= IDEX_PC[31:0];
                EXMEM_link <= IDEX_link;
            end
        end
    end
    
    assign MEM_ALUOut = EXMEM_link?EXMEM_PC[31:0]:EXMEM_ALUOut;
    assign dmem_a = MEM_ALUOut;
    assign dmem_wd = EXMEM_WriteData;
    assign dmem_we = EXMEM_MemWrite;
    
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) begin
            MEMWB_RegWrite <= 1'b0;
            MEMWB_ALUOut    <= 1'b0;
            MEMWB_ReadData  <= 1'b0;
            MEMWB_MemtoReg  <= MemtoReg_ALU;
            MEMWB_WriteReg  <= 1'b0;
        end else begin
             MEMWB_RegWrite <= EXMEM_RegWrite;
             MEMWB_ALUOut    <= MEM_ALUOut;
             MEMWB_ReadData  <= dmem_rd;
             MEMWB_MemtoReg  <= EXMEM_MemtoReg;
             MEMWB_WriteReg  <= EXMEM_WriteReg;
        end
    end
    
    hazard_unit _hazard_unit(
        .Branch(ID_WaitResult),
        .RsID(IFID_rs),
        .RtID(IFID_rt),
        .MemtoRegEX(IDEX_MemtoReg),
        .RegWriteEX(IDEX_RegWrite),
        .RsEX(IDEX_IR[25:21]),
        .RtEX(IDEX_IR[20:16]),
        .WriteRegEX(EX_WriteReg),
        .MemtoRegMEM(EXMEM_MemtoReg),
        .RegWriteMEM(EXMEM_RegWrite),
        .WriteRegMEM(EXMEM_WriteReg),
        .RegWriteWB(MEMWB_RegWrite),
        .WriteRegWB(MEMWB_WriteReg),
        .StallIF(StallIF),
        .StallID(StallID),
        .ForwardAID(ForwardAID),
        .ForwardBID(ForwardBID),
        .ForwardAEX(ForwardAEX),
        .ForwardBEX(ForwardBEX),
        .FlushEX(FlushEX)
    );
    
    assign MEMWB_Result = (MEMWB_MemtoReg == MemtoReg_ALU)?MEMWB_ALUOut:MEMWB_ReadData;
    
    
    
    
    /*interrupt*/
    reg [31:0] CHK_IFID_PC, CHK_IDEX_PC;
    reg CHK_IFID_FLUSH, CHK_IDEX_FLUSH;
    always @(posedge clk or negedge rst_n) 
    begin
        if (~rst_n) begin
            CHK_IFID_PC <= BOOT_ADDR;
            CHK_IFID_FLUSH <= 1'b1;
        end else begin
            CHK_IFID_PC <= PC;
            CHK_IFID_FLUSH <= PCSrcID;
        end
    end
    
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) begin
            CHK_IDEX_PC <= BOOT_ADDR;
            CHK_IDEX_FLUSH <= 1'b1;
        end else begin
            CHK_IDEX_PC <= CHK_IFID_PC;
            CHK_IDEX_FLUSH <= CHK_IFID_FLUSH;
        end
    end
    
    assign interrupt = (!CHK_IDEX_FLUSH) && (irq) && (!StallIF);
    
endmodule
