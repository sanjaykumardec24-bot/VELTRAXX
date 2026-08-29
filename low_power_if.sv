`timescale 1ns/1ps

interface low_power_if;

    //========================================================
    // GLOBAL CLOCK / RESET
    //========================================================

    logic clk;
    logic rst_n;


    //========================================================
    // FUNCTIONAL ENABLES
    //========================================================

    logic cpu_enable;
    logic sram_enable;
    logic gpio_enable;
    logic timer_enable;
    logic uart_enable;


    //========================================================
    // ASYNCHRONOUS WAKE-UP
    //========================================================

    logic async_wakeup;


    //========================================================
    // TEST / SCAN ENABLE
    //========================================================

    logic test_enable;


    //========================================================
    // GATED CLOCK OUTPUTS
    //========================================================

    logic cpu_clk;
    logic sram_clk;
    logic gpio_clk;
    logic timer_clk;
    logic uart_clk;


    //========================================================
    // STATUS
    //========================================================

    logic wake_sync;


    //========================================================
    // DUT MODPORT
    //========================================================

    modport DUT (

        input  clk,
        input  rst_n,

        input cpu_enable,
        input sram_enable,
        input gpio_enable,
        input timer_enable,
        input uart_enable,

        input async_wakeup,

        input test_enable,

        output cpu_clk,
        output sram_clk,
        output gpio_clk,
        output timer_clk,
        output uart_clk,

        output wake_sync
    );


    //========================================================
    // TESTBENCH MODPORT
    //========================================================

    modport TB (

        output clk,
        output rst_n,

        output cpu_enable,
        output sram_enable,
        output gpio_enable,
        output timer_enable,
        output uart_enable,

        output async_wakeup,

        output test_enable,

        input cpu_clk,
        input sram_clk,
        input gpio_clk,
        input timer_clk,
        input uart_clk,

        input wake_sync
    );

endinterface
