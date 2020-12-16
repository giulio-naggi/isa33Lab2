set name "FPmul_in_reg_pipe"
set clock_name "clk"
set clock_period 1.45
analyze -library "work" -format vhdl "../src/flip_flop.vhd"
analyze -library "work" -format vhdl "../src/register.vhd"
analyze -library "work" -format vhdl "../src/packfp_packfp.vhd"
analyze -library "work" -format vhdl "../src/unpackfp_unpackfp.vhd"
analyze -library "work" -format vhdl "../src/fpround_fpround.vhd"
analyze -library "work" -format vhdl "../src/fpnormalize_fpnormalize.vhd"
analyze -library "work" -format vhdl "../src/fpmul_stage1_struct.vhd"
analyze -library "work" -format vhdl "../src/fpmul_stage2_struct.vhd"
analyze -library "work" -format vhdl "../src/fpmul_stage3_struct.vhd"
analyze -library "work" -format vhdl "../src/fpmul_stage4_struct.vhd"
analyze -library "work" -format vhdl "../src/fpmul_pipeline_inreg.vhd"
set power_preserve_rtl_hier_names true
elaborate FPmul -architecture pipeline -library work
create_clock -name "CLK" -period $clock_period $clock_name
set_dont_touch_network CLK
set_clock_uncertainty 0.07 [get_clocks CLK]
set_input_delay 0.5 -max -clock CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]
ungroup -all -flatten
#set_implementation DW02_mult/pparch [find cell *mult*]
compile_ultra
#compile
#optimize_registers
report_timing > ${name}_timing.txt
report_area > ${name}_area.txt
report_resources > ${name}_resources.txt
change_names -hierarchy -rules verilog
write_sdf ${name}.sdf
write -f verilog -hierarchy -output ${name}.v
write_sdc ${name}.sdc

