`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ceng232 Summer Project 
// Engineer: 
// 
// Create Date:    02:09:17 07/10/2016 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//	Expect the size (12 bits) this module is exactly the same with the register module (16 bits). For 
//	explanations, please look at the register module.	
//
//////////////////////////////////////////////////////////////////////////////////
module smallregister(
    input clk,
    input load,
    input inc,
    input clr,
    input [15:0] indata,
    output [11:0] outdata
    );


genvar i;
genvar j;

wire [11:0] CLOCK, FF_INDATA, FF_CLR, RESET, FF_EN, FF_OUTDATA, FF_OUTDATA_BAR;
wire [11:0] outdatabars, incrementalindata, temporary1;

//Here, this lining of input outputs should be correct otherwise there will be errors!
generate
	for (i=0;i<12;i=i+1)
		begin: commoninputs
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
		for (j=1;j<12;j=j+1)
			begin: incremental_flipflopchecker
				assign temporary1[j] = temporary1[j-1] & FF_OUTDATA[j];    
			end
endgenerate			
	
	
generate
	for (i=1;i<12;i=i+1)
		begin: ff_indataassignments
			assign incrementalindata[i] = (FF_OUTDATA[i] ^ temporary1[i-1]);
			assign FF_INDATA[i] =(load & indata[i] & ~inc) | ( (~load) & (~inc) & FF_OUTDATA[i]) | 
						( (~load) & inc & incrementalindata[i]);
	end		
endgenerate

generate
	for (i=0;i<12;i=i+1)
		begin: outputassignments
			assign outdata[i] = FF_OUTDATA[i];
			assign outdatabars[i] = FF_OUTDATA_BAR[i];
		end
endgenerate	

ff datasaved [11:0]  (CLOCK, FF_INDATA, FF_CLR, RESET, FF_EN, FF_OUTDATA, FF_OUTDATA_BAR);

/*
reg [11:0] datasaved;

initial
	datasaved=12'b000000000000;
 
always @(posedge clk)				// Or,should this be a * rather than clock.
	begin
		if (load==1 & inc==0 & clr==0)
				datasaved<=indata[11:0];
		else if (load==0 & inc==1 & clr==0)
			datasaved<=datasaved+1;
		else if (load==0 & inc==0 & clr==1)
			datasaved<=0;
		else if (load+inc+clr>1)
			$display("Error: Multiple commands for adress register");
	end

assign outdata=datasaved;
*/

endmodule
