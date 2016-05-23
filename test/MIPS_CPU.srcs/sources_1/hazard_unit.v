`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2016 09:44:55 PM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(
    input Branch,
    input [4:0] RsID,
    input [4:0] RtID,
    input MemtoRegEX,
    input RegWriteEX,
    input [4:0] RsEX,
    input [4:0] RtEX,
    input [4:0] WriteRegEX,
    input MemtoRegMEM,
    input RegWriteMEM,
    input [4:0] WriteRegMEM,
    input RegWriteWB,
    input [4:0] WriteRegWB,
    output reg StallIF,
    output reg StallID,
    output reg ForwardAID,
    output reg ForwardBID,
    output reg [1:0] ForwardAEX,
    output reg [1:0] ForwardBEX,
    output reg FlushEX
    );
    
    `include "param.v"
    
    // Stall
    always @(*)
    begin
        // Normal Load Stall or Stall Before Branch
        if ((Branch | MemtoRegEX) && WriteRegEX && (WriteRegEX == RsID || WriteRegEX == RtID)) begin
            StallIF = 1;
            StallID = 1;
            FlushEX = 1;
        end
        // Branch and Load Stall
        else if (MemtoRegMEM && Branch && WriteRegMEM && (WriteRegMEM == RsID || WriteRegMEM == RtID)) begin
            StallIF = 1;
            StallID = 1;
            FlushEX = 1;
        end
        else begin
            StallIF = 0;
            StallID = 0;
            FlushEX = 0;
        end
    end
    
    // Forwarding
    always @(*)
    begin
        // To ID forwarding
        if (~MemtoRegMEM && RegWriteMEM && WriteRegMEM && (WriteRegMEM == RsID))
            ForwardAID = 1;
        else
            ForwardAID = 0;
        
        if (~MemtoRegMEM && RegWriteMEM && WriteRegMEM && (WriteRegMEM == RtID))
            ForwardBID = 1;
        else
            ForwardBID = 0;
        
        
        // To EX forwarding
        if (~MemtoRegMEM && RegWriteMEM && WriteRegMEM && (WriteRegMEM == RsEX))
            ForwardAEX = 2'b10;
        else if (RegWriteWB && WriteRegWB && (WriteRegWB == RsEX))
            ForwardAEX = 2'b01;
        else
            ForwardAEX = 2'b00;
        
        if (~MemtoRegMEM && RegWriteMEM && WriteRegMEM && (WriteRegMEM == RtEX))
            ForwardBEX = 2'b10;
        else if (RegWriteWB && WriteRegWB && (WriteRegWB == RtEX))
            ForwardBEX = 2'b01;
        else
            ForwardBEX = 2'b00;
    end
    
endmodule
