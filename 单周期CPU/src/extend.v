`timescale 1ns / 1ps
module Extend
(
    input [15:0] imme,
    input ExtSg,
    output [31:0] out
);
    assign out[15:0] = imme;  
    assign out[31:16] = ExtSg? (imme[15]? 16'hffff : 16'h0000) : 16'h0000; 
endmodule
