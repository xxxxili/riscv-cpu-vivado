`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/27 10:38:45
// Design Name: 
// Module Name: alu_mux
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


module alu_mux(
    input wire [`ALUA_MUX-1:0] A_MUX,
    input wire [`ALUB_MUX-1:0] B_MUX,
    input wire [31:0] ro1,
    input wire [31:0] ro2,
    input wire [31:0] sext,
    input wire [31:0] pc,
    
    output reg [31:0] A,
    output reg [31:0] B
    );
    
    always @(*) begin
    case (A_MUX) 
        `ALU_MUX_RO1: A = ro1;
        `ALU_MUX_PC: A = pc;
    endcase
end

always @(*) begin
    case (B_MUX) 
        `ALU_MUX_RO2: B = ro2;
        `ALU_MUX_SEXT: B = sext;
    endcase
end
endmodule
