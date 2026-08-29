`timescale 1ns/1ps

package low_power_pkg;

    //========================================================
    // COMMON PARAMETERS
    //========================================================

    parameter int SYNC_STAGES = 2;

    parameter time CLK_PERIOD  = 10ns;
    parameter time HALF_PERIOD = 5ns;


    //========================================================
    // TEST MODES
    //========================================================

    typedef enum logic [2:0] {
        TEST_RESET      = 3'b000,
        TEST_IDLE       = 3'b001,
        TEST_CPU        = 3'b010,
        TEST_PERIPHERAL = 3'b011,
        TEST_WAKEUP     = 3'b100,
        TEST_SCAN       = 3'b101,
        TEST_ALL        = 3'b110
    } test_mode_t;

endpackage
