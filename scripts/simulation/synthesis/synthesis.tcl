# RTL Script to run Basic Synthesis Flow 
#set_db init_lib_search_path /home/install/FOUNDRY/digital/90nm/dig/lib/    
 
set_db library slow_vdd1v0_basicCells.lib 
read_hdl -sv low_power_soc.sv 
elaborate  
read_sdc constraints_soccon.sdc 
 
set_db dft_scan_style muxed_scan  
set_db dft_prefix dft_ 
define_dft shift_enable -name SE -active high -create_port SE 
check_dft_rules 
gui_show 
set_db use_scan_seqs_for_non_dft false 
 
 
set_db syn_generic_effort medium 
set_db syn_map_effort  medium 
set_db syn_opt_effort  medium 
syn_generic 
syn_map 
syn_opt 
 
check_dft_rules 
set_db design:low_power_soc .dft_min_number_of_scan_chains 1 
define_scan_chain -name top_chain -sdi scan_in -sdo scan_out -create_ports  
#connect_scan_chains -auto_create_chains -preview 
connect_scan_chains -auto_create_chains 
syn_opt -incr 
 
report_scan_chains 
write_dft_atpg -library slow_vdd1v0_basiccells.v 
write_hdl > soccon_netlist_dft.v 
write_sdc > soccon_dft.sdc 
write_sdf -nonegchecks -edges check_edge -timescale ns -recrem split > delays_dft.sdf 
write_scandef > soccon_scanDEF.scandef 
report_timing > soccon_timing.rep 
report_area > soccon_area.rep 
report_gates > soccon_GateCount.rep 
report_power > soccon_power.rep 
report_timing_summary > soccon_timing_summary.rep