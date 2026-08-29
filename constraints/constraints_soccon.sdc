# #################################################################### 
 
#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Fri Aug 28 23:52:07 IST 2026 
 
# #################################################################### 
 
set sdc_version 2.0 
 
set_units -capacitance 1000fF 
set_units -time 1000ps 
 
# Set the current design 
current_design low_power_soc 
 
create_clock -name "clk" -period 1.0 -waveform {0.0 0.5} [get_ports clk] 
set_clock_transition 0.1 [get_clocks clk] 
set_clock_gating_check -setup 0.0  
set_input_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports cpu_enable] 
set_input_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports sram_enable] 
set_input_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports gpio_enable] 
set_input_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports timer_enable] 
set_input_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports uart_enable] 
set_input_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports async_wakeup] 
set_input_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports test_enable] 
set_output_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports cpu_clk] 
set_output_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports sram_clk] 
set_output_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports gpio_clk] 
set_output_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports timer_clk] 
set_output_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports uart_clk] 
set_output_delay -clock [get_clocks clk] -add_delay -max 0.2 [get_ports wake_sync] 
set_wire_load_mode "enclosed" 
set_clock_uncertainty -setup 0.01 [get_ports clk] 
set_clock_uncertainty -hold 0.01 [get_ports clk] 