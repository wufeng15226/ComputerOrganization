//Control.v
module Control
(
  input [5:0] op,func,
  input zero,sign,
  output PCw,branch,jump,RegDst,Regw,ALUDst1,ALUDst2,ExtSg,DataR,DataW,DataDst,
  output [2:0] ALUop
);
  assign PCw = (op==6'b111111)?0:1;
  assign jump = (op==6'b000010)?1:0;
  assign branch = ((zero==0&&op==6'b000100)||(zero!=0&&op==6'b000101)||(sign!=0&&op==6'b000001))?1:0;
  
  assign RegDst = (op==6'b001100||op==6'b001101||op==6'b001000||op==6'b01010||op==6'b100011)?0:1;//rt,rd
  assign ALUDst1 = (op==6'b000000&&func==6'b000000)?1:0;
  assign ALUDst2 = (op==6'b001100||op==6'b001101||op==6'b001000||op==6'b01010||op==6'b100011||op==6'b101011)?1:0;//imme
  assign ExtSg = (op==6'b001000||op==6'b01010||op==6'b100011||op==6'b101011)?1:0;//extend
  assign DataR = (op==6'b100011)?1:0;
  assign DataW = (op==6'b101011)?1:0;
  assign DataDst = (op==6'b100011)?1:0;
  assign Regw = (op==6'b11111||op==6'b000010||op==6'b000101||op==6'b000001||op==6'b000001||op==6'b101011)?0:1;
  
  assign ALUop[2] = (((op==6'b000000)&&(func==6'b100000||func==6'b100100||func==6'b100101||func==6'b000000))||
                     ((op==6'b001100)||(op==6'b001101)||(op==6'b001000)||(op==6'b101011)||(op==6'b100011)))?0:1;
  assign ALUop[1] = (((op==6'b000000)&&(func==6'b100100||func==6'b100101))||(op==6'b001101)||(op==6'b001100))?0:1;
  assign ALUop[0] = (((op==6'b000000)&&(func==6'b100000||func==6'b100010||func==6'b100100))||
                     ((op==6'b001100)||(op==6'b001000)||(op==6'b000100)||(op==6'b000101)||
                     (op==6'b000001)||(op==6'b101011)||(op==6'b100011)))?0:1;  
  
endmodule