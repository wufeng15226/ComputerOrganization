//Register.v
module Register
(
  input  [4:0] rs,rt,rd,sm,
  input  CLK,RegDst,DataDst,Regw,ALUDst1,ALUDst2,ExtSg,Reset,
  input  [31:0] wData,Dataout,
  input  [15:0] imme,
  output [31:0] DB,
  output [31:0] busA,busB,Datain,rs_data,rt_data
);
  reg  [31:0] Reg[31:0];
  wire  [31:0] imme_sgex;
  wire [4:0] wReg;
  integer i;
  
  Extend ext_ins1(.imme(imme),.ExtSg(ExtSg),.out(imme_sgex));
    
  assign busA = (ALUDst1)?sm:Reg[rs];
  assign busB = (ALUDst2)?imme_sgex:Reg[rt];
  assign wReg[4:0] = (RegDst)?rd[4:0]:rt[4:0];
  assign Datain = Reg[rt];
  assign DB = DataDst?Dataout:wData;
  assign rs_data = Reg[rs];
  assign rt_data = Reg[rt];  
  
  always@(negedge CLK)//
    begin
//      $display("%d %d %d %d %d",Regw,ALUDst1,wReg[4:0],DataDst,sm[4:0]);
      if(Reset==1)
        begin
          for (i = 0; i < 32; i = i+1) Reg[i] <= 0;
        end
      else if(Regw&&wReg)
        begin
            begin 
              Reg[wReg] <= DB;
//              $display("$%d<-%d",wReg,Reg[wReg]);
            end
        end
    end
    
endmodule