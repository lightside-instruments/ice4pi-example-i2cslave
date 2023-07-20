
module top(input clk,

           //i2c slave interface
           inout i2c_sda, input i2c_scl,

           output reg [4:0] led,
           input [7:0] pmod,
           output reg tx,
           output reg ce0,
           output reg ce1);

/**
 * PLL configuration
 *
 * This Verilog module was generated automatically
 * using the icepll tool from the IceStorm project.
 * Use at your own risk.
 *
 * Given input frequency:        12.000 MHz
 * Requested output frequency:   60.000 MHz
 * Achieved output frequency:    60.000 MHz
 */

SB_PLL40_CORE #(
		.FEEDBACK_PATH("SIMPLE"),
		.DIVR(4'b0000),		// DIVR =  0
		.DIVF(7'b1001111),	// DIVF = 79
		.DIVQ(3'b100),		// DIVQ =  4
		.FILTER_RANGE(3'b001)	// FILTER_RANGE = 1
	) uut (
		.LOCK(locked),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.REFERENCECLK(clk),
		.PLLOUTCORE(clk_60mhz)
		);


    wire clk_60mhz;
    wire bypass;
    wire resetb;
    assign bypass = 0;
    assign resetb = 1;

    rot rot0(.clk(clk_60mhz), .D1(led[0]), .D2(led[1]), .D3(led[2]), .D4(led[3]), .D5(led[4]));

    reg ready = 0;
    reg [20:0]     index;
    reg [1:0]     divider;

    localparam link_test_pulse = 56'hFFFFFFFFFFFFFF;
    //16 bits is the roughly estimated (through oscilloscope measurement) latency of the driver circuit so the 24 zero bits prefix
    localparam frame = 1212'hFFFFFFFFFFFFF66666666666666666666666666666665555555555555555555555555A69555666AAA5A9595559A56A9AA96AAAAAA6AAAA9AAAAAA96AAA6AAAAAA6AAAA69555666AAA5A9595559A5699AAAAAAAAAA5AAAAAAAAAAAAAAAAAAAAAAAAAAA99AAAAAAAAAA9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6A96A69AA6966AAFF;

    always @(posedge clk_60mhz) begin
           if(ready) begin
               if (index < 1212)
                 begin
                   ce0 <= 1;
                   tx <= frame[1212-1-index];
                 end
               else if(index>=100000 &&  index<100000+56) begin
                   ce0 <= 1;
                   tx <= link_test_pulse[56-1-(index-100000)];
               end
               else
                 begin
                   ce0 <= 0;
                   tx <= 0;
                 end
               if(divider == 2) begin
                   if (index == 200000) begin
                       index <= 0;
                   end
                   else begin
                       index <= index + 1;
                   end
                   divider <= 0;
               end
               else begin
                   divider <= divider + 1;
               end
             end
           else
             begin
               ce0 <= 0;
               ce1 <= 0;
               ready <= 1;
               divider <= 0;
               index <= 0;
             end
    end


endmodule // top
