`timescale 1ns/1ps


module uart_tx #(
    parameter BAUD_DIV = 50
)(
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    output reg tx,
    output reg busy
);

reg [3:0] bit_cnt;
reg [9:0] shift_reg;
reg [7:0] baud_cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx <= 1;
        busy <= 0;
        bit_cnt <= 0;
        baud_cnt <= 0;
    end else begin
        if (start && !busy) begin
            shift_reg <= {1'b1, data_in, 1'b0}; // stop, data, start
            busy <= 1;
            bit_cnt <= 0;
            baud_cnt <= 0;
        end 
        else if (busy) begin
            if (baud_cnt == BAUD_DIV-1) begin
                baud_cnt <= 0;

                tx <= shift_reg[0];
                shift_reg <= shift_reg >> 1;
                bit_cnt <= bit_cnt + 1;

                if (bit_cnt == 9) begin
                    busy <= 0;
                    tx <= 1; // idle
                end
            end else begin
                baud_cnt <= baud_cnt + 1;
            end
        end
    end
end

endmodule

module dma_controller(
    input clk,
    input rst,
    input start,
    input tx_busy,
    output reg tx_start,
    output reg [7:0] tx_data
);

reg [2:0] index;
reg active;
reg prev_tx_busy;

reg [7:0] mem [0:7];

initial begin
    mem[0]=8'hA1; mem[1]=8'hB2; mem[2]=8'hC3; mem[3]=8'hD4;
    mem[4]=8'hE5; mem[5]=8'hF6; mem[6]=8'h11; mem[7]=8'h22;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        index <= 0;
        tx_start <= 0;
        active <= 0;
        prev_tx_busy <= 0;
    end else begin
        tx_start <= 0; // default

        // Start DMA
        if (start) begin
            active <= 1;
            index <= 0;
        end

        // First byte
        if (active && index == 0 && !tx_busy) begin
            tx_data <= mem[index];
            tx_start <= 1;
            index <= index + 1;
        end

        // Next bytes (edge-based trigger)
        if (active && prev_tx_busy && !tx_busy) begin
            if (index < 8) begin
                tx_data <= mem[index];
                tx_start <= 1;
                index <= index + 1;
            end else begin
                active <= 0; // stop after all bytes
            end
        end

        prev_tx_busy <= tx_busy;
    end
end

endmodule

module uart_dma_top(
    input clk,
    input rst,
    input start,
    output tx
);

wire tx_busy;
wire tx_start;
wire [7:0] tx_data;

// 🔥 ADD HERE (CPU MONITOR)
reg [7:0] cpu_access_count;

always @(posedge clk or posedge rst) begin
    if (rst)
        cpu_access_count <= 0;
    else if (start)
        cpu_access_count <= cpu_access_count + 1;
end

// DMA
dma_controller dma (
    .clk(clk),
    .rst(rst),
    .start(start),
    .tx_busy(tx_busy),
    .tx_start(tx_start),
    .tx_data(tx_data)
);

// UART TX
uart_tx #(.BAUD_DIV(50)) uart_tx_inst (
    .clk(clk),
    .rst(rst),
    .start(tx_start),
    .data_in(tx_data),
    .tx(tx),
    .busy(tx_busy)
);

endmodule