`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/31 10:12:32
// Design Name: 
// Module Name: regfile_wd_mux
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

module regfile_wd_mux(
    input wire [31:0] pc,
    input wire [31:0] data_out,
    input wire [31:0] result,
    input wire [`WD_OP-1:0] wd_op,
    input wire [31:0] sext,
    
    output reg [31:0] wd
    );
    
    always@(*)begin
        case(wd_op)
            `WD_J:wd=pc + 32'd4;
            `WD_OUT:wd=data_out;
            `WD_AUI:wd=result;
            `WD_LUI:wd=sext;
            default:  wd = 32'b0;
        endcase
    
    end
    
endmodule
