`timescale 1ns/1ps

interface icg_if;

    logic clk;
    logic rst_n;

    logic cpu_enable;
    logic sram_enable;
    logic gpio_enable;
    logic timer_enable;
    logic uart_enable;

    logic async_wakeup;
    logic test_enable;

    logic cpu_clk;
    logic sram_clk;
    logic gpio_clk;
    logic timer_clk;
    logic uart_clk;

endinterface
