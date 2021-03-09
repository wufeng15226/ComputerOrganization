`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/17 19:49:29
// Design Name: 
// Module Name: Register
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


module Register(
    input CLK,Rst,RegWre,RegWreDst,
    input [1:0]RegDst,
    input [31:0]Instruction,PC,DB,
    output [31:0]A_data,B_data,A_Data,B_Data,
    output [4:0]rs,rt
);
    reg  [31:0] Reg[31:0];
    integer i;
    wire [31:0]Wre_data;
    wire [4:0]rd,wReg;
    assign rs = Instruction[25:21];
    assign rt = Instruction[20:16];
    assign rd = Instruction[15:11];
    assign A_Data = Reg[rs];
    assign B_Data = Reg[rt];  
    assign wReg = (RegDst==0)?31:((RegDst==1)?rt:rd);
    assign Wre_data = (RegWreDst==0)?(PC+4):DB;
    always@(posedge CLK)
    begin
      if(Rst==1) for (i = 0; i < 32; i = i+1) Reg[i] <= 0;
      else if(RegWre&&wReg) Reg[wReg] <= Wre_data;
    end

    DR DRA(CLK,A_Data,A_data);
    DR DRB(CLK,B_Data,B_data);

endmodule
