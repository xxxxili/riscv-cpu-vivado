`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/13 15:31:18
// Design Name: 
// Module Name: ex_wd_mux
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

module EX_wD_MUX1(
    input  wire [`WD_OP-1:0] wd_op,
    input  wire [31:0] pc4,
    input  wire [31:0] sext,
    input  wire [31:0] result,
    output reg  [31:0] wD_temp
);

always @(*) begin
    case (wd_op)
        `WD_J:   wD_temp = pc4;
        `WD_ALU: wD_temp = result;
        `WD_LUI: wD_temp = sext;
        default: wD_temp = 32'b0;
    endcase
end

endmodule