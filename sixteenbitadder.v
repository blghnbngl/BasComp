`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:40:11 09/07/2016 
// Design Name: 
// Module Name:    sixteenbitadder 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//	A 16-bit adder, ripple carry adder is written below. It consists of 16 full adders. It gives out 
//	a 16-bit sum and a single bit carry. This one will be a part of ALU module.
//
//////////////////////////////////////////////////////////////////////////////////
module sixteenbitadder(
    input [15:0] sixteenbitinput1,
    input [15:0] sixteenbitinput2,
    output [15:0] sixteenbitsum,
	 output sixteenbitcarry_out
    );
	 
wire alwaysfalse;
wire carry1, carry2, carry3, carry4, carry5, carry6, carry7, carry8, carry9, carry10, carry11, carry12,
		carry13, carry14, carry15, carry16;

assign alwaysfalse=0;
	 
fulladder adder0(.input1(sixteenbitinput1[0]), .input2(sixteenbitinput2[0]), .carry_in(alwaysfalse),
						.carry_out(carry1), .sum(sixteenbitsum[0])) ;
fulladder adder1(.input1(sixteenbitinput1[1]), .input2(sixteenbitinput2[1]), .carry_in(carry1),
						.carry_out(carry2), .sum(sixteenbitsum[1])) ;
fulladder adder2(.input1(sixteenbitinput1[2]), .input2(sixteenbitinput2[2]), .carry_in(carry2),
						.carry_out(carry3), .sum(sixteenbitsum[2])) ;
fulladder adder3(.input1(sixteenbitinput1[3]), .input2(sixteenbitinput2[3]), .carry_in(carry3),
						.carry_out(carry4), .sum(sixteenbitsum[3])) ;
fulladder adder4(.input1(sixteenbitinput1[4]), .input2(sixteenbitinput2[4]), .carry_in(carry4),
						.carry_out(carry5), .sum(sixteenbitsum[4])) ;
fulladder adder5(.input1(sixteenbitinput1[5]), .input2(sixteenbitinput2[5]), .carry_in(carry5),
						.carry_out(carry6), .sum(sixteenbitsum[5])) ;
fulladder adder6(.input1(sixteenbitinput1[6]), .input2(sixteenbitinput2[6]), .carry_in(carry6),
						.carry_out(carry7), .sum(sixteenbitsum[6])) ;
fulladder adder7(.input1(sixteenbitinput1[7]), .input2(sixteenbitinput2[7]), .carry_in(carry7),
						.carry_out(carry8), .sum(sixteenbitsum[7])) ;
fulladder adder8(.input1(sixteenbitinput1[8]), .input2(sixteenbitinput2[8]), .carry_in(carry8),
						.carry_out(carry9), .sum(sixteenbitsum[8])) ;
fulladder adder9(.input1(sixteenbitinput1[9]), .input2(sixteenbitinput2[9]), .carry_in(carry9),
						.carry_out(carry10), .sum(sixteenbitsum[9])) ;
fulladder adder10(.input1(sixteenbitinput1[10]), .input2(sixteenbitinput2[10]), .carry_in(carry10),
						.carry_out(carry11), .sum(sixteenbitsum[10])) ;
fulladder adder11(.input1(sixteenbitinput1[11]), .input2(sixteenbitinput2[11]), .carry_in(carry11),
						.carry_out(carry12), .sum(sixteenbitsum[11])) ;
fulladder adder12(.input1(sixteenbitinput1[12]), .input2(sixteenbitinput2[12]), .carry_in(carry12),
						.carry_out(carry13), .sum(sixteenbitsum[12])) ;
fulladder adder13(.input1(sixteenbitinput1[13]), .input2(sixteenbitinput2[13]), .carry_in(carry13),
						.carry_out(carry14), .sum(sixteenbitsum[13])) ;
fulladder adder14(.input1(sixteenbitinput1[14]), .input2(sixteenbitinput2[14]), .carry_in(carry14),
						.carry_out(carry15), .sum(sixteenbitsum[14]));
fulladder adder15(.input1(sixteenbitinput1[15]), .input2(sixteenbitinput2[15]), .carry_in(carry15),
						.carry_out(sixteenbitcarry_out), .sum(sixteenbitsum[15])) ;


endmodule
