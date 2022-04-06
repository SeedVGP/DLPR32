`timescale 1ns/1ps 
module addk_tb(); 
reg clk,cs_add,rst;
  reg [15:0] x,y;
wire [15:0] sum;
wire rdy_add;
  addk addd(clk,cs_add,rst,x,y,sum,rdy_add);
initial
begin
clk=1'b0;
forever #5 clk=~clk;
end
initial
begin
rst=1;
#5
cs_add=0;
#10;
rst=0;
cs_add=1;

x=16'b1011010000000000;
y=16'b1011010000000000;
#50;
$finish;
end

endmodule
