`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/14 17:01:49
// Design Name: 
// Module Name: Hazard
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
module Hazard(
    input                       id_ro1_used  , 
    input                       id_ro2_used  , 
    
    input [`WD_OP-1:0]          ex_wd_op     ,              //input [`RF_WSEL_WIDTH-1:0]  ex_rf_wsel   , 
    input [`WD_OP-1:0]          mem_wd_op    ,
    
    input [4:0]                 ex_rd        , 
    input [4:0]                 mem_rd       , 
    input [4:0]                 wb_rd        , 
//    input [31:0]                ex_wD_temp        , 
//    input [31:0]                mem_wD       , 
//    input [31:0]                wb_wD        , 
    input [4:0]                 id_rs1       ,
    input [4:0]                 id_rs2       ,
    input                       branched     , 
    input                       ex_reg_we     ,
    input                       mem_reg_we    ,
    input                       wb_reg_we     ,
    
    input [4:0] ex_rs1,
    input [4:0] ex_rs2,
    input       ex_ro1_used,
    input       ex_ro2_used,

    output reg                  stall        , 
    output reg                  flush_IF_ID  , 
    output reg                  flush_ID_EX  , 
//    output reg [31:0]           A_forward    , 
//    output reg [31:0]           B_forward    , 
//    output wire                 Forward_A_en , 
//    output wire                 Forward_B_en  
    output reg [1:0]            forward_A_sel,
    output reg [1:0]            forward_B_sel
);

wire mem_can_forward = (mem_wd_op != `WD_L);

wire RAW_A_rD1 = (ex_rd  == id_rs1) && ex_reg_we  && id_ro1_used && ~(ex_rd==0);
wire RAW_A_rD2 = (ex_rd  == id_rs2) && ex_reg_we  && id_ro2_used && ~(ex_rd==0);

wire RAW_B_rD1 = (mem_rd == ex_rs1) && mem_reg_we && ex_ro1_used && ~(mem_rd==0) && mem_can_forward;
wire RAW_B_rD2 = (mem_rd == ex_rs2) && mem_reg_we && ex_ro2_used && ~(mem_rd==0) && mem_can_forward;

wire RAW_C_rD1 = (wb_rd  == ex_rs1) && wb_reg_we  && ex_ro1_used && ~(wb_rd==0);
wire RAW_C_rD2 = (wb_rd  == ex_rs2) && wb_reg_we  && ex_ro2_used && ~(wb_rd==0);

//assign Forward_A_en = RAW_A_rD1 || RAW_B_rD1 || RAW_C_rD1;
//assign Forward_B_en = RAW_A_rD2 || RAW_B_rD2 || RAW_C_rD2;


//always @ (*) begin
//    if (RAW_A_rD1)      A_forward = ex_wD_temp;
//    else if (RAW_B_rD1) A_forward = mem_wD;
//    else if (RAW_C_rD1) A_forward = wb_wD;
//    else                A_forward = 32'b0;
//end

//always @ (*) begin
//    if (RAW_A_rD2)      B_forward = ex_wD_temp; 
//    else if (RAW_B_rD2) B_forward = mem_wD;
//    else if (RAW_C_rD2) B_forward = wb_wD; 
//    else                B_forward = 32'b0; 
//end

always @(*) begin
    forward_A_sel = `forward_NOP;

    if (RAW_B_rD1)
        forward_A_sel = `forward_B;
    else if (RAW_C_rD1)
        forward_A_sel = `forward_C;
end

always @(*) begin
    forward_B_sel = `forward_NOP;

    if (RAW_B_rD2)
        forward_B_sel = `forward_B;
    else if (RAW_C_rD2)
        forward_B_sel = `forward_C;
end

wire load_use_exist = (RAW_A_rD1 || RAW_A_rD2) & (ex_wd_op == `WD_L);

always @ (*) begin
    if (load_use_exist) stall = 1'b1;
    else                 stall = 1'b0;
end

always @ (*) begin
    if (branched) flush_IF_ID = 1'b1;
    else          flush_IF_ID = 1'b0;
end

always @ (*) begin
    if (load_use_exist || branched) flush_ID_EX = 1'b1;
    else                            flush_ID_EX = 1'b0;
end


endmodule
