`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 14:46:45
// Design Name: 
// Module Name: npc
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

 module npc(
    input wire [31:0] pc,//上个地址，从pc的输出接过来
    input wire br_taken,
    input wire [31:0] sext,
    input wire [31:0] b_pc,
    input wire [`NPC_OP-1:0] npc_op,//判断下一个地址
    input wire [31:0] result,
    output reg [31:0] npc,//输出下个地址
    output wire [31:0] pc_4,
    output reg branched
    
    );
    
    
    assign pc_4 = pc + 32'd4;
    
    always@(*)begin
            case(npc_op) 
        //正常情况
        `NPC_PC4:begin
            npc = pc_4;
            branched = 0;
        end
        //B型指令，需要加上偏移量
        `NPC_BR: begin 
            if(br_taken) begin
                npc = pc + sext -8;
                branched = 1;
            end else begin
                npc = pc_4;
                branched = 0;
            end
        end
        //jalr
        `NPC_JALR:begin
            npc = {result[31:1],1'b0};
            branched = 1;
        end
        //jal
        `NPC_JAL:begin
            npc = pc + sext -8;
            branched = 1;
         end
         default: begin 
            npc = 0;
            branched = 0;
         end
     endcase
     end
endmodule
