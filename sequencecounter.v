`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232 Summer Project
// Engineer: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//	This is a dataflow description of a counter. Behavioral model also exists as a comment between lines 
// 56-77 so that in case of a mistake in dataflow code it might be used.
//
//	This is a SYNCHRONOUS counter and there are 4 T flip flops. The first (least significant) ff toggles at
// each negative edge of the clock. The second one toggles if the first ff is 1, the third toggles if both
// the first and second ffs are 1, final one toggles if all three prior ffs are 1.
//
//	Some inputs are same for all ffs. They get the same clock and same clear command. They are always enabled
// (so the counter never stops), and the reset is set to 0 for all of them (resetting is done by clear 
// command). It is the indata they get that makes it a counter.
//
// WARNING: This counter increments at every NEGATIVE edge of the clock. But this can be changed easily if
// needed.
//
//////////////////////////////////////////////////////////////////////////////////
module sequencecounter(
	 input clk,
	 input inc,
	 input clr,
    output [3:0] sequence
    );

 
wire alwaystrue;
wire alwaysfalse;
wire a;
wire b;
wire c;
wire d;

assign alwaystrue = 1; 
assign alwaysfalse = 0; 

t_ff tflipflop0(.clk(~clk), .tff_indata(inc), .tff_clr(clr), .reset(alwaysfalse), .tff_en(alwaystrue),
					.tff_outdata(sequence[0]), .tff_outdata_bar(a));
					
t_ff tflipflop1(.clk(~clk), .tff_indata(inc & sequence[0]), .tff_clr(clr), .reset(alwaysfalse), .tff_en(alwaystrue),
					.tff_outdata(sequence[1]), .tff_outdata_bar(b));
					
t_ff tflipflop2(.clk(~clk), .tff_indata(inc & sequence[0] & sequence[1]), .tff_clr(clr), .reset(alwaysfalse),
					.tff_en(alwaystrue), .tff_outdata(sequence[2]), .tff_outdata_bar(c));
					
t_ff tflipflop3(.clk(~clk), .tff_indata(inc & sequence[0] & sequence[1] & sequence[2]), .tff_clr(clr),
					.reset(alwaysfalse), .tff_en(alwaystrue), .tff_outdata(sequence[3]), .tff_outdata_bar(d));					
 

/* 		BEHAVIORAL MODEL IN BETWEEN!!! 
//reg [3:0] sequence;
initial
	begin
		sequence<=4'b0000;
	end

//CHECK THIS!!!!! I DID THIS TO BE IN LINE WITH ASM CHART!!!
always @(negedge clk)			
	begin
		if (inc==0 && clr==1)
			sequence<=4'b0000;
		else if (inc==1 && clr==0)
			begin
				if (sequence==4'b1111)
					sequence<=4'b0000;
				else
					sequence=sequence+1;
			end 	
		else if (inc==1 && clr==1)
			$display("Error: Multiple inputs to sequence counter");
	end
*/

	
endmodule
