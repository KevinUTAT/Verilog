`timescale 1ns / 1ns 

module Lab5p2(CLOCK_50, SW, HEX0);
	input CLOCK_50;
	input [2:0] SW;
	output [6:0] HEX0;
	
	wire [3:0] out;
	reg [27:0] speed;
	
	always@(*)
	begin 
		case (SW[1:0])
			2'b00: speed = 28'd1;
			2'b01: speed = 28'd50000000;
			2'b10: speed = 28'd100000000;
			2'd11: speed = 28'd200000000;
		endcase
	end
		
	
	oneSecond(CLOCK_50, SW[2], out, speed);
	
	bithex hex0(out[3], out[2], out[1], out[0],
		HEX0[0], HEX0[1], HEX0[2], HEX0[3], HEX0[4],
		HEX0[5], HEX0[6]);
endmodule


module oneSecond(clock_50M, reset, out, speed);
	input clock_50M;
	input reset;
	input [27:0] speed;
	output [3:0] out;
	
	wire clear1, clear2, enable1;
	
	reg [27:0] count1;
	reg [3:0] count2;
	
	always@(posedge clock_50M)
	begin
		if ((clear1 == 1'b1) | (reset == 1'b1))
			count1 <= 28'd0;
		else 
			count1 <= count1 + 1'b1;
	end
	
	assign clear1 = enable1;
	assign enable1 = (count1 == speed) ? 1'b1 : 1'b0;
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
		
		
		
		
		
		
		
		