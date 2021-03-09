`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/17 22:31:08
// Design Name: 
// Module Name: DataMem
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


module DataMem(
    input CLK,Rst,MEMWre,DBSrc,
    input [31:0]result,B_data,
    output [31:0]DB,
    output [3:0]mem0,mem1,mem2,mem3 //bubble
);
  wire [31:0] DAddr,DB_in,data_out;
  reg  [7:0] Data[127:0];
  integer i;

  //bubble
  assign mem0=Data[3][3:0];
  assign mem1=Data[7][3:0];
  assign mem2=Data[11][3:0];
  assign mem3=Data[15][3:0];

  assign data_out ={Data[DAddr],Data[DAddr+1],Data[DAddr+2],Data[DAddr+3]};//大端
  assign DB_in = (DBSrc==0)?result:data_out;
  always@(posedge CLK)
    begin
      if(Rst==1) for (i = 0; i < 128; i = i+1) Data[i] <= 0;
      else if(MEMWre)
      begin
        Data[DAddr] <= B_data[31:24];
        Data[DAddr+1] <= B_data[23:16];
        Data[DAddr+2] <= B_data[15:8];
        Data[DAddr+3] <= B_data[7:0];
      end
    end
  DR ALUDR(CLK,result,DAddr);
  DR DBDR(CLK,DB_in,DB);
endmodule
