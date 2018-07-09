transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Aluno/Desktop/Aula\ 5\ -\ LSD/aula5_mux/mux_fluxo_Always/ex1 {C:/Users/Aluno/Desktop/Aula 5 - LSD/aula5_mux/mux_fluxo_Always/ex1/mux_21.v}

