//前七位操作码
`define R       7'b0110011
`define I_math  7'b0010011
`define I_load  7'b0000011
`define S       7'b0100011
`define B       7'b1100011
`define I_jump  7'b1100111
`define J       7'b1101111
`define U_auipc 7'b0010111
`define U_lui   7'b0110111
//特殊信号
`define RstEnable 1
//信号长度
`define ALU_OP  4
`define SEXT_OP 3
`define ALUA_MUX 1
`define ALUB_MUX 1
`define MEM_OP   4
`define BR_OP    3
`define WD_OP    2
`define NPC_OP   2
//control里面判断具体R型信号(func3)
`define R_ADD_SUB 3'b000
`define R_SLL     3'b001
`define R_SLT     3'b010
`define R_SLTU    3'b011
`define R_XOR     3'b100
`define R_SRL_SRA 3'b101
`define R_OR      3'b110
`define R_AND     3'b111
//func7
`define R_ADD 7'b0000000
`define R_SUB 7'b0100000
`define R_SRL 7'b0000000
`define R_SRA 7'b0100000

//control里面判断具体I_math型信号(func3)
`define I_ADDI       3'b000
`define I_SLTI       3'b010
`define I_SLTIU      3'b011
`define I_XORI       3'b100
`define I_ORI        3'b110
`define I_ANDI       3'b111
`define I_SLLI       3'b001
`define I_SRLI_SRAI  3'b101
//func7
`define I_SRLI 7'b0000000
`define I_SRAI 7'b0100000

//control里面判断具体I_load型信号(func3)
`define I_LB  3'b000
`define I_LH  3'b001
`define I_LW  3'b010
`define I_LBU 3'b100
`define I_LHU 3'b101

//control里面判断具体S型信号(func3)
`define S_SB  3'b000
`define S_SH  3'b001
`define S_SW  3'b010

//control里面判断具体B型信号(func3)
`define B_BEQ  3'b000
`define B_BNE  3'b001
`define B_BLT  3'b100
`define B_BGE  3'b101
`define B_BLTU 3'b110
`define B_BGEU 3'b111
//ALU数字选择
`define ALU_MUX_RO1 0//A通路
`define ALU_MUX_PC  1

`define ALU_MUX_RO2  0//B通路
`define ALU_MUX_SEXT 1
//ALU运算定义
`define ALU_ADD  0 //加
`define ALU_SUB  1 //减
`define ALU_SLL  2 //逻辑左移,（低位补0）
`define ALU_SLT  3 //若 rs1 < rs2（有符号）则 rd = 1
`define ALU_SLTU 4 //若 rs1 < rs2（无符号）则 rd = 1
`define ALU_XOR  5 //按位异或
`define ALU_SRL  6 //逻辑右移,rd = rs1 >> rs2[4:0]（高位补0）
`define ALU_SRA  7 //算术右移,rd = rs1 >> rs2[4:0](高位补符号位）
`define ALU_OR   8 //按位或
`define ALU_AND  9 //按位与
`define ALU_NOP  10//不做处理

//Branch分支运算定义
`define BR_BEQ  0 //若 rs1 与 rs2 的值相等，则跳转
`define BR_BNE  1 //若 rs1 与 rs2 的值不相等，则跳转。
`define BR_BLT  2 //若 rs1 的值小于 rs2 的值（按有符号数比较），则跳转。
`define BR_BGE 3 //若 rs1 的值大于等于 rs2 的值（按有符号数比较），则跳转
`define BR_BLTU  4 //若 rs1 的值小于 rs2 的值（按无符号数比较），则跳转。
`define BR_BGEU 5 //若 rs1 的值大于等于 rs2 的值（按无符号数比较），则跳转。
`define BR_NOP  6 //不做处理

//SEXT运算定义
`define SEXT_shamt        0 //shamt
`define SEXT_11_0         1 //取imm[11:0]
`define SEXT_31_12        2 //U型指令
`define SEXT_11_5_4_0     3 //S型指令
`define SEXT_12_105_4_111 4 //B型指令
`define SEXT_2010_1119_12 5 //J型指令
//MEM操作定义
`define MEM_LB   0 //从内存中读取 1 个字节（8 位），然后符号扩展至 32 位，存入 rd。
`define MEM_LH   1 //从内存中读取 2 个字节（16 位，半字），然后符号扩展至 32 位，存入 rd。
`define MEM_LW   2 //从内存中读取 4 个字节（32 位，字），直接存入 rd（无需扩展）。
`define MEM_LBU  3 //从内存中读取 1 个字节（8 位），然后零扩展至 32 位，存入 rd。
`define MEM_LHU  4 //从内存中读取 2 个字节（16 位），然后零扩展至 32 位，存入 rd。
`define MEM_NOP  5
`define MEM_SB   6 //将 rs2 的低 8 位数据，保存到 rs1 + 立即数 指向的内存地址（一个字节）
`define MEM_SH   7 //将 rs2 的低 16 位数据，保存到 rs1 + 立即数 指向的内存地址（需 2 字节对齐）。
`define MEM_SW   8 //将 rs2 的 32 位数据，保存到 rs1 + 立即数 指向的内存地址（需 4 字节对齐）

//写回数据选择器

`define WD_J       0
`define WD_L       1
`define WD_ALU     2
`define WD_LUI     3
//npc选择
`define NPC_PC4   0
`define NPC_BR    1
`define NPC_JALR  2
`define NPC_JAL   3

`define forward_NOP 2'b00
`define forward_A   2'b01
`define forward_B   2'b10
`define forward_C   2'b11