
`include "vga_adapter/vga_adapter.v"
`include "vga_adapter/vga_address_translator.v"
`include "vga_adapter/vga_controller.v"
`include "vga_adapter/vga_pll.v"

module PartII
	(
		clk,						//	On Board 50 MHz
		// Your inputs and outputs here
		x_ini,
		y_ini,
		colour,
		writeEn,
		black,
		resetn,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			clk;				//	50 MHz
	// Declare your inputs and outputs here
	input [7:0] x_ini;
	input [6:0] y_ini;
	input [2:0] colour;
	input writeEn;
	input black;
	input resetn;
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire [7:0] x;
	wire [6:0] y;
	wire [2:0] colours;
	reg [3:0] count;
	reg [14:0] screenCount;
	reg clear;
	
	//4bit counter
	always@(posedge clk)
	begin
			if (clear == 1'b1)
				count <= 4'b0000;
			else
				count <= count + 1'b1;
	end
	
	//clear the screen 15bit counter
	always@(posedge clk)
	begin
			if (black == 1'b0) begin
				screenCount <= 15'd0;
				               end
			else if (black == 1'b1) begin
				screenCount <= screenCount + 1'b1;
									end
	end
	

	
	assign x = (black) ? (screenCount[7:0]) : (x_ini + count[1:0]);
	assign y = (black) ? (screenCount[14:8]) : (y_ini + count[3:2]);
	assign colours = (black) ? (3'b000) : (colour);
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(clk),
			.colour(colours),
			.x(x),
			.y(y),
			.plot(writeEn | black),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	
endmodule
