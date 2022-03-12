`timescale 1ns/1ps 
module shift(
  input [31:0]  op1,op2,
  input clk,
  input     cs_shift,
  input [3:0]   dec_val,
  output  reg [31:0] rslt3
);
  always@(posedge clk)
    begin
      if(cs_shift)
        case(dec_val)
          2:rslt3=op1<<op2;//x[rd] = x[rs1] << x[rs2]
          3:rslt3=(op1<op2)?32'd1:32'd0;
          4:rslt3=(op1<op2)?32'd1:32'd0;
          7:rslt3=op1>>op2;//x[rd] = x[rs1] >>u x[rs2]
          8:rslt3=op1>>>op2;
        endcase
    end
endmodule
