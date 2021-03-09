//ALU.v
module ALU
(
  input [2:0]  ALUop,
  input [31:0] busA,busB,
  output sign,zero,
  output reg [31:0] wData
);

  assign zero = wData;
  assign sign = wData[31];

  always@(*)
    begin
      case(ALUop)
        3'b010: wData = busA + busB;
        3'b110: wData = busA - busB;
        3'b000: wData = busA & busB;
        3'b001: wData = busA | busB;
        3'b011: wData = busB<<busA;
        3'b111: wData = ((busA<busB&&busA[31]==busB[31])||(busA[31]>busB[31]))?1:0;
        default: wData = 32'h00000000;
      endcase
//        $display("%d,%d,%d,%d",busA,busB,wData,ALUop);
    end 

endmodule