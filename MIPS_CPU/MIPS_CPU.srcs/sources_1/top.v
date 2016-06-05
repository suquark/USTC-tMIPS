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
    input [15:1] sw_raw,
    output reg [15:0] led,
    output [6:0] seg,
    output [3:0] an
    );
    
    `include "param.v"
    
    wire [31:0] imem_a, imem_d;
    wire [31:0] dmem_a, dmem_rd, dmem_wd;
    wire dmem_we;
    
    wire clk;
        
    slow_clk _slow_clk(
        .clk_orig(clk_orig),
        .clk(clk)
    );
    
    wire [15:1] sw;
    debounce _debounce(clk, sw_raw, sw);
    
    wire int_req;
    wire int_ack;
    wire int_map_write;
    wire [4:0] int_map_index;
    wire int_map_r;
    wire int_map_w;
    wire int_enable_write;
    wire int_enable_r;
    wire int_enable_w;
    wire int_mask_write;
    reg [31:0] int_mask;
    wire [31:0] int_mask_wd;
    
    wire io_write;
    wire io_index;
    reg  [31:0] io_rd;
    wire [31:0] io_wd;
    
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
        .int_map_r        (int_map_r),
        .int_map_w        (int_map_w),
        .int_enable_write (int_enable_write),
        .int_enable_r     (int_enable_r),
        .int_enable_w     (int_enable_w),
        .int_mask_write   (int_mask_write),
        .int_mask_rd      (int_mask),
        .int_mask_wd      (int_mask_wd),
        .io_write         (io_write),
        .io_index         (io_index),
        .io_rd            (io_rd),
        .io_wd            (io_wd)
    );
    
    rom rom1(
        .a                (imem_a[11:2]),
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
    
    // Interrupt Mask Handling
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) int_mask <= 32'hffffffff;
        else int_mask <= int_mask_write ? int_mask_wd : int_mask;
    end
    
    // Switch interrupt
    reg [15:1] switch_status;
    wire sw_comp = ~(switch_status[15:1] == sw[15:1]);
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) switch_status <= 15'h0000;
        else        switch_status <= sw;
    end
    
    // Time tick interrupt
    reg [31:0] time_counter;
    wire tick_gen = (time_counter == 32'h0);
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n)
            time_counter <= TICK_CYCLE - 1;
        else begin
            if (time_counter)
                time_counter <= time_counter - 1;
            else
                time_counter <= TICK_CYCLE - 1;
        end
    end
    
    // Memory-Mapped Interrupt
    reg [31:0] int_vector;
    assign int_map_r = int_vector[int_map_index];
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) int_vector <= 32'h0;
        else begin
            int_vector[INT_INDEX_SWITCH] <=
                (int_map_write & ~int_map_w & (int_map_index == INT_INDEX_SWITCH)) ? 
                int_map_w : (int_vector[INT_INDEX_SWITCH] | sw_comp);
            int_vector[INT_INDEX_TICK] <=
                (int_map_write & ~int_map_w & (int_map_index == INT_INDEX_TICK)) ? 
                int_map_w : (int_vector[INT_INDEX_TICK] | tick_gen);
            int_vector[INT_INDEX_SOFT] <=
                (int_map_write & (int_map_index == INT_INDEX_SOFT)) ?
                int_map_w : int_vector[INT_INDEX_SOFT];
        end
    end
    
    assign int_exist = ((int_vector & int_mask) != 32'h0);
    
    // LED output
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) led <= 16'h0000;
        else        led <= (io_write && io_index == IO_INDEX_LED) ? io_wd[15:0] : led;
    end
    
    // Seven Segment Display output
    reg [15:0] sseg_data;
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) sseg_data <= 16'h0;
        else        sseg_data <= (io_write && io_index == IO_INDEX_SSEG) ? io_wd[15:0] : sseg_data[0];
    end
    wire [7:0] seg0;
    wire [7:0] seg1;
    wire [7:0] seg2;
    wire [7:0] seg3;
    ssegdecode decoder0(sseg_data[3:0],   seg0);
    ssegdecode decoder1(sseg_data[7:4],   seg1);
    ssegdecode decoder2(sseg_data[11:8],  seg2);
    ssegdecode decoder3(sseg_data[15:12], seg3);
    ssegout out(clk, seg3, seg2, seg1, seg0, seg, an);
    
    // Memory-Mapped Input
    always @(*)
    begin
        case (io_index)
            IO_INDEX_SWITCH: io_rd <= {17'h0, switch_status};
            default:         io_rd <= 32'h0;
        endcase
    end
endmodule
