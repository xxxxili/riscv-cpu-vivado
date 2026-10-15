[README.md](https://github.com/user-attachments/files/33478828/README.md)
# 基于 RISC-V 的五级流水线 CPU 设计

> 第十届（2026 年）全国大学生集成电路创新创业大赛参赛项目｜华南赛区三等奖

## 项目简介

本项目为团队完成的 RISC-V CPU 设计与 FPGA 系统集成实践，使用 Verilog / SystemVerilog 进行 RTL 开发，通过 Xilinx Vivado 管理工程与仿真。

CPU 采用 **IF（取指）—ID（译码）—EX（执行）—MEM（访存）—WB（写回）** 的五级流水线组织方式，并设置 `IF_ID`、`ID_EX`、`EX_MEM`、`MEM_WB` 四组级间流水线寄存器。

根据参赛工程在 Vivado 中的 **Hierarchy** 截图，实际使用的 CPU 实例为：

```text
Core_cpu : myCPU (CPU.v)
```

其中，`CPU.v` 为 CPU 核心顶层 RTL 文件，**模块名为 `myCPU`**。`digital_twin.srcs` 内还保存了其他版本或导入的源码，不能仅按文件夹判断它们是否属于最终 CPU 层次结构。

## 个人贡献

本人负责 **CPU 内核中除数据冒险处理之外的主要 RTL 代码编写**，工作内容涉及程序计数器、指令译码和控制、寄存器堆、算术逻辑运算、分支比较、流水线寄存器及核心数据通路等。

- **本人主要工作范围：** CPU 核心功能模块的设计与 RTL 编写（数据冒险相关部分除外）。
- **团队其他工作范围：** 数据冒险处理与前递相关逻辑，以及外围存储器、总线/外设接口等系统级模块，不列入本人独立贡献。

本仓库包含团队的完整工程文件，**不代表所有代码均由本人编写**。

## CPU 核心模块层次

以下层次以参赛工程 **Vivado → Sources → Hierarchy** 展示的实例为准，并与 `CPU.v` 内的模块实例化关系进行了核对。

```text
Core_cpu : myCPU (CPU.v)               # CPU 核心顶层
├── my_npc            : npc             (npc.v)
├── my_pc             : pc              (pc.v)
├── my_IF_ID          : IF_ID           (IF_ID.v)
├── my_control        : control         (control.v)
├── my_regfile        : regfile         (regfile.v)
├── my_sext           : sext            (sext.v)
├── my_ID_EX          : ID_EX           (ID_EX.v)
├── my_forwarding_mux : forwarding_mux  (forwarding_mux.v)
├── my_alu_mux        : alu_mux         (alu_mux.v)
├── my_ex_wd_mux      : EX_wD_MUX1      (ex_wd_mux.v)
├── my_alu            : alu             (alu.v)
├── my_BranchComp     : BranchComp      (BranchComp.v)
├── my_ex_mem         : EX_MEM          (ex_mem.v)
├── my_mem_mask       : mem_mask        (mem_mask.v)
├── my_mem_wb         : MEM_WB          (mem_wb.v)
├── my_load           : load            (load.v)
├── my_wb_wd_mux      : WB_wD_MUX       (mem_wd_mux.v)
└── my_hazard         : Hazard          (Hazard.v)
```

### 主要模块及作用

| 处理环节 | 主要文件 | 功能 |
| --- | --- | --- |
| IF 取指 | `pc.v`、`npc.v` | 保存当前 PC、计算下一条指令地址 |
| IF/ID | `IF_ID.v` | 锁存取指结果及相关信息 |
| ID 译码 | `control.v`、`regfile.v`、`sext.v` | 生成控制信号、读取通用寄存器、扩展立即数 |
| ID/EX | `ID_EX.v` | 将译码结果及操作数传递至执行阶段 |
| EX 执行 | `alu_mux.v`、`alu.v`、`BranchComp.v`、`ex_wd_mux.v` | 操作数选择、算术逻辑运算、分支条件判断与结果选择 |
| EX/MEM | `ex_mem.v` | 向访存阶段传递执行结果及控制信号 |
| MEM 访存接口 | `mem_mask.v` | 生成访存字节使能/掩码相关控制 |
| MEM/WB | `mem_wb.v` | 将访存/写回信息传递至写回阶段 |
| WB 写回 | `load.v`、`mem_wd_mux.v` | 读取数据处理、写回数据选择 |
| 流水线相关控制 | `Hazard.v`、`forwarding_mux.v` | 数据冒险检测、暂停/冲刷与前递相关处理（非本人主要负责部分） |

> 这里仅概述文件功能；具体信号定义与实现以 RTL 源码为准。外部 `IROM`、`perip_bridge` 等在 `myCPU` 实例之外，不属于上面列出的 CPU 内部层次。

## 关键源码位置

CPU 核心及其依赖文件分布于 `digital_twin.srcs/sources_1/new/` 下的两个层级：

```text
digital_twin.srcs/
├── sources_1/
│   ├── new/
│   │   ├── new/                      # 当前 CPU 绝大部分 RTL 源文件
│   │   │   ├── CPU.v                # myCPU 顶层模块
│   │   │   ├── define.vh            # 宏定义
│   │   │   ├── pc.v / npc.v
│   │   │   ├── control.v / regfile.v / sext.v
│   │   │   ├── IF_ID.v / ID_EX.v
│   │   │   ├── alu_mux.v / alu.v / BranchComp.v
│   │   │   ├── ex_wd_mux.v / ex_mem.v
│   │   │   ├── mem_wb.v / mem_wd_mux.v
│   │   │   └── Hazard.v
│   │   ├── forwarding_mux.v         # 数据前递选择
│   │   ├── mem_mask.v               # 访存掩码
│   │   └── load.v                   # Load 数据处理
│   ├── ip/                          # IROM、DRAM、时钟等相关 IP 配置
│   └── imports/                     # 导入文件及其他版本源码
├── sim_1/new/                       # tb_myCPU.sv、tb_top.sv、tb_uart.sv
├── constrs_1/new/                   # digital_twin.xdc
└── utils_1/                         # 工程相关辅助文件
```

注意：上述为便于阅读而整理的**重点文件索引**，不是仓库中所有文件的穷举。`sources_1/imports/new/` 中还存在另一套 CPU 相关源码；本 README 的 CPU 层次介绍以截图中显示的 `CPU.v` 实例为准。

## 开发与验证环境

- 处理器架构：RISC-V
- 硬件描述语言：Verilog / SystemVerilog
- 工程与仿真工具：Xilinx Vivado
- 配套文件：仿真 Testbench、FPGA 约束及部分 IP 配置文件

**复现说明：** 当前仓库保存的 `.srcs` 为工程源文件目录，若要完整复现 Vivado 项目，还需要核对 `.xpr` 工程文件、仿真顶层、相关 IP 配置以及实际启用的源码集合。目前暂不宣称仓库已实现开箱即用的一键综合或仿真。

## 获奖情况

第十届（2026 年）全国大学生集成电路创新创业大赛 **华南赛区三等奖**。
