`timescale 1ns/1ps 
module arith(
  input [31:0]  op1,op2,
  input clk,
  input     cs_addsub,
  input [3:0]   dec_val,
  output reg [31:0] rslt1);
  always@(posedge clk)
    begin
      if(cs_addsub)
        case(dec_val)
          1:rslt1=op1-op2;
      0:rslt1=op1+op2;
      endcase
    end
endmodule
