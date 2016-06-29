`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232SummerProject 
// Engineer: bilgehan
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Decoder(d7,d6,d5,d4,d3,d2,d1,d0,vector2,vector1,vector0);
output reg d7, d6, d5, d4,d3,d2,d1, d0;
input vector2,vector1,vector0;

initial
	begin
		if (vector2 && vector1 && vector0)
			begin
				d7<=1;
				d6<=0;
				d5<=0;
				d4<=0;
				d3<=0;
				d2<=0;
				d1<=0;
				d0<=0;
			end
		else if (vector2 && vector1 && !vector0)
			begin
				d7<=0;
				d6<=1;
				d5<=0;
				d4<=0;
				d3<=0;
				d2<=0;
				d1<=0;
				d0<=0;
			end
		else if (vector2 && !vector1 && vector0)
			begin
				d7<=0;
				d6<=0;
				d5<=1;
				d4<=0;
				d3<=0;
				d2<=0;
				d1<=0;
				d0<=0;
			end
	else if (vector2 && !vector1 && !vector0)
			begin
				d7<=0;
				d6<=0;
				d5<=0;
				d4<=1;
				d3<=0;
				d2<=0;
				d1<=0;
				d0<=0;
			end
		else if (!vector2 && vector1 && vector0)
			begin
				d7<=0;
				d6<=0;
				d5<=0;
				d4<=0;
				d3<=1;
				d2<=0;
				d1<=0;
				d0<=0;
			end
	else if (!vector2 && vector1 && !vector0)
			begin
				d7<=0;
				d6<=0;
				d5<=0;
				d4<=0;
				d3<=0;
				d2<=1;
				d1<=0;
				d0<=0;
			end
	else if (!vector2 && !vector1 && vector0)
			begin
				d7<=0;
				d6<=0;
				d5<=0;
				d4<=0;
				d3<=0;
				d2<=0;
				d1<=1;
				d0<=0;
			end
	else if (!vector2 && !vector1 && !vector0)
			begin
				d7<=0;
				d6<=0;
				d5<=0;
				d4<=0;
				d3<=0;
				d2<=0;
				d1<=0;
				d0<=1;
			end
	end


endmodule
