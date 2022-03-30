`timescale 1ns/100ps 
module sigmoidfn_tb();
  reg clk,cs_s,rst;
  reg [15:0] y;
  wire [15:0]  Out;
  wire rdy_s;
  sigmoidfn a1(clk,cs_s,rst,y,Out,rdy_s);
  initial 
    begin
      clk=1'b0;
      forever #5 clk =~clk;
    end
  initial
    begin
      //$dumpfile("dump.vcd"); $dumpvars;
      #5 rst=1;
      #25 rst=0;
      cs_s=1;
      //rdy_s=0;
      //#5 y=16'b0_101_000000000000;		//5.000000	 :0_001_000000000000
      //#5 y=16'b1_010_110001000000;		//-2.765625  :0_000_000100011110
      //#5 y=16'b0_110_000000000000;
      #5 y=16'b1_011_100100000000;		//-3.5625	 :0_000_000010111000
      //rst=1;
      //rst=0;
      //#5 y=16'b1_000_001001000000;		//-0.140625	 :0_000_011101110000
      #100 $finish;
      
    end
endmodule
