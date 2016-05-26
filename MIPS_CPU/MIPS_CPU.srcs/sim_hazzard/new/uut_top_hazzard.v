module uut_top_hazzard();
    reg rst_n;
    reg clk;
    wire [15:0] led;
    top top1(
        .rst_n       (rst_n),
        .clk_orig    (clk),
        .led         (led),
        .sw          (15'b0)
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