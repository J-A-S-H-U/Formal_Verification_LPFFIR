vlib work				
							
vlog -lint lpffir.sv	+acc -sv	
vlog -lint tb.sv		+acc -sv	
					
vsim -coverage -vopt work.testbench		
						
						
run -all	

add wave -r \*
vcover report -html lpffir_coverage			