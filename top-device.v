module top(input clk,
           output [4:0] led,
           input [7:0] pmod,
           inout [15:0] gpib,
           output reg ctrl_led);

   wire [15:0] gpib_out; 
   wire [15:0] gpib_out_enable; 
   wire [15:0] gpib_in; 


genvar i;
generate
    for (i=0; i<16; i=i+1) begin : gpib_sb_ios

SB_IO #(
    .PIN_TYPE(6'b 1010_01),
    .PULLUP(1'b 0)
) led_io (
    .PACKAGE_PIN(gpib[i]),
    .OUTPUT_ENABLE(gpib_out_enable[i]),
    .D_OUT_0(gpib_out[i]),
    .D_IN_0(gpib_in[i])
);
end 
endgenerate


   reg [23:0] counter = 23'd0;
   reg [15:0] gpib_out_reg = 16'd0; 
   reg [15:0] gpib_out_enable_reg = 16'd0; 


   //toggle SRQ every second
   always @ (negedge clk)
   begin
      if(counter < 12000000) begin
            counter <= counter + 1;
      end
      else begin
        counter <= 0;
        gpib_out_reg[15] <= ~gpib_out_reg[15]; //SRQ
        gpib_out_enable_reg[15] <= 1;
     end 
   end

   parameter SIZE = 3;
   parameter IDLE  = 3'b001;
   parameter ACK = 3'b010;
   reg   [SIZE-1:0] state;// Seq part of the FSM

   always @ (negedge clk)
   begin
     case(state)
       IDLE : begin
         gpib_out_reg[10] <=0; //NDAC
         gpib_out_reg[11] <=1; //NRFD
         gpib_out_enable_reg[10] <=1; //NDAC
         gpib_out_enable_reg[11] <=1; //NRFD
         if(gpib_in_reg[12] == 0) begin //DAV
           gpib_out_reg[10] <=1; //NDAC
           gpib_out_reg[11] <=0; //NRFD
           state <= ACK;
         end
       end

       ACK :
        if(gpib_in_reg[12] == 0) begin //DAV
          gpib_out_reg[10] <=0; //NDAC
          gpib_out_reg[11] <=1; //NRFD
          gpib_out_enable_reg[10] <=1; //NDAC
          gpib_out_enable_reg[11] <=1; //NRFD
          state <= IDLE;
        end
     endcase
   end


   assign gpib_out = gpib_out_reg;
   assign gpib_out_enable = gpib_out_enable_reg;
   assign led=gpib_in[4:0];
endmodule // top

