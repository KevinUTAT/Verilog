`timescale 1ns / 1ns 



module Lab5p1(SW, KEY, HEX0, HEX1);
	input [2:0] SW;
	input [1:0] KEY;
	output [6:0] HEX0;
	output [6:0] HEX1;
	
	wire [7:0] out;
	
	counter4b counter0(SW[1], KEY[0], SW[0], out);
	
	bithex bh0(out[3], out[2], out[1], out[0], HEX0[0], HEX0[1], 
		HEX0[2], HEX0[3], HEX0[4], HEX0[5], HEX0[6]);
	
	bithex bh1(out[7], out[6], out[5], out[4], HEX1[0], HEX1[1], 
		HEX1[2], HEX1[3], HEX1[4], HEX1[5], HEX1[6]);
	
endmodule


module counter4b(enable, clock, clear_b, Q);
	input enable;
	input clock;
	input clear_b;
	output [7:0] Q;
	
	TFlipflop TFF0(enable, Q[0], clock, clear_b);
	
	wire T1;
	assign T1 = enable & Q[0];
	TFlipflop TFF1(T1, Q[1], clock, clear_b);
	
	wire T2;
	assign T2 = T1 & Q[1];
	TFlipflop TFF2(T2, Q[2], clock, clear_b);
	
	wire T3;
	assign T3 = T2 & Q[2];
	TFlipflop TFF3(T3, Q[3], clock, clear_b);
	
	wire T4;
	assign T4 = T3 & Q[3];
	TFlipflop TFF4(T4, Q[4], clock, clear_b);
	
	wire T5;
	assign T5 = T4 & Q[4];
	TFlipflop TFF5(T5, Q[5], clock, clear_b);
	
	wire T6;
	assign T6 = T5 & Q[5];
	TFlipflop TFF6(T6, Q[6], clock, clear_b);
	
	wire T7;
	assign T7 = T6 & Q[6];
	TFlipflop TFF7(T7, Q[7], clock, clear_b);
endmodule
	

module TFlipflop(T, Q, clock, clear);
	input T;
	output Q;
	input clock;
	input clear;
	
	wire D;
	
	DFlipflop DFF0(D, clock, clear, Q);
	
	assign D = (T) ? ~Q : Q;
	
		
endmodule	

	
module DFlipflop(D, clock, reset, Q);
	input D;
	input clock;
	input reset;
	output Q;
	
	reg q;
	
	always@(posedge clock or negedge reset)
	begin
		if (~reset)
			q <= 0;
		else q <= D;
	end
	
	assign Q = q;
endmodule


module bithex(c3,c2,c1,c0,h0,h1,h2,h3,h4,h5,h6); 
	input c0;
	input c1;
	input c2;
	input c3;
	output h0,h1,h2,h3,h4,h5,h6;
	
	assign h0 = (~c3 & ~c2 & ~c1 & c0) | (~c3 & c2 & ~c1 & ~c0) | (c3 & ~c2 & c1 & c0) | (c3 & c2 & ~c1 & c0);
	assign h1 = (~c3 & c2 & ~c1 & c0) | (~c3 & c2 & c1 & ~c0) | (c3 & ~c2 & c1 & c0) | (c3 & c2 & ~c1 & ~c0 ) | (c3 & c2 & c1 & ~c0) | (c3 & c2 & c1 & c0);
	assign h2 = (~c3 & ~c2 & c1 & ~c0) | (c3 & c2 & ~c1 & ~c0) | ( c3 & c2 & c1 & ~c0) | (c3 & c2 & c1 & c0);
	assign h3 = (~c3 & ~c2 & ~c1 & c0) | ( ~c3 & c2 & ~c1 & ~c0) | ( ~c3 & c2 & c1 & c0) | (c3 & ~c2 & ~c1 & c0) | (c3 & ~c2 & c1 & ~c0) | (c3 & c2 & c1 & c0);
	assign h4 = (~c3 & ~c2 & ~c1 & c0) | ( ~c3 & ~c2 & c1 & c0) | (~c3 & c2 & ~c1 & ~c0) | ( ~c3 & c2 & ~c1 & c0) | ( ~c3 & c2 & c1 & c0) | (c3 & ~c2 & ~c1 & c0);
	assign h5 = (~c3 & ~c2 & ~c1 & c0) | (~c3 & ~c2 & c1 & ~c0) | ( ~c3 & ~c2 & c1 & c0) | (~c3 & c2 & c1 & c0) | (c3 & c2 & ~c1 & c0);
	assign h6 = (~c3 & ~c2 & ~c1 & ~c0) | (~c3 & ~c2 & ~c1 & c0) | (~c3 & c2 & c1 & c0) | (c3 & c2 & ~c1 & ~c0);
endmodule
