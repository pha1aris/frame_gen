# ============================================================================
# Vivado 空工程创建脚本
# 描述: 仅设置器件型号，不添加任何源文件或约束文件。
# 时间: 2025-10-08
# ============================================================================

# --- 1. 参数设置 ---

# 设置FPGA器件型号 (Zynq UltraScale+ MPSoC)
set DEVICE_PART "xczu15eg-ffvb1156-2-i"

# 设置工程名称 (您可以按需修改)
set PROJECT_NAME "frame_gen"

# ============================================================================

# --- 2. 工程创建流程 (通常无需修改) ---

# 获取脚本所在的目录
set PROJ_DIR [pwd]

# 创建工程目录路径，如果已存在则先删除
set PROJECT_DIR "${PROJ_DIR}/${PROJECT_NAME}"
if { [file exists $PROJECT_DIR] } {
    puts "INFO: Deleting existing project directory: $PROJECT_DIR"
    file delete -force $PROJECT_DIR
}
puts "INFO: Creating new empty project: $PROJECT_NAME at $PROJECT_DIR"

# 创建Vivado工程
# 这是本脚本最核心的命令
create_project $PROJECT_NAME $PROJECT_DIR -part $DEVICE_PART

puts "============================================================================"
puts "INFO: Empty project '$PROJECT_NAME' created successfully."
puts "INFO: Device Part: $DEVICE_PART"
puts "INFO: No source or constraint files were added."
puts "INFO: To open the project, run:"
puts "INFO: vivado ${PROJ_DIR}/${PROJECT_NAME}/${PROJECT_NAME}.xpr"
puts "============================================================================"