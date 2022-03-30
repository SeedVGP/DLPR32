
`timescale 1ns/100ps
module Tanh(clk,rst,cs_tanh,rdy_t,z,a,b,th);
  input clk,rst,cs_tanh;
  input [15:0]th;
  output reg [15:0]z;
  output reg rdy_t;
  output reg [15:0]a;
  output reg [15:0]b;
  reg [15:0]state;
  always@(posedge clk)
   begin
      if(rst)
       begin        
      state=0;
      z=0;
       end


      else
        begin
          case(state)
        0:
           begin
            if(cs_tanh)
                state=1;
            else
                state=0;
          end

        1:state=2;
        2:state=3;
        3:state=4;
     
       4:
          begin
          if(rdy_t)
            state=0;
          else
            state=4;
          end
   
        endcase
end
end
always@(state)    
   begin
    case(state)
        0:begin
rdy_t=1;
end
        1:rdy_t=0;
        2:
           begin
         
           //For Comparator  
      if(th<=16'b0111111111111111 && th>=16'b0001000000000000)
        begin
          a=16'b0001000000000000;
        end
      else if(th<=16'b1111111111111111 && th>=16'b1001000000000000)
         begin
          a=16'b1001000000000000;
        end
      else
        begin
          a=th;
        end
end
       
      3:begin
        //For RALUT
        //For +ve numbers
      if(th>=16'b0001001001000000 && th<=16'b0001011110000000)
        begin
          b=16'b0000000110011100;
        end
      else if(th>=16'b0000111011000000 && th<=16'b0001001000000000)
        begin
          b=16'b0000001100001101;
        end
      else if(th<=16'b0000111010000000 && th>=16'b0000110000000000)
        begin
          b=16'b0000000111010110;
        end
      else if(th<=16'b0000101111000000 && th>=16'b0000100110000000)
        begin
          b=16'b0000000011111010;
        end
     
      //For -ve Numbers
      else if(th>=16'b1001001001000000 && th<=16'b1001011110000000)
        begin
          b=16'b0000000110011100;
        end
      else if(th>=16'b1000111011000000 && th<=16'b1001001000000000)
        begin
          b=16'b0000001100001101;
        end
      else if(th<=16'b1000111010000000 && th>=16'b1000110000000000)
        begin
          b=16'b0000000111010110;
        end
      else if(th<=16'b1000101111000000 && th>=16'b1000100110000000)
        begin
          b=16'b0000000011111010;
        end
      else
        begin
          b=16'b0000000000000000;
        end
     
end
     4:begin
       //For Subtractor
           z = a - b;
       rdy_t=1;
        end
   
    endcase
end
endmodule
