transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+sync_fifo_8w_8r  -L xil_defaultlib -L xpm -L fifo_generator_v13_2_11 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.sync_fifo_8w_8r xil_defaultlib.glbl

do {sync_fifo_8w_8r.udo}

run 1000ns

endsim

quit -force
