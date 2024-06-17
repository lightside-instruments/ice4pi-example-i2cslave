module clock_divider(input clk, output sig, input [23:0] value);
   
   reg x = 0;
   reg [23:0]     divider = 0;

   always @(posedge clk) begin
     begin
       if (divider == value)
         begin
           divider <= 0;
           x <= ~x;
         end
       else 
         divider <= divider + 1;
       end
   end

   assign sig = x;
endmodule // top
