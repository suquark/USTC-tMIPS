`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/21 12:15:46
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input rst_n,
    output [15:0] led
    );
    
    wire [31:0] imem_a, imem_d;
    wire [31:0] dmem_a, dmem_rd, dmem_wd;
    wire dmem_we;
    
    processor processor1
    (
        .clk        (clk),
        .rst_n      (rst_n),
        .irq        (1'b0),
        .imem_a     (imem_a),
        .imem_d     (imem_d),
        .dmem_a     (dmem_a),
        .dmem_rd    (dmem_rd),
        .dmem_wd    (dmem_wd),
        .dmem_we    (dmem_we)
    );
    
    data_mem _data_mem(
        .clk            (clk),
        .address        (dmem_a),
        .data_in        (dmem_wd),
        .write_enabled  (dmem_we),
        .data_out       (dmem_rd),
        .led            (led)
    );
    
    rom rom1(
        .a  (imem_a[7:2]),
        .spo    (imem_d)
    );
endmodule
