//register to store decoder outputs
`timescale 1ns/1ps 
module decoder(
  input       clk,rst,cs_decoder,
  input [31:0]    pc_out,
    output reg [3:0]  dec_output,
    output reg    rdy_decoder,
    output reg    cs_d_to_e,
    output reg [1:0]  sel,
    output reg [4:0]  rs1,rs2,rd
  );

reg[31:0] PC;
reg [15:0] state;
  
always@(posedge clk)
begin
  if(rst)
    begin
      state=16'd0;
      PC=32'd0;
      dec_output=4'd0;
      rdy_decoder=1;
      sel=2'bz;
      rs1=5'b0;rs2=5'b0;rd=5'b0;
    end
  else
    begin
    case(state)
        0:begin
            if(cs_decoder)
                state=1;
            else
                state=0;
        end
        1:begin
    		PC=pc_out;
             if(PC[6:0]==7'b0110011)
                state=15;
        
        end
      15:state=2;
        2:begin
             case(PC[14:12])
                0:state=3;
                1:state=4;
                2:state=5;
                3:state=6;
                4:state=7;
                5:state=8;
                6:state=13;
                7:state=14; 
            endcase
        end
        3:begin
            if(PC[31:25]==7'b0000000)
                state=9;
            else if(PC[31:25]==7'b0100000)
                    state=10;
        end
        4:begin
    state=(rdy_decoder)?0:4;
        end
        5:begin
    state=(rdy_decoder)?0:5;
        end
        6:begin
    state=(rdy_decoder)?0:6;
        end
        7:begin
    state=(rdy_decoder)?0:7;
        end
        8:begin
           if(pc_out[31:25]==7'b0000000)
                state=11;
            else if(pc_out[31:25]==7'b0100000)
                    state=12;
        end
        9:begin
    state=(rdy_decoder)?0:9;
        end
        10:begin
    state=(rdy_decoder)?0:10;
        end
        11:begin
    state=(rdy_decoder)?0:11;
        end
        12:begin
    state=(rdy_decoder)?0:12;
        end
        13:begin
    state=(rdy_decoder)?0:13;
        end
        14:begin
    state=(rdy_decoder)?0:14;
        end
        
    endcase
    end
end


always@(state)
begin
    case(state)
    0:begin
    rdy_decoder=1;
       cs_d_to_e=0;
    end
    1:begin
      
    rdy_decoder=0;
    end
        9:begin dec_output=4'b0000; rdy_decoder=1; cs_d_to_e=1; sel=0;end //add 0
    10:begin dec_output=4'b0001; rdy_decoder=1; cs_d_to_e=1;  sel=0; end//sub 1
    4:begin dec_output=4'b0010; rdy_decoder=1; cs_d_to_e=1;sel=2;end//sll 2
    5:begin dec_output=4'b0011; rdy_decoder=1; cs_d_to_e=1;sel=2;end//slt 3
    6:begin dec_output=4'b0100; rdy_decoder=1; cs_d_to_e=1; sel=2; end//sltu  4
    7:begin dec_output=4'b0101; rdy_decoder=1; cs_d_to_e=1;sel=1; end//xor  5
    11:begin dec_output=4'b0110; rdy_decoder=1;  cs_d_to_e=1;sel=2;end//srl 6
    12:begin dec_output=4'b0111; rdy_decoder=1; cs_d_to_e=1;sel=2;end//sra  7
    13:begin dec_output=4'b1000; rdy_decoder=1;  cs_d_to_e=1;sel=1;end//or  8
    14:begin dec_output=4'b1001; rdy_decoder=1; cs_d_to_e=1;sel=1;end//and  9
      15:begin rs2=PC[24:20]; rs1=PC[19:15]; rd=PC[11:7]; end
    endcase
end
endmodule


