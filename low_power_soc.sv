`timescale 1ns/1ps

module low_power_soc #(
    parameter int SYNC_STAGES = 2
)(
    //========================================================
    // GLOBAL CLOCK / RESET
    //========================================================

    input  logic clk,
    input  logic rst_n,


    //========================================================
    // FUNCTIONAL ENABLES
    //========================================================

    input  logic cpu_enable,
    input  logic sram_enable,
    input  logic gpio_enable,
    input  logic timer_enable,
    input  logic uart_enable,


    //========================================================
    // ASYNCHRONOUS WAKE-UP
    //========================================================

    input logic async_wakeup,


    //========================================================
    // TEST / SCAN ENABLE
    //========================================================

    input logic test_enable,


    //========================================================
    // GATED CLOCK OUTPUTS
    //========================================================

    output logic cpu_clk,
    output logic sram_clk,
    output logic gpio_clk,
    output logic timer_clk,
    output logic uart_clk,


    //========================================================
    // STATUS
    //========================================================

    output logic wake_sync
);


    //========================================================
    // PARAMETER CHECK
    //========================================================

    initial begin

        if (SYNC_STAGES < 1) begin

            $error("SYNC_STAGES must be >= 1");

        end

    end


    //========================================================
    // WAKE-UP SYNCHRONIZER
    //========================================================

    logic [SYNC_STAGES-1:0] wake_ff;


    //========================================================
    // CLOCK GATE ENABLE SIGNALS
    //========================================================

    logic cpu_gate_en;
    logic sram_gate_en;
    logic gpio_gate_en;
    logic timer_gate_en;
    logic uart_gate_en;


    //========================================================
    // LATCHED CLOCK ENABLES
    //========================================================

    logic cpu_en_latched;
    logic sram_en_latched;
    logic gpio_en_latched;
    logic timer_en_latched;
    logic uart_en_latched;


    //========================================================
    // ACTIVITY COUNTERS
    //========================================================

    logic [7:0] clk_activity;
    logic [7:0] cpu_activity;
    logic [7:0] sram_activity;
    logic [7:0] gpio_activity;
    logic [7:0] timer_activity;
    logic [7:0] uart_activity;


    //========================================================
    // 1. ASYNCHRONOUS WAKE-UP SYNCHRONIZER
    //========================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            wake_ff <= '0;

        end
        else begin

            wake_ff[0] <= async_wakeup;

            for (int i = 1; i < SYNC_STAGES; i = i + 1) begin

                wake_ff[i] <= wake_ff[i-1];

            end

        end

    end


    assign wake_sync = wake_ff[SYNC_STAGES-1];


    //========================================================
    // 2. GLOBAL CLOCK ACTIVITY COUNTER
    //========================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n)

            clk_activity <= 8'h00;

        else

            clk_activity <= clk_activity + 8'h01;

    end


    //========================================================
    // 3. CLOCK ENABLE GENERATION
    //========================================================

    assign cpu_gate_en =
            cpu_enable |
            wake_sync  |
            test_enable;


    assign sram_gate_en =
            sram_enable |
            wake_sync   |
            test_enable;


    assign gpio_gate_en =
            gpio_enable |
            wake_sync   |
            test_enable;


    assign timer_gate_en =
            timer_enable |
            wake_sync    |
            test_enable;


    assign uart_gate_en =
            uart_enable |
            wake_sync   |
            test_enable;


    //========================================================
    // 4. CPU CLOCK GATING
    //========================================================

    always_ff @(negedge clk or negedge rst_n) begin

        if (!rst_n)

            cpu_en_latched <= 1'b0;

        else

            cpu_en_latched <= cpu_gate_en;

    end

    assign cpu_clk = clk & cpu_en_latched;


    //========================================================
    // 5. SRAM CLOCK GATING
    //========================================================

    always_ff @(negedge clk or negedge rst_n) begin

        if (!rst_n)

            sram_en_latched <= 1'b0;

        else

            sram_en_latched <= sram_gate_en;

    end

    assign sram_clk = clk & sram_en_latched;


    //========================================================
    // 6. GPIO CLOCK GATING
    //========================================================

    always_ff @(negedge clk or negedge rst_n) begin

        if (!rst_n)

            gpio_en_latched <= 1'b0;

        else

            gpio_en_latched <= gpio_gate_en;

    end

    assign gpio_clk = clk & gpio_en_latched;


    //========================================================
    // 7. TIMER CLOCK GATING
    //========================================================

    always_ff @(negedge clk or negedge rst_n) begin

        if (!rst_n)

            timer_en_latched <= 1'b0;

        else

            timer_en_latched <= timer_gate_en;

    end

    assign timer_clk = clk & timer_en_latched;


    //========================================================
    // 8. UART CLOCK GATING
    //========================================================

    always_ff @(negedge clk or negedge rst_n) begin

        if (!rst_n)

            uart_en_latched <= 1'b0;

        else

            uart_en_latched <= uart_gate_en;

    end

    assign uart_clk = clk & uart_en_latched;


    //========================================================
    // 9. CPU ACTIVITY COUNTER
    //========================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n)

            cpu_activity <= 8'h00;

        else if (cpu_clk)

            cpu_activity <= cpu_activity + 8'h01;

    end


    //========================================================
    // 10. SRAM ACTIVITY COUNTER
    //========================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n)

            sram_activity <= 8'h00;

        else if (sram_clk)

            sram_activity <= sram_activity + 8'h01;

    end


    //========================================================
    // 11. GPIO ACTIVITY COUNTER
    //========================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n)

            gpio_activity <= 8'h00;

        else if (gpio_clk)

            gpio_activity <= gpio_activity + 8'h01;

    end


    //========================================================
    // 12. TIMER ACTIVITY COUNTER
    //========================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n)

            timer_activity <= 8'h00;

        else if (timer_clk)

            timer_activity <= timer_activity + 8'h01;

    end


    //========================================================
    // 13. UART ACTIVITY COUNTER
    //========================================================

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n)

            uart_activity <= 8'h00;

        else if (uart_clk)

            uart_activity <= uart_activity + 8'h01;

    end


endmodule
