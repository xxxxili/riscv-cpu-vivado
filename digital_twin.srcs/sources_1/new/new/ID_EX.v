`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/07 15:54:40
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input                               clk          ,
    input                               rst          ,
    input                               flush        ,
    input [`ALU_OP-1:0]                 id_alu_op    ,
    input [`WD_OP-1:0]                  id_wd_op     ,//id_rf_wsel
    input [`MEM_OP-1:0]                 id_mem_op     ,//id_ram_we
    input [`BR_OP-1:0]                  id_Br_op    ,
    input                               id_is_write    ,
    //input                               id_rf_we     ,
    //input                               id_ram_we    ,
    //input [`RF_WSEL_WIDTH-1:0]          id_rf_wsel   ,
    //input [`DRAM_SEL_WIDTH-1:0]         id_dram_sel  ,
    input [31:0]                        id_ro2      ,
//    input [31:0]                        id_ro1      ,
    input [31:0]                        id_pc_4       ,
    input [`NPC_OP-1:0]                 id_npc_op    ,
    input [31:0]                        id_sext      ,
    input [31:0]                        id_A         ,
    input [31:0]                        id_B         ,
    input [4:0]                         id_rd        ,
//    input                               Forward_A_en ,
//    input                               Forward_B_en ,
//    input [31:0]                        A_forward    ,
//    input [31:0]                        B_forward    ,
    input                               id_reg_we    ,
    input  [31:0]                       id_pc        ,
    
    input  [4:0]                        id_rs1,
    input  [4:0]                        id_rs2,
    input                               id_ro1_used,
    input                               id_ro2_used,
    
    output reg [4:0]                    ex_rs1,
    output reg [4:0]                    ex_rs2,
    output reg                          ex_ro1_used,
    output reg                          ex_ro2_used,

    output reg [`ALU_OP-1:0]            ex_alu_op    ,
    //output reg                          ex_rf_we     ,
    //output reg                          ex_ram_we    ,
    output reg [`MEM_OP-1:0]            ex_mem_op,
    output reg [`BR_OP-1:0]             ex_Br_op,
    output reg [`WD_OP-1:0]             ex_wd_op,
    output reg                          ex_is_write,//Ð´²»Ð´ÄÚ´æ
    //output reg [`RF_WSEL_WIDTH-1:0]     ex_rf_wsel   ,
    //output reg [`DRAM_SEL_WIDTH-1:0]    ex_dram_sel  ,
    output reg [31:0]                   ex_ro2       ,
//    output reg [31:0]                   ex_ro1       ,
    output reg [31:0]                   ex_sext      ,
    output reg [31:0]                   ex_pc_4       ,
    output reg [31:0]                   ex_A         ,
    output reg [31:0]                   ex_B         ,
    output reg [4:0]                    ex_rd        ,
    output reg [`NPC_OP-1:0]            ex_npc_op    ,
    output reg [31:0]                   ex_pc        ,
    output reg                          ex_reg_we
    //trace
//    ,input  wire [31:0] pc_i       ,
//    output reg  [31:0] pc_o       ,
//    input  wire        have_inst_i,
//    output reg         have_inst_o
    );

//always @(posedge clk or posedge rst) begin
//    if(rst) begin
//        ex_A        <= 0;
//    end else if(Forward_A_en) begin
//        ex_A <= A_forward;
//    end else begin
//        ex_A        <= id_A;
//    end
//end

//always @(posedge clk or posedge rst) begin
//    if(rst) begin
//        ex_B        <= 0;
//        ex_ro2      <= 0;
//    end else if(Forward_B_en) begin
//        if(id_is_write) begin
//            ex_B <= id_B;
//        end else begin
//            ex_B <= B_forward;
//        end
//        ex_ro2 <= B_forward;
//    end else begin
//        ex_B        <= id_B;
//        ex_ro2      <= id_ro2     ;
//    end
//end
always @(posedge clk or posedge rst) begin
    if(rst) begin
        ex_A <= 32'b0;
    end else if(flush) begin
        ex_A <= 32'b0;
    end else begin
        ex_A <= id_A;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        ex_B   <= 32'b0;
        ex_ro2 <= 32'b0;
    end else if(flush) begin
        ex_B   <= 32'b0;
        ex_ro2 <= 32'b0;
    end else begin
        ex_B   <= id_B;
        ex_ro2 <= id_ro2;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        ex_alu_op   <= 0;
        ex_mem_op   <= 0;
        ex_Br_op   <= 0;
        ex_wd_op   <= 0;
        ex_is_write   <= 0;
        //ex_rf_we    <= 0;
        //ex_ram_we   <= 0;
        //ex_rf_wsel  <= 0;
        //ex_dram_sel <= 0;
        
        ex_sext     <= 0;
        ex_pc_4      <= 0;
        ex_rd       <= 0;
        ex_npc_op   <= 0;
        ex_reg_we   <= 0;
        ex_rs1      <= 5'b0;
        ex_rs2      <= 5'b0;
        ex_ro1_used <= 1'b0;
        ex_ro2_used <= 1'b0;
//        ex_ro1 <= 32'b0;
        ex_pc  <= 32'b0;
    end else if(flush) begin
        ex_alu_op   <= 0;
        ex_mem_op   <= 0;
        ex_Br_op   <= 0;
        ex_wd_op   <= 0;
        ex_is_write   <= 0;
        ex_sext     <= 0;
        ex_pc_4      <= 0;
        ex_rd       <= 0;
        ex_npc_op   <= 0;
        ex_reg_we   <= 0;
        ex_rs1      <= 5'b0;
        ex_rs2      <= 5'b0;
        ex_ro1_used <= 1'b0;
        ex_ro2_used <= 1'b0;
//        ex_ro1 <= 32'b0;
        ex_pc  <= 32'b0;
    end else begin
        ex_alu_op   <= id_alu_op  ;
        ex_mem_op   <= id_mem_op;
        ex_Br_op   <= id_Br_op;
        ex_wd_op   <= id_wd_op;
        ex_is_write   <= id_is_write;
        ex_sext     <= id_sext    ;
        ex_pc_4      <= id_pc_4     ;
        ex_rd       <= id_rd      ;
        ex_npc_op   <= id_npc_op  ;
        ex_reg_we   <= id_reg_we  ;
//        ex_ro1 <= id_ro1;
        ex_pc  <= id_pc;
        ex_rs1      <= id_rs1;
        ex_rs2      <= id_rs2;
        ex_ro1_used <= id_ro1_used;
        ex_ro2_used <= id_ro2_used;
    end
end

//trace
//always @ (posedge clk or posedge rst) begin
//    if (rst) pc_o <= 32'b0;
//    else if (flush) pc_o <= 32'b0;
//    else        pc_o <= pc_i;
//end
//always @ (posedge clk or posedge rst) begin
//    if (rst) have_inst_o <= 1'b0;
//    else if(flush)  have_inst_o <= 1'b0;
//    else        have_inst_o <= have_inst_i;
//end


endmodule
