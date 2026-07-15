`timescale 1ns/1ps

module tb;

reg clk;
reg rst;
reg start;
wire tx;

// Instantiate
uart_dma_top uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .tx(tx)
);

// Clock (10ns period)
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    start = 0;

    #20 rst = 0;

    #20 start = 1;
    #10 start = 0;

    #100000 $finish;
end

endmodule