`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/13 16:52:59
// Design Name: 
// Module Name: ex_mem
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

module EX_MEM(
    input  wire                 clk,
    input  wire                 rst,

    input  wire                 ex_is_write,
    input  wire [31:0]          ex_result,
    input  wire [`MEM_OP-1:0]   ex_mem_op,
    input  wire [`WD_OP-1:0]    ex_wd_op,
    input  wire [31:0]          ex_ro2,
    input  wire [4:0]           ex_rd,
    input  wire [31:0]          ex_wD_temp,
    input                       ex_reg_we,
    
    output reg                  mem_is_write,
    
//    (* keep = "true", equivalent_register_removal = "no" *)
    output reg [31:0]           mem_result,
    
    output reg [`MEM_OP-1:0]    mem_mem_op,
    output reg [`WD_OP-1:0]     mem_wd_op,
    output reg [31:0]           mem_ro2,
    output reg [4:0]            mem_rd,
    output reg [31:0]           mem_wD_temp,
    output reg                  mem_reg_we
    
    
//    (* keep = "true", equivalent_register_removal = "no", max_fanout = 64 *)
//    output reg [31:0]           mem_addr//新增
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        mem_is_write <= 1'b0;
        mem_result   <= 32'b0;
        
//        mem_addr     <= 32'b0;   // 新增
        
        mem_mem_op   <= {`MEM_OP{1'b0}};
        mem_wd_op    <= {`WD_OP{1'b0}};
        mem_ro2      <= 32'b0;
        mem_rd       <= 5'b0;
        mem_wD_temp  <= 32'b0;
        mem_reg_we   <= 1'b0;
    end
    else begin
        mem_is_write <= ex_is_write;
        mem_result   <= ex_result;
        
//        mem_addr <= ex_result;// 新增
        
        mem_mem_op   <= ex_mem_op;
        mem_wd_op    <= ex_wd_op;
        mem_ro2      <= ex_ro2;
        mem_rd       <= ex_rd;
        mem_wD_temp  <= ex_wD_temp;
        mem_reg_we   <= ex_reg_we;
    end
end

endmodule
