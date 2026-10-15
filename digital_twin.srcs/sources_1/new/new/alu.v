`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 21:03:07
// Design Name: 
// Module Name: alu
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

module alu(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [`ALU_OP-1:0] alu_op,
    
    output reg [31:0] result
    );
    
    always @(*) begin
    result = 32'b0;   // 默认值
    case (alu_op)
        `ALU_ADD:    result = A + B;
        `ALU_SUB:    result = A - B;
        `ALU_SLL:    result = A << B[4:0];
        `ALU_SLT:    result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
        `ALU_SLTU:   result = (A < B) ? 32'd1 : 32'd0;
        `ALU_XOR:    result = A ^ B;
        `ALU_SRL:    result = A >> B[4:0];
        `ALU_SRA:    result = ($signed(A)) >>> B[4:0];
        `ALU_OR:     result = A | B;
        `ALU_AND:    result = A & B;
        `ALU_NOP:    result = 32'b0;   // 无操作
        default:     result = 32'b0;
    endcase
end
endmodule
