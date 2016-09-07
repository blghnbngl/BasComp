`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:05:27 09/07/2016 
// Design Name: 
// Module Name:    fulladder 

// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//	A full adder that takes two inputs and a carry_in, gives out a sum and a carry_out. This module will be
//	building block of a sixteen bit adder.
//
//////////////////////////////////////////////////////////////////////////////////
module fulladder(
    input input1,
    input input2,
    input carry_in,
    output carry_out,
    output sum
    );

assign carry_out= (input1 & input2) | (input1 & carry_in) | (input2 & carry_in);
assign sum = (carry_in ^ input1 ^ input2);

endmodule
