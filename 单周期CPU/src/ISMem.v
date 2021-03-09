//ISMem_ins.v
module ISMem
(
  input [31:0] Add,
  input Reset,
  output [5:0] op,func,
  output [4:0] rs,rt,rd,sm,
  output [15:0]imme,
  output [25:0]addr
);
  reg [7:0] Mem [255:0];
  reg [31:0]Instruction;
  
  initial
    begin
 /*
      i = 0;
      fp = $fopen("D:/modelsim-seexamples/test/Mem.txt","r");
      while(i<64&&!($feof(fp)))
        begin
          $fscanf(fp,"%b",Mem[i]);
          i = i+1;
        end
  */
      $readmemb("D:/Xlinx/Vivado/CPU1/CPU1.sim/ISMem.txt",Mem,0,255);
    end 
    
  always@(Add or Reset)
    begin
//      $display("%d",Add);
    if(Reset==1)Instruction = 0;
    else Instruction = {Mem[Add],Mem[Add+1],Mem[Add+2],Mem[Add+3]};
//      $display("%b",Instruction);
    end
  
  assign op = Instruction[31:26];
  assign func = Instruction[5:0];
  assign rs = Instruction[25:21];
  assign rt = Instruction[20:16];
  assign rd = Instruction[15:11];
  assign imme = Instruction[15:0];
  assign addr = Instruction[25:0];
  assign sm = Instruction[10:6];
endmodule