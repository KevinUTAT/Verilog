`timescale 1ns / 1ns 
`include "sequence_detector.v"


module Lab6p1(SW, KEY, LEDR);
	 input [9:0] SW;
    input [3:0] KEY;
    output [9:0] LEDR;
	
	sequence_detector SD0(SW, KEY, LEDR);
endmodule
