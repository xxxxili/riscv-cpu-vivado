`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/26 20:38:38
// Design Name: 
// Module Name: regfile
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

module regfile(
    input clk,
    input rst,
    
    input wire [4:0] rs1,//从操作指令进来的寄存器地址
    input wire [4:0] rs2,
    
    input wire [31:0] wd,//运算结果
    input wire [4:0] rd,//要写入的寄存器
    
    input wire we,//使能信号
    
    output reg [31:0] ro1,//从寄存器输出的数据
    output reg [31:0] ro2
    
    
    );
    
    reg [31:0] regs [0:32-1];//寄存器数组
    
   always @(*) begin
    // rs1 读端口：支持 WB 同周期旁路
    if (rs1 == 5'd0)
        ro1 = 32'h00000000;
    else if (we && rd != 5'd0 && rd == rs1)
        ro1 = wd;
    else
        ro1 = regs[rs1];

    // rs2 读端口：支持 WB 同周期旁路
    if (rs2 == 5'd0)
        ro2 = 32'h00000000;
    else if (we && rd != 5'd0 && rd == rs2)
        ro2 = wd;
    else
        ro2 = regs[rs2];
end
    
    integer i;//这段后期可能要改
     always @(posedge clk or posedge rst) begin
        if (rst == `RstEnable) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'h00000000;
        end else begin
            if (we && rd != 5'd0)
                regs[rd] <= wd;

            regs[0] <= 32'h00000000;
        end
    end

endmodule