//CPU1.v
module CPU1
(
  input   or_CLK,CLK,Reset,
  input   [1:0] sw,
  output  [7:0] dispcode,
  output  sign_1,sign_2,sign_3,sign_4
);
  wire   [5:0] op,func;
  wire   [31:0] Add,next,busA,busB,wData,Dataout,Datain,DB,rs_data,rt_data;
  wire   [15:0] imme;
  wire   [25:0] addr;
  wire   [4:0]  rs,rt,rd,sm;
  wire   [2:0]  ALUop;
  wire   branch,jump,PCw,zero,sign,RegDst,Regw,DataDst,ALUDst1,ALUDst2,ExtSg,DataR,DataW;
  reg   [3:0]  display_data;
  reg   [1:0]  count;
  reg   [20:0]  CNT;
  reg   clk;
  PC PC_ins(.CLK(CLK),.Reset(Reset),.PCw(PCw),.Add(Add),.next(next),.branch(branch),.jump(jump),.imme(imme),
            .addr(addr));
  ISMem ISMem_ins(.Add(Add),.Reset(Reset),
                  .op(op),.func(func),.rs(rs),.rt(rt),.rd(rd),.sm(sm),.imme(imme),.addr(addr));
  Control Con_ins(.op(op),.func(func),.zero(zero),.sign(sign),
                  .PCw(PCw),.branch(branch),.jump(jump),.RegDst(RegDst),.Regw(Regw),
                  .ALUDst1(ALUDst1),.ALUDst2(ALUDst2),.ExtSg(ExtSg),.DataR(DataR),.DataW(DataW),
                  .DataDst(DataDst),.ALUop(ALUop));//
  Register reg_ins(.rs(rs),.rt(rt),.rd(rd),.sm(sm),.CLK(CLK),.RegDst(RegDst),.DataDst(DataDst),.Regw(Regw),
                   .ALUDst1(ALUDst1),.ALUDst2(ALUDst2),.ExtSg(ExtSg),.Reset(Reset),.wData(wData),.Dataout(Dataout),
                   .imme(imme),.DB(DB),.busA(busA),.busB(busB),.Datain(Datain),.rs_data(rs_data),.rt_data(rt_data));
  ALU ALU_ins(.ALUop(ALUop),.busA(busA),.busB(busB),.sign(sign),.zero(zero),.wData(wData));
  DataMem DataMem_ins(.CLK(CLK),.DataR(DataR),.DataW(DataW),.Reset(Reset),.DAdd(wData),
                      .Datain(Datain),.Dataout(Dataout));
  
  always@(posedge or_CLK)
      begin
        if(CNT==99999||Reset==1)CNT=0;
        else CNT <= CNT+1;
      end
  
  always@(*) clk <= Reset?0:((CNT==99999)?~clk:clk);
  assign sign_1 = (count==0)?0:1;
  assign sign_2 = (count==1)?0:1;
  assign sign_3 = (count==2)?0:1;
  assign sign_4 = (count==3)?0:1;
  
  always@(posedge clk)
    begin
      count <= Reset?0:(count+1);
    end
  
  //next,BD
  always@(*)
    begin
      case(sw)
      2'b00://display_data = Add[7:0]+next[7:0];
        begin
          case(count)
            0:display_data = Add[7:4];
            1:display_data = Add[3:0];
            2:display_data = next[7:4];
            3:display_data = next[3:0];
          endcase
        end
      2'b01://display_data = rs[3:0]+rs[3:0];
        begin
          case(count)
            0:display_data = rs[4];
            1:display_data = rs[3:0];
            2:display_data = rs_data[7:4];
            3:display_data = rs_data[3:0];
          endcase
        end
      2'b10://display_data = rt[3:0]+rt[3:0];
        begin
          case(count)
            0:display_data = rt[4];
            1:display_data = rt[3:0];
            2:display_data = rt_data[7:4];
            3:display_data = rt_data[3:0];
          endcase
        end
      2'b11://display_data = wData[7:0]+DB;
        begin
          case(count)
            0:display_data = wData[7:4];
            1:display_data = wData[3:0];
            2:display_data = DB[7:4];
            3:display_data = DB[3:0];
          endcase
        end
      endcase
    end
 // handle_shake handle_shake_ins(.clk(or_CLK),.PB(PB_CLK),.PB_state(CLK));
  SegLED SegLED_ins(.display_data(display_data),.dispcode(dispcode));
endmodule
