`timescale 1ns/1ns
`include "Lab2p2.v"

module Lab2(SW, LEDR);

input [9:0] SW;
output [9:0] LEDR;

mux(LEDR, SW);

endmodule
