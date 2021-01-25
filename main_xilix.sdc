# Constrain clock port clk with a 10-ns requirement

create_clock -period 10.000 [get_ports clk_i]

# Automatically apply a generate clock on the output of phase-locked loops (PLLs)
# This command can be safely left in the SDC even if no PLLs exist in the design

# Constrain the input I/O path

set_input_delay -clock clk_i -max 3.000 [all_inputs]

set_input_delay -clock clk_i -min 2.000 [all_inputs]

# Constrain the output I/O path

set_output_delay -clock clk_i -max 3.000 [all_outputs]

set_output_delay -clock clk_i -min 2.000 [all_outputs]

set_property PACKAGE_PIN A9 [get_ports TXD_i]
set_property IOSTANDARD LVCMOS33 [get_ports TXD_i]
set_property PACKAGE_PIN D10 [get_ports RXD_o]
set_property PACKAGE_PIN C2 [get_ports rst_ni]
set_property PACKAGE_PIN E3 [get_ports clk_i]
set_property PACKAGE_PIN H5 [get_ports {led_dbg_o[1]}]
set_property PACKAGE_PIN J5 [get_ports {led_dbg_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports RXD_o]
set_property IOSTANDARD LVCMOS33 [get_ports rst_ni]
set_property IOSTANDARD LVCMOS33 [get_ports clk_i]
set_property IOSTANDARD LVCMOS33 [get_ports {led_dbg_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_dbg_o[0]}]


set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets pll_50_inst/inst/clk_in1_pll]



