/* Main RISC V Core file */ 


`timescale 1ns/1ps 
module riscv(
  input   rst,clk,
  output  [31:0] result
);
    reg  cs_fetch,cs_decoder,cs_execution;
    wire cs_F_to_D,cs_d_to_e;
    wire rdy_fetch,rdy_F_to_D,rdy_decoder,rdy_d_to_e,rdy_execution;
    wire [31:0] pc_32,pc_out;
    wire [3:0] dec_output,dec_val;
    wire [4:0] Rs1,Rs2,Rd,rs1,rs2,rd;
    wire [1:0] sel,sel_o;
      
     //call all the modules
	fetch fetch( cs_fetch,clk,rst,pc_32,rdy_fetch,cs_F_to_D);
	regofFetch regofFetch(clk,cs_F_to_D,rst, pc_32, pc_out,rdy_F_to_D );    
	decoder decoder(clk,rst,cs_decoder, pc_out, dec_output,rdy_decoder,cs_d_to_e,sel,rs1,rs2,rd);
	regofDecoder regofDecoder( rs1,rs2,rd,dec_output,sel,clk,rst,cs_d_to_e, dec_val,sel_o, Rs1,Rs2,Rd,rdy_d_to_e);
    	execution execution(sel_o,dec_val,Rs1,Rs2,Rd,rdy_d_to_e,cs_execution,clk,rst,rdy_execution,result);
    
  always@(posedge clk)
    begin
      if(rst)
  begin
      cs_fetch=0;cs_decoder=0;cs_execution=0;
  end 
      else
  begin
    cs_fetch=1;cs_decoder=1;cs_execution=1;   
      
    end
end
endmodule
