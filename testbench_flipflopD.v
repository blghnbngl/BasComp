`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:42:18 08/31/2016
// Design Name:   flipflop_dataflow
// Module Name:   C:/Users/Bilgehan/Desktop/2016summer/basiccomputer/bascomp/testbench_flipflopD.v
// Project Name:  bascomp

// 
////////////////////////////////////////////////////////////////////////////////

module testbench_flipflopD;

	// Inputs
	reg ff_indata;
	reg clk;
	reg ff_en;
	reg ff_clr;
	reg reset;

	// Outputs
	wire ff_outdata;
	wire ff_outdata_bar;

	// Instantiate the Unit Under Test (UUT)
	flipflop_dataflow uut (
		.ff_indata(ff_indata), 
		.clk(clk), 
		.ff_en(ff_en), 
		.ff_clr(ff_clr), 
		.reset(reset), 
		.ff_outdata(ff_outdata), 
		.ff_outdata_bar(ff_outdata_bar)
	);

always
			begin
				#10 clk=~clk;
			end	
			

	initial begin
		// Initialize Inputs
		ff_indata = 0;
		reset = 0;
		ff_en = 0;
		ff_clr = 0;
		clk=0;

	
		// Wait 100 ns for global reset to finish
		#100;
		ff_en=1;
        
		// Add stimulus here
		#100;
		ff_indata = 1;
		#20; 
		if (ff_outdata!=1 && ff_outdata_bar!=0)
			begin
				$display("time:",$time,":Error in structured tests, ff_outdata should have been 1, ff_outdata:%b ff_outdata_bar: %b",
				ff_outdata,ff_outdata_bar);
			end
		#200;
		
		ff_indata = 0;
		#20;
		if (ff_outdata!=0 && ff_outdata_bar!=1)
			begin
				$display("time:",$time,":Error in structured tests, ff_outdata should have been 0, ff_outdata:%b ff_outdata_bar: %b",
				ff_outdata,ff_outdata_bar);
			end
		#200;
		
		ff_indata=1;
		#20; 
		if (ff_outdata!=1 && ff_outdata_bar!=0)
			begin
				$display("time:",$time,":Error in structured tests, ff_outdata should have been 1, ff_outdata:%b ff_outdata_bar: %b",
				ff_outdata,ff_outdata_bar);
			end
		#200;
		
		ff_clr=1;
		#20;
		if (ff_outdata!=0 && ff_outdata_bar!=1)
			begin
				$display("time:",$time,":Error in structured tests, ff_outdata should have been 0, ff_outdata:%b ff_outdata_bar: %b",
				ff_outdata,ff_outdata_bar);
			end
		#200;
			
		ff_clr=0;
		ff_en=0;
		ff_indata=1;
		#20;
		if (ff_outdata!=0 && ff_outdata_bar!=1)
			begin
				$display("time:",$time,":Error in structured tests, ff_outdata should have been 0, ff_outdata:%b ff_outdata_bar: %b",
				ff_outdata,ff_outdata_bar);
			end
			
		#200;
		ff_en=1;
		#20;
		if (ff_outdata!=1 && ff_outdata_bar!=0)
			begin
				$display("time:",$time,":Error in structured tests, ff_outdata should have been 1, ff_outdata:%b ff_outdata_bar: %b",
				ff_outdata,ff_outdata_bar);
			end
			
		#200;
		ff_en=0;
		ff_indata=0;
		#20;
		if (ff_outdata!=1 && ff_outdata_bar!=0)
			begin
				$display("time:",$time,":Error in structured tests, ff_outdata should have been 1, ff_outdata:%b ff_outdata_bar: %b",
				ff_outdata,ff_outdata_bar);
			end
		
		#200;
		ff_en=0;
		reset=1;
		#20;
		if (ff_outdata!=0 && ff_outdata_bar!=1)
			begin
				$display("time:",$time,":Error in structured tests, ff_outdata should have been 0, ff_outdata:%b ff_outdata_bar: %b",
				ff_outdata,ff_outdata_bar);
			end
		$display("Finishing test");
		$finish;
		

	end
      
endmodule

