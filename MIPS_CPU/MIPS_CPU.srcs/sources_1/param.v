parameter	A_NOP	= 5'h00;
parameter	A_ADD	= 5'h01;
parameter	A_SUB	= 5'h02;
parameter	A_AND = 5'h03;
parameter	A_OR  = 5'h04;
parameter	A_XOR = 5'h05;
parameter	A_NOR = 5'h06;
parameter	MemtoReg_MEM = 1'b1;
parameter	MemtoReg_ALU = 1'b0;

parameter	RegDst_rt =	1'b0;
parameter	RegDst_rd	=	1'b1;

parameter	ALUSrc_REG =	1'b0;
parameter	ALUSrc_IM	=	1'b1;

parameter	PCSrcIF_ADD4	=	1'b0;
parameter	PCSrcIF_J		=	1'b1;
parameter	PCSrcID_BR		=	1'b1;
parameter PCSrcID_NORM    =    1'b0;

parameter	IorD_I		=	2'b0;
parameter	IorD_D		=	2'b1;

parameter  BOOT_ADDR    = 32'b0;

parameter J_TYPE_OP     = 5'b00001;

parameter AddrSrc_IM   = 1'b0;
parameter AddrSrc_REG  = 1'b1;

parameter ForwardAEX_NONE = 2'b00;
parameter ForwardAEX_ALU  = 2'b10;
parameter ForwardAEX_MEM  = 2'b01;

parameter ForwardBEX_NONE = 2'b00;
parameter ForwardBEX_ALU  = 2'b10;
parameter ForwardBEX_MEM  = 2'b01;

parameter ISR_ADDR = 32'h0008;
parameter EPC_REG  = 5'd26;
parameter INT_ENABLE_ADDR = 32'h2100;
