`timescale 1ns / 1ps
`include "i2c_master.v"

module I2C(
	inout [35:0] GPIO_0,
	input CLOCK_50,
	input [3:0] KEY,
	output [9:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1);
	
	wire [7:0] data;
	reg [7:0] out;
	
	always@(data)
	begin
			if (data != 8'bzzzzzzzz)
				out <= data;
	end
	
	hex_decoder hex0(out[3:0], HEX0);
	hex_decoder hex1(out[7:4], HEX1);
	
	reg LED0;
	
	//LED set up
	wire ready_c, ready_id, valid_od, last_od, busy, ctrl, active, nack, 
			sda_t, scl_t;
	assign LEDR[0] = LED0;
	assign LEDR[1] = ready_id;
	assign LEDR[2] = valid_od;
	assign LEDR[3] = last_od;
	assign LEDR[4] = busy;
	assign LEDR[5] = ctrl;
	assign LEDR[6] = active;
	assign LEDR[7] = nack;
	assign LEDR[8] = sda_t;
	assign LEDR[9] = scl_t;
	
	
	reg [22:0] count;
	
	
	
	always@(posedge CLOCK_50)
	begin
			if(KEY[0] == 1'b0) count = 23'd0;
			else count = count + 1'b1;
	end
	
	//LED light up for a bit longer
	always@(ready_c)
	begin
			if(ready_c == 1'b1) LED0 = 1'b1;
			else if (ready_c == 1'b0 && count > 23'd7000000) LED0 = 1'b0;
	end
	
	//SCL I/O
	wire SCL_I, SCL_O, SCL;
	assign SCL_I = SCL;
	assign SCL = scl_t ? 1'bz : SCL_O;
	assign GPIO_0[35] = SCL;
	
	//SDA I/O
	wire SDA_I, SDA_O, SDA;
	assign SDA_I = SDA;
	assign SDA = sda_t ? 1'bz : SDA_O;
	assign GPIO_0[34] = SDA;
	
	assign GPIO_0[1] = data[0];
	
	
	
	
	
	
	i2c_master master(
					.clk(CLOCK_50),
					.rst(~KEY[0]),
					//Host interface
					.cmd_address(7'h1e), //address for HMC5883L  is 0x1E
					.cmd_start(~KEY[1]),
					.cmd_read(1'b1),
					.cmd_write(1'b0),
					.cmd_write_multiple(1'b0),
					.cmd_stop(~KEY[2]),
					.cmd_valid(1'b1),
					.cmd_ready(ready_c),
					
					.data_in(8'd0),
					.data_in_valid(1'b0),
					.data_in_ready(ready_id),
					.data_in_last(1'b0),
					
					.data_out(data),
					.data_out_valid(valid_od),
					.data_out_ready(1'b1),
					.data_out_last(last_od),
					//i2c inerface
					.scl_i(SCL_I),
					.scl_o(SCL_O),
					.scl_t(scl_t),
					.sda_i(SDA_I),
					.sda_o(SDA_O),
					.sda_t(sda_t),
					//status
					.busy(busy),
					.bus_control(ctrl),
					.bus_active(active),
					.missed_ack(nack),
					//Configuration
					.prescale(16'd125),
					.stop_on_idle(1'b0));
					
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
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	