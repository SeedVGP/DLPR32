`timescale 1ns/1ps 
module logical(
  input [31:0]  op1,op2,
  input 	clk,
  input     cs_logic,
  input [3:0] dec_val,
  output reg [31:0] rslt2
);
  always@(posedge clk)
    begin
      if(cs_logic)
        case(dec_val)
          5:begin
            rslt2=op1^op2;
          end
          8:rslt2=op1|op2;
          9:rslt2=op1&op2;
        endcase
    end
  
endmodule
