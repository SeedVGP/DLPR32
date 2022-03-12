// fetch module
`timescale 1ns/1ps 
module fetch(
  input       cs_fetch,clk,rst,
  output reg [31:0]   pc_32,
  output reg    rdy_fetch,cs_F_to_D
  ); 

reg [7:0] pc;
wire [7:0] pc_data;
reg cs_code_mem;
wire rdy_code_mem;

reg [31:0] state;
  
  
codemem codemem( cs_code_mem,clk,rst,pc,rdy_code_mem, pc_data);

always@(posedge clk)
     begin
if(rst)
  begin
    pc=8'b0;
    pc_32=32'b0;
    state=8'd0;
    rdy_fetch=1'b1;
    cs_F_to_D=1'b0;
  end
else
  begin
        case(state)
        0:begin
            if(cs_fetch)
                state=1;
            else
                state=0;
         end
        1:begin
            case(pc[1:0])
                0:state=2;
                1:state=3;
                2:state=4;
                3:state=5;
            endcase
        end
        2:state=(rdy_fetch)?0:2;
        3:state=(rdy_fetch)?0:3;
        4:state=(rdy_fetch)?0:4;
        5:state=(rdy_fetch)?0:5;
        endcase
    end
end
    
    always@(state)
    begin
        case(state)
            0:begin
                cs_code_mem=1;
                cs_F_to_D=0;
                rdy_fetch=1;
              end
            1:begin
                rdy_fetch=0;            
              end
            2:begin
                pc_32[31:24]=pc_data;
                pc=pc+1;rdy_fetch=1;
              end
            3:begin
                pc_32[23:16]=pc_data;
                pc=pc+1;rdy_fetch=1;
              end
            4:begin
                pc_32[15:8]=pc_data;
                pc=pc+1;rdy_fetch=1;
              end
            5:begin
                pc_32[7:0]=pc_data;
                pc=pc+1;rdy_fetch=1;
                cs_F_to_D=1;
    
              end 
        endcase
            
   end            
    endmodule   

