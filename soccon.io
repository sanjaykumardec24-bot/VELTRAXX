(globals
        version = 3
        io_order = clockwise
        space = 2
        total_edge = 2
)

(iopad

        (topleft
                (inst name="CornerCell1"
                      cell=padIORINGCORNER
                      offset=0
                      orientation=R180
                      place_status=fixed)
        )

        (left

                (inst name="cpu_clk_pad"
                      cell=PADDO
                      place_status=fixed)

                (inst name="sram_clk_pad"
                      cell=PADDO
                      place_status=fixed)

                (inst name="gpio_clk_pad"
                      cell=PADDO
                      place_status=fixed)

                (inst name="timer_clk_pad"
                      cell=PADDO
                      place_status=fixed)

                (inst name="POWER_VDD01"
                      cell=PADVDD
                      place_status=fixed)

                (inst name="POWER_VSS01"
                      cell=PADVSS
                      place_status=fixed)

        )

        (topright
                (inst name="CornerCell2"
                      cell=padIORINGCORNER
                      offset=0
                      orientation=R90
                      place_status=fixed)
        )

        (top

                (inst name="clk_pad"
                      cell=PADDI
                      place_status=fixed)

                (inst name="rstn_pad"
                      cell=PADDI
                      place_status=fixed)

                (inst name="cpu_en_pad"
                      cell=PADDI
                      place_status=fixed)

                (inst name="sram_en_pad"
                      cell=PADDI
                      place_status=fixed)

                (inst name="gpio_en_pad"
                      cell=PADDI
                      place_status=fixed)

                (inst name="timer_en_pad"
                      cell=PADDI
                      place_status=fixed)

        )

        (bottomright
                (inst name="CornerCell3"
                      cell=padIORINGCORNER
                      offset=0
                      orientation=R0
                      place_status=fixed)
        )

        (right

                (inst name="uart_clk_pad"
                      cell=PADDO
                      place_status=fixed)

                (inst name="wake_sync_pad"
                      cell=PADDO
                      place_status=fixed)

                (inst name="scanout_pad"
                      cell=PADDO
                      place_status=fixed)

                (inst name="dft_sdo_pad"
                      cell=PADDO
                      place_status=fixed)

                (inst name="DUMMY_OUT1"
                      cell=PADDO
                      place_status=fixed)

                (inst name="DUMMY_OUT2"
                      cell=PADDO
                      place_status=fixed)

        )

        (bottomleft
                (inst name="CornerCell4"
                      cell=padIORINGCORNER
                      offset=0
                      orientation=R270
                      place_status=fixed)
        )

        (bottom

                (inst name="uart_en_pad"
                      cell=PADDI
                      place_status=fixed)

                (inst name="wake_pad"
                      cell=PADDI
                      place_status=fixed)

                (inst name="test_pad"
                      cell=PADDI
                      place_status=fixed)

                (inst name="se_pad"
                      cell=PADDI
                      place_status=fixed)

                (inst name="scanin_pad"
                      cell=PADDI
                      place_status=fixed)

                (inst name="dft_sdi_pad"
                      cell=PADDI
                      place_status=fixed)

        )
)
