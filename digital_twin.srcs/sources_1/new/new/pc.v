`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 14:52:23
// Design Name: 
// Module Name: pc
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

module pc(
    input wire rst,
    input wire clk,
    input wire stall,
    input wire [31:0] npc,
    output reg [31:0] pc_irom
);

always @(posedge clk or posedge rst) begin
    if (rst)begin
        pc_irom <= 32'h8000_0000;
    end else if(stall) begin
        pc_irom <= pc_irom;
    end else begin
        pc_irom <= npc;
    end
end

endmodule