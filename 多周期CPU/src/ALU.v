`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 15:01:12
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [2:0]ALUop,
    input ALUSrcA,ALUSrcB,sg,
    input [31:0]A_data,B_data,Instruction,
    output reg [31:0] result,
    output zero,sign,over,rtdata_iszero
);
wire [31:0] sg_imme,sa;
wire [15:0]imme; 
assign imme=Instruction[15:0];
Extend ext_ALUins(imme,sg,sg_imme);
assign sa = Instruction[10:6];
wire [31:0]A,B;
assign A=(ALUSrcA==0)?A_data:sa;
assign B=(ALUSrcB==0)?B_data:sg_imme;
assign zero=(result==0)?0:1;
assign sign=result[31];
assign over=((ALUop==0&&A[31]==B[31]&&A[31]!=result[31])||(ALUop==1&&A[31]!=B[31]&&A[31]!=result[31]))?1:0;
assign rtdata_iszero=(B==0);
always@(*)
    begin
      case(ALUop)
        3'b000:result=A+B;
        3'b001:result=A-B;
        3'b010:result=B<<A;
        3'b011:result=A|B;
        3'b100:result=A&B;
        3'b101:result=(B!=0)?A:0;//0此处无效
        3'b110:result=((A<B&&A[31]==B[31])||(A[31]>B[31]))?1:0;
        //3'b111这里没用
        default: result=32'h00000000;
      endcase
    end

endmodule
