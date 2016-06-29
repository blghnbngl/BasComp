`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232SummerProject 
// Engineer: bilgehan
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Decoder(
    output d7,
    output d6,
    output d5,
    output d4,
    output d3,
    output d2,
    output d1,
    output d0,
    input vector2,
    input vector1,
    input vector0
    );

module decoder(
					output  d7,
					output  d6,
					output  d5,
					output  d4,
					output  d3,
					output  d2,
					output  d1,
					output  d0,
					input vector2,
					input vector1,
					input vector0);

assign d7=(vector2 && vector1 && vector0);
assign d6=(vector2 && vector1 && !vector0);
assign d5=(vector2 && !vector1 && vector0);
assign d4=(vector2 && !vector1 && !vector0);
assign d3=(!vector2 && vector1 && vector0);
assign d2=(!vector2 && vector1 && !vector0);
assign d1=(!vector2 && !vector1 && vector0);
assign d0=(!vector2 && !vector1 && !vector0);

endmodule
