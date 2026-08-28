`timescale 1ns/1ps

module icg_cell (
    input  logic clk,
    input  logic rst_n,
    input  logic enable,
    input  logic test_enable,
    output logic gated_clk
);

    logic enable_latched;

    always_ff @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            enable_latched <= 1'b0;
        else
            enable_latched <= enable | test_enable;
    end

    assign gated_clk = clk & enable_latched;

endmodule


module icg_controller (
    input  logic clk,
    input  logic rst_n,

    input  logic cpu_enable,
    input  logic sram_enable,
    input  logic gpio_enable,
    input  logic timer_enable,
    input  logic uart_enable,

    input  logic async_wakeup,
    input  logic test_enable,

    output logic cpu_clk,
    output logic sram_clk,
    output logic gpio_clk,
    output logic timer_clk,
    output logic uart_clk
);

    logic wake_sync;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wake_sync <= 1'b0;
        else
            wake_sync <= async_wakeup;
    end

    icg_cell u_cpu_icg (
        .clk(clk),
        .rst_n(rst_n),
        .enable(cpu_enable | wake_sync),
        .test_enable(test_enable),
        .gated_clk(cpu_clk)
    );

    icg_cell u_sram_icg (
        .clk(clk),
        .rst_n(rst_n),
        .enable(sram_enable | wake_sync),
        .test_enable(test_enable),
        .gated_clk(sram_clk)
    );

    icg_cell u_gpio_icg (
        .clk(clk),
        .rst_n(rst_n),
        .enable(gpio_enable | wake_sync),
        .test_enable(test_enable),
        .gated_clk(gpio_clk)
    );

    icg_cell u_timer_icg (
        .clk(clk),
        .rst_n(rst_n),
        .enable(timer_enable | wake_sync),
        .test_enable(test_enable),
        .gated_clk(timer_clk)
    );

    icg_cell u_uart_icg (
        .clk(clk),
        .rst_n(rst_n),
        .enable(uart_enable | wake_sync),
        .test_enable(test_enable),
        .gated_clk(uart_clk)
    );

endmodule


module soc_cpu (
    input logic clk,
    input logic rst_n,
    output logic [7:0] activity
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            activity <= 8'h00;
        else
            activity <= activity + 8'h01;
    end

endmodule


module soc_sram (
    input logic clk,
    input logic rst_n,
    output logic [7:0] activity
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            activity <= 8'h00;
        else
            activity <= activity + 8'h01;
    end

endmodule


module soc_gpio (
    input logic clk,
    input logic rst_n,
    output logic [7:0] activity
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            activity <= 8'h00;
        else
            activity <= ~activity;
    end

endmodule


module soc_timer (
    input logic clk,
    input logic rst_n,
    output logic [7:0] activity
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            activity <= 8'h00;
        else
            activity <= activity + 8'h01;
    end

endmodule


module soc_uart (
    input logic clk,
    input logic rst_n,
    output logic [7:0] activity
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            activity <= 8'h00;
        else
            activity <= ~activity;
    end

endmodule


module simple_soc (

    input logic clk,
    input logic rst_n,

    input logic cpu_enable,
    input logic sram_enable,
    input logic gpio_enable,
    input logic timer_enable,
    input logic uart_enable,

    input logic async_wakeup,
    input logic test_enable,

    output logic cpu_clk,
    output logic sram_clk,
    output logic gpio_clk,
    output logic timer_clk,
    output logic uart_clk

);

    logic [7:0] cpu_activity;
    logic [7:0] sram_activity;
    logic [7:0] gpio_activity;
    logic [7:0] timer_activity;
    logic [7:0] uart_activity;

    icg_controller u_icg_controller (
        .clk          (clk),
        .rst_n        (rst_n),

        .cpu_enable   (cpu_enable),
        .sram_enable  (sram_enable),
        .gpio_enable  (gpio_enable),
        .timer_enable (timer_enable),
        .uart_enable  (uart_enable),

        .async_wakeup (async_wakeup),
        .test_enable  (test_enable),

        .cpu_clk      (cpu_clk),
        .sram_clk     (sram_clk),
        .gpio_clk     (gpio_clk),
        .timer_clk    (timer_clk),
        .uart_clk     (uart_clk)
    );

    soc_cpu u_cpu (
        .clk      (cpu_clk),
        .rst_n    (rst_n),
        .activity (cpu_activity)
    );

    soc_sram u_sram (
        .clk      (sram_clk),
        .rst_n    (rst_n),
        .activity (sram_activity)
    );

    soc_gpio u_gpio (
        .clk      (gpio_clk),
        .rst_n    (rst_n),
        .activity (gpio_activity)
    );

    soc_timer u_timer (
        .clk      (timer_clk),
        .rst_n    (rst_n),
        .activity (timer_activity)
    );

    soc_uart u_uart (
        .clk      (uart_clk),
        .rst_n    (rst_n),
        .activity (uart_activity)
    );

endmodule
