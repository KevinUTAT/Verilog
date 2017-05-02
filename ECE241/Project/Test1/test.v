

module test(KEY,SW,HEX0,HEX1);

input [2:0]SW;
input [3:0]KEY;
output [0:6]HEX0;
output [0:6]HEX1;

wire Clearb,Clock,Enable;
assign Clearb = SW[0];
assign Enable = SW[1];
assign Clock = KEY[0];

reg [7:0]Q;

always@(posedge Clock)
 
 if(~Clearb) begin
	Q <= 7'b0;
	end
 else if (Enable) begin
	Q <= Q + 1;
	end
bithex u0(Q[3],Q[2],Q[1],Q[0],HEX0[0],HEX0[1],HEX0[2],HEX0[3],HEX0[4],HEX0[5],HEX0[6]); // leastsig 4 bits Q0-Q3
bithex u1(Q[7],Q[6],Q[5],Q[4],HEX1[0],HEX1[1],HEX1[2],HEX1[3],HEX1[4],HEX1[5],HEX1[6]); // mostsig 4 bits Q4-Q7
// are they gonna run in parallel??

endmodule 

module bithex(c3,c2,c1,c0,h0,h1,h2,h3,h4,h5,h6); 
     input c0;
     input c1;
     input c2;
     input c3;
     output h0,h1,h2,h3,h4,h5,h6;
     
     assign h0 = (~c3 & ~c2 & ~c1 & c0) | (~c3 & c2 & ~c1 & ~c0) | (c3 & ~c2 & c1 & c0) | (c3 & c2 & ~c1 & c0);
     assign h1 = (~c3 & c2 & ~c1 & c0) | (~c3 & c2 & c1 & ~c0) | (c3 & ~c2 & c1 & c0) | (c3 & c2 & ~c1 & ~c0 ) | (c3 & c2 & c1 & ~c0) | (c3 & c2 & c1 & c0);
     assign h2 = (~c3 & ~c2 & c1 & ~c0) | (c3 & c2 & ~c1 & ~c0) | ( c3 & c2 & c1 & ~c0) | (c3 & c2 & c1 & c0);
     assign h3 = (~c3 & ~c2 & ~c1 & c0) | ( ~c3 & c2 & ~c1 & ~c0) | ( ~c3 & c2 & c1 & c0) | (c3 & ~c2 & ~c1 & c0) | (c3 & ~c2 & c1 & ~c0) | (c3 & c2 & c1 & c0);
     assign h4 = (~c3 & ~c2 & ~c1 & c0) | ( ~c3 & ~c2 & c1 & c0) | (~c3 & c2 & ~c1 & ~c0) | ( ~c3 & c2 & ~c1 & c0) | ( ~c3 & c2 & c1 & c0) | (c3 & ~c2 & ~c1 & c0);
     assign h5 = (~c3 & ~c2 & ~c1 & c0) | (~c3 & ~c2 & c1 & ~c0) | ( ~c3 & ~c2 & c1 & c0) | (~c3 & c2 & c1 & c0) | (c3 & c2 & ~c1 & c0);
     assign h6 = (~c3 & ~c2 & ~c1 & ~c0) | (~c3 & ~c2 & ~c1 & c0) | (~c3 & c2 & c1 & c0) | (c3 & c2 & ~c1 & ~c0);

endmodule
