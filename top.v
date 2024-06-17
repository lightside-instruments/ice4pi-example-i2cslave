
module top(input clk,
           //i2c slave interface
           inout i2c_sda, input i2c_scl,
           output reg [4:0] led,
           input [7:0] pmod,
           output sig1, output sig2, output sig3, output sig4, input sig5, input sig6,
           output sig1_oe, output sig2_oe, output sig3_oe, output sig4_oe, output sig5_oe, output sig6_oe
);

   reg rst = 1'b1;
   reg [7:0] pmod_i2c;
   wire [7:0] led_i2c;
   reg [27:0] startup_cnt = 28'd0;
   reg [7:0] byte2;
   reg [7:0] byte1;
   reg [7:0] byte0;



   i2cSlaveTop i2c0(.clk(clk), .rst(rst), .sda(i2c_sda), .scl(i2c_scl),
                    //output regs 0-3
                    .myReg0(led_i2c),
                    .myReg1(byte0),
                    .myReg2(byte1),
                    .myReg3(byte2),
                    //input regs 4-7
                    .myReg4({pmod, 2'b00}),
);

   clock_divider clock_divider0(.clk(clk), .sig(sig1), .value({byte2[7:0],byte1[7:0],byte0[7:0]}));

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

   assign sig2 = 1;
   assign sig3 = 0;
   assign sig4 = sig6;


   assign sig1_oe = 1;
   assign sig2_oe = 1;
   assign sig3_oe = 1;
   assign sig4_oe = 1;
   assign sig5_oe = 0;
   assign sig6_oe = 0;

endmodule // top
