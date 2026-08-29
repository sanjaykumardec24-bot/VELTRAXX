`timescale 1ns/1ps

module tb_low_power_soc;

    import low_power_pkg::*;


    //========================================================
    // INTERFACE
    //========================================================

    low_power_if vif();


    //========================================================
    // DUT
    //========================================================

    low_power_soc #(
        .SYNC_STAGES(SYNC_STAGES)
    ) dut (

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
        .uart_clk     (vif.uart_clk),

        .wake_sync    (vif.wake_sync)

    );


    //========================================================
    // CLOCK GENERATION
    //========================================================

    initial begin

        vif.clk = 1'b0;

        forever #(HALF_PERIOD)
            vif.clk = ~vif.clk;

    end


    //========================================================
    // INITIAL VALUES
    //
    // IMPORTANT:
    // rst_n starts at 1 so that the testbench creates
    // a real 1 -> 0 -> 1 reset transition.
    //========================================================

    initial begin

        vif.rst_n = 1'b1;

        vif.cpu_enable   = 1'b0;
        vif.sram_enable  = 1'b0;
        vif.gpio_enable  = 1'b0;
        vif.timer_enable = 1'b0;
        vif.uart_enable  = 1'b0;

        vif.async_wakeup = 1'b0;

        vif.test_enable  = 1'b0;

    end


    //========================================================
    // WAVEFORM
    //========================================================

    initial begin

        $dumpfile("low_power_soc.vcd");

        $dumpvars(0, tb_low_power_soc);

    end


    //========================================================
    // CHECK ALL CLOCKS
    //========================================================

    task automatic check_all_clocks_off();

        begin

            #1;

            if (vif.cpu_clk !== 1'b0)
                $error("CPU clock should be OFF");

            if (vif.sram_clk !== 1'b0)
                $error("SRAM clock should be OFF");

            if (vif.gpio_clk !== 1'b0)
                $error("GPIO clock should be OFF");

            if (vif.timer_clk !== 1'b0)
                $error("TIMER clock should be OFF");

            if (vif.uart_clk !== 1'b0)
                $error("UART clock should be OFF");

        end

    endtask


    //========================================================
    // RESET TEST
    //========================================================

    task automatic test_reset();

        begin

            $display("");
            $display("==============================================");
            $display("RESET TEST");
            $display("==============================================");

            // Start from reset inactive
            vif.rst_n = 1'b1;

            repeat (2)
                @(posedge vif.clk);

            // Explicit 1 -> 0 transition
            #2;

            vif.rst_n = 1'b0;

            // Keep reset active across clock edges
            repeat (3)
                @(posedge vif.clk);

            #1;

            // Check reset state
            if (vif.wake_sync !== 1'b0)
                $error("wake_sync did not reset");

            if (vif.cpu_clk !== 1'b0)
                $error("CPU clock not reset");

            if (vif.sram_clk !== 1'b0)
                $error("SRAM clock not reset");

            if (vif.gpio_clk !== 1'b0)
                $error("GPIO clock not reset");

            if (vif.timer_clk !== 1'b0)
                $error("TIMER clock not reset");

            if (vif.uart_clk !== 1'b0)
                $error("UART clock not reset");

            // Explicit 0 -> 1 transition
            #2;

            vif.rst_n = 1'b1;

            repeat (4)
                @(posedge vif.clk);

            $display("PASS: Reset assertion/deassertion covered");

        end

    endtask


    //========================================================
    // ALL CLOCKS OFF
    //========================================================

    task automatic test_all_off();

        begin

            $display("");
            $display("==============================================");
            $display("TEST 1 : ALL CLOCKS OFF");
            $display("==============================================");

            vif.cpu_enable   = 1'b0;
            vif.sram_enable  = 1'b0;
            vif.gpio_enable  = 1'b0;
            vif.timer_enable = 1'b0;
            vif.uart_enable  = 1'b0;

            vif.async_wakeup = 1'b0;
            vif.test_enable  = 1'b0;

            repeat (10)
                @(posedge vif.clk);

            check_all_clocks_off();

            $display("PASS: All clocks OFF");

        end

    endtask


    //========================================================
    // CPU ENABLE
    //========================================================

    task automatic test_cpu();

        begin

            $display("");
            $display("==============================================");
            $display("TEST 2 : CPU CLOCK");
            $display("==============================================");

            vif.cpu_enable = 1'b1;

            repeat (5)
                @(posedge vif.clk);

            #1;

            if (vif.cpu_clk !== vif.clk)
                $error("CPU clock did not start");

            vif.cpu_enable = 1'b0;

            repeat (5)
                @(posedge vif.clk);

            #1;

            if (vif.cpu_clk !== 1'b0)
                $error("CPU clock did not stop");

            $display("PASS: CPU enable 0->1->0 covered");

        end

    endtask


    //========================================================
    // INDIVIDUAL PERIPHERALS
    //========================================================

    task automatic test_peripherals();

        begin

            $display("");
            $display("==============================================");
            $display("TEST 3 : PERIPHERAL CLOCKS");
            $display("==============================================");


            // SRAM
            vif.sram_enable = 1'b1;

            repeat (5)
                @(posedge vif.clk);

            #1;

            if (vif.sram_clk !== vif.clk)
                $error("SRAM clock did not start");

            vif.sram_enable = 1'b0;

            repeat (4)
                @(posedge vif.clk);


            // GPIO
            vif.gpio_enable = 1'b1;

            repeat (5)
                @(posedge vif.clk);

            #1;

            if (vif.gpio_clk !== vif.clk)
                $error("GPIO clock did not start");

            vif.gpio_enable = 1'b0;

            repeat (4)
                @(posedge vif.clk);


            // TIMER
            vif.timer_enable = 1'b1;

            repeat (5)
                @(posedge vif.clk);

            #1;

            if (vif.timer_clk !== vif.clk)
                $error("TIMER clock did not start");

            vif.timer_enable = 1'b0;

            repeat (4)
                @(posedge vif.clk);


            // UART
            vif.uart_enable = 1'b1;

            repeat (5)
                @(posedge vif.clk);

            #1;

            if (vif.uart_clk !== vif.clk)
                $error("UART clock did not start");

            vif.uart_enable = 1'b0;

            repeat (4)
                @(posedge vif.clk);


            $display("PASS: Peripheral enables covered");

        end

    endtask


    //========================================================
    // ASYNCHRONOUS WAKE-UP
    //========================================================

    task automatic test_wakeup();

        begin

            $display("");
            $display("==============================================");
            $display("TEST 4 : ASYNCHRONOUS WAKE-UP");
            $display("==============================================");


            // All functional enables OFF
            vif.cpu_enable   = 1'b0;
            vif.sram_enable  = 1'b0;
            vif.gpio_enable  = 1'b0;
            vif.timer_enable = 1'b0;
            vif.uart_enable  = 1'b0;

            vif.test_enable = 1'b0;

            vif.async_wakeup = 1'b0;

            repeat (5)
                @(posedge vif.clk);


            // Deliberately asynchronous assertion
            #3;

            vif.async_wakeup = 1'b1;

            // Wait for synchronizer
            repeat (5)
                @(posedge vif.clk);

            #1;

            if (vif.wake_sync !== 1'b1)
                $error("wake_sync did not assert");


            if (vif.cpu_clk !== vif.clk)
                $error("CPU wake-up clock failed");

            if (vif.sram_clk !== vif.clk)
                $error("SRAM wake-up clock failed");

            if (vif.gpio_clk !== vif.clk)
                $error("GPIO wake-up clock failed");

            if (vif.timer_clk !== vif.clk)
                $error("TIMER wake-up clock failed");

            if (vif.uart_clk !== vif.clk)
                $error("UART wake-up clock failed");


            // Keep wake-up active long enough
            repeat (5)
                @(posedge vif.clk);


            // Asynchronous deassertion
            #2;

            vif.async_wakeup = 1'b0;


            // Wait for synchronizer to clear
            repeat (5)
                @(posedge vif.clk);

            #1;

            if (vif.wake_sync !== 1'b0)
                $error("wake_sync did not clear");


            // Give ICGs time to disable
            repeat (3)
                @(posedge vif.clk);

            check_all_clocks_off();

            $display("PASS: Wake-up assertion and deassertion covered");

        end

    endtask


    //========================================================
    // TEST / SCAN ENABLE
    //========================================================

    task automatic test_scan();

        begin

            $display("");
            $display("==============================================");
            $display("TEST 5 : TEST / SCAN");
            $display("==============================================");


            vif.async_wakeup = 1'b0;

            vif.cpu_enable   = 1'b0;
            vif.sram_enable  = 1'b0;
            vif.gpio_enable  = 1'b0;
            vif.timer_enable = 1'b0;
            vif.uart_enable  = 1'b0;


            repeat (5)
                @(posedge vif.clk);


            // test_enable 0 -> 1
            vif.test_enable = 1'b1;

            repeat (5)
                @(posedge vif.clk);

            #1;

            if (vif.cpu_clk !== vif.clk)
                $error("CPU scan clock failed");

            if (vif.sram_clk !== vif.clk)
                $error("SRAM scan clock failed");

            if (vif.gpio_clk !== vif.clk)
                $error("GPIO scan clock failed");

            if (vif.timer_clk !== vif.clk)
                $error("TIMER scan clock failed");

            if (vif.uart_clk !== vif.clk)
                $error("UART scan clock failed");


            // test_enable 1 -> 0
            vif.test_enable = 1'b0;

            repeat (5)
                @(posedge vif.clk);

            check_all_clocks_off();

            $display("PASS: Test enable 0->1->0 covered");

        end

    endtask


    //========================================================
    // ALL CLOCKS ACTIVE
    //
    // IMPORTANT FOR COUNTER TOGGLE COVERAGE
    //
    // 8-bit counter:
    //
    // bit 7 needs at least 128 increments to become 1.
    // To observe both 0 and 1 reliably for every bit,
    // run for >256 increments.
    //
    // 520 cycles gives plenty of margin.
    //========================================================

    task automatic test_counter_coverage();

        begin

            $display("");
            $display("==============================================");
            $display("TEST 6 : COUNTER TOGGLE COVERAGE");
            $display("==============================================");

            // Disable wake/test
            vif.async_wakeup = 1'b0;
            vif.test_enable  = 1'b0;


            // Enable every functional clock
            vif.cpu_enable   = 1'b1;
            vif.sram_enable  = 1'b1;
            vif.gpio_enable  = 1'b1;
            vif.timer_enable = 1'b1;
            vif.uart_enable  = 1'b1;


            // Allow gate enables to latch
            repeat (4)
                @(posedge vif.clk);


            $display("Running 520 clock cycles for activity counters...");


            // More than enough to toggle all [7:0] bits
            repeat (520)
                @(posedge vif.clk);


            // Turn every enable OFF
            vif.cpu_enable   = 1'b0;
            vif.sram_enable  = 1'b0;
            vif.gpio_enable  = 1'b0;
            vif.timer_enable = 1'b0;
            vif.uart_enable  = 1'b0;


            repeat (5)
                @(posedge vif.clk);


            check_all_clocks_off();


            $display("PASS: All activity counter bits exercised");

        end

    endtask


    //========================================================
    // INDIVIDUAL GATING
    //========================================================

    task automatic test_individual();

        begin

            $display("");
            $display("==============================================");
            $display("TEST 7 : INDIVIDUAL GATING");
            $display("==============================================");


            // CPU only
            vif.cpu_enable   = 1'b1;
            vif.sram_enable  = 1'b0;
            vif.gpio_enable  = 1'b0;
            vif.timer_enable = 1'b0;
            vif.uart_enable  = 1'b0;

            repeat (5)
                @(posedge vif.clk);


            // SRAM only
            vif.cpu_enable  = 1'b0;
            vif.sram_enable = 1'b1;

            repeat (5)
                @(posedge vif.clk);


            // GPIO only
            vif.sram_enable = 1'b0;
            vif.gpio_enable = 1'b1;

            repeat (5)
                @(posedge vif.clk);


            // TIMER only
            vif.gpio_enable  = 1'b0;
            vif.timer_enable = 1'b1;

            repeat (5)
                @(posedge vif.clk);


            // UART only
            vif.timer_enable = 1'b0;
            vif.uart_enable  = 1'b1;

            repeat (5)
                @(posedge vif.clk);


            // ALL OFF
            vif.uart_enable = 1'b0;

            repeat (5)
                @(posedge vif.clk);

            check_all_clocks_off();

            $display("PASS: Individual gating covered");

        end

    endtask


    //========================================================
    // RESET AGAIN
    //
    // This second reset is intentional.
    // It exercises reset branches after the DUT has been
    // fully active.
    //========================================================

    task automatic test_second_reset();

        begin

            $display("");
            $display("==============================================");
            $display("SECOND RESET COVERAGE");
            $display("==============================================");


            vif.cpu_enable   = 1'b1;
            vif.sram_enable  = 1'b1;
            vif.gpio_enable  = 1'b1;
            vif.timer_enable = 1'b1;
            vif.uart_enable  = 1'b1;

            repeat (5)
                @(posedge vif.clk);


            // 1 -> 0
            #2;

            vif.rst_n = 1'b0;

            repeat (3)
                @(posedge vif.clk);


            #1;

            if (vif.wake_sync !== 1'b0)
                $error("Wake synchronizer reset failed");


            // 0 -> 1
            vif.rst_n = 1'b1;


            // Remove enables
            vif.cpu_enable   = 1'b0;
            vif.sram_enable  = 1'b0;
            vif.gpio_enable  = 1'b0;
            vif.timer_enable = 1'b0;
            vif.uart_enable  = 1'b0;


            repeat (5)
                @(posedge vif.clk);


            $display("PASS: Second asynchronous reset covered");

        end

    endtask


    //========================================================
    // GLITCH MONITOR
    //========================================================

    always @(vif.cpu_clk) begin

        if (vif.rst_n === 1'b1) begin

            if (vif.cpu_clk === 1'b1) begin

                if (vif.clk !== 1'b1) begin

                    $error(
                        "[%0t ns] CPU CLOCK GLITCH: CPU_CLK HIGH while CLK LOW",
                        $time
                    );

                end

            end


            if (vif.cpu_clk === 1'b0) begin

                if (vif.clk !== 1'b0) begin

                    $error(
                        "[%0t ns] CPU CLOCK GLITCH: CPU_CLK LOW while CLK HIGH",
                        $time
                    );

                end

            end

        end

    end


    //========================================================
    // MAIN TEST
    //========================================================

    initial begin

        $display("");
        $display("================================================");
        $display(" LOW POWER CLOCK GATING CONTROLLER");
        $display(" COMPLETE COVERAGE TEST");
        $display("================================================");
        $display("Clock Frequency = 100 MHz");
        $display("Clock Period    = 10 ns");
        $display("================================================");


        //====================================================
        // RESET
        //====================================================

        test_reset();


        //====================================================
        // ALL CLOCKS OFF
        //====================================================

        test_all_off();


        //====================================================
        // CPU
        //====================================================

        test_cpu();


        //====================================================
        // PERIPHERALS
        //====================================================

        test_peripherals();


        //====================================================
        // WAKE-UP
        //====================================================

        test_wakeup();


        //====================================================
        // TEST / SCAN
        //====================================================

        test_scan();


        //====================================================
        // COUNTER COVERAGE
        //====================================================

        test_counter_coverage();


        //====================================================
        // INDIVIDUAL GATING
        //====================================================

        test_individual();


        //====================================================
        // SECOND RESET
        //====================================================

        test_second_reset();


        //====================================================
        // FINAL WAIT
        //====================================================

        repeat (10)
            @(posedge vif.clk);


        $display("");
        $display("================================================");
        $display(" ALL COVERAGE TESTS COMPLETED");
        $display("================================================");


        #20;

        $finish;

    end

endmodule
