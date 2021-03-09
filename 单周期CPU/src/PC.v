//PC.v
module PC(CLK,Reset,PCw,Add,next,branch,jump,imme,addr);
  input   CLK,Reset,PCw,branch,jump;
  input   [15:0] imme;
  input   [25:0] addr;
  output  [31:0] Add,next;
  reg     [31:0] Add,next;
  wire    [31:0] imme_sgex;
  Extend ext_ins1(.imme(imme),.ExtSg(1'b1),.out(imme_sgex));
  
  always@(negedge CLK)
    begin
      if(Reset==1)
        next <= 0;
      else if(PCw) 
        begin
          if(branch) 
            begin
              next <= Add+4+imme_sgex*4;
            end
          else if(jump) next <= {Add[31:28],addr[25:0],2'b00};
          else next <= Add + 4;
        end
    end
  
  always@(posedge CLK)
    begin
//      $display("%d",branch);
      if(Reset==1)
        begin
          Add <= 0;
        end
      else if(PCw) 
        begin
          Add <= next;
        end
    end

endmodule