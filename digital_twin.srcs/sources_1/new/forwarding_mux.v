`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/27 09:18:56
// Design Name: 
// Module Name: forwarding_mux
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

module forwarding_mux(
    input  wire [1:0]  forward_A_sel,
    input  wire [1:0]  forward_B_sel,
    
//    input  wire [31:0] ex_wD_temp,
    input  wire [31:0] mem_wD,
    input  wire [31:0] wb_wD,
    
    input  wire [31:0] ex_A,
    input  wire [31:0] ex_B,
    input  wire [31:0] ex_ro2,
    
    input  wire        ex_is_write,
    
    output reg  [31:0] real_A,
    output reg  [31:0] real_B,
    output reg  [31:0] real_ro2
    );
    
        always @(*) begin
        case (forward_A_sel)
//            `forward_A: real_A = ex_wD_temp;
            `forward_B: real_A = mem_wD;
            `forward_C: real_A = wb_wD;
            default: real_A = ex_A;
        endcase

        case (forward_B_sel)
//            `forward_A: real_ro2 = ex_wD_temp;
            `forward_B: real_ro2 = mem_wD;
            `forward_C: real_ro2 = wb_wD;
            default:    real_ro2 = ex_ro2;
          endcase
        
        // B 是 ALU 的第二操作数
        // 如果是 store，ALU 的 B 通常是立即数，不应该被 rs2 前递覆盖
      if (ex_is_write) begin
            real_B = ex_B;          // store：ALU B 是地址偏移立即数
        end else if (forward_B_sel != `forward_NOP) begin
            real_B = real_ro2;      // 只有真的发生 rs2 前递时，才替换 ALU B
        end else begin
            real_B = ex_B;          // 默认保持原 ALU B
        end
      end  
endmodule
