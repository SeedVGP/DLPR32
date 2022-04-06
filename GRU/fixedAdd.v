`timescale 1ns/1ps 
module addk( 
input clk,cs_add,rst,
  input [15:0]x,y,
output reg [15:0] sum,
output reg rdy_add
);
reg cout;
reg [15:0] op1,op2;
reg [1:0] state=0;

always@(posedge clk)
begin
if(rst)
begin
state=0;

end
else
begin
case(state)
0:begin
	if(cs_add)
	state=1;
  	else
	state=0;
  end
1:state=2;
2:state=3;
3:begin
	if(rdy_add)
	state=0;
	else
	state=3;
  	end
endcase
end
end
  
always@(state)
begin
case(state)
0:rdy_add=1;
1:rdy_add=0;
2:
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
  end
3:begin
 {cout,sum}=op1+op2;
  	if(sum[15]==1'b1)
    	sum={1'b1,~sum[14:0]+1'b1};
	else
	sum=sum;
rdy_add=1;
end
endcase
end
endmodule

