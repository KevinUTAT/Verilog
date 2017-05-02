`timescale 1ns / 1ns 

module Lab3p3(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [7:0] SW;
	input [2:0] KEY;
	
	output [9:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	
	wire [7:0] Wout;
	
	ALU alu0(
			.A(SW[7:4]),
			.B(SW[3:0]),
			.func(KEY[2:0]),
			.out(Wout[7:0]));
			
	displayHex hex(
			.A(SW[7:4]),
			.B(SW[3:0]),
			.out(Wout[7:0]),
			.H0(HEX0[6:0]),
			.H1(HEX1[6:0]),
			.H2(HEX2[6:0]),
			.H3(HEX3[6:0]),
			.H4(HEX4[6:0]),
			.H5(HEX5[6:0]));
			
	assign LEDR = Wout;
	
endmodule
	

module displayHex(A, B, out, H0, H1, H2, H3, H4, H5);
	input [7:0] out;
	input [3:0] A;
	input [3:0] B;
	output [6:0] H0;
	output [6:0] H1;
	output [6:0] H2;
	output [6:0] H3;
	output [6:0] H4;
	output [6:0] H5;
	
	hexDecoder dec0(
					.C(B[3:0]),
					.H(H0[6:0]));
					
	hexDecoder dec2(
					.C(A[3:0]),
					.H(H2[6:0]));
					
	hexDecoder dec4(
					.C(out[3:0]),
					.H(H4[6:0]));
					
	hexDecoder dec5(
					.C(out[7:4]),
					.H(H5[6:0]));
					
	assign H1 = 7'b0000000;
	assign H3 = 7'b0000000;
	
endmodule 
		
	
module ALU(A, B, func, out);
	input [3:0] A;
	input [3:0] B;
	input [2:0] func;
	output [7:0] out;
	
	wire [7:0] ans0;
	RCAddera rca0(
						.A(A[3:0]),
						.B(B[3:0]),
						.S(ans0[4:0]));
						
	wire [7:0] ans1;
	Vadder4b vad0(
						.A(A[3:0]),
						.B(B[3:0]),
						.O(ans1[4:0]));
						
	wire [7:0] ans2;
	orXor ox0(
						.A(A[3:0]),
						.B(B[3:0]),
						.O(ans2[7:0]));
						
	wire [7:0] ans5;
	invert iv0(
						.A(A[3:0]),
						.B(B[3:0]),
						.O(ans5[7:0]));
	
	reg [7:0] ans;
	
	always @(*)
	begin
		case (func)
			3'b000: ans = ans0;
			3'b001: ans = ans1;
			3'b010: ans = ans2;
			3'b011: if (A || B)
							ans = 8'b10000001;
					  else
							ans = 8'b00000000;
			3'b100: if (&A && &B)
							ans = 8'b01111110;
					  else
							ans = 8'b00000000;
			3'b101: ans = ans5;
			default ans = 8'b00000000;
		endcase
	end
endmodule 


module Vadder4b(A, B, O);
    input [3:0] A;
	 input [3:0] B;
	 output [4:0] O;
	 
	 assign O = A + B;
endmodule
	 
	 
module orXor(A, B, O);
	 input [3:0] A;
	 input [3:0] B;
	 output [7:0] O;
	 
	 assign O[3:0] = A | B;
	 assign O[7:4] = A ^ B;
endmodule 


module invert(A, B, O);
    input [3:0] A;
	 input [3:0] B;
	 output [7:0] O;
	 
	 wire [3:0] Aout;
	 
	 assign Aout[0] = ~A[0];
	 assign Aout[1] = ~A[1];
	 assign Aout[2] = ~A[2];
	 assign Aout[3] = ~A[3];
	 
	 assign O[7:4] = Aout;
	 assign O[3:0] = B;
endmodule 

	
module mux2to1a(x, y, s, m);
    input x; //select 0
    input y; //select 1
    input s; //select signal
    output m; //output
  
    //assign m = s & y | ~s & x;
    // OR
    assign m = s ? y : x;

endmodule



module fullAddera(a, b, ci, out, co);
	input a, b, ci;
	output out, co;
	wire W;
	
	assign 	W = (a ^ b) ^ ci;
	
	mux2to1a mux1(
			.x(b),
			.y(ci),
			.s(W),
			.m(co)
			);
			
	assign out = W;
endmodule 


module RCAddera(A, B, S);
	input [3:0] A;
	input [3:0] B;
	output [4:0] S;
	
	wire w0, w1, w2;
	
	fullAddera FA0(
				.a(A[0]),
				.b(B[0]),
				.ci(1'b0),
				.out(S[0]),
				.co(w0));
				
	fullAddera FA1(
				.a(A[1]),
				.b(B[1]),
				.ci(w0),
				.out(S[1]),
				.co(w1));
				
	fullAddera FA2(
				.a(A[2]),
				.b(B[2]),
				.ci(w1),
				.out(S[2]),
				.co(w2));
				
	fullAddera FA3(
				.a(A[3]),
				.b(B[3]),
				.ci(w2),
				.out(S[3]),
				.co(S[4]));
				
endmodule 
	

module hexDecoder(C, H);
	input [3:0] C;
	output [6:0] H;
	
	//assigning value to each light
	assign H[0] = (C[3] | C[2] | C[1] | ~C[0]) & (C[3] | ~C[2] | C[1] | C[0]) &
		(~C[3] | C[2] | ~C[1] | ~C[0]) & (~C[3] | ~C[2] | ~C[1] | C[0]);
		
	assign H[1] = (C[3] | ~C[2] | C[1] | ~C[0]) & (C[3] | ~C[2] | ~C[1] | C[0]) & 
		(~C[3] | C[2] | ~C[1] | ~C[0]) & (~C[3] | ~C[2] | C[1] | C[0]) & 
		(~C[3] | ~C[2] | ~C[1] | C[0]) & (~C[3] | ~C[2] | ~C[1] | ~C[0]);
		
	assign H[2] = (C[3] | C[2] | ~C[1] | C[0]) & (~C[3] | ~C[2] | C[1] | C[0]) & 
		(~C[3] | ~C[2] | ~C[1] | C[0]) & (~C[3] | ~C[2] | ~C[1] | ~C[0]);
		
	assign H[3] = (C[3] | C[2] | C[1] | ~C[0]) & (C[3] | ~C[2] | C[1] | C[0]) & 
		(C[3] | ~C[2] | ~C[1] | ~C[0]) & (~C[3] | C[2] | C[1] | ~C[0]) & 
		(~C[3] | C[2] | ~C[1] | C[0]) & (~C[3] | ~C[2] | ~C[1] | ~C[0]);
		
	assign H[4] = (C[3] | C[2] | C[1] | ~C[0]) & (C[3] | C[2] | ~C[1] | ~C[0]) & 
		(C[3] | ~C[2] | C[1] | C[0]) & (C[3] | ~C[2] | C[1] | ~C[0]) & 
		(C[3] | ~C[2] | ~C[1] | ~C[0]) & (~C[3] | C[2] | C[1] | ~C[0]);
		
	assign H[5] = (C[3] | C[2] | C[1] | ~C[0]) & (C[3] | C[2] | ~C[1] | C[0]) & 
		(C[3] | C[2] | ~C[1] | ~C[0]) & (C[3] | ~C[2] | ~C[1] | ~C[0]) & 
		(~C[3] | ~C[2] | C[1] | ~C[0]);
		
	assign H[6] = (C[3] | C[2] | C[1] | C[0]) & (C[3] | C[2] | C[1] | ~C[0]) & 
		(C[3] | ~C[2] | ~C[1] | ~C[0]) & (~C[3] | ~C[2] | C[1] | C[0]);
		
endmodule


module mux7to1a(inp, select, outp);
	input [6:0] inp; //input 
	input [2:0] select; //select signal
	
	reg out; //output for the always
	output outp;
	
	always @(*)
	begin
		case (select[2:0]) //switch by select signal input
			3'b000: out = inp[0];
			3'b001: out = inp[1];
			3'b010: out = inp[2];
			3'b011: out = inp[3];
			3'b100: out = inp[4];
			3'b101: out = inp[5];
			3'b110: out = inp[6];
			3'b111: out = inp[0];  //default out put to input[1]
			default: out = inp[0];
		endcase
	end
	
	assign outp = out;
	
endmodule
