`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:29:25 09/01/2016 
// Design Name: 
// Module Name:    t_ff 
// Project Name: 
// Target Devices: 
//
//
//	This is a T Flip Flop, which toggles in each positive edge of the clock
//
//////////////////////////////////////////////////////////////////////////////////
module t_ff(
    input clk,
    input tff_indata,
    input tff_clr,
    input reset,
    input tff_en,
    output tff_outdata,
	 output tff_outdata_bar
    );
	
//For intermadiate steps
wire Q1;					
wire Q1bar;
wire d_refined;

//To make a T flip flop
assign d_refined= (tff_outdata & (~tff_en) & (~reset)) | 
						( (~reset) & (~tff_clr) & tff_en & (~tff_indata) & tff_outdata) |
						( (~reset) & (~tff_clr) & tff_en & tff_indata & (~tff_outdata)) ;


	d_latch master( .d(d_refined), .c(~clk), .q(Q1) , .qbar(Q1bar));
	sr_latch slave( .s(Q1), .r(Q1bar), .c(clk), .q(tff_outdata) , .qbar(tff_outdata_bar));
	

endmodule
