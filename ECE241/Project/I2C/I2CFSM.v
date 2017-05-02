`timescale 1ns / 1ps
`include "i2c_master.v"

module I2CFSM(
	input CLOCK_50,
	input [3:0] KEY,
	inout [35:0] GPIO_0,
	output [6:0] HEX0,
	output [6:0] HEX1);
	
	
	
endmodule

module controlPath(
	input clk,
	input reset,
	output ren,
	output wen,
	output start,
	output stop);
	
	reg [2:0] current;
	reg [2:0] next;
	reg [25:0] count;
	
	localparam reset        = 3'd0,
			   start        = 3'd1,
			   startWait    = 3'd2,
			   writeAddr    = 3'd3,
			   Rstart       = 3'd4,
			   read         = 3'd5;
			   
			   
	always@(posedge clk)
			   
	always@(posedge clk)
	begin
			if (resetn == 1'b0)
				current <= reset;
			else 
				current <= next;
	end
			   
	
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   
			   