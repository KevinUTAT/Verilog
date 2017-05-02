`timescale 1ns / 1ns 
`include "vga_adapter/vga_adapter.v"
`include "vga_adapter/vga_address_translator.v"
`include "vga_adapter/vga_controller.v"
`include "vga_adapter/vga_pll.v"



module Lab7p2(
	input [9:0] SW,
	input [3:0] KEY,
	input CLOCK_50,
	output VGA_CLK,   				//	VGA Clock
	output VGA_HS,					//	VGA H_SYNC
	output VGA_VS,					//	VGA V_SYNC
	output VGA_BLANK_N,				//	VGA BLANK
	output VGA_SYNC_N,				//	VGA SYNC
	output [9:0] VGA_R,   				//	VGA Red[9:0]
	output [9:0] VGA_G, 				//	VGA Green[9:0]
	output [9:0] VGA_B,
	output [9:0] LEDR);
	
	wire load_x, load_y, wren;
	
	controlPath control(
					.load(~KEY[3]),
					.plot(~KEY[1]),
					.resetn(KEY[0]),
					.clk(CLOCK_50),
					.load_x(load_x),
					.load_y(load_y),
					.wren(wren));
					
	fill data(
					.clk(CLOCK_50),						
					.coord(SW[6:0]),
					.colour(SW[9:7]),
					.load_x(load_x),
					.load_y(load_y),
					.writeEn(wren),
					.black(~KEY[2]),
					.resetn(KEY[0]),
					.VGA_CLK(VGA_CLK),   						//	VGA Clock
					.VGA_HS(VGA_HS),							//	VGA H_SYNC
					.VGA_VS(VGA_VS),							//	VGA V_SYNC
					.VGA_BLANK_N(VGA_BLANK_N),						//	VGA BLANK
					.VGA_SYNC_N(VGA_SYNC_N),						//	VGA SYNC
					.VGA_R(VGA_R),   						//	VGA Red[9:0]
					.VGA_G(VGA_G),	 						//	VGA Green[9:0]
					.VGA_B(VGA_B));
					
//the floowing coade are for debuging purpose only, not part of the lab
	assign LEDR[0] = load_x;
	assign LEDR[1] = load_y;
	assign LEDR[2] = wren;
//end of debuging code
endmodule



module controlPath(
	input load,
	input plot,
	input resetn,
	input clk,
	output reg load_x,
	output reg load_y,
	output reg wren);
	
	reg [2:0] current;
	reg [2:0] next;
	reg [3:0] counter;
	reg clear;
	
	localparam  reset     = 3'b000,
				loadx     = 3'b001,
				waitx     = 3'b010,
				loady     = 3'b011,
				waity     = 3'b100,
				draw      = 3'b101;
				
	
	always@(posedge clk)
	begin
			if (resetn == 1'b0)
				current <= reset;
			else 
				current <= next;
	end
	
	//0 - 15 counter
	always@(posedge clk)
	begin
			if ((resetn == 1'b0) | (clear == 1'b1))
				counter <= 4'b1111;
			else
				counter <= counter - 1'b1;
	end
	
	//state table
	always@(*)
	begin
			clear = 1'b0;
			case(current)
				reset: begin 
						next = (resetn) ? loadx : reset;
						clear = 1'b1;
					   end
				
				loadx: begin
						clear = 1'b1;
						if (resetn == 1'b0) next = reset;
						else if (load == 1'b1) next = waitx;
						else next = loadx;
					   end
				
				waitx: begin
						clear = 1'b1;
						if (resetn == 1'b0) next = reset;
						else if (load == 1'b1) next = waitx;
						else next = loady;
					   end
					   
				loady: begin
						clear = 1'b1;
						if (resetn == 1'b0) next = reset;
						else if (plot == 1'b1) next = waity;
						else next = loady;
					   end
					  
			    waity: begin
						clear = 1'b1;
						if (resetn == 1'b0) next = reset;
						else if (plot == 1'b1) next = waity;
						else next = draw;
					   end
					   
				draw: begin
						if (resetn == 1'b0) next = reset;
						else if (counter != 4'b0000) next = draw;
						else next = reset;
					  end
				
				default: next = reset;
			endcase
	end
	
	always@(*)
	begin
			load_x = 1'b0;
			load_y = 1'b0;
			wren = 1'b0;
			
			case (current)
				waitx: load_x = 1'b1;
				waity: load_y = 1'b1;
				draw: wren = 1'b1;
			endcase
	end
endmodule



module fill
	(
		clk,						//	On Board 50 MHz
		// Your inputs and outputs here
		coord,
		colour,
		load_x,
		load_y,
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
	input [6:0] coord;
	input [2:0] colour;
	input load_x;
	input load_y;
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
	reg [7:0] x_ini;
	reg [6:0] y_ini;
	reg [3:0] count;
	reg [14:0] screenCount;
	reg clear;

	
	
	
	//load input in to x_ini or y_ini
	always@(*)
	begin
			if (load_x == 1'b1)
				x_ini <= {1'b0, coord};
			else if (load_y == 1'b1)
				y_ini <= coord;
	end
	
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
