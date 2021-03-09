`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/05 14:55:56
// Design Name: 
// Module Name: PC
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


module PC(
    input CLK,Rst,PCWre,
    input [1:0] PCSrc,
    input [31:0] Instruction,A_Data,
    output reg [31:0] PC,next
);
    wire [31:0]j_add,sg_imme;
    assign j_add={PC[31:28],Instruction[25:0],2'b00};
    wire [15:0]imme; 
    assign imme=Instruction[15:0];
    Extend ext_PCins(imme,1'b1,sg_imme);


    always@(*)
       begin
         if(Rst)next<=0;
         else if(PCSrc==0)next<=PC+4;
         else if(PCSrc==1)next<=PC+4+sg_imme*4;
         else if(PCSrc==2)next<=A_Data;
         else if(PCSrc==3)next<=j_add;
      end

    
    always@(posedge CLK)
       begin
        if(Rst)PC <= 0;
        else if(Instruction[31:26]==6'b111111)PC <= PC;
        else if(PCWre)
          begin
            PC <= next;
          end
        else PC <= PC;
       end


endmodule
