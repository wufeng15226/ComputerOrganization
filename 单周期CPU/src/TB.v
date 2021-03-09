//
`timescale 1ns / 1ps

module TB();
  reg CLK,or_CLK,Reset;
  reg [1:0] sw;
  wire [7:0] dispcode;
  initial
    begin
      or_CLK = 1;
      CLK = 0;
      Reset = 1;
      sw = 2'b00;
      #110 Reset = 0;
    end
  always #100   CLK = ~CLK;
  always #1  or_CLK = ~or_CLK;
    CPU1 CPU1_ins(.or_CLK(or_CLK),.CLK(CLK),.Reset(Reset),.sw(sw),.dispcode(dispcode)
    ,.sign_1(sign_1),.sign_2(sign_2),.sign_3(sign_3),.sign_4(sign_4));
    
endmodule
