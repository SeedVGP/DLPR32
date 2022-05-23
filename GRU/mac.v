`timescale 1ns/1ps 

module mul2(en,a,b,q);
input en;
input [1:0] a,b;
output reg [3:0] q;
always@(*)
begin
if(en)
begin
 q[0]=a[0]&b[0];
 q[1]=(a[1]&b[0])^(a[0]&b[1]);
q[2]=((a[1]&b[0])&(a[0]&b[1]))^(a[1]&b[1]);
q[3]=(a[1]&b[1])&((a[1]&b[0])&(a[0]&b[1]));
end
else;
end
endmodule



//4 bit multiplier

module mul4(en,a,b,q);
input en;
input [3:0] a,b;
output reg [7:0] q;
wire [3:0] q0,q1,q2,q3;
reg cs1,cs2,cs3,cs4;
mul2 m1(cs1,a[1:0],b[1:0],q0[3:0]);
mul2 m2(cs2,a[3:2],b[1:0],q1[3:0]);
mul2 m3(cs3,a[1:0],b[3:2],q2[3:0]);
mul2 m4(cs4,a[3:2],b[3:2],q3[3:0]);
always@(*)
begin
if(en)
begin
cs1=1'b1;
cs2=1'b1;
 cs3=1'b1;
cs4=1'b1;
 q[1:0]=q0[1:0];
 q[7:2]=({2'b00,q0[3:2]}+q1[3:0])+({2'b00,q2[3:0]}+{q3[3:0],2'b00});
end
else;
end
endmodule



//8 bit multiplier

module mul8(en,a,b,q);
input en;
input [7:0] a,b;
output reg [15:0] q;
wire [7:0] q0,q1,q2,q3;
reg cs1,cs2,cs3,cs4;
mul4 m5(cs1,a[3:0],b[3:0],q0[7:0]);
mul4 m6(cs2,a[7:4],b[3:0],q1[7:0]);
mul4 m7(cs3,a[3:0],b[7:4],q2[7:0]);
mul4 m8(cs4,a[7:4],b[7:4],q3[7:0]);
always@(*)
begin
if(en)
begin
cs1=1'b1;
cs2=1'b1;
 cs3=1'b1;
 cs4=1'b1;
 q[3:0]=q0[3:0];
q[15:4]=({4'b0000,q0[7:4]}+q1[7:0])+({4'b0000,q2[7:0]}+{q3[7:0],4'b0000});
end
else;
end
endmodule



//16 bit multplier

module mul16(en,a,b,q);
input en;
input [15:0] a,b;
output reg [31:0] q;
wire [15:0] q0,q1,q2,q3;
reg cs1,cs2,cs3,cs4;
mul8 m9(cs1,a[7:0],b[7:0],q0[15:0]);
mul8 m10(cs2,a[15:8],b[7:0],q1[15:0]);
mul8 m11(cs3,a[7:0],b[15:8],q2[15:0]);
mul8 m12(cs4,a[15:8],b[15:8],q3[15:0]);
always@(*)
begin
if(en)
begin
cs1=1'b1;
cs2=1'b1;
cs3=1'b1;
 cs4=1'b1;
 q[7:0]=q0[7:0];
 q[31:8]=({8'b00000000,q0[15:8]}+q1[15:0])+({8'b00000000,q2[15:0]}+{q3[15:0],8'b00000000});
end
else;
end
endmodule

//main multiplier

module multi(en,x,y,product);
input en;
input [15:0] x,y;
output reg [15:0] product;
wire [31:0] q;
reg [14:0] p0,p1;
reg sign;  
reg [27:0] result;
reg cs;
  mul16 m13(cs,p0,p1,q[31:0]);
always@(*)
begin
if(en)
begin
  p0=x[14:0];
  p1=y[14:0];
cs=1'b1;
result[27:0] = q[31:0];
 sign = x[15] ^ y[15];
 product[14:12]= result[26:24];
 product[11:0] = result[23:12];
 product[15] =sign;
end
else;
end
endmodule

module addq(
input en, 
input [15:0]x,y,
output reg [15:0] sum

);
reg [15:0] op1,op2;
reg cout;

always@(*)
begin

if(en)
begin
  
    sum=16'b0;
cout=0;
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
else;
end
endmodule

module mac2(a,b,clk,out,cs_mac,rdy,sync);
input[15:0]a,b;
input clk;
output reg rdy;
output reg sync;
input cs_mac;
output reg [15:0]out;
wire [15:0] fprod, fadd;
reg [15:0] data_a, data_b,fprod1;
reg cs_mult,cs_add,done;
reg [1:0] size;
reg [1:0] i;
reg [2:0] state;

initial state = 0;
initial i = 0;
initial sync=0;

multi mul(cs_mult,data_a,data_b,fprod);
addq add(cs_add,fprod1,out,fadd);

always@(posedge clk)
begin
case(state)
0:begin
	if(cs_mac)
	state=1;
	else
	state=0;
  end
1:state=2;
2:state=3;
3:state=4;
4:state=5;
5:state=6;
6:begin
	if(i==size)
	state=7;
	else
	state=2;
end
7:begin
if(rdy)
state=0;
else
state=7;
end

endcase
end

always@(state)
begin
case(state)
0:rdy=1;
1:begin
	rdy = 1'b0;
 	data_a = 16'b0;
        data_b = 16'b0;
        fprod1 = 16'b0;
        out = 16'b0;
	size = 2'b11;
  end
2:begin
	sync =1'b1;
	data_a = a;
        data_b  = b;	
end
3:begin
  cs_mult = 1'b1;
  sync = 1'b0;
  end
4:fprod1 = fprod;


5:cs_add = 1'b1;
6:  begin     
	out = fadd;
	cs_add=1'b0;
	i = i+1;
	//syn=1'b1;
  end

7:begin
	done = 1'b1;
	rdy = 1'b1;
	sync=1'b0;
  end
  default:begin 
	state = 0;
        end
endcase
end
endmodule
