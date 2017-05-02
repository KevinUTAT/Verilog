`timescale 1ns / 1ns 

//Easy 241 v0.1

//this is are library aim to help Enum[E241 labs
//made by Kevin Xu and Linda Yu



//this module is use to display Hex number on the 7 segment display on DE-1
//num is a 4 bit input for a 4 bit(0 to 15) number to be displayed and hex is 
//a 7 bit out put intended to connect to each segment of a display
module bithex(num,hex); 
	input [3:0] num;
	output [6:0] hex;
	
	assign hex[0] = (~num[3] & ~num[2] & ~num[1] & num[0]) | (~num[3] & num[2]& ~num[1] & ~num[0]) 
		| (num[3]& ~num[2] & num[1] & num[0]) | (num[3] & num[2] & ~num[1] & num[0]);
	assign hex[1] = (~num[3] & num[2] & ~num[1] & num[0]) | (~num[3] & num[2] & num[1] & ~num[0]) 
		| (num[3] & ~num[2] & num[1] & num[0]) | (num[3] & num[2] & ~num[1] & ~num[0] ) 
		| (num[3] & num[2] & num[1] & ~num[0]) | (num[3] & num[2] & num[1] & num[0]);
	assign hex[2] = (~num[3] & ~num[2] & num[1] & ~num[0]) | (num[3] & num[2] & ~num[1] & ~num[0]) 
		| ( num[3] & num[2] & num[1] & ~num[0]) | (num[3] & num[2] & num[1] & num[0]);
	assign hex[3] = (~num[3] & ~num[2] & ~num[1] & num[0]) | ( ~num[3] & num[2] & ~num[1] & ~num[0]) 
		| ( ~num[3] & num[2] & num[1] & num[0]) | (num[3] & ~num[2] & ~num[1] & num[0]) 
		| (num[3] & ~num[2]& num[1] & ~num[0]) | (num[3] & num[2] & num[1] & num[0]);
	assign hex[4] = (~num[3] & ~num[2] & ~num[1] & num[0]) | ( ~num[3] & ~num[2] & num[1] & num[0]) 
		| (~num[3] & num[2] & ~num[1] & ~num[0]) | ( ~num[3] & num[2] & ~num[1] & num[0]) 
		| ( ~num[3] & num[2] & num[1] & num[0]) | (num[3] & ~num[2] & ~num[1] & num[0]);
	assign hex[5] = (~num[3] & ~num[2] & ~num[1] & num[0]) | (~num[3] & ~num[2] & num[1] & ~num[0]) 
		| ( ~num[3] & ~num[2] & num[1] & num[0]) | (~num[3] & num[2] & num[1] & num[0]) 
		| (num[3] & num[2] & ~num[1] & num[0]);
	assign hex[6] = (~num[3] & ~num[2] & ~num[1] & ~num[0]) | (~num[3] & ~num[2] & ~num[1] & num[0]) 
		| (~num[3] & num[2] & num[1] & num[0]) | (num[3] & num[2] & ~num[1] & ~num[0]);
endmodule



//this moudule is a 1bit positive edge trigered async reset TFlipflop
//T is data input, Q is output, clear is async active low
//this moudle will only work with DFlipflop_al module included
module TFlipflop_al(T, Q, clock, clear);
	input T;
	output Q;
	input clock;
	input clear;
	
	wire D;
	
	DFlipflop_al DFF0(D, clock, clear, Q);
	
	assign D = (T) ? ~Q : Q;
	
endmodule	



//this moudule is a 1 bit positive edge trigered async reset D flip flop
//D is data input, Q is output, reset is async active low
module DFlipflop_al(D, clock, reset, Q);
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
