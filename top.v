
module top(input clk,

           //i2c slave interface
           inout i2c_sda, input i2c_scl,

           output reg [4:0] led,
           input [7:0] pmod);

    SB_PLL40_CORE #(

/**
 * PLL configuration
 * user@xps:~/icestorm/icepll$ ./icepll -i 12 -o 120 -f pll.v -m
 *
 * F_PLLIN:    12.000 MHz (given)
 * F_PLLOUT:  120.000 MHz (requested)
 * F_PLLOUT:  120.000 MHz (achieved)
 *
 * FEEDBACK: SIMPLE
 * F_PFD:   12.000 MHz
 * F_VCO:  960.000 MHz
 *
 * DIVR:  0 (4'b0000)
 * DIVF: 79 (7'b1001111)
 * DIVQ:  3 (3'b011)
 *
 * FILTER_RANGE: 1 (3'b001)
 *
 */

.FEEDBACK_PATH("SIMPLE"),
.DIVR(4'b0000),		// DIVR =  0
.DIVF(7'b1001111),	// DIVF = 79
.DIVQ(3'b011),		// DIVQ =  3
.FILTER_RANGE(3'b001)	// FILTER_RANGE = 1

) uut(
.REFERENCECLK   (clk),
.PLLOUTGLOBAL   (clk_120mhz),
.BYPASS         (bypass),
.RESETB         (resetb)
);


    wire clk_120mhz;
    wire bypass;
    wire resetb;
    assign bypass = 0;
    assign resetb = 1;

    rot rot0(.clk(clk_120mhz), .D1(led[0]), .D2(led[1]), .D3(led[2]), .D4(led[3]), .D5(led[4]));

endmodule // top
