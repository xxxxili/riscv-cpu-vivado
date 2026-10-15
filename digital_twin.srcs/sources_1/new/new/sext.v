`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/27 10:11:46
// Design Name: 
// Module Name: sext
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

module sext(
    input wire [24:0] imm,//散装立即数
    input wire [`SEXT_OP-1:0] sext_op,//从cpu来的
    
    output reg [31:0] sext//输出最终立即数
    );
    
    always@(*)begin
         case (sext_op)
            `SEXT_shamt: sext = {27'b0, imm[17:13]};
            `SEXT_11_0: sext={{20{imm[24]}}, imm[24:13]};
            `SEXT_31_12:sext={imm[24:5], 12'b0};
            `SEXT_12_105_4_111: sext = {{19{imm[24]}}, imm[24], imm[0], imm[23:18], imm[4:1], 1'b0};
            `SEXT_2010_1119_12: sext = {{11{imm[24]}}, imm[24], imm[12:5], imm[13], imm[23:14], 1'b0};
            `SEXT_11_5_4_0: sext = {{20{imm[24]}}, imm[24:18], imm[4:0]};
            default:    sext = 32'b0;
        endcase
    end
    
endmodule
