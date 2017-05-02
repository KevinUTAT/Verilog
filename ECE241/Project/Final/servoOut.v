`timescale 1ns / 1ns 

module servoOut(
	input clk,
	input load,
	input [15:0] din,
	input resetn,
	output [1:0] sevout
	);
	servos sev(
			.clk(clk),
			.data_in(din),
			.resetn(resetn),
			.load(load),
			.servoP(sevout[1]),
			.servoY(sevout[0]));
			
	
endmodule

	
	
module servos(
	input clk,
	input [15:0] data_in,
	input resetn,
	input load,
	output servoP,
	output servoY);
	
	wire [7:0] dinP;
	wire [7:0] dinY;
	
	assign dinP = data_in[7:0];
	assign dinY = data_in[15:8];
	
	servoControl sevP(
					.clk(clk),
					.resetn(resetn),
					.loadP(load),
					.posi(dinP),
					.sig(servoP));
					
	servoControl sevY(
					.clk(clk),
					.resetn(resetn),
					.loadP(load),
					.posi(dinY),
					.sig(servoY));
	
endmodule
	



module servoControl(
	input clk,
	input resetn,
	input loadP,
	input [7:0] posi,
	output reg sig);
	
	reg [2:0] current;
	reg [2:0] next;
	reg clear;
	reg [20:0] count; //21 bit counter for pulse control
	reg loadPos;
	
	reg [20:0] pulseWidth;
	wire [20:0] GNDWidth;
	
	assign GNDWidth = 21'd1000000 - pulseWidth;
	
	localparam reset = 3'd0,
			   load  = 3'd1,
			   lwait = 3'd2,
			   GND   = 3'd3,
			   pulse = 3'd4;
			   
	always@(posedge clk)
	begin
			if (resetn == 1'b0)
				current <= reset;
			else 
				current <= next;
	end
	
	
	//counter
	always@(posedge clk)
	begin
			if(resetn == 1'b0 | clear == 1'b1)
				count <= 21'd0;
			else
				count <= count + 1'b1;
	end
	
	
	//state table
	always@(*)
	begin
			clear = 1'b0;
			case(current)
				reset: begin 
						next = (resetn) ? load : resetn;
						clear = 1'b1;
					   end
					   
				load: begin
						if(resetn == 0) next = reset;
						else if(loadP == 0) next = load;
						else next = GND;
					  end
						
//				lwait: begin
//						if(resetn == 0) next = reset;
//						else if (loadP == 1'b1) next = lwait;
//						else begin 
//								next = GND;
//								clear = 1'b1;
//							 end
//					   end
				
				GND: begin
						if(resetn == 0) next = reset;
						else if(count != GNDWidth) next = GND;
						else begin
								next = pulse;
								clear = 1'b1;
							 end
					 end
				
				pulse: begin
						if(resetn == 0) next = reset;
						else if (count != pulseWidth) next = pulse; //this number decide the signal
						else begin                                 //75000 x 20ns = 1.5ms -> 50% position
								next = load;
								clear = 1'b1;
							 end
					   end
				default: next = reset;
			endcase
	end
	
	
	always@(*)
	begin 
			loadPos = 1'b0;
			case(current)
				reset: sig = 1'b0;
				load: loadPos = 1'b1;
				GND: sig = 1'b0;
				pulse: sig = 1'b1;
				default: sig = 1'b0;
			endcase
	end
	
	always@(*)                                                //servo EMAX ES08MAII
	begin                                                     //travel 1.5ms - 1.9ms
			if(loadPos == 1'b1)
				pulseWidth <= 21'd29200 + posi * 21'd355;
	end                   //lowest point 
	
	
endmodule



