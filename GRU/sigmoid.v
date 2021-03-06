`timescale 1ns/100ps 
// Code your design here
module sigmoidfn(
  input clk,cs_s,rst,
  input [15:0] y,
  output reg [15:0] Out,
  output reg rdy_s 
);
  
  reg [1:0] state;
  reg [15:0] x,out,a,b,c;
  reg z=0;
  
always@(posedge clk)
    begin
      if(rst)
        state=0;
      else
        begin
          case(state)
            0:begin
              if(cs_s)
                    state=1;
                else 
                    state=0;
              end
            1:state=2;		//needs time to update
            2:state=3;
            3:begin
                if(rdy_s)
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
        0:rdy_s=1;
        1:rdy_s=0;
        2:begin
        	rdy_s=1;           
            a=16'd0;
            b=16'd0;
            c=16'd0;
            case(y[15])
              1:begin
                      z=1;
                      x={1'b0,y[14:0]};
              end
              0:begin
                      z=0;
                      x={y[15:0]}; 
              end
        	endcase

            if(x>=16'b0101000000000000)
             begin
                    out=16'b0001000000000000;
             end

            else if(x>=16'b0010011000000000 && x<16'b0101000000000000)
             begin
                    a=x>>5;
                    out=((a)+ (16'b0000110110000000));
             end

            else if(x>=16'b0001000000000000 && x<16'b0010011000000000)
             begin
                    b=x>>3;
                    out=(b) + 16'b0000101000000000;
             end

            else if(x>=16'b0 && x<16'b0010000000000000)
             begin
                    c=x>>2;
                    out=(c) + 16'b0000100000000000;
             end
            else
             begin
              		out=16'bx;
             end
          case(z)
            1:begin
                out=(~out)+1'b1;
                out=16'b0001000000000000+out;
                //Out=16'd1-out;
              end
            0:begin
                out=out;
              end
          endcase  
         end
         
      3:begin
          case(z)
            1:begin
                Out=out;
                //Out=16'd1-out;
              end
            0:begin
                Out=out;
              end
          endcase
        rdy_s=0;
      end
    endcase

end
endmodule
