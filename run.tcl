read_libs slow_vdd1v0_basicCells.lib
read_hdl -sv low_power_soc.sv
elaborate
read_sdc constraints_soccon.sdc
syn_generic
gui_show
syn_map
syn_opt
write_hdl > soccon_netlist.v
write_sdc > soccon_constraint_tool.sdc
report_area > soccon_area.txt
report_power > soccon_power.txt
report_timing > soccon_timing.txt
