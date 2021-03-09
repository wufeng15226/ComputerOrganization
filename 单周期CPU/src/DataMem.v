//DataMem.v
module DataMem
(
  input  CLK,DataR,DataW,Reset,
  input  [31:0] DAdd,Datain,
  output [31:0] Dataout
);
  reg  [31:0] Data[127:0];
  integer i;
    
assign Dataout = (DataR)?Data[DAdd]:0;

always@(negedge CLK)
  begin
    if(Reset==1)for (i = 0; i < 128; i = i+1) Data[i] <= 0;
    else if(DataW)Data[DAdd] <= Datain;
//    $display("Data[%d]<-%d",DAdd,Data[DAdd]);   
  end
  
endmodule