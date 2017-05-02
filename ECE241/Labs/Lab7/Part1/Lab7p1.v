`timescale 1ns / 1ns 
`include "ram32x4.v"
`include "EZ241.v"



module Lab7p1(
	input [9:0] SW,
	input [1:0] KEY,
	output [6:0] HEX0,
	output [6:0] HEX2,
	output [6:0] HEX4,
	output [6:0] HEX5);
	
	wire [3:0] out;
	
	ram32x4 ram0(
			.address(SW[8:4]),
			.clock(KEY[0]),
			.data(SW[3:0]),
			.wren(SW[9]),
			.q(out));
			
	bithex hex0(
			.num(out),
			.hex(HEX0));
			
	bithex hex2(
			.num(SW[3:0]),
			.hex(HEX2));
			
	bithex hex4(
			.num(SW[7:4]),
			.hex(HEX4));
			
	bithex hex5(
			.num({1'b0, 1'b0, 1'b0, SW[8]}),
			.hex(HEX5));
endmodule