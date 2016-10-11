`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:14:55 08/30/2016 
// Design Name: 
// Module Name:    flipflop_dataflow 
// Project Name: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module flipflop_dataflow(
    input ff_indata,
    input clk,
	 input ff_en,
	 input ff_clr,
	 input reset,
    output ff_outdata,
    output ff_outdata_bar
    );


//For intermadiate steps
wire Q1;					
wire Q1bar;
wire d_refined;

//For clear and enable

assign d_refined = (ff_outdata & (~ff_en) & (~reset)) | (ff_indata & ff_en & (~ff_clr) & (~reset));


	
	d_latch master( .d(d_refined), .c(~clk), .q(Q1) , .qbar(Q1bar));
	sr_latch slave( .s(Q1), .r(Q1bar), .c(clk), .q(ff_outdata) , .qbar(ff_outdata_bar));
	

endmodule
