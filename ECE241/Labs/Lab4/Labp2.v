`timescale 1ns / 1ns 

module Labp2(SW,KEY,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5); //Top level, only use to 
	input [9:0] SW;                                       //assign pin
	input [3:0] KEY;

	output [7:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	
	aluNew alu0(SW, KEY[3:1], LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY[0], SW[9]);
	         // in     s       out   H0    H1    H2    H3    H4    H5   clock   resetn
endmodule 


module aluNew(in,s,out,H0,H1,H2,H3,H4,H5, clock, resetn);
	
	input [3:0] in;
	input [2:0] s;
	input clock;
	input resetn;
	output [7:0] out;
	wire [3:0] A;
	wire [3:0] B;
	wire [2:0] select;
	assign A = in[3:0];
	assign B = Blatched[3:0];
	assign select = s[2:0];
	output [6:0]H1;
	output [6:0]H2;
	output [6:0]H3;
	output [6:0]H4;
	output [6:0]H5;
	output [6:0]H0;
	assign H1[6:0] = 7'b1000000;
	assign H3[6:0] = 7'b1000000;
	
	wire[7:0]ripple;
	ripcurry u0(B[0],B[1],B[2],B[3],A[0],A[1],A[2],A[3],ripple[0],ripple[1],ripple[2],ripple[3],ripple[4]);
	assign ripple[7:5] = 3'b000;
	//shows output on LED 
   reg [7:0] Blatched;
	output Blatched;
	
//	register8b r8g0(aluOut, clock, resetn, Blatched);
//		         //     D    clock  resetn     Q

	always@(posedge clock)
	begin
		if (resetn == 1'b0)
			Blatched <= 0;
		else
			Blatched <= aluOut;
	end
					
	reg [7:0] aluOut;
//	reg [7:0] regin;
		
	always@(*)
	begin
		case(select[2:0])
		3'b000:  aluOut <= ripple;//case 0: A + B using the adder from Part II of this Lab
		
		3'b001:  begin aluOut[7:5] = 3'b000;
					aluOut[4:0] = A + B; 
					end // case 1: A + B using the Verilog +
					
		3'b010: aluOut = {(A[3:0] ^ B[3:0]), (A[3:0] | B[3:0])}; // case 2: A OR B in the lower four bits and A XOR B in the upper four bits
		
		3'b011: begin// case 3: Output 8'b10000001) if at least 1 of the 8 bits in the two inputs is 1 using a single OR operation// make another case if it's 1
		if (|{A,B} == 1)
		begin 
		aluOut = 8'b10000001; 	
		end
		else 
		begin aluOut=8'b00000000; 
		end
		end
		
		3'b100: begin   // case 4: Output 8'b01111110) if all of the 8 bits in the two inputs are 1 using a single AND operation
		if (&{A,B} == 1) 
		begin 
		aluOut = 8'b01111110; 	
		end
		else 
		begin aluOut=8'b00000000;
		end
		end
		
		3'b101: aluOut = {(4'b0000), (B << A)}; //shift B left by A bits
		
		3'b110: aluOut = A * B; //Verilog '*' operater
		
//		3'b111: regin <= aluOut;
		
		default: begin aluOut= 8'b00000000; end 
	endcase
	end	

   // now connect to hex 
	wire [7:0]hexDisp; 
	assign hexDisp = aluOut; 

	bithex m0(B[3],B[2],B[1],B[0],H0[0],H0[1],H0[2],H0[3],H0[4], H0[5], H0[6]);
	bithex m1(in[3],in[2],in[1],in[0],H2[0],H2[1],H2[2],H2[3],H2[4], H2[5], H2[6]);
	bithex m4(hexDisp[3],hexDisp[2],hexDisp[1],hexDisp[0],H4[0],H4[1],H4[2],H4[3],H4[4], H4[5], H4[6]);
	bithex m5(hexDisp[7],hexDisp[6],hexDisp[5],hexDisp[4],H5[0],H5[1],H5[2],H5[3],H5[4], H5[5], H5[6]);

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


module mux2to1(x, y, s, m);
    input x; //select 0
    input y; //select 1
    input s; //select signal
    output m; //output
  
    //assign m = s & y | ~s & x;
    // OR
    assign m = s ? y : x;

endmodule


module fulladd(a, b, ci, out, co);
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


module ripcurry(b0,b1,b2,b3,a0,a1,a2,a3,s0,s1,s2,s3,cout); // can i call this module eventhought it's after topmodule? 
	input a0,a1,a2,a3,b0,b1,b2,b3;
	output s0,s1,s2,s3,cout;
	wire w0,w1,w2;  //corresponds to c1,c2,c3 in the next inputs in the schematics 

	fulladd m0(a0,b0,1'b0,s0,w0);
	fulladd m1(a1,b1,w0,s1,w1);
	fulladd m2(a2,b2,w1,s2,w2);
	fulladd m3(a3,b3,w2,s3,cout);
endmodule 



			