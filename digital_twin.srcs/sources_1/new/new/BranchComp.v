`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/30 16:05:31
// Design Name: 
// Module Name: BranchComp
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

module BranchComp(
    input wire [31:0] ro1,
    input wire [31:0] ro2,
    input wire [`BR_OP-1:0] Br_op,
    output reg br_taken
    );
    wire eq  = (ro1 == ro2);
    wire ltu = (ro1 < ro2);
    wire lts = ($signed(ro1) < $signed(ro2));

always @(*) begin
    br_taken = 1'b0;
    case (Br_op) 
        `BR_BEQ :  br_taken = eq;
        `BR_BNE :  br_taken = ~eq;
        `BR_BLT :  br_taken = lts;
        `BR_BGE :  br_taken = ~lts;
        `BR_BLTU:  br_taken = ltu;
        `BR_BGEU:  br_taken = ~ltu;
        default :  br_taken = 1'b0;
    endcase
end

endmodule
