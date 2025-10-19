# =====================================================
# 1. 清理并创建工作库
# =====================================================
# 检查并关闭可能存在的旧窗口
if {[winfo exists .source1]} { 
    destroy .source1 
}
vdel -all
vlib work
vmap work work

# =====================================================
# 2. 编译设计文件 (单文件版)
# =====================================================
puts "=== Compiling RTL source files for single-file DUT... ==="

# 编译依赖的底层模块
vlog ../sim/sync_fifo_8w_8r.v
vlog ../sim/tb_frame_sync_top.v

vlog ../src/delay_fifo.v
vlog ../src/frame_sync_top.v
vlog ../src/pipelined_sync_match.v

# **已修改**: 只编译单文件版的 frame_synchronizer
# vlog ../src/frame_synchronizer_circular.v
# vlog ../src/circular_buffer.v
# vlog ../src/frame_controller.v

# vlog ../src/pipelined_sync_match.v
# 编译新的测试平台
# vlog -sv ./tb_frame_synchronizer_final.v

puts "=== Compilation complete. ==="

# =====================================================
# 3. 启动仿真
# =====================================================
puts "=== Starting simulation... ==="

# **已修改**: 启动新的测试平台
vsim -L fifo_generator_v13_2_11 -L xpm -gui -voptargs="+acc" work.tb_frame_sync_top

# =====================================================
# 4. 配置波形并运行
# =====================================================
puts "=== Configuring waveform and running simulation... ==="

# **已修改**: 添加与新顶层一致的波形信号
# add wave -r /tb_frame_synchronizer_final/u_dut/*
# add wave -r /tb_frame_synchronizer_final/u_dut/pipelined_sync_match/*
aadd wave -r /tb_frame_sync_top/*
run 2us
puts "=== Simulation finished. ==="
