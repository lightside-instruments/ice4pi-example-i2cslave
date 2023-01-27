
module top(input clk,

           //i2c slave interface
           inout i2c_sda, input i2c_scl,

           output reg [4:0] led,
           input [7:0] pmod);

   reg rst = 1'b1;
   reg [7:0] pmod_i2c;
   wire [7:0] led_i2c;
   reg [27:0] startup_cnt = 28'd0;


   i2cSlaveTop i2c0(.clk(clk), .rst(rst), .sda(i2c_sda), .scl(i2c_scl),
                    //output regs 0-3
                    .myReg0(led_i2c),
                    //input regs 4-7
                    .myReg4({pmod, 2'b00}),
);

   always @ (posedge clk)
   begin
      if(startup_cnt < 28'd144000000)
        begin
            rst <= 1'b1;
            startup_cnt <= startup_cnt + 1;
         end
      else
        begin
            rst <= 1'b0;
            led <= led_i2c[5:0];
            pmod_i2c <= pmod[7:0];
        end
   end

endmodule // top
