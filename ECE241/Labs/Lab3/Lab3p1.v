`timescale 1ns / 1ns 

module Lab3p1(SW, LEDR);
	input [9:0] SW;
	output [9:0] LEDR;
	
	mux7to1 mux1(
			.inp(SW[6:0]),
			.select(SW[9:7]),
			.outp(LEDR[0])
			);
			
endmodule
	
	
	
	
	
	
	
module mux7to1(inp, select, outp);
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
