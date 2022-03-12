//registers to store the output of the fetch module
`timescale 1ns/1ps
module regofFetch(
  input       clk,cs_F_to_D,rst,
  input [31:0]    pc_32,
    output reg [31:0]   pc_out,
  output reg    rdy_F_to_D 
  );
  
  reg [31:0] state;
  
always@(posedge clk)
    begin
      if(rst)begin
        state=32'd0;
	rdy_F_to_D =1;
	pc_out=32'd0;
		end
      else
        begin
        case(state)
        0:begin
            state=(cs_F_to_D)?1:0;
          end
          1:state=2;//needs time to update
        2:begin
          state=(rdy_F_to_D)?0:2;
          end
        endcase
    end
end
always@(state)
begin
    case(state)
        0:rdy_F_to_D=1;
        1:begin
         rdy_F_to_D=0;
          end
      2:begin
        pc_out=pc_32;
        rdy_F_to_D=1;
      end
    endcase

end
endmodule


