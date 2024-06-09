#-- Lattice Semiconductor Corporation Ltd.
#-- Synplify OEM project file

#device options
set_option -technology MACHXO3LF
set_option -part LCMXO3LF_6900C
set_option -package BG256C
set_option -speed_grade -5

#compilation/mapping options
set_option -symbolic_fsm_compiler true
set_option -resource_sharing true

#use verilog 2001 standard option
set_option -vlog_std v2001

#map options
set_option -frequency 100
set_option -maxfan 1000
set_option -auto_constrain_io 0
set_option -disable_io_insertion false
set_option -retiming false; set_option -pipe true
set_option -force_gsr false
set_option -compiler_compatible 0
set_option -dup false

set_option -default_enum_encoding default

#simulation options


#timing analysis options



#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#synplifyPro options
set_option -fix_gated_and_generated_clocks 1
set_option -update_models_cp 0
set_option -resolve_multiple_driver 0


set_option -seqshift_no_replicate 0

#-- add_file options
add_file -vhdl {E:/Programs/Iscc/diamond/3.13/cae_library/synthesis/vhdl/machxo3l.vhd}
add_file -vhdl -lib "work" {C:/Users/Flori/iCloudDrive/Uni/sose24/fpga/sheets/blatt03/ex03/ex03_clkdiv.vhd}
add_file -vhdl -lib "work" {C:/Users/Flori/iCloudDrive/Uni/sose24/fpga/sheets/blatt03/ex03/ex03_top_lfsr.vhd}
add_file -vhdl -lib "work" {C:/Users/Flori/iCloudDrive/Uni/sose24/fpga/sheets/blatt03/ex03/ex03_clkdiv_sel.vhd}
add_file -vhdl -lib "work" {C:/Users/Flori/iCloudDrive/Uni/sose24/fpga/sheets/blatt03/ex03/ex03_lfsr8.vhd}

#-- top module name
set_option -top_module ex03_top_lfsr

#-- set result format/file last
project -result_file {C:/Users/Flori/iCloudDrive/Uni/sose24/fpga/sheets/blatt03/impl1/Blatt03_impl1.edi}

#-- error message log file
project -log_file {Blatt03_impl1.srf}

#-- set any command lines input by customer


#-- run Synplify with 'arrange HDL file'
project -run hdl_info_gen -fileorder
project -run
