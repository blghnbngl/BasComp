`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ceng232 Summer Project
// Engineer: 
// 
// Create Date:    01:53:37 07/10/2016 
// Module Name:    register 
// Project Name: 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//	This is a dataflow description of a register. Behavioral model also exists as a comment between lines 
// 91-109 so that in case of a mistake in dataflow code it might be used. 16 D flip flops are defined in
//	line 50. Some inputs are same for all flip flops: They get the same clock and clear signals, reset is
//	always 0 and enable is always 1 for them. This is coded between 53-59. 
//	
//	Here, every signal flip flop refreshes itself in every positive clock edge. The main point here is what
//	gets in as input in every positive edge.Lines 61-62 (for the first FF) and lines 78-79 (for the remaining 
// 15 FFs) determine this input. There are three choices, 1) there is a load signal and indata is loaded, 
//	2) There is neither a load nor increment signal so what was in is preserved, 3) An increment signal comes
//	in and each flip flop is toggled if all the values before it were 1s. You can these possibilities in the
//	exact same order in aforementioned lines.
//
//	In lines 77-79, you can see a wire called incrementalindata. This one gets loaded to the flip flop when
//	an increment signal comes. This signal consists of XOR of the prior value of flip flop and the result
// of an AND operation on all prior flip flops. That is, after an increment signal a flip flop is toggled if
// all the prior values before it are 1, it stays the same otherwise. Lines 77 make sure of this.
//
//	Whether all prior flip flops are 1 is checked by a set of 16 wires called temporary1, and their code is 
// between 66-71. Between lines 83-89 output wires are assigned and the module finishes.
//
//////////////////////////////////////////////////////////////////////////////////
 module register(
    input clk,
    input load,
    input inc,
    input clr,
    input [15:0] indata,
    output [15:0] outdata
    );


genvar i;
genvar j;

wire [15:0] CLOCK, FF_INDATA, FF_CLR, RESET, FF_EN, FF_OUTDATA, FF_OUTDATA_BAR;
wire [15:0] outdatabars, incrementalindata, temporary1;

ff datasaved [15:0]  (CLOCK, FF_INDATA, FF_CLR, RESET, FF_EN, FF_OUTDATA, FF_OUTDATA_BAR);	//16 flip flops
//Here, this lining of input outputs should be correct otherwise there will be errors!

generate
	for (i=0;i<16;i=i+1)				//These inputs are same for all flip flops.
		begin: common_inputs
			assign CLOCK[i] = clk;
			assign FF_EN[i] = 1;
			assign RESET[i]=0;
			assign FF_CLR[i]=clr;
		end
endgenerate

assign FF_INDATA[0] =  ((load & indata[0] & ~inc) | ( (~load) & (~inc) & FF_OUTDATA[0]) | 
								( (~load) & inc & (~FF_OUTDATA[0])) );
	
assign temporary1[0] = FF_OUTDATA[0];

generate
		for (j=1;j<16;j=j+1)			//Checks whether all prior flip flops are 0 for each flip flop
			begin: incremental_flipflop_checker
				assign temporary1[j] = temporary1[j-1] & FF_OUTDATA[j];    
			end
endgenerate			
	
	
generate
	for (i=1;i<16;i=i+1)			//ASSIGNMENT TO REGISTER IS HERE
		begin: ff_indata_assignments
			assign incrementalindata[i] = (FF_OUTDATA[i] ^ temporary1[i-1]);	//For increment command
			assign FF_INDATA[i] =(load & indata[i] & ~inc) | ( (~load) & (~inc) & FF_OUTDATA[i]) | 
						( (~load) & inc & incrementalindata[i]);		//What comes as input in each clock cycle
	end		
endgenerate

generate
	for (i=0;i<16;i=i+1)			//Assigns the flip flop outputs to the module output wires.
		begin: output_assignments
			assign outdata[i] = FF_OUTDATA[i];
			assign outdatabars[i] = FF_OUTDATA_BAR[i];
		end
endgenerate	

/*
reg [15:0] datasaved;

initial
	datasaved=16'b0000000000000000;
 
always @(posedge clk)
	begin
		if (load==1 && inc==0 && clr==0)
			datasaved<=indata;
		else if (load==0 && inc==1 && clr==0)
			datasaved<=datasaved+1;
		else if (load==0 && inc==0 && clr==1)
			datasaved<=0;
		else if (load+inc+clr>1)
			$display("Error: Multiple commands for a register");
	end

assign outdata=datasaved;
*/

endmodule
