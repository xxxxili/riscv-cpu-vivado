`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/28 08:48:09
// Design Name: 
// Module Name: load
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

module load(
    input  wire [`MEM_OP-1:0] mem_op,
    input  wire [31:0]        mem_rdata,
    output reg  [31:0]        data_out
);

always @(*) begin
    case (mem_op)
        `MEM_LB: begin
            data_out = {{24{mem_rdata[7]}}, mem_rdata[7:0]};
        end

        `MEM_LBU: begin
            data_out = {24'b0, mem_rdata[7:0]};
        end

        `MEM_LH: begin
            data_out = {{16{mem_rdata[15]}}, mem_rdata[15:0]};
        end

        `MEM_LHU: begin
            data_out = {16'b0, mem_rdata[15:0]};
        end

        `MEM_LW: begin
            data_out = mem_rdata;
        end

        default: begin
            data_out = 32'b0;
        end
    endcase
end

endmodule
