`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 19:25:57
// Design Name: 
// Module Name: control
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

module control(
    input wire [6:0] opcode,//操作码
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    
    output reg [`ALU_OP-1:0] alu_op,
    output reg [`SEXT_OP-1:0] sext_op,
    output reg [`ALUA_MUX-1:0] A_MUX,
    output reg [`ALUB_MUX-1:0] B_MUX,
    output reg [`MEM_OP-1:0] mem_op,
    output reg [`BR_OP-1:0] Br_op,
    output reg [`WD_OP-1:0] wd_op,
    output reg [`NPC_OP-1:0] npc_op,
    output wire              ro1_used  ,
    output wire              ro2_used  ,  
//    output reg is_load,//读不读内存
    output reg is_write//写不写内存
    );
    
    
//    assign ro1_used = ~((opcode == `U_lui) || (opcode == `J));
    assign ro1_used = ~((opcode == `U_lui) || (opcode == `J) || (opcode == `U_auipc));
    assign ro2_used = ((opcode == `R) || (opcode == `S) || (opcode == `B));
    always@(*)begin
        alu_op=`ALU_NOP;
        sext_op=`SEXT_11_0;
        A_MUX=`ALU_MUX_RO1;
        B_MUX=`ALU_MUX_RO2;
        mem_op=`MEM_NOP;
//        is_load=1'b0;
        is_write=1'b0;
        Br_op=`BR_NOP;
        wd_op=`WD_ALU;
        npc_op=`NPC_PC4;
        case(opcode)
            `R:begin
                case(funct3)
                    `R_ADD_SUB:begin
                        case(funct7)
                            `R_ADD:begin
                                alu_op=`ALU_ADD;
                            end
                            `R_SUB:begin
                                alu_op=`ALU_SUB;
                            end
                            default: alu_op = `ALU_NOP;
                        endcase
                    end
                    `R_SLL:alu_op=`ALU_SLL;
                    `R_SLT:alu_op=`ALU_SLT;
                    `R_SLTU:alu_op=`ALU_SLTU;
                    `R_XOR: alu_op=`ALU_XOR;
                    `R_SRL_SRA:begin
                        case(funct7)
                            `R_SRL:alu_op=`ALU_SRL;
                            `R_SRA:alu_op=`ALU_SRA;
                            default: alu_op = `ALU_NOP;
                        endcase
                    end
                    `R_OR:alu_op=`ALU_OR;
                    `R_AND:alu_op=`ALU_AND;
                    default: alu_op = `ALU_NOP;
                endcase
            end
            `I_math:begin
                B_MUX=`ALU_MUX_SEXT;
                case(funct3)
                `I_ADDI:alu_op=`ALU_ADD;
                `I_SLTI:alu_op=`ALU_SLT;
                `I_SLTIU:alu_op=`ALU_SLTU;
                `I_XORI:alu_op=`ALU_XOR;
                `I_ORI:alu_op=`ALU_OR;
                `I_ANDI:alu_op=`ALU_AND;
                `I_SLLI: begin
                        if (funct7 == 7'b0) begin
                            alu_op = `ALU_SLL;
                            sext_op = `SEXT_shamt;
                        end else begin
                            alu_op = `ALU_NOP;   // 或触发异常
                            sext_op = `SEXT_11_0;
                        end
                    end
                `I_SRLI_SRAI:begin
                    case(funct7)
                        `I_SRLI:begin
                            alu_op=`ALU_SRL;
                            sext_op=`SEXT_shamt;
                        end
                        `I_SRAI:begin
                            alu_op=`ALU_SRA;
                            sext_op=`SEXT_shamt;
                        end
                             default: begin
                            alu_op  = `ALU_NOP;
                            sext_op = `SEXT_11_0;
                        end 
                    endcase
                    
                end
                default: begin
                    alu_op  = `ALU_NOP;
                    sext_op = `SEXT_11_0;
                end
                endcase
            end
            `I_load:begin
                B_MUX=`ALU_MUX_SEXT;
                alu_op=`ALU_ADD;
                wd_op=`WD_L;
//                is_load=1'b1;
                case(funct3)
                    `I_LB:mem_op=`MEM_LB;
                    `I_LH:mem_op=`MEM_LH;
                    `I_LW:mem_op=`MEM_LW;
                    `I_LBU:mem_op=`MEM_LBU;
                    `I_LHU:mem_op=`MEM_LHU;
                       default: begin
                            mem_op  = `MEM_NOP;
//                            is_load = 1'b0;
                        end
                endcase
            end
            `S:begin
                B_MUX=`ALU_MUX_SEXT;
                alu_op=`ALU_ADD;
                sext_op=`SEXT_11_5_4_0;
                is_write=1'b1;
                case(funct3)
                    `S_SB:mem_op=`MEM_SB;
                    `S_SH:mem_op=`MEM_SH;
                    `S_SW:mem_op=`MEM_SW;
                       default: begin
                        mem_op = `MEM_NOP;
                        is_write = 1'b0;
                    end
                endcase
            end
            `B:begin
                alu_op=`ALU_NOP;
                sext_op=`SEXT_12_105_4_111;
                npc_op=`NPC_BR;
                case(funct3)
                    `B_BEQ:Br_op=`BR_BEQ;
                    `B_BNE:Br_op=`BR_BNE;
                    `B_BLT:Br_op=`BR_BLT;
                    `B_BGE:Br_op=`BR_BGE;
                    `B_BLTU:Br_op=`BR_BLTU;
                    `B_BGEU:Br_op=`BR_BGEU;
                
                endcase
            end
            `I_jump:begin
                B_MUX=`ALU_MUX_SEXT;
                alu_op=`ALU_ADD;
                wd_op=`WD_J;
                npc_op=`NPC_JALR;
            end
            `J:begin
                wd_op=`WD_J;
                npc_op=`NPC_JAL;
                sext_op=`SEXT_2010_1119_12;
            end
            `U_auipc:begin
                alu_op=`ALU_ADD;
                A_MUX=`ALU_MUX_PC;
                B_MUX=`ALU_MUX_SEXT;
                sext_op=`SEXT_31_12;
                wd_op=`WD_ALU;
            end
            `U_lui: begin
                sext_op = `SEXT_31_12;
                wd_op   = `WD_LUI;
            end
                
            default:alu_op=`ALU_NOP;
        endcase
    end
    
endmodule
