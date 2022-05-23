`timescale 1ns / 100ps
// Code your design here
module sync (clk,dataInA,dataInB,RD,WR,EN,dataOutA,dataOutB,rst,rdy_sy);
input clk,RD,WR,EN,rst;
//output EMPTYA,FULLA,EMPTYB,FULLB;
input [15:0] dataInA,dataInB;
output reg [15:0] dataOutA,dataOutB; // internal registers
output reg rdy_sy;
reg [3:0] Count1 = 0,Count2 = 0;
reg [2:0] state;
reg [15:0] FIFO1 [0:8];
reg [15:0] FIFO2 [0:8];
wire [15:0] FIFO2_t [0:8];
reg [3:0] readCounter1 = 0,writeCounter1 = 0,readCounter2 = 0,writeCounter2 = 0;

/*assign EMPTYA = (Count1==0)? 1&#39;b1:1&#39;b0;
assign FULLA = (Count1==9)? 1&#39;b1:1&#39;b0;
assign EMPTYB = (Count2==0)? 1&#39;b1:1&#39;b0;
assign FULLB = (Count2==9)? 1&#39;b1:1&#39;b0; */

assign FIFO2_t[0] = FIFO2 [0];
assign FIFO2_t[3] = FIFO2 [1];
assign FIFO2_t[6] = FIFO2 [2];
assign FIFO2_t[1] = FIFO2 [3];
assign FIFO2_t[4] = FIFO2 [4];
assign FIFO2_t[7] = FIFO2 [5];
assign FIFO2_t[2] = FIFO2 [6];
assign FIFO2_t[5] = FIFO2 [7];
assign FIFO2_t[8] = FIFO2 [8];

always @ (posedge clk)
begin
if(rst)
state=0;
else
begin
case(state)
0:begin
if(EN)
state=1;
else
state=0;
end
1:state=2; //needs time to update
2:state=3;
3:begin
if(rdy_sy)
state=2;
else
state=0;
end
default:state=2&#39;bx;
endcase
end
end
always@(state)
begin
case(state)

0:begin
rdy_sy=0;
readCounter1 = 0;
writeCounter1 = 0;
readCounter2 = 0;
writeCounter2 = 0;
end
1:rdy_sy=1;
2:begin
rdy_sy=1;
if (EN==0);
else
begin
/*if (rst)
begin
readCounter1 = 0;
writeCounter1 = 0;
readCounter2 = 0;
writeCounter2 = 0;
end
else */if (RD ==1&#39;b1 &amp;&amp; (Count1!=0 || Count2!=0))
begin
dataOutA = FIFO1[readCounter1];
dataOutB = FIFO2_t[readCounter2];

readCounter1 = readCounter1+1;
readCounter2 = readCounter2+1;
end
else if (WR==1&#39;b1 &amp;&amp; (Count1&lt;9 || Count2&lt;9))
begin

FIFO1[writeCounter1] = dataInA;
FIFO2[writeCounter2] = dataInB;
writeCounter1 = writeCounter1+1;
writeCounter2 = writeCounter2+1;
end
else;
end
/*if (writeCounter1==9)
begin
writeCounter1=0;
end
else if (readCounter1==9)
begin
readCounter1=0;
end
else;
if (writeCounter2==9)
begin
writeCounter2=0;
end
else if (readCounter2==9)
begin
readCounter2=0;
end
else;*/
if (readCounter1 &gt; writeCounter1)
begin
Count1=readCounter1-writeCounter1;
end
else if (writeCounter1 &gt; readCounter1)
begin

Count1=writeCounter1-readCounter1;
end
else;
if (readCounter2 &gt; writeCounter2)
begin
Count2=readCounter2-writeCounter2;
end
else if (writeCounter2 &gt; readCounter2)
begin
Count2=writeCounter2-readCounter2;
end
else;
end
3:rdy_sy=1;
default:begin
dataOutA=16&#39;bx;
dataOutB=16&#39;bx;
end
endcase
end
endmodule
