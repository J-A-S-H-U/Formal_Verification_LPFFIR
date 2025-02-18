set_fml_appmode FPV

set design lpffir_axis
#set_fml_var fml_aep_unique_name
read_file -top lpffir_axis -format sverilog -sva -vcs {/u/jaswanth/LPFFIR/code/lpffir.sv}

create_clock aclk_i -period 100
create_reset aresetn_i -sense high

# Running a reset simulation
sim_run -stable
sim_save_reset

