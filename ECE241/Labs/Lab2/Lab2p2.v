`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signals

//LEDR[0] output display

module mux(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    mux2to1 u0(
        .x(SW[0]),
        .y(SW[1]),
        .s(SW[9]),
        .m(LEDR[0])
        );
endmodule

module mux2to1(x, y, s, m);
    input x; //select 0
    input y; //select 1
    input s; //select signal
    output m; //output
  
    //assign m = s & y | ~s & x;
    // OR
    assign m = s ? y : x;

endmodule

module mux4to1(LEDR, SW);
	input [9:0] SW;
	
	output [9:0] LEDR;
	
	wire W0;
	wire W1;
	
	mux2to1 m0(
			.x(SW[0]),
			.y(SW[2]),
			.s(SW[4]),
			.m(W0)
			);
			
	mux2to1 m1(
			.x(SW[1]),
			.y(SW[3]),
			.s(SW[4]),
			.m(W1)
			);
			
	mux2to1 m2(
			.x(W0),
			.y(W1),
			.s(SW[5]),
			.m(LEDR[0])
			);
			
endmodule 