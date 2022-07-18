
----------------------Test Bench-------------------------------
`timescale 1ns/1ps 
module addq_tb(); 
reg rst;
reg [15:0] x,y;
wire [15:0] sum;
  addq addd(rst,x,y,sum);

initial
begin
rst=1;
#10;
rst=0;
x=16'b1011010000000000;
y=16'b1011010000000000;
#50;
$finish;
end

endmodule

