`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/05 15:10:58
// Design Name: 
// Module Name: Control
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


module Control(
    input Rst,CLK,zero,sign,over,rtdata_iszero,
    input [31:0] Instruction,
    output PCWre,IRWre,ALUSrcA,ALUSrcB,RegWre,RegWreDst,MEMWre,DBSrc,sg,
    output [1:0]RegDst,
    output [2:0]ALUop,
    output reg [1:0]PCSrc,
    output reg [2:0]state
);
  wire [5:0]op,funct;
  assign op = Instruction[31:26];
  assign funct = Instruction[5:0];
  `define IF 3'b000
  `define ID 3'b001
  `define EXE_1 3'b101
  `define EXE_2 3'b110
  `define EXE_3 3'b010
  `define WB_1 3'b111 
  `define WB_2 3'b100
  `define MEM 3'b011

    reg [2:0] next_state;
    always@(posedge CLK)
      begin
        state <= next_state;
      end

    always@(*)
        begin
          if(Rst)next_state = `IF;//初始化状态
          else if(state==`IF)next_state = `ID;//必须过程
          else if(state==`ID&&((op==6'b000010||op==6'b111111||op==6'b000011)||(op==6'b000000&&funct==6'b001000)))next_state = `IF;//直接跳转
          else if(state==`ID&&(op==6'b000100||op==6'b000101||op==6'b000001))next_state = `EXE_1;//条件跳转
          else if(state==`ID&&(op==6'b101011||op==6'b100011||op==6'b100101))next_state = `EXE_3;//存取
          else if(state==`ID&&op==6'b000000||op==6'b001001||op==6'b001000||op==6'b001100||op==6'b001101||op==6'b001010)next_state = `EXE_2;//一般指令    
          else next_state = next_state; 
          if(state==`EXE_2)next_state = `WB_1;//一般写回
          if(state==`EXE_3)next_state = `MEM;//取
          if(state==`MEM&&(op==6'b100011||op==6'b100101))next_state = `WB_2;//存
          if(state==`EXE_1||state==`WB_1||state==`WB_2||(state==`MEM&&op==6'b101011))next_state = `IF;//结束
        end

  assign PCWre=(next_state==`IF)?1:0;
  assign IRWre=(state==`IF)?1:0;
  assign ALUop[2]=((op==6'b000000&&(funct==6'b100100||funct==6'b101010||funct==6'b001011))||op==6'b001100||op==6'b001010)?1:0;
  assign ALUop[1]=((op==6'b000000&&(funct==6'b100101||funct==6'b000000||funct==6'b101010))||op==6'b001101||op==6'b001010)?1:0;
  assign ALUop[0]=(op==6'b000100||op==6'b000101||op==6'b000001||op==6'b001101||(op==6'b000000&&(funct==6'b100010||funct==6'b100101||funct==6'b001011)))?1:0;
  assign ALUSrcA = (op==6'b000000&&funct==6'b000000)?1:0;
  assign ALUSrcB = (op==6'b001001||op==6'b001000||op==6'b001100||op==6'b001101||op==6'b001010||op==6'b101011||op==6'b100011||op==6'b100101)?1:0;
  assign RegWre = ((over==0||(over==1&&op==6'b001001))&&((state==`WB_1&&(!(op==6'b000000&&funct==6'b001011&&rtdata_iszero)))||state==`WB_2||op==6'b000011&&state==`ID))?1:0;
  assign RegWreDst = (op==6'b000011)?0:1;
  assign RegDst = (op==6'b000011)?0:((op==6'b001001||op==6'b001000||op==6'b001100||op==6'b001101||op==6'b001010||op==6'b100011||op==6'b100101)?1:2);
  assign MEMWre = (state==`MEM&&op==6'b101011)?1:0;
  assign DBSrc = (op==6'b100011||op==6'b100101)?1:0;
  assign sg = (op==6'b100101)?0:1;
  always@(*)
      begin
       if(Rst)PCSrc = 0;
       else if(op==6'b000010||op==6'b111111||op==6'b000011)PCSrc = 3;
       else if(op==6'b000000&&funct==6'b001000)PCSrc = 2;
       else if((op==6'b000100&&zero==0)||(op==6'b000101&&zero==1)||(op==6'b000001&&sign==1))PCSrc = 1;
       else PCSrc = 0;
      end
endmodule
