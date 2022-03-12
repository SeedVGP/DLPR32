//code memory
`timescale 1ns/1ps 
module codemem(
  input   cs_code_mem,clk,rst,
  input [7:0] pc,
  output reg rdy_code_mem,
  output reg [7:0] pc_data
  );
reg [7:0] code_memo[0:(2**8-1)];
reg [7:0] state;

always@ (posedge clk)
begin
if(rst)
	begin
		state=0;
		rdy_code_mem=1'b1;
  code_memo[0]={8'b01000000};//msb-lsb
  code_memo[1]={8'b00010000};
  code_memo[2]={8'b00000000};
  code_memo[3]={8'b10110011};
  code_memo[4]={8'b01000000};//msb-lsb
  code_memo[5]={8'b00010000};
  code_memo[6]={8'b00000001};
  code_memo[7]={8'b00110011};
  code_memo[8]={8'd8};
	end
else
begin
case(state)
0:begin
state=(cs_code_mem)?1:0;
end
1:state=2;//read
2:state=3;
3:state=(rdy_code_mem)?2:3;
endcase
end
end

  
always@(state)
begin
case(state)
0:begin
rdy_code_mem=1;
pc_data=8'bZ;
end
1:rdy_code_mem=0;
//read
2:begin
pc_data=code_memo[pc];
rdy_code_mem=1;
end
endcase
end
endmodule
