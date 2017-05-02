`timescale 1ns / 1ns 



module Lab6p3(SW, KEY, CLOCK_50, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [9:0] SW;
	input [3:0] KEY;
	input CLOCK_50;
	output [9:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	
	wire [3:0] answer;
	wire [4:0] remainder;
	wire [8:0] shift_reg;
	wire load_dividend, load_divisor, update_q0, update_regA, alu_op, left_shift, count, termSig;
	
	assign LEDR[3:0] = answer;
	
	assign remainder = shift_reg[8:4];
	assign answer = shift_reg[3:0];
	
	dividerControl control(~KEY[1], KEY[0], remainder, CLOCK_50,
		load_dividend, load_divisor, update_q0, update_regA, alu_op, left_shift, count, termSig);
	
	data_path path(SW[7:4], {1'b0, SW[3:0]}, KEY[0], alu_op, CLOCK_50, left_shift,
		update_q0, update_regA, load_dividend, load_divisor, shift_reg);
		
	terminator term(count, termSig, KEY[0] & KEY[1], CLOCK_50);
	
	hex_decoder hex0(SW[7:4], HEX0);
	hex_decoder hex1(4'd0, HEX1);
	hex_decoder hex2(SW[3:0], HEX2);
	hex_decoder hex3(4'd0, HEX3);
	hex_decoder hex4(answer, HEX4);
	hex_decoder hex5(remainder, HEX5);
	
endmodule



module dividerControl(Go, resetn, shift_reg, clk, 
	load_dividend, load_divisor, update_q0, update_regA, alu_op, left_shift, count, termSig);
	input Go;
	input resetn;
	input clk;
	input termSig;
	input [8:4] shift_reg;

	output reg load_dividend;
	output reg load_divisor;
	output reg update_q0;
	output reg update_regA;
	output reg alu_op;
	output reg left_shift;
	output reg count;
	
	
	reg [3:0] current;
	reg [3:0] next;
	
	localparam LOAD    = 4'd0,
	           WAIT    = 4'd1,
               SHIFT   = 4'd2,
			   SUB     = 4'd3,
			   ADD     = 4'd4,
			   SUB_WAIT= 4'd5,
			   DONE    = 4'd6;
	
	//state table
	always@(*)
	begin: state_table
			case(current)
				LOAD: next = Go ? WAIT : LOAD;
				
				WAIT: next = Go ? WAIT : SHIFT;
				
				SHIFT: next = SUB;
				
				SUB: next = SUB_WAIT;
				
				SUB_WAIT: next = shift_reg[8] ? ADD : DONE;
				
				ADD: next = DONE;
				
				DONE: next = (termSig) ? LOAD : SHIFT;
				
				default next = LOAD;
			endcase
	end
	
	
	always@(*)
	begin
			
			case (current)
				LOAD: begin
					load_dividend = 1'b0;
					load_divisor = 1'b0;
					left_shift = 1'b0;
					update_q0 = 1'b0;
					alu_op = 1'b0;
					update_regA = 1'b0;
					count = 1'b0;	
					
				end
				WAIT: begin
					load_dividend = 1'b1;
					load_divisor = 1'b1;
					left_shift = 1'b0;
					update_q0 = 1'b0;
					alu_op = 1'b0;
					update_regA = 1'b0;
					count = 1'b0;	
					
				end
				SHIFT: begin
					load_dividend = 1'b0;
					load_divisor = 1'b0;
					left_shift = 1'b1;
					update_q0 = 1'b0;
					alu_op = 1'b0;
					update_regA = 1'b0;
					count = 1'b0;	
				end
				SUB: begin
					load_dividend = 1'b0;
					load_divisor = 1'b0;
					left_shift = 1'b0;
					update_q0 = 1'b0;
					alu_op = 1'b0;
					update_regA = 1'b1;
					count = 1'b0;	
				end
				SUB_WAIT: begin
						load_dividend = 1'b0;
						load_divisor = 1'b0;
						left_shift = 1'b0;
						update_q0 = 1'b1;
						alu_op = 1'b0;
						update_regA = 1'b0;
						count = 1'b0;	
				end
				ADD: begin 
					load_dividend = 1'b0;
					load_divisor = 1'b0;
					left_shift = 1'b0;
					update_q0 = 1'b0;
					alu_op = 1'b1;
					update_regA = 1'b1;
					count = 1'b0;	
				end
				DONE: begin
					load_dividend = 1'b0;
					load_divisor = 1'b0;
					left_shift = 1'b0;
					update_q0 = 1'b0;
					alu_op = 1'b1;
					update_regA = 1'b0;
					count = 1'b1;
				end
				default begin
					load_dividend = 1'b0;
					load_divisor = 1'b0;
					left_shift = 1'b0;
					update_q0 = 1'b0;
					alu_op = 1'b0;
					update_regA = 1'b0;	
					count = 1'b0;					
				end
			endcase
	end
	
	
	always@(posedge clk)
	begin
			if (!resetn)
				current <= LOAD;
			else
				current <= next;
	end
endmodule



module terminator(count, terminate, resetn, clk);
	input count;
	input clk;
	input resetn;
	output terminate;
	
	reg [1:0] counter;
	
	assign terminate = (counter == 2'b11);
	
	always@(posedge clk)
	begin
			if (~resetn)
				counter <= 2'b00;
			else if (count)
				counter <= counter + 1'b1;
	end
	
endmodule



module data_path(dividend_in, d_in, resetn, alu_op, clk, left_shift,
	update_q0, update_regA, load_dividend, load_divisor, shift_reg);
	
	input [3:0] dividend_in;
	input [4:0] d_in;
	
	input resetn;
	input alu_op;
	input clk;
	input left_shift;
	input update_q0;
	input update_regA;
	input load_dividend;
	input load_divisor;
	
	output [8:0]shift_reg;
	wire [4:0] alu_out;
	wire [4:0] A_out;
	wire [4:0] divisor_out;
	
	assign A_out = shift_reg[8:4];
	
	aluAddSub alu(alu_op, A_out, divisor_out, alu_out);

	Shift_reg shiftreg(dividend_in, alu_out, resetn, clk, left_shift, update_q0, 
		update_regA, load_dividend, shift_reg);
	
	divisor idkwhattonamethis(d_in, clk, resetn, load_divisor, divisor_out);
	
endmodule

	

module Shift_reg(dividend_in, alu_out, resetn, clk, left_shift, update_q0, 
	update_regA, load_dividend, shift_reg);
	input [3:0]dividend_in;
	input [4:0] alu_out;
	input resetn;
	input clk;
	input left_shift;
	input update_q0;
	input update_regA;
	input load_dividend;
	
	output reg [8:0] shift_reg;
	
	always@(posedge clk)
	begin
			if (!resetn)  //reset to all 0
				shift_reg <= 9'b0;
			else if (left_shift)  // shift left
				shift_reg <= shift_reg << 1;
			else if (update_q0) // last to first
				shift_reg[0] <= ~shift_reg[8];
			else if (load_dividend) begin
				shift_reg[8:4] <= 5'b0;
				shift_reg[3:0] <= dividend_in;
				end
			else if (update_regA)
				shift_reg[8:4] <= alu_out[4:0];
	end
endmodule



module aluAddSub(alu_op, a, b, out);
	input alu_op;
	input [4:0] a;
	input [4:0] b;
	
	output reg [4:0] out;

	always@(*)
	begin
			if (alu_op) // alu_op =1 -> +, =0 -> -
				out = a + b;
			else
				out = a - b;
	end
endmodule

module divisor(
		input [4:0] d_in,
		input clk, input resetn,
		input load,
		output reg [4:0] out
);
	always@(posedge clk)
	if (!resetn)
		out <= 5'b0;
	else if (load)
		out <= d_in;
	else 
		out <= out;
endmodule

	
				
	
module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
				
