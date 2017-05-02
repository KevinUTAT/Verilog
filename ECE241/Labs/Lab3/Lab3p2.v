`timescale 1ns / 1ns 

module Lab3p2(SW, LEDR);
	input [8:0] SW;
	output [9:0]LEDR;
	
	RCAdder RCA0(
			.A(SW[3:0]),
			.B(SW[7:4]),
			.C(SW[8]),
			.S(LEDR[4:0]));
			
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



module fullAdder(a, b, ci, out, co);
	input a, b, ci;
	output out, co;
	wire W;
	
	assign W = a ^ b;
	assign 	out = (a ^ b) ^ ci;
	
	mux2to1 mux1(
			.x(b),
			.y(ci),
			.s(W),
			.m(co)
			);
			

endmodule 


module RCAdder(A, B, C, S);
	input [3:0] A;
	input C;
	input [3:0] B;
	output [4:0] S;
	
	wire w0, w1, w2;
	
	fullAdder FA0(
				.a(A[0]),
				.b(B[0]),
				.ci(C),
				.out(S[0]),
				.co(w0));
				
	fullAdder FA1(
				.a(A[1]),
				.b(B[1]),
				.ci(w0),
				.out(S[1]),
				.co(w1));
				
	fullAdder FA2(
				.a(A[2]),
				.b(B[2]),
				.ci(w1),
				.out(S[2]),
				.co(w2));
				
	fullAdder FA3(
				.a(A[3]),
				.b(B[3]),
				.ci(w2),
				.out(S[3]),
				.co(S[4]));
				
endmodule 
	
	