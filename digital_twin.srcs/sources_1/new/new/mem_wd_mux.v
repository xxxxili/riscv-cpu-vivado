`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/13 16:14:12
// Design Name: 
// Module Name: mem_wd_mux
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
module WB_wD_MUX(
    input  wire [`WD_OP-1:0] wd_op,
    input  wire [31:0] data_out,
    input  wire [31:0] wD_temp,
    output reg  [31:0] wD
);

always @(*) begin
    if (wd_op == `WD_L)
        wD = data_out;
    else
        wD = wD_temp;
end

endmodule