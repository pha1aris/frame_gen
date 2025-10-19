onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib sync_fifo_8w_8r_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {sync_fifo_8w_8r.udo}

run 1000ns

quit -force
