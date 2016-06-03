`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2016 08:54:36 PM
// Design Name: 
// Module Name: data_mem
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


module data_mem(
    input clk,
    input rst_n,
    input [31:0] address,
    input [31:0] data_in,
    input write_enabled,
    output reg [31:0] data_out,
    
    output int_map_write,
    output [4:0] int_map_index,
    input  int_map_r,
    output int_map_w,
    output int_enable_write,
    input  int_enable_r,
    output int_enable_w,
    output int_mask_write,
    input  [31:0] int_mask_rd,
    output [31:0] int_mask_wd,
    
    output io_write,
    output [4:0] io_index,
    input  [31:0] io_rd,
    output [31:0] io_wd
    );
    
    `include "param.v"
    
    wire [31:0] mem_data_out;
    
    always @(*)
    begin
        if (address[31:7] == MEM_MAP_IO_HEAD)
            data_out = io_rd;
        else if (address[31:7] == MEM_MAP_INT_HEAD)
            data_out = {31'h0, int_map_r};
        else if (address == MEM_MAP_INT_ENABLE)
            data_out = {31'h0, int_enable_r};
        else if (address == MEM_MAP_INT_MASK)
            data_out = int_mask_rd;
        else if (address[31:12] == MEM_MAP_RAM_AVAILABLE_HEAD)
            data_out = mem_data_out;
        else // For output mappings
            data_out = 32'h0;
    end
    
    assign int_map_write    = (address[31:7] == MEM_MAP_INT_HEAD) && write_enabled;
    assign int_map_index    = address[6:2];
    assign int_map_w        = (data_in != 32'h0);
    assign int_enable_write = (address == MEM_MAP_INT_ENABLE) && write_enabled;
    assign int_enable_w     = (data_in != 32'h0);
    assign int_mask_write   = (address == MEM_MAP_INT_MASK) && write_enabled;
    assign int_mask_wd      = data_in[31:0];
    
    assign io_write         = (address[31:7] == MEM_MAP_IO_HEAD) && write_enabled;
    assign io_index         = address[6:2];
    assign io_wd            = data_in;
    
    ram ram1(
        .a(address[11:2]),
        .d(data_in),
        .clk(clk),
        .we((address[31:12] == MEM_MAP_RAM_AVAILABLE_HEAD) & write_enabled),
        .spo(mem_data_out)
    );
    
endmodule
