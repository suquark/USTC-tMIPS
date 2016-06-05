`timescale 1ns / 1ps
module uut_top_hazzard();
    reg rst_n;
    reg clk;
    wire [15:0] led;
    wire [7:0] seg;
    wire [3:0] an;
    top top1(
        .rst_n       (rst_n),
        .clk_orig    (clk),
        .led         (led),
        .sw_raw      (15'b0),
        .seg         (seg),
        .an          (an)
    );
    initial begin
        rst_n = 0;
        clk = 0;
        #100;
        rst_n = 1;
    end
    always begin
        #5;
        clk = ~clk;
    end
endmodule