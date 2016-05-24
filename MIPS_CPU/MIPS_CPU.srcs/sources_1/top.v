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
    input clk_orig,
    input rst_n,
    input [15:1] sw,
    output reg [15:0] led
    );
        
    slow_clk _slow_clk(
        .clk_orig(clk_orig),
        .clk(clk)
    );
    
    wire [31:0] imem_a, imem_d;
    wire [31:0] dmem_a, dmem_rd, dmem_wd;
    wire dmem_we;
    
    wire clk;
    
    wire int_req;
    wire int_ack;
    wire int_map_write;
    wire [3:0] int_map_index;
    wire [31:0] int_map_data;
    wire int_enable_write;
    wire int_enable;
    
    processor processor1
    (
        .clk        (clk),
        .rst_n      (rst_n),
        .irq        (int_req),
        .interrupt  (int_ack),
        .imem_a     (imem_a),
        .imem_d     (imem_d),
        .dmem_a     (dmem_a),
        .dmem_rd    (dmem_rd),
        .dmem_wd    (dmem_wd),
        .dmem_we    (dmem_we)
    );
    
    data_mem _data_mem(
        .clk              (clk),
        .rst_n            (rst_n),
        .address          (dmem_a),
        .data_in          (dmem_wd),
        .write_enabled    (dmem_we),
        .data_out         (dmem_rd),
        .int_map_write    (int_map_write),
        .int_map_index    (int_map_index),
        .int_map_rd       (int_map_rd),
        .int_map_wd       (int_map_wd),
        .int_enable_write (int_enable_write),
        .int_enable_r     (int_enable_r),
        .int_enable_w     (int_enable_w),
        .out_write        (out_write),
        .out_index        (out_index),
        .out_data         (out_data)
    );
    
    rom rom1(
        .a                (imem_a[7:2]),
        .spo              (imem_d)
    );
    
    interrupt_unit _interrupt_unit(
        .clk              (clk),
        .rst_n            (rst_n),
        .int_exist        (int_exist),
        .int_req          (int_req),
        .int_ack          (int_ack),
        .int_enable_write (int_enable_write),
        .int_enable_r     (int_enable_r),
        .int_enable_w     (int_enable_w)
    );
    
    // Switch interrupt
    reg [31:0] int_map_switch;
    wire sw_comp = ~(int_map_switch[31:17] == sw[15:1]);
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) int_map_switch <= 32'h0;
        else begin
            int_map_switch[31:17] <= sw[15:1];
            int_map_switch[0] <=
                (int_map_write & (int_map_index == INT_INDEX_SWITCH)) ? 
                int_map_wd[0] : (int_map_switch[0] | sw_comp);
        end
    end
    
    // Interrupt Map reading
    always @(*)
    begin
        case (int_map_index)
            INT_INDEX_SWITCH: int_map_rd <= int_map_switch;
            default: int_map_rd <= 32'h0;
        endcase
    end
    
    // Whether to interrupt? AND all interrupt sources' int_map[0]!
    assign int_exist = int_map_switch[0];
    
    // LED output
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) led <= 16'h0000;
        else        led <= (out_write && out_index == OUT_INDEX_LED) ? out_data : led;
    end
endmodule
