`timescale 1ns/1ps 
module addq( 
input rst,
input [15:0]x,y,
output reg [15:0] sum,
);
reg cout;
reg [15:0] op1,op2;

always@(*)
begin
if(rst)
sum=0;
else
begin


  
    sum=16'b0;
    op1=x;
    op2=y;
    	if(x[15]==1'b1)
      	op1={1'b1,~x[14:0]+1'b1};
	else
	op1=op1;
    	if(y[15]==1'b1)
      	op2={1'b1,~y[14:0]+1'b1};
	else
	op2=op2;

 {cout,sum}=op1+op2;
  	if(sum[15]==1'b1)
    	sum={1'b1,~sum[14:0]+1'b1};
	else
	sum=sum;

end
endmodule
