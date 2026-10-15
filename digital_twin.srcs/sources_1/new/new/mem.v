`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/27 17:12:42
// Design Name: 
// Module Name: mem
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


module mem(
    input  wire [`MEM_OP-1:0] mem_op,
//    input  wire [31:0] result,      // ALU结果（非访存类直接写回）
    input  wire [31:0] mem_rdata,   // 来自 dram_driver 的读数据（已按宽度取好）
    
    output reg  [31:0] data_out,    // 最终写回寄存器的数据
    output reg  [1:0]  perip_mask   // 给 dram_driver 的访问宽度控制
);

    always @(*) begin
        // 默认值
        data_out   = 32'b0;
        perip_mask = 2'b10;   // 默认按 word

        case (mem_op)
            // ---------------- load ----------------
            `MEM_LB: begin
                perip_mask = 2'b00;
                data_out   = {{24{mem_rdata[7]}}, mem_rdata[7:0]};
            end

            `MEM_LBU: begin
                perip_mask = 2'b00;
                data_out   = {24'b0, mem_rdata[7:0]};
            end

            `MEM_LH: begin
                perip_mask = 2'b01;
                data_out   = {{16{mem_rdata[15]}}, mem_rdata[15:0]};
            end

            `MEM_LHU: begin
                perip_mask = 2'b01;
                data_out   = {16'b0, mem_rdata[15:0]};
            end

            `MEM_LW: begin
                perip_mask = 2'b10;
                data_out   = mem_rdata;
            end

            // ---------------- store ----------------
            `MEM_SB: begin
                perip_mask = 2'b00;
                data_out   = 32'b0;
            end

            `MEM_SH: begin
                perip_mask = 2'b01;
                data_out   = 32'b0;
            end

            `MEM_SW: begin
                perip_mask = 2'b10;
                data_out   = 32'b0;
            end

            // ---------------- 非访存 ----------------
            `MEM_NOP: begin
                perip_mask = 2'b10;
                data_out   = 32'b0;
            end

            default: begin
                perip_mask = 2'b10;
                data_out   = 32'b0;
            end
        endcase
    end

endmodule