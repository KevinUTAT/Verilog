`timescale 1ns / 1ns 

module Lab4p3(SW, KEY, LEDR);
	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;
	
	LRrotatReg8b LR8b(SW[7:0],   KEY[1],  KEY[2],      KEY[3], KEY[0], SW[9], LEDR[7:0]);
	//                 data   paralleLoadn rotatRight  ASR     clock   reset      Q
	
endmodule


//positive edge trigered active-high reset D-flipflop
module flipfloph(D, clock, reset, Q);
	input D;
	input clock;
	input reset;
	output Q;
	
	reg Q;
	
	always@(posedge clock)
	begin
		if (reset == 1'b1)
			Q = 0;
		else 
			Q = D;
	end
endmodule


//1 bit left/right rotatibg register
module LRrotatReg(D, left, right, loadL, loadn, clock, reset, Q);
	input D;
	input left;
	input right;
	input loadL;
	input loadn;
	input clock;
	input reset;
	output Q;
	wire w0;
	wire shift;
	
	assign w0 = (loadn) ? shift : D;
	assign shift = (loadL) ? left :right;
	
	flipfloph FF0(w0, clock, reset, Q);
            //   D  clock  reset  Q
endmodule


module LRrotatReg8b(data, paralleLoadn, rotatRight, ASR, clock, reset, Q);
	input [7:0] data;
	input paralleLoadn;
	input rotatRight;
	input clock;
	input reset;
	input ASR;
	output [7:0] Q;
	
	wire w0;
	wire w7;
	
	assign w0 = (ASR) ? Q[7] : Q[0];
	assign w7 = (ASR) ? Q[0] : Q[7];

	
	//                 D   left right     loadL        loadn      clock  reset   Q
	LRrotatReg LR0(data[0], Q[1], w7, rotatRight, paralleLoadn, clock, reset, Q[0]);
	
	LRrotatReg LR1(data[1], Q[2], Q[0], rotatRight, paralleLoadn, clock, reset, Q[1]);
	
	LRrotatReg LR2(data[2], Q[3], Q[1], rotatRight, paralleLoadn, clock, reset, Q[2]);
	
	LRrotatReg LR3(data[3], Q[4], Q[2], rotatRight, paralleLoadn, clock, reset, Q[3]);
	
	LRrotatReg LR4(data[4], Q[5], Q[3], rotatRight, paralleLoadn, clock, reset, Q[4]);
	
	LRrotatReg LR5(data[5], Q[6], Q[4], rotatRight, paralleLoadn, clock, reset, Q[5]);
	
	LRrotatReg LR6(data[6], Q[7], Q[5], rotatRight, paralleLoadn, clock, reset, Q[6]);
	
	LRrotatReg LR7(data[7], w0, Q[6], rotatRight, paralleLoadn, clock, reset, Q[7]);
endmodule

