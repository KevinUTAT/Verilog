`timescale 1ns / 1ns 

module Lab5p3(SW, KEY, CLOCK_50, LEDR);
	input [4:0] SW;
	input [1:0] KEY;
	input CLOCK_50;
	output [1:0] LEDR;
	
	wire [11:0] code, clock_1, reset;
	assign reset = 1'b0;
	assign LEDR[1] = clock_1;
	
	morsePlayer player(code, clock_1, LEDR[0], KEY[1], KEY[0]);
	
	morseDecode decode(SW[2:0], code);
	
	oneSecond clk(CLOCK_50, reset, clock_1);

endmodule



//this module take the morse code in 12bit and play it out
module morsePlayer(code, clock_1, signal, load, reset);
	input [11:0] code;
	input clock_1;
	input load;
	input reset;
	output signal;
	wire [11:0] Q;
	
	wire reset;         //fix later
//	assign load = 1'b0;
//	assign reset = 1'b0;
	
	assign signal = Q[11];
	
	LshiftReg12b LSR0(code, load, clock_1, reset, Q);
     //               data, paralleLoadn, clock, reset, Q
endmodule


//this module convert letter input to a morse code in 12bit
module morseDecode(letter, code);
	input [2:0] letter;
	output [11:0] code;
	
	reg [11:0] code;
	
	always@(*)
	begin
		case (letter[2:0])
			3'b000: code = 12'b101110000000;        //A
			3'b001: code = 12'b111010101000;    //B
			3'b010: code = 12'b111010111010;  //C
			3'b011: code = 12'b111010100000;      //D
			3'b100: code = 12'b100000000000;            //E
			3'b101: code = 12'b101011101000;    //F
			3'b110: code = 12'b111011101000;    //G
			3'b111: code = 12'b101010100000;      //H
		    default: code = 12'b0;
		endcase
	end
endmodule
	
/*	
module oneSecond(clock_50M, reset, out);
	input clock_50M;
	input reset;
	output [3:0] out;
	
	wire clear1, clear2, enable1;
	
	reg [26:0] count1;
	reg [3:0] count2;
	
	always@(posedge clock_50M)
	begin
		if ((clear1 == 1'b1) | (reset == 1'b1))
			count1 <= 26'd0;
		else 
			count1 <= count1 + 1'b1;
	end
	
	assign clear1 = enable1;
	assign enable1 = (count1 == 27'd2500000) ? 1'b1 : 1'b0;
	assign out = count2;
	assign clear2 = (count2 == 4'b1111) ? 1'b1 : 1'b0;
	
	always@(posedge clock_50M)
	begin
		if (clear2 | reset)
			count2 <= 4'b0000;
		else if (enable1)
			count2 <= count2 + 1'b1;
	end
endmodule
*/

	
//this module output clock_1 witch is a 2Hz puse clock
module oneSecond(clock_50M, reset, clock_1);
	input clock_50M;
	input reset;
	output clock_1;
	
	wire clear1, clear2, enable1, puse, FFclear;
	assign FFclear = 1'b1;
	
	TFlipflop TFF0(puse, clock_1, clock_50M, FFclear);
	
	reg [26:0] count1;
	reg [3:0] count2;
	
	always@(posedge clock_50M)
	begin
		if ((clear1 == 1'b1) | (reset == 1'b1))
			count1 <= 27'd0;
		else 
			count1 <= count1 + 1'b1;
	end
	
	assign clear1 = enable1;
	assign enable1 = (count1 == 27'd25000000) ? 1'b1 : 1'b0;
	assign puse = enable1;
	assign clear2 = (count2 == 4'b1111) ? 1'b1 : 1'b0;
	
	always@(posedge clock_50M)
	begin
		if (clear2 | reset)
			count2 <= 4'b0000;
		else if (enable1)
			count2 <= count2 + 1'b1;
	end
endmodule



module LshiftReg12b(data, paralleLoadn, clock, reset, Q);
	input [11:0] data;
	input paralleLoadn;
	input clock;
	input reset;
	output [11:0] Q;
	
	//                  D   left right     loadn      clock  reset   Q
	LshiftReg LR0(data[0], Q[1], 1'b0, paralleLoadn, clock, reset, Q[0]);
	
	LshiftReg LR1(data[1], Q[2], Q[0], paralleLoadn, clock, reset, Q[1]);
	
	LshiftReg LR2(data[2], Q[3], Q[1], paralleLoadn, clock, reset, Q[2]);
	
	LshiftReg LR3(data[3], Q[4], Q[2], paralleLoadn, clock, reset, Q[3]);
	
	LshiftReg LR4(data[4], Q[5], Q[3], paralleLoadn, clock, reset, Q[4]);
	
	LshiftReg LR5(data[5], Q[6], Q[4], paralleLoadn, clock, reset, Q[5]);
	
	LshiftReg LR6(data[6], Q[7], Q[5], paralleLoadn, clock, reset, Q[6]);
	
	LshiftReg LR7(data[7], Q[8], Q[6], paralleLoadn, clock, reset, Q[7]);
	
	LshiftReg LR8(data[8], Q[9], Q[7], paralleLoadn, clock, reset, Q[8]);
	
	LshiftReg LR9(data[9], Q[10], Q[8], paralleLoadn, clock, reset, Q[9]);
	
	LshiftReg LR10(data[10], Q[11], Q[9], paralleLoadn, clock, reset, Q[10]);
	
	LshiftReg LR11(data[11], 1'b0, Q[10], paralleLoadn, clock, reset, Q[11]);
	
	
endmodule


module LshiftReg(D, left, right, loadn, clock, reset, Q);
	input D;
	input left;
	input right;
	input loadn;
	input clock;
	input reset;
	output Q;
	wire w0;
	wire shift;
	
	assign w0 = (loadn) ? shift : D;
	assign shift = right;
	
	flipfloph FF0(w0, clock, reset, Q);
              //   D  clock  reset  Q
endmodule


module flipfloph(D, clock, reset, Q);
	input D;
	input clock;
	input reset;
	output Q;
	
	reg Q;
	
	always@(posedge clock, negedge reset)
	begin
		if (~reset)
			Q = 0;
		else 
			Q = D;
	end
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


