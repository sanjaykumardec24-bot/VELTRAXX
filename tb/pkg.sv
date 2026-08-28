`timescale 1ns/1ps

package icg_pkg;

    class test;

        virtual icg_if vif;

        function new(virtual icg_if v);
            vif = v;
        endfunction


        // ====================================================
        // Apply all functional enables
        // ====================================================

        task all_enable();

            @(negedge vif.clk);
            vif.cpu_enable   = 1'b1;
            vif.sram_enable  = 1'b1;
            vif.gpio_enable  = 1'b1;
            vif.timer_enable = 1'b1;
            vif.uart_enable  = 1'b1;

        endtask


        // ====================================================
        // Disable all functional enables
        // ====================================================

        task all_disable();

            @(negedge vif.clk);
            vif.cpu_enable   = 1'b0;
            vif.sram_enable  = 1'b0;
            vif.gpio_enable  = 1'b0;
            vif.timer_enable = 1'b0;
            vif.uart_enable  = 1'b0;

        endtask


        // ====================================================
        // Individual enable tests
        // ====================================================

        task individual_enables();

            // CPU
            @(negedge vif.clk);
            vif.cpu_enable = 1'b1;

            repeat(10) @(posedge vif.clk);

            @(negedge vif.clk);
            vif.cpu_enable = 1'b0;


            // SRAM
            @(negedge vif.clk);
            vif.sram_enable = 1'b1;

            repeat(10) @(posedge vif.clk);

            @(negedge vif.clk);
            vif.sram_enable = 1'b0;


            // GPIO
            @(negedge vif.clk);
            vif.gpio_enable = 1'b1;

            repeat(10) @(posedge vif.clk);

            @(negedge vif.clk);
            vif.gpio_enable = 1'b0;


            // TIMER
            @(negedge vif.clk);
            vif.timer_enable = 1'b1;

            repeat(10) @(posedge vif.clk);

            @(negedge vif.clk);
            vif.timer_enable = 1'b0;


            // UART
            @(negedge vif.clk);
            vif.uart_enable = 1'b1;

            repeat(10) @(posedge vif.clk);

            @(negedge vif.clk);
            vif.uart_enable = 1'b0;

        endtask


        // ====================================================
        // TEST ENABLE
        // ====================================================

        task test_enable_test();

            all_disable();

            // test_enable 0 -> 1
            @(negedge vif.clk);
            vif.test_enable = 1'b1;

            repeat(20) @(posedge vif.clk);

            // test_enable 1 -> 0
            @(negedge vif.clk);
            vif.test_enable = 1'b0;

            repeat(20) @(posedge vif.clk);

        endtask


        // ====================================================
        // ASYNC WAKE-UP
        // ====================================================

        task wakeup_test();

            all_disable();

            // Wake-up OFF
            @(negedge vif.clk);
            vif.async_wakeup = 1'b0;

            repeat(10) @(posedge vif.clk);

            // Wake-up ON
            @(negedge vif.clk);
            vif.async_wakeup = 1'b1;

            repeat(20) @(posedge vif.clk);

            // Wake-up OFF
            @(negedge vif.clk);
            vif.async_wakeup = 1'b0;

            repeat(20) @(posedge vif.clk);

        endtask


        // ====================================================
        // LONG ALL-ENABLE TEST
        //
        // 8-bit counters need >256 clock pulses.
        // 600 cycles gives complete 0->1 and 1->0 coverage.
        // ====================================================

        task long_activity_test();

            all_enable();

            repeat(600)
                @(posedge vif.clk);

            all_disable();

            repeat(20)
                @(posedge vif.clk);

        endtask


        // ====================================================
        // MIXED ENABLE TEST
        // ====================================================

        task mixed_test();

            // 10101
            @(negedge vif.clk);

            vif.cpu_enable   = 1'b1;
            vif.sram_enable  = 1'b0;
            vif.gpio_enable  = 1'b1;
            vif.timer_enable = 1'b0;
            vif.uart_enable  = 1'b1;

            repeat(30)
                @(posedge vif.clk);


            // 01010
            @(negedge vif.clk);

            vif.cpu_enable   = 1'b0;
            vif.sram_enable  = 1'b1;
            vif.gpio_enable  = 1'b0;
            vif.timer_enable = 1'b1;
            vif.uart_enable  = 1'b0;

            repeat(30)
                @(posedge vif.clk);


            all_disable();

        endtask


        // ====================================================
        // MAIN TEST
        // ====================================================

        task run();

            $display("");
            $display("================================================");
            $display("      ICG 100%% COVERAGE DIRECTED TEST");
            $display("================================================");


            // ------------------------------------------------
            // 1. Individual enables
            // ------------------------------------------------

            $display("[TEST] Individual enables");

            individual_enables();


            // ------------------------------------------------
            // 2. Test enable
            // ------------------------------------------------

            $display("[TEST] Test enable");

            test_enable_test();


            // ------------------------------------------------
            // 3. Wake-up
            // ------------------------------------------------

            $display("[TEST] Async wake-up");

            wakeup_test();


            // ------------------------------------------------
            // 4. Mixed enables
            // ------------------------------------------------

            $display("[TEST] Mixed enables");

            mixed_test();


            // ------------------------------------------------
            // 5. Long activity
            // ------------------------------------------------

            $display("[TEST] Long activity");

            long_activity_test();


            // ------------------------------------------------
            // 6. Repeat long activity after wake/test
            // ------------------------------------------------

            $display("[TEST] Final activity");

            all_enable();

            repeat(600)
                @(posedge vif.clk);

            all_disable();


            $display("");
            $display("================================================");
            $display("      DIRECTED COVERAGE TEST COMPLETE");
            $display("================================================");

        endtask

    endclass

endpackage
