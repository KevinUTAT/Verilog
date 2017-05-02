`timescale 1ns / 1ns 
/*
INPUTA SW[7:4]
INPUTB SW[3:0]
FUNCTION INPUT KEY[2:0]
DISPLAY [7:0]
DISPLAYB HEX0 DISPLAYA HEX2
DISPLAY HEX4 HEX5
*/
module Test0(SW,KEY,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6);

	input [7:0] SW;
	input [2:0] KEY;
	output [7:0] LEDR;
	wire [3:0] A;
	wire [3:0] B;
	wire [2:0] select;
	assign A = SW[7:4];
	assign B = SW[3:0];
	assign select = KEY[2:0];
	output [6:0]HEX1;
	output [6:0]HEX2;
	output [6:0]HEX3;
	output [6:0]HEX4;
	output [6:0]HEX5;
	output [6:0]HEX6;
	output [6:0]HEX0; // CAN I DO THIS
	assign HEX1[6:0] = 7'b1000000;
	assign HEX3[6:0] = 7'b1000000;
	
	wire[7:0]ripple;
	ripcurry u0(B[0],B[1],B[2],B[3],A[0],A[1],A[2],A[3],ripple[0],ripple[1],ripple[2],ripple[3],ripple[4]);
	assign ripple[7:5] = 3'b000;

//shows output on LED 
	reg [7:0]aluOut;
		
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
	3'b101: aluOut = {~A[3:0],B[3:0]}; // case 5: Display the inverse of the A switches in the most significant four bits and the value of the B switches in the least significant four bits.
	default: begin aluOut= 8'b11111111; end// will this be the general default for all cases? 
endcase
end	

// now connect to hex 
	wire [7:0]hexDisp; 
	assign hexDisp = aluOut; 

	bithex m0(SW[7],SW[6],SW[5],SW[4],HEX0[0],HEX0[1],HEX0[2],HEX0[3],HEX0[4], HEX0[5], HEX0[6]);
	bithex m1(SW[3],SW[2],SW[1],SW[0],HEX2[0],HEX2[1],HEX2[2],HEX2[3],HEX2[4], HEX2[5], HEX2[6]);
	bithex m4(hexDisp[3],hexDisp[2],hexDisp[1],hexDisp[0],HEX4[0],HEX4[1],HEX4[2],HEX4[3],HEX4[4], HEX4[5], HEX4[6]);
	bithex m5(hexDisp[7],hexDisp[6],hexDisp[5],hexDisp[4],HEX5[0],HEX5[1],HEX5[2],HEX5[3],HEX5[4], HEX5[5], HEX5[6]);

endmodule 

// below is the display of A and B// will this run parallel with the top module?
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


module fulladd(a,b,ci,co,s); //ci:carry in, co carry out, s output digit
	input a,b,ci;
	output co,s; // careful might have flipped them, find more about what they actually stand for 
	assign co = a & b + ci & b + ci & a;
	assign s = a ^ b ^ ci; 
endmodule 

module ripcurry(b0,b1,b2,b3,a0,a1,a2,a3,s0,s1,s2,s3,cout); // can i call this module eventhought it's after topmodule? 
	input a0,a1,a2,a3,b0,b1,b2,b3;
	output s0,s1,s2,s3,cout;
	wire w0,w1,w2;  //corresponds to c1,c2,c3 in the next inputs in the schematics 

	fulladd m0(a0,b0,1'b0,w0,s0);
	fulladd m1(a1,b1,w0,w1,s1);
	fulladd m2(a2,b2,w1,w2,s2);
	fulladd m3(a3,b3,w2,cout,s3);
endmodule 



