`include "servoOut.v"
`include "PWM_trans.v"


/*
	HEX0&1 default angle - will eventually be set by KEY
	HEX2&3 current angle - angle the IMU is sensing
	HEX4&5 update  angle - angle the motor needs to turn

*/
module Final(
	input CLOCK_50,
	input [3:0] KEY,
	input [9:0] SW,
	input [9:0] LEDR,
	output [35:34] GPIO_0,
	input [31:30] GPIO_1,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX4,
	output [6:0] HEX5
	);
	
	wire [15:0] out;
	wire [15:0] din;
	
	assign din = (SW[9]) ? out : {SW[7:4], 4'd0, SW[3:0], 4'd0};
	
	
	
	PWM_trans trans(
				.clk(CLOCK_50),
				.resetn(KEY[0]),
				.PWM(GPIO_1[31:30]),
				.outb(out));
					
	servoOut outa(
				.clk(CLOCK_50),
				.load(1'b1),
				.din(din),
				.resetn(KEY[0]),
				.sevout(GPIO_0[35:34]));
				
	hex_decoder hex0(din[3:0], HEX0);
	hex_decoder hex1(din[7:4], HEX1);
	
	hex_decoder hex4(din[11:8], HEX4);
	hex_decoder hex5(din[15:12], HEX5);
	
	assign SW[9] = LEDR[9];
				
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
