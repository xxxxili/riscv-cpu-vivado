`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/13 20:08:55
// Design Name: 
// Module Name: mem_wb
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

module MEM_WB(
    input  wire        clk,
    input  wire        rst,

    input  wire        mem_reg_we,
    input  wire [4:0]  mem_rd,
//    input  wire [31:0] mem_wD, // 现在这个 mem_wD 在顶层接 mem_wD_temp

      // 新增：告诉 MEM_WB 当前写回类型、load类型、原始读数据
    input [`WD_OP-1:0]          mem_wd_op,
    input [`MEM_OP-1:0]         mem_mem_op,
    input [31:0]                mem_rdata,
    input [31:0]                mem_wD_temp,
    
    output reg                  wb_reg_we,
    output reg [4:0]            wb_rd,

    output reg [`WD_OP-1:0]     wb_wd_op,
    output reg [`MEM_OP-1:0]    wb_mem_op,
    output reg [31:0]           wb_wD_temp,
    output reg [31:0]           wb_rdata
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        wb_reg_we <= 1'b0;
        wb_rd     <= 5'b0;
        wb_wd_op   <= {`WD_OP{1'b0}};
        wb_mem_op  <= {`MEM_OP{1'b0}};
        wb_wD_temp <= 32'b0;
        wb_rdata   <= 32'b0;
    end
    else begin
        wb_reg_we <= mem_reg_we;
        wb_rd     <= mem_rd;
        wb_wd_op   <= mem_wd_op;
        wb_mem_op  <= mem_mem_op;
        wb_wD_temp <= mem_wD_temp;
        wb_rdata   <= mem_rdata;
    end
end

endmodule
