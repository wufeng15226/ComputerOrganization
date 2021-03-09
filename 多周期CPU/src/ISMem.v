`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/07 15:56:08
// Design Name: 
// Module Name: ISMem
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


module ISMem(
    input [31:0]PC,
    output reg [31:0]IS_out
);
    reg [7:0] ISData[511:0];
    initial
        begin
//            $readmemb("D:/Xlinx/Vivado/CPU2/CPU2.sim/bubble.txt",ISData,0,511);
            $readmemb("D:/Xlinx/Vivado/CPU2/CPU2.sim/ISData.txt",ISData,0,511);
        end 

    always@(*)
        begin
           IS_out = {ISData[PC],ISData[PC+1],ISData[PC+2],ISData[PC+3]};
        end
endmodule
