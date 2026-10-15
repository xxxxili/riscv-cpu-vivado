`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 17:21:58
// Design Name: 
// Module Name: CPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.vh"

module myCPU(
    input  wire  cpu_rst,
    input  wire  cpu_clk,
    
    output wire [31:0] irom_addr,
    input  wire [31:0] irom_data,
    
    output wire [31:0] perip_addr,
    output wire        perip_wen,
    output wire [1:0] perip_mask,
    output wire [31:0] perip_wdata,
    input  wire [31:0] perip_rdata
    );
    
    wire br_taken;//判断是否进行分支跳转
//    wire is_load;//判断是否要因为读内存而停一拍
    wire is_write;//判断是否要写内存
    wire [31:0] sext;//立即数
    wire [31:0] pc;//npc和pc之间的连线(旧指令地址)
    wire [31:0] npc;//npc和pc之间的连线（新指令地址）

    wire [31:0] result;
    wire [`NPC_OP-1:0] npc_op;//判断下一个地址
    
//    wire hit_led_addr;//回头记得删
//    assign hit_led_addr = (perip_addr == 32'h8020_0040);
    
    wire stall;
    wire flush_IF_ID;
    wire flush_ID_EX;
    wire branched;
//    wire [31:0] A_forward;
//    wire [31:0] B_forward;
//    wire Forward_A_en;
//    wire Forward_B_en; 
    
    wire [31:0] pc_4;
    
    wire [`NPC_OP-1:0] ex_npc_op;
    wire [31:0] ex_sext;
    wire [31:0] ex_pc;
     wire [31:0] id_pc;    
    npc my_npc(
        .pc(pc),
        .b_pc(ex_pc),
        .npc(npc),
        .br_taken(br_taken),
        .sext(ex_sext),
        .npc_op(ex_npc_op),
        .pc_4(pc_4),
        .result(result),
        .branched(branched)
    );
    wire [`MEM_OP-1:0] mem_op;
    pc my_pc(
        .rst(cpu_rst),
        .npc(npc),
        .stall(stall),
        .pc_irom(pc),
        .clk(cpu_clk)
        
       
    );
    
    

    assign irom_addr = pc;   // 先输出完整PC
    wire [31:0] op;
    assign op = irom_data;   // 外部IROM返回的指令
    wire [31:0] id_op;
    
    
    wire [31:0] id_pc_4;
    IF_ID my_IF_ID(
        .clk      (cpu_clk),
        .rst      (cpu_rst),
        .stall    (stall),
        .flush    (flush_IF_ID),
        .if_pc    (pc),
        .if_pc_4   (pc_4),
        .if_op  (op),//指令
        .id_pc    (id_pc),
        .id_pc_4   (id_pc_4),
        .id_op  (id_op)
    );
    //id
    
    wire [6:0] opcode=id_op[6:0];
    wire [2:0] funct3=id_op[14:12];
    wire [6:0] funct7=id_op[31:25];
    
    wire [`ALU_OP-1:0] alu_op;
    wire [`SEXT_OP-1:0] sext_op;
    
    wire [`ALUA_MUX-1:0] A_MUX;
    wire [`ALUB_MUX-1:0] B_MUX;
    

    wire [31:0] data_out;
    
    wire [`BR_OP-1:0] Br_op;
    wire [`WD_OP-1:0] wd_op;
    wire ro1_used;
    wire ro2_used;
    
    control my_control(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(alu_op),
        .sext_op(sext_op),
        .A_MUX(A_MUX),
        .B_MUX(B_MUX),
        .mem_op(mem_op),
        .Br_op(Br_op),
        .wd_op(wd_op),
        .npc_op(npc_op),
        .ro1_used(ro1_used),
        .ro2_used(ro2_used),
       
        .is_write(is_write)
    );
    
    wire [4:0] rs1=id_op[19:15];
    wire [4:0] rs2=id_op[24:20];
    wire [4:0] rd=id_op[11:7];
    
    wire [31:0] ro1;
    wire [31:0] ro2;
    
    wire reg_we;//判断本周期要不要写寄存器//id_rf_we
    assign reg_we = (opcode == `R) ||
                (opcode == `I_math) ||
                ((opcode == `I_load))||
                (opcode==`I_jump)||
                (opcode==`J)||
                (opcode==`U_auipc)||
                (opcode==`U_lui);
                
//    wire [31:0] wd;   
    wire wb_reg_we;
    wire [4:0] wb_rd;
    wire [31:0] wb_wD;         
    regfile my_regfile(
        .rs1(rs1),
        .rs2(rs2),
        .ro1(ro1),
        .ro2(ro2),
        .wd(wb_wD),
        .rd(wb_rd),
        .we(wb_reg_we), //之后要改
        .clk(cpu_clk),
        .rst(cpu_rst)
    );
    
    wire [24:0] imm=id_op[31:7];
   
    sext my_sext(
        .imm(imm),
        .sext_op(sext_op),
        .sext(sext)
    );
    wire [31:0] A;
    wire [31:0] B;
    
     wire [`ALU_OP-1:0] ex_alu_op;
    wire [`WD_OP-1:0]  ex_wd_op;
    wire [`MEM_OP-1:0] ex_mem_op;
    wire [`BR_OP-1:0]  ex_Br_op;
    wire               ex_is_write;

    
      wire [31:0] ex_ro1;
    wire [31:0] ex_ro2;

    wire [31:0] ex_pc_4;
    wire [31:0] ex_A;
    wire [31:0] ex_B;
    wire [4:0]  ex_rd;
    
    wire ex_reg_we;
    
    wire [4:0] ex_rs1;
    wire [4:0] ex_rs2;
    wire ex_ro1_used;
    wire ex_ro2_used;
    
    ID_EX my_ID_EX(
    .clk           (cpu_clk),
    .rst           (cpu_rst),
    .flush         (flush_ID_EX),
    .id_alu_op     (alu_op    ),
    .id_wd_op     (wd_op     ),//id_rf_wsel大信号
    .id_mem_op     (mem_op    ), //dram_sel
    .id_Br_op     (Br_op    ),
    .id_is_write     (is_write    ),//id_ram_we
   //  .id_rf_we      (id_rf_we     ),
    //.id_dram_sel   (id_dram_sel  ),
    .id_ro2        (ro2       ),
//    .id_ro1        (ro1       ),
    .id_pc_4        (id_pc_4       ),
    .id_pc          (id_pc),
    .id_npc_op     (npc_op    ),
    .id_sext       (sext      ),
    .id_A          (A         ),
    .id_B          (B         ),
    .id_rd         (rd),//wR
    .id_reg_we     (reg_we),
    
    .id_rs1        (rs1),
    .id_rs2        (rs2),
    .id_ro1_used   (ro1_used),
    .id_ro2_used   (ro2_used),

    .ex_rs1        (ex_rs1),
    .ex_rs2        (ex_rs2),
    .ex_ro1_used   (ex_ro1_used),
    .ex_ro2_used   (ex_ro2_used),
//    .Forward_A_en  (Forward_A_en ),
//    .Forward_B_en  (Forward_B_en ),
//    .A_forward     (A_forward    ),
//    .B_forward     (B_forward    ),
    .ex_alu_op     (ex_alu_op    ),
    .ex_wd_op      (ex_wd_op     ),//id_rf_wsel
    .ex_mem_op     (ex_mem_op    ),//dram_sel
    .ex_Br_op      (ex_Br_op    ),
    .ex_is_write   (ex_is_write    ),//id_ram_we
   // .ex_rf_we      (ex_rf_we     ),
    //.ex_ram_we     (ex_ram_we    ),
    //.ex_rf_wsel    (ex_rf_wsel   ),
    //.ex_dram_sel   (ex_dram_sel  ),
    .ex_ro2        (ex_ro2       ),
//    .ex_ro1        (ex_ro1       ),
    .ex_sext       (ex_sext      ),
    .ex_pc_4       (ex_pc_4       ),
    .ex_A          (ex_A         ),
    .ex_B          (ex_B         ),
    .ex_rd         (ex_rd        ),
    .ex_npc_op     (ex_npc_op    ),
    .ex_pc         (ex_pc),
    .ex_reg_we     (ex_reg_we    )
    

//    ,//trace
//    .pc_i        (id_pc         ),
//    .pc_o        (pc_EX         ),
//    .have_inst_i (have_inst_ID  ),
//    .have_inst_o (have_inst_EX  )
);
    wire [1:0]            forward_A_sel;
    wire [1:0]            forward_B_sel;
    
    wire [31:0] real_A;
    wire [31:0] real_B;
    wire [31:0] real_ro2;
    
    wire [31:0]        mem_wD_temp;
    
   forwarding_mux my_forwarding_mux(
    .forward_A_sel(forward_A_sel),
    .forward_B_sel(forward_B_sel),
    
    .mem_wD(mem_wD_temp),
    .wb_wD(wb_wD),
    .ex_A(ex_A),
    .ex_B(ex_B),
    .ex_ro2(ex_ro2),
    .ex_is_write(ex_is_write),
    .real_A(real_A),
    .real_B(real_B),
    .real_ro2(real_ro2)
   
   );
   
   
    alu_mux my_alu_mux(
        .A_MUX(A_MUX),
        .B_MUX(B_MUX),
        .ro1(ro1),
        .ro2(ro2),
        .sext(sext),
        .A(A),
        .B(B),
        .pc(id_pc)
    );
    //ex
   
    wire [31:0] ex_wD_temp;
    EX_wD_MUX1 my_ex_wd_mux(
        .wd_op(ex_wd_op),
        .pc4(ex_pc_4),
        .sext(ex_sext),
        .result(result),
        .wD_temp(ex_wD_temp)
    );
   
    alu my_alu(
        .A(real_A),
        .B(real_B),
        .alu_op(ex_alu_op),
        .result(result)
    );
    
   BranchComp my_BranchComp(
        .ro1(real_A),
        .ro2(real_ro2),
        .Br_op(ex_Br_op),
        .br_taken(br_taken)
    
    );
    
    wire               mem_is_write;
    wire [31:0]        mem_result;
    wire [`MEM_OP-1:0] mem_mem_op;
    wire [`WD_OP-1:0]  mem_wd_op;
    wire [31:0]        mem_ro2;
    wire [4:0]         mem_rd;

    wire               mem_reg_we;
    
//    wire [31:0]        mem_addr;      // 新增：专门给访存地址用
    EX_MEM my_ex_mem(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .ex_is_write(ex_is_write),
        .ex_result(result),
        .ex_mem_op(ex_mem_op),
        .ex_wd_op(ex_wd_op),
        .ex_ro2(real_ro2),
        .ex_rd(ex_rd),
        .ex_wD_temp(ex_wD_temp),
        .ex_reg_we(ex_reg_we),
        
        .mem_is_write(mem_is_write),
        .mem_result(mem_result),
        .mem_mem_op(mem_mem_op),
        .mem_wd_op(mem_wd_op),
        .mem_ro2(mem_ro2),
        .mem_rd(mem_rd),
        .mem_wD_temp(mem_wD_temp),
        .mem_reg_we(mem_reg_we)
        
//        .mem_addr(mem_addr)
    );


assign perip_wdata = mem_ro2;
assign perip_addr  = mem_result; 
assign perip_wen   = mem_is_write; 
//mem
mem_mask my_mem_mask(
    .mem_op(mem_mem_op),
    .perip_mask(perip_mask)
);
    
   
    
    wire [`WD_OP-1:0]  wb_wd_op;     // 新增：WB阶段判断写回来源
    wire [`MEM_OP-1:0] wb_mem_op;    // 新增：WB阶段判断 load 类型
    wire [31:0]        wb_wD_temp;   // 新增：WB阶段的非load写回数据
    wire [31:0]        wb_rdata;     // 新增：WB阶段保存的内存原始读数据
    
    MEM_WB my_mem_wb(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .mem_reg_we(mem_reg_we),//要改
        .mem_rd(mem_rd),
        
        .mem_wd_op(mem_wd_op),//新增
        .mem_mem_op(mem_mem_op),
        .mem_wD_temp(mem_wD_temp),
        .mem_rdata(perip_rdata),
    
        .wb_reg_we(wb_reg_we),
        .wb_rd(wb_rd),
        
        .wb_wd_op(wb_wd_op),//新增
        .wb_mem_op(wb_mem_op),
        .wb_wD_temp(wb_wD_temp),
        .wb_rdata(wb_rdata)
);

    wire [31:0] wb_data_out;

    load my_load(
        .mem_op(wb_mem_op),
        .mem_rdata(wb_rdata),
        .data_out(wb_data_out)
    );
    


     WB_wD_MUX my_wb_wd_mux(
        .wd_op(wb_wd_op),
        .data_out(wb_data_out),
        .wD_temp(wb_wD_temp),
        .wD(wb_wD)
    );
    
    Hazard my_hazard(
        .id_ro1_used(ro1_used),
        .id_ro2_used(ro2_used),
        
        .ex_wd_op(ex_wd_op),
        .mem_wd_op(mem_wd_op), 
        
        .ex_rd(ex_rd),
        .mem_rd(mem_rd),
        .wb_rd(wb_rd),
//        .ex_wD_temp(ex_wD_temp),
//        .mem_wD(wd),
//        .wb_wD(wb_wD),
        .id_rs1(rs1),
        .id_rs2(rs2),
        .branched(branched),
        .ex_reg_we       (ex_reg_we    ),
        .mem_reg_we      (mem_reg_we   ),
        .wb_reg_we       (wb_reg_we    ),
        .stall          (stall       ),
        .flush_IF_ID    (flush_IF_ID ),
        .flush_ID_EX    (flush_ID_EX ),
//        .A_forward      (A_forward   ),
//        .B_forward      (B_forward   ),
//        .Forward_A_en   (Forward_A_en),
//        .Forward_B_en   (Forward_B_en)
        .ex_rs1(ex_rs1),
        .ex_rs2(ex_rs2),
        .ex_ro1_used(ex_ro1_used),
        .ex_ro2_used(ex_ro2_used),
        
        .forward_A_sel(forward_A_sel),
        .forward_B_sel(forward_B_sel)
    );
    
//    regfile_wd_mux my_regfile_wd_mux(
//        .pc(pc),
//        .data_out(data_out),
//        .wd_op(wd_op),
//        .wd(wd),
//        .sext(sext),
//        .result(result)
//    );
endmodule
