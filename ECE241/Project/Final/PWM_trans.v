`timescale 1ns / 1ns 

module PWM_trans(
	input clk,
	input resetn,
	input [1:0] PWM,
	output [15:0] outb
	);
	
	wire [11:0] Pout;
	wire [11:0] Yout;
	
//	assign PO = Pout[11:4];
//	assign YO = Yout[11:4];
	
	
//	wire [7:0] Pdis, Ydis;
	
//	assign Pdis = Pout / 16;
//	assign Ydis = Yout / 16;
	
	assign outb = {Yout[11:4], Pout[11:4]};
	
	PWMRead readP(
				.resetn(resetn),
				.clk(clk),
				.pwm(PWM[1]),
				.width(Pout));
				
	PWMRead readY(
				.resetn(resetn),
				.clk(clk),
				.pwm(PWM[0]),
				.width(Yout));
				
				
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
	
	
	
