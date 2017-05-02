`timescale 1ns / 1ns 

module PWM(
	input CLOCK_50,
	input [3:0] KEY,
	input [9:0] SW,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [35:0] GPIO_0);
	
	controlPath control(
						.clk(CLOCK_50),
						.resetn(KEY[0]),
						.loadP(~KEY[1]),
						.posi(SW[7:0]),
						.sig(GPIO_0[33]));
						
	hex_decoder hexd0(
					.hex_digit(SW[3:0]),
					.segments(HEX0));
					
	hex_decoder hexd1(
					.hex_digit(SW[7:4]),
					.segments(HEX1));

endmodule 



module controlPath(
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
						else next = lwait;
					  end
						
				lwait: begin
						if(resetn == 0) next = reset;
						else if (loadP == 1'b1) next = lwait;
						else begin 
								next = GND;
								clear = 1'b1;
							 end
					   end
				
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
								next = GND;
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
				lwait: loadPos = 1'b1;
				GND: sig = 1'b0;
				pulse: sig = 1'b1;
				default: sig = 1'b0;
			endcase
	end
	
	always@(*)                                                //servo EMAX ES08MAII
	begin                                                     //travel 1.5ms - 1.9ms
			if(loadPos == 1'b1)
				pulseWidth <= 21'd40000 + posi * 21'd400;
	end                   //lowest point 
	
	
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	