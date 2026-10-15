`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2025 11:42:01 AM
// Design Name: 
// Module Name: dram_driver
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


module dram_driver(
    input  logic         clk				,

    input  logic [17:0]  perip_addr			, //CPU 传进来的访问地址
    input  logic [31:0]  perip_wdata		, //要写入的数据
	input  logic [1:0]	 perip_mask			, //访问类型掩码
    input  logic         dram_wen           , //DRAM 写使能
    output logic [31:0]  perip_rdata		 //读出来返回给上层的数据
);
    logic [15:0] dram_addr;
    logic [ 1:0] offset;
    logic [31:0] dram_data, dram_rdata_raw, dout;
//dram_rdata_raw 是 DRAM 原始读出来的 32 位
//dout 是经过字节/半字选择后的最终结果
//perip_rdata 就是最后对外输出的数据
    assign dram_addr = perip_addr[17:2];
    assign offset = perip_addr[1:0];
    assign perip_rdata = dout;

    DRAM Mem_DRAM (
        .clk        (clk),
        .a          (dram_addr),
        .spo        (dram_rdata_raw),
        .we         (dram_wen),
        .d          (dram_data)
    );

    // dram_rdata_raw process, lh lb
    always_comb begin
        dout = 0;
        case (perip_mask)
            2'b00: // lb/lbu
                case (offset)
                    2'b00:  dout = {24'b0, dram_rdata_raw[7:0]};
                    2'b01:  dout = {24'b0, dram_rdata_raw[15:8]};
                    2'b10:  dout = {24'b0, dram_rdata_raw[23:16]};
                    2'b11:  dout = {24'b0, dram_rdata_raw[31:24]};
                endcase
            2'b01: // lh/lhu
                case (offset[1])
                    1'b0:  dout = {24'b0, dram_rdata_raw[15:0]};
                    1'b1:  dout = {24'b0, dram_rdata_raw[31:16]};
                endcase
            2'b10: dout = dram_rdata_raw;
            default: dout = 0;
        endcase
    end

    // dram_data_raw process, sh, sb
    always_comb begin
        case (perip_mask)
            2'b10: dram_data = perip_wdata;  // sw
            2'b01: begin           // sh
                case (offset[1])
                    1'b0: dram_data = {dram_rdata_raw[31:16], perip_wdata[15:0]};
                    1'b1: dram_data = {perip_wdata[15:0], dram_rdata_raw[15:0]};
                endcase
            end
            2'b00: begin           // sb
                case (offset)
                    2'b00: dram_data = {dram_rdata_raw[31:8], perip_wdata[7:0]};
                    2'b01: dram_data = {dram_rdata_raw[31:16], perip_wdata[7:0], dram_rdata_raw[7:0]};
                    2'b10: dram_data = {dram_rdata_raw[31:24], perip_wdata[7:0], dram_rdata_raw[15:0]};
                    2'b11: dram_data = {perip_wdata[7:0], dram_rdata_raw[23:0]};
                endcase
            end
            default: dram_data = perip_wdata;
        endcase
    end
endmodule
