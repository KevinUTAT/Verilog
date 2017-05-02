`timescale 1ns / 1ns 

module PWM_trans(
	input CLOCK_50,
	input [3:0] KEY,
	input [35:0] GPIO_0,
	input [35:0] GPIO_1,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5
	);
	
	wire [11:0] Pout, 
	wire [11:0] Yout;
//	wire [7:0] Pdis, Ydis;
	
//	assign Pdis = Pout / 16;
//	assign Ydis = Yout / 16;
	
	PWMRead readP(
				.resetn(KEY[0]),
				.clk(CLOCK_50),
				.pwm(GPIO_1[30]),
				.width(Pout));
				
	PWMRead readY(
				.resetn(KEY[0]),
				.clk(CLOCK_50),
				.pwm(GPIO_0[31]),
				.width(Yout));
				
	hex_decoder hex0(Pout[3:0], HEX0);
	hex_decoder hex1(Pout[7:4], HEX1);
	hex_decoder hex2(Pout[11:8], HEX2);
	
	hex_decoder hex3(Yout[3:0], HEX3);
	hex_decoder hex4(Yout[7:4], HEX4);
	hex_decoder hex5(Yout[11:8], HEX5);
				
endmodule



module PWMRead(
	input resetn,
	input clk,
	input pwm,
	output [11:0] width); //width in unit of us witch is 0.001 ms
	
	reg [1:0] current;
	reg [1:0] next;
	reg clear;
	reg [18:0] counter = 19'd0;
	reg [18:0] clkwidth;
	
	
	localparam reset  = 2'd0,
			   count  = 2'd1,
			   outing = 2'd2;
			   
	always@(posedge clk)
	begin
			if (resetn == 1'b0)
				current <= reset;
			else 
				current <= next;
	end
	
	always@(posedge clk)
	begin
			if(clear == 1'b1) counter <= 19'd0;
			
			else counter <= counter + 1'b1;
	end
	
	always@(*)
	begin
			case(current)
				reset: next = (pwm) ? count : reset;
				
				count: next = (pwm) ? count : outing;
				
				outing: next = reset;
				
				default: next = reset;
			endcase
	end
	
	always@(*)
	begin
			case(current)
				reset: clear = 1'b1;
				
				count: clear = 1'b0;
				
				outing: clkwidth = counter;
				
				default: clear = 1'b0;
			endcase
	end
	
	
	assign width = clkwidth / 50;
	
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
