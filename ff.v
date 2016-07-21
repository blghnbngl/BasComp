`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232 Summer Project
// Engineer: Bilgehan
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ff(
    input clk,
    input e_indata,
    input e_clr,
	 input reset,
    input ff_en,
    output e_outdata
    );
	 
reg e;
wire ff_en;

	initial
		begin
			e<=0;
			ff_en=0;
		end
		
	always@ (posedge clk)
		begin
			if (ff_en==1 & e_clr==0 & reset==0)
				e<=e_indata;
			else if (ff_en==1 & e_clr==1)
				e<=0;
			else if (ff_en==1 & reset==1)
				e<=0;
		end

	assign e_outdata=e;
		

endmodule
