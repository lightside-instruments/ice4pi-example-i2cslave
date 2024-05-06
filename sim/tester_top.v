`timescale 1ns/1ps

module tester_top       #(
           parameter MYPARAM    = 8

       )
(
    input clk,
    output sig1

);


wire clk_;
wire sig1_;

assign clk_ = clk;
assign sig1 = sig1_;


top top0(.clk(clk_), .sig1(sig1_));


endmodule
