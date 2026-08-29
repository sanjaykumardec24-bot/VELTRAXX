#######################################################
#                                                     
#  Tempus Timing Signoff Solution Command Logging File                     
#  Created on Sat Aug 29 09:23:01 2026                
#                                                     
#######################################################

#@(#)CDS: Tempus Timing Signoff Solution v21.18-s100_1 (64bit) 07/24/2023 10:44 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 21.18-s100_1 NR230707-1955/21_18-UB (database version 18.20.605) {superthreading v2.17}
#@(#)CDS: AAE 21.18-s017 (64bit) 07/24/2023 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 21.18-s023_1 () Jul 22 2023 21:47:22 ( )
#@(#)CDS: SYNTECH 21.18-s011_1 () Jul 21 2023 10:04:21 ( )
#@(#)CDS: CPE v21.18-s054

read_design -physical_data low_power_soc.enc.dat /low_power_soc
all_setup_analysis_views
all_hold_analysis_views
all_setup_analysis_views
all_hold_analysis_views
all_setup_analysis_views
all_hold_analysis_views
all_setup_analysis_views
all_hold_analysis_views
read_spef low_power_soc.spef
read_sdf low_power_soc.sdf
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -early > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -late > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -early > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
add_repeater -cell BUFX2 -net rst_n
redraw
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
add_repeater -cell BUFX2 -net rst_n
redraw
add_repeater -cell BUFX2 -net rst_n
redraw
add_repeater -cell BUFX3 -net rst_n
redraw
zoomSelected
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
change_cell -inst {wake_ff_reg[0]} -cell DFFRHQX2
redraw
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -early > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
zoomSelected
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
add_repeater -cell BUFX3 -net async_wakeup
redraw
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
add_repeater -cell BUFX12 -net async_wakeup
redraw
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
add_repeater -cell BUFX2 -net async_wakeup
redraw
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
change_cell -inst {wake_ff_reg[0]} -cell DFFRHQX4
redraw
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -early > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -late > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
change_cell -inst uart_en_latched_reg -cell DFFNSRX2
redraw
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -late > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
change_cell -inst uart_en_latched_reg -cell DFFNSRX4
redraw
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -late > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
change_cell -inst {wake_ff_reg[1]} -cell DFFRHQX2
redraw
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -late > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
change_cell -inst {wake_ff_reg[1]} -cell DFFRHQX4
redraw
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -late > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
change_cell -inst {wake_ff_reg[1]} -cell DFFRHQX8
redraw
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -late > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -early > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -late > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
change_cell -inst g242 -cell CLKINVX20
redraw
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -late > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
change_cell -inst FE_RC_0_0 -cell NAND2X6
redraw
change_cell -inst FE_RC_0_0 -cell NAND2X6
redraw
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -late > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
change_cell -inst g242 -cell CLKINVX8
redraw
change_cell -inst {wake_ff_reg[1]} -cell DFFRHQX8
redraw
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -late > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
change_cell -inst g181__2398 -cell AND2X2
redraw
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all -late > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt -max_path_num 10000 -updateCategory 0
zoomSelected
zoomSelected
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
all_analysis_views
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dc -rc_corner
add_repeater -cell BUFX2 -net wake_sync
redraw
exit
