`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 14:47:38
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input               clk,
    input               rst,
    input               stall,
    input               flush,
    input [31:0]        if_pc,
    input [31:0]        if_pc_4,
    input [31:0]        if_op,
    output reg [31:0]   id_pc,
    output reg [31:0]   id_pc_4,
    output reg [31:0]   id_op
    
    
    );

always @(posedge clk or posedge rst) begin
    if(rst == `RstEnable || flush) begin
        id_pc <= 0;
        id_pc_4 <= 0;
        id_op <= 0;
//    end else if(flush) begin
//        id_pc <= 0;
//        id_pc4 <= 0;
//        id_inst <= 0;
    end else if(stall) begin
        id_pc <= id_pc;
        id_pc_4 <= id_pc_4;
        id_op <= id_op;
    end else begin
        id_pc <= if_pc;
        id_pc_4 <= if_pc_4;
        id_op <= if_op;
    end
end 


endmodule
