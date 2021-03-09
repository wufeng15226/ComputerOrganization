`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/05 14:03:38
// Design Name: 
// Module Name: CPU2
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


module CPU2(
    input or_CLK,CLK,Rst,
    input   [1:0] sw,
    output  [7:0] dispcode,
    output  sign_1,sign_2,sign_3,sign_4,light_1,light_2,light_3,light_4,light_5
);
    wire [1:0] PCSrc,RegDst;
    wire PCWre,zero,sign,over,IRWre,ALUSrcA,ALUSrcB,RegWre,RegWreDst,MEMWre,DBSrc,sg;
    wire [31:0] PC,next,result,IS_out,Instruction,A_data,B_data,DB,A_Data,B_Data;
    wire [2:0] ALUop,state;
    wire [4:0] rs,rt;
    wire [3:0] mem0,mem1,mem2,mem3;
    PC PC_ins(CLK,Rst,PCWre,PCSrc,Instruction,A_Data,PC,next);
    Control Control_ins(Rst,CLK,zero,sign,over,rtdata_iszero,Instruction,PCWre,IRWre,ALUSrcA,ALUSrcB,
                        RegWre,RegWreDst,MEMWre,DBSrc,sg,RegDst,ALUop,PCSrc,state);
    Register Reg_ins(CLK,Rst,RegWre,RegWreDst,RegDst,Instruction,PC,DB,A_data,B_data,A_Data,B_Data,rs,rt);
    ALU ALU_ins(ALUop,ALUSrcA,ALUSrcB,sg,A_data,B_data,Instruction,result,zero,sign,over,rtdata_iszero);
    ISMem ISMem_ins(PC,IS_out);
    DataMem DataMem_ins(CLK,Rst,MEMWre,DBSrc,result,B_data,DB,mem0,mem1,mem2,mem3);//bubble
    IR IR_ins(IS_out,CLK,IRWre,Instruction);
    reg   [3:0]  display_data;
    reg   [1:0]  count;
    reg   [20:0]  CNT;
    reg   clk;
    always@(posedge or_CLK)
      begin
        if(CNT==99999||Rst==1)CNT=0;
        else CNT <= CNT+1;
      end
  
   always@(*) clk <= Rst?0:((CNT==99999)?~clk:clk);
   assign sign_1 = (count==0)?0:1;
   assign sign_2 = (count==1)?0:1;
   assign sign_3 = (count==2)?0:1;
   assign sign_4 = (count==3)?0:1;
   `define IF 3'b000
   `define ID 3'b001
   `define EXE_1 3'b101
   `define EXE_2 3'b110
   `define EXE_3 3'b010
   `define WB_1 3'b111 
   `define WB_2 3'b100
   `define MEM 3'b011
   assign light_1 = (state==`IF)?1:0;
   assign light_2 = (state==`ID)?1:0;
   assign light_3 = (state==`EXE_1||state==`EXE_2||state==`EXE_3)?1:0;
   assign light_4 = (state==`WB_1||state==`WB_2)?1:0;
   assign light_5 = (state==`MEM)?1:0;
   always@(posedge clk)
     begin
       count <= Rst?0:(count+1);
     end
  
   always@(*)
     begin
       case(sw)
       2'b00://display_data = Add[7:0]+next[7:0];
        begin
          case(count)
            0:display_data = PC[7:4];
            1:display_data = PC[3:0];
            2:display_data = next[7:4];
            3:display_data = next[3:0];
          endcase
        end
      2'b01://display_data = rs[3:0]+rs[3:0];
        begin
          case(count)
            0:display_data = rs[4];
            1:display_data = rs[3:0];
            2:display_data = A_Data[7:4];
            3:display_data = A_Data[3:0];
          endcase
        end
      2'b10://display_data = rt[3:0]+rt[3:0];
        begin
          case(count)
            0:display_data = rt[4];
            1:display_data = rt[3:0];
            2:display_data = B_Data[7:4];
            3:display_data = B_Data[3:0];
          endcase
        end
      2'b11://display_data = result[7:0]+DB;
        begin
          case(count)
        /* //bubble
            0:display_data = mem0;
            1:display_data = mem1;
            2:display_data = mem2;
            3:display_data = mem3;
        */
        
            0:display_data = result[7:4];
            1:display_data = result[3:0];
            2:display_data = DB[7:4];
            3:display_data = DB[3:0];
        
          endcase
        end
      endcase
    end
 // handle_shake handle_shake_ins(.clk(or_CLK),.PB(PB_CLK),.PB_state(CLK));
  SegLED SegLED_ins(.display_data(display_data),.dispcode(dispcode));
endmodule


