remove_design
set name "FPmul_in_reg_pipe"
set clock_name "clk"
set clock_period 3.1
analyze -library WORK -format vhdl {/home/isa33/Lab2/Dadda/src/unpackfp_unpackfp.vhd /home/isa33/Lab2/Dadda/src/register.vhd /home/isa33/Lab2/Dadda/src/packfp_packfp.vhd /home/isa33/Lab2/Dadda/src/half_adder.vhd /home/isa33/Lab2/Dadda/src/full_adder.vhd /home/isa33/Lab2/Dadda/src/fpround_fpround.vhd /home/isa33/Lab2/Dadda/src/fpnormalize_fpnormalize.vhd /home/isa33/Lab2/Dadda/src/fpmul_stage4_struct.vhd /home/isa33/Lab2/Dadda/src/fpmul_stage3_struct.vhd /home/isa33/Lab2/Dadda/src/fpmul_stage2_struct.vhd /home/isa33/Lab2/Dadda/src/fpmul_stage1_struct.vhd /home/isa33/Lab2/Dadda/src/fpmul_pipeline_inreg.vhd /home/isa33/Lab2/Dadda/src/flip-flop.vhd /home/isa33/Lab2/Dadda/src/Dadda_mul.vhd {/home/isa33/Lab2/Dadda/src/mux_encoded.vhd}}
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
#compile_ultra
compile
#optimize_registers
report_timing > ${name}_timing.txt
report_area > ${name}_area.txt
#report_resources > ${name}_resources.txt
change_names -hierarchy -rules verilog
write_sdf ${name}.sdf
write -f verilog -hierarchy -output ${name}.v
write_sdc ${name}.sdc
report_timing
