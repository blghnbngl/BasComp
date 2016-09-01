`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232 Summer Project
// Engineer: Bilgehan
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//	WARNING: Between lines 46-57, a flip flop is coded with the dataflow method. It uses two modules: d latch 
// and sr latch. These two modules are in dataflow too. Between 26-42 a flip flop is coded with behavioral 
//	method. But it is not used since it is in comments. The reason I left it there rather than erasing is
// in case of a mistake in dataflow model, this one may be taken out of comments and can be used. Both ones
// perform well with the testbench. NOTE THAT THE DEFAULT FLIP FLOP TYPE IS A D-FF, UNLESS OTHERWISE DENOTED.
// This one defines a D-Flip Flop
//////////////////////////////////////////////////////////////////////////////////
module ff(
    input clk,
    input ff_indata,
    input ff_clr,
	 input reset,
    input ff_en,
    output ff_outdata,
	 output ff_outdata_bar
    );
/*	 
reg e;

	initial
			e<=0;

		
	always@ (posedge clk)
		begin
			if (reset==1)
				e<=0;
			else if (ff_en==1 & ff_clr==0 & reset==0)
				e<=ff_indata;
			else if (ff_en==1 & ff_clr==1 & reset==0)
				e<=0;
		end

	assign ff_outdata=e;*/
	
	
//For intermadiate steps
wire Q1;					
wire Q1bar;
wire d_refined;

//For clear and enable

assign d_refined = (ff_outdata & (~ff_en) & (~reset)) | (ff_indata & ff_en & (~ff_clr) & (~reset));


	
	d_latch master( .d(d_refined), .c(~clk), .q(Q1) , .qbar(Q1bar));
	sr_latch slave( .s(Q1), .r(Q1bar), .c(clk), .q(ff_outdata) , .qbar(ff_outdata_bar));
	
		

endmodule
