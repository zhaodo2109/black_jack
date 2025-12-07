if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

### ---------------------------------------------- ###
### Compile code ###
### Enter files here; copy line for multiple files ###
vlog -sv -work work [pwd]/synchronizer.sv
vlog -sv -work work [pwd]/deck_memory.sv
vlog -sv -work work [pwd]/deck_lookup.sv
vlog -sv -work work [pwd]/deck_loader.sv
vlog -sv -work work [pwd]/adder6.sv
vlog -sv -work work [pwd]/alu_logic.sv
vlog -sv -work work [pwd]/card_draw.sv
vlog -sv -work work [pwd]/PorD_disp.sv
vlog -sv -work work [pwd]/fullgame.sv
vlog -sv -work work [pwd]/game_fsm.sv
vlog -sv -work work [pwd]/asyncRst_syncRst.sv
vlog -sv -work work [pwd]/tb_deck_memory.sv


### ---------------------------------------------- ###
### Load design for simulation ###
### Replace topLevelModule with the name of your top level module (no .sv) ###
### Do not duplicate! ###
vsim -voptargs=+acc tb_deck_memory


### ---------------------------------------------- ###
### Add waves here ###
### Use add wave * to see all signals ###
add wave *
add wave -position insertpoint sim:/fstb/dut/*

### ---------------------------------------------- ###
### Run simulation ###
### Do not modify ###
# to see your design hierarchy and signals 
view structure 

# to see all signal names and current values
view signals 

### ---------------------------------------------- ###
### Edit run time ###
#run 13950ns
run 50000ns

### ---------------------------------------------- ###
### Will create large wave window and zoom to show all signals
view -undock wave
wave zoomfull 