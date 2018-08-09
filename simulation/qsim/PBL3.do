onerror {quit -f}
vlib work
vlog -work work PBL3.vo
vlog -work work PBL3.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.Coprocessador_vlg_vec_tst
vcd file -direction PBL3.msim.vcd
vcd add -internal Coprocessador_vlg_vec_tst/*
vcd add -internal Coprocessador_vlg_vec_tst/i1/*
add wave /*
run -all
