`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2016 05:19:40 PM
// Design Name: 
// Module Name: interrupt_unit
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


module interrupt_unit(
    input clk,
    input rst_n,
    input int_exist,
    output int_req,
    input int_ack,
    input int_enable_write,
    output int_enable_r,
    input int_enable_w
    );
    
    reg int_enable;
    
    assign int_enable_r = int_enable;
    
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) begin
            int_enable <= 1;
        end
        else begin
            if (int_enable) begin
                if (int_enable_write & ~int_enable_w) int_enable <= 0;
                else if (int_ack) int_enable <= 0;
                else int_enable <= 1;
            end
            else begin
                if (int_enable_write & int_enable_w) int_enable <= 1;
                else int_enable <= 0;
            end
        end
    end
    
    assign int_req = int_enable & int_exist;
    
endmodule
