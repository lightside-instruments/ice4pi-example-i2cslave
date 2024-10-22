module top(input clk,
           output [4:0] led,
           input [7:0] pmod,
           output [15:0] gpib,
           output reg ctrl_led);
 

   reg [4:0] counter = 5'd0;
   reg [15:0] gpib_reg = 16'd0; 

   always @ (negedge clk)
   begin
      if(counter < 5'd11) begin
            counter <= counter + 1;
      end
      else begin
        counter <= 0;
        gpib_reg <= gpib_reg + 1;
        gpib <= gpib_reg;
        led <= gpib_reg[15:11];
     end 
   end

endmodule // top

