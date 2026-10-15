`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/28 08:45:42
// Design Name: 
// Module Name: mem_mask
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

module mem_mask(
    input  wire [`MEM_OP-1:0] mem_op,
    output reg  [1:0]         perip_mask
);

always @(*) begin
    case (mem_op)
        `MEM_LB, `MEM_LBU, `MEM_SB: begin
            perip_mask = 2'b00;
        end

        `MEM_LH, `MEM_LHU, `MEM_SH: begin
            perip_mask = 2'b01;
        end

        `MEM_LW, `MEM_SW, `MEM_NOP: begin
            perip_mask = 2'b10;
        end

        default: begin
            perip_mask = 2'b10;
        end
    endcase
end

endmodule
