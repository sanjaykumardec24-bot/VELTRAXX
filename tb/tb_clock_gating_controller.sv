`timescale 1ns/1ps

module tb;

    // Interface
    icg_if vif();

    // DUT
    simple_soc dut (
        .clk          (vif.clk),
        .rst_n        (vif.rst_n),
        .cpu_enable   (vif.cpu_enable),
        .sram_enable  (vif.sram_enable),
        .gpio_enable  (vif.gpio_enable),
        .timer_enable (vif.timer_enable),
        .uart_enable  (vif.uart_enable),
        .async_wakeup (vif.async_wakeup),
        .test_enable  (vif.test_enable),
        .cpu_clk      (vif.cpu_clk),
        .sram_clk     (vif.sram_clk),
        .gpio_clk     (vif.gpio_clk),
        .timer_clk    (vif.timer_clk),
        .uart_clk     (vif.uart_clk)
    );

    // 100 MHz Clock Generation
    initial begin
        vif.clk = 1'b0;
        forever #5 vif.clk = ~vif.clk;
    end

    // Stimulus
    initial begin
        vif.rst_n        = 1'b0;
        vif.cpu_enable   = 1'b0;
        vif.sram_enable  = 1'b0;
        vif.gpio_enable  = 1'b0;
        vif.timer_enable = 1'b0;
        vif.uart_enable  = 1'b0;
        vif.async_wakeup = 1'b0;
        vif.test_enable  = 1'b0;

        repeat (3) @(posedge vif.clk);
        vif.rst_n = 1'b1;

        $display("=== STARTING ICG SIMULATION ===");

        repeat (20) begin
            @(negedge vif.clk);
            #1;
            vif.cpu_enable   = $random;
            vif.sram_enable  = $random;
            vif.gpio_enable  = $random;
            vif.timer_enable = $random;
            vif.uart_enable  = $random;
            vif.async_wakeup = ($random % 5 == 0);
            vif.test_enable  = ($random % 10 == 0);
        end

        #100;
        $display("=== SIMULATION COMPLETE ===");
        $finish;
    end

    // Waveform Dump
    initial begin
        $dumpfile("icg_soc.vcd");
        $dumpvars(0, tb);
    end

endmodule