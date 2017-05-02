`timescale 1ns / 1ns 
`include "PartII.v"



module Lab7p3(
	input [1:0] KEY,
	input [9:7] SW,
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
	
	wire plot, black, zero, update_, quarterClk;
	
	controlPath3 control(
				.resetn(KEY[0]),
				.clk(CLOCK_50),
				.plot(plot),
				.black(black),
				.zero(zero),
				.update_(update_),
				.quarterClk(quarterClk));
				
	dataPath3 data(
				.quarterClk(quarterClk),
				.clk(CLOCK_50),
				.zero(zero),
				.plot(plot),
				.update_(update_),
				.black(black),
				.resetn(KEY[0]),
				.colour(SW[9:7]),
				.VGA_CLK(VGA_CLK),   						//	VGA Clock
				.VGA_HS(VGA_HS),							//	VGA H_SYNC
				.VGA_VS(VGA_VS),							//	VGA V_SYNC
				.VGA_BLANK_N(VGA_BLANK_N),						//	VGA BLANK
				.VGA_SYNC_N(VGA_SYNC_N),						//	VGA SYNC
				.VGA_R(VGA_R),   						//	VGA Red[9:0]
				.VGA_G(VGA_G),	 						//	VGA Green[9:0]
				.VGA_B(VGA_B));
				
	assign LEDR[0] = plot;
	assign LEDR[1] = black;
				
endmodule


module controlPath3(
	input resetn,
	input clk,
	output reg plot,
	output reg black,
	output reg zero,
	output reg update_,
	output quarterClk);
	
	
	reg [1:0] current;
	reg [1:0] next;
	wire clear;
	reg [23:0] countQuarter;
	reg clearb;
	reg [14:0] countb;
	
	localparam reset     = 2'b00,
			   draw      = 2'b01,
			   Black     = 2'b10,
			   update    = 2'b11;
			   
	always@(posedge clk)
	begin
			if (resetn == 1'b0)
				current <= reset;
			else 
				current <= next;
	end
	
	//create a clock of 4Hz
	always@(posedge clk)
	begin
			if (clear == 1'b1 | resetn == 1'b0)
				countQuarter <= 24'd0;
			else
				countQuarter <= countQuarter + 1'b1;
	end
	
	assign clear = (countQuarter == 24'd12500000) ? 1'b1 : 1'b0;
	assign quarterClk = clear;
	
	always@(posedge clk)
	begin
			if (resetn == 1'b0 | clearb == 1'b1)
				countb <= 15'd0;
			else
				countb <= countb + 1'b1;
	end
				
	//state table
	always@(*)
	begin
			clearb = 1'b0;
			case (current)
				reset: begin 
						next = (resetn) ? draw : reset;
						clearb = 1'b1;
					   end
				
				draw: begin
					clearb = 1'b1;
					if (~resetn)
						next <= reset;
					else
						next <= (~clear) ? draw : Black;
					  end
				
				Black: begin 
						if (countb != 15'd32760)
							next <= Black;
						else begin
							next <= (resetn) ? update : reset;
							clearb <= 1'b1;
							 end
					   end 
				
				update: begin 
						next <= (resetn) ? draw : reset;
						clearb = 1'b1;
						end 
				
				default next <= reset;
			endcase
	end
			
					
	always@(*)
	begin
			plot = 1'b0;
			black = 1'b0;
			update_ = 1'b0;
			
			case (current)
				reset: zero = 1'b1;
				
				draw: begin 
						plot = 1'b1;
					  end
				
				Black: black = 1'b1;

				
				update: zero = 1'b0;
			endcase
	end
endmodule



module dataPath3(
	input quarterClk,
	input clk,
	input zero,
	input plot,
	input update_,
	input black,
	input resetn,
	input [2:0] colour,
	output VGA_CLK,   				//	VGA Clock
	output VGA_HS,					//	VGA H_SYNC
	output VGA_VS,					//	VGA V_SYNC
	output VGA_BLANK_N,				//	VGA BLANK
	output VGA_SYNC_N,				//	VGA SYNC
	output [9:0] VGA_R,   				//	VGA Red[9:0]
	output [9:0] VGA_G, 				//	VGA Green[9:0]
	output [9:0] VGA_B);
	
	wire [7:0] x_ini;
	wire [6:0] y_ini;
	
	reg [7:0] x_count_up;
	reg [7:0] x_count_down;
	reg [6:0] y_count_up;
	reg [6:0] y_count_down;
	reg H;
	reg V;
	
	
	//x up counter
	always@(posedge plot)
	begin
			if (zero| H == 1'b0 | resetn == 1'b0)
				x_count_up <= 8'd0;
			else 
				x_count_up <= x_count_up + 1'b1;
	end
	
	//x down counter
	always@(posedge plot)
	begin
			if (zero| H == 1'b1 | resetn == 1'b0)
				x_count_down <= 8'd156;
			else 
				x_count_down <= x_count_down - 1'b1;
	end
	
	//y up counter
	always@(posedge plot)
	begin
			if (zero| V == 1'b1 | resetn == 1'b0)
				y_count_up <= 7'd0;
			else 
				y_count_up <= y_count_up + 1'b1;
	end
	
	//y down counter
	always@(posedge plot)
	begin
			if (zero| V == 1'b0 | resetn == 1'b0)
				y_count_down <= 7'd116;
			else 
				y_count_down <= y_count_down - 1'b1;
	end
	
	assign x_ini = (~H) ? x_count_down[7:0] : x_count_up[7:0];
	assign y_ini = (V) ? y_count_down[6:0] : y_count_up[6:0];
	
	//H update
	always@(posedge clk)
	begin
			if (x_ini >= 8'd156 & H == 1'b1)
				H = 1'b0;
			else if (x_ini >= 8'd156 & H == 1'b0)
				H = 1'b0;
			else if (x_ini == 8'd0 & H == 1'b0)
				H = 1'b1;
	end
	
	//V update
	always@(posedge clk)
	begin
			if (y_ini >= 7'd116 & V == 1'b0)
				V = 1'b1;
			else if (y_ini >= 7'd116 & V == 1'b1)
				V = 1'b1;	
			else if (y_ini == 7'd0 & V == 1'b1)
				V = 1'b0;
	end
	
	PartII drawSquare(
						.clk(clk),						//	On Board 50 MHz
						.x_ini(x_ini),
						.y_ini(y_ini),
						.colour(colour),
						.writeEn(plot),
						.black(black),
						.resetn(resetn),
						// The ports below are for the VGA output.  Do not change.
						.VGA_CLK(VGA_CLK),   						//	VGA Clock
						.VGA_HS(VGA_HS),							//	VGA H_SYNC
						.VGA_VS(VGA_VS),							//	VGA V_SYNC
						.VGA_BLANK_N(VGA_BLANK_N),						//	VGA BLANK
						.VGA_SYNC_N(VGA_SYNC_N),						//	VGA SYNC
						.VGA_R(VGA_R),   						//	VGA Red[9:0]
						.VGA_G(VGA_G),	 						//	VGA Green[9:0]
						.VGA_B(VGA_B));
	
endmodule

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	