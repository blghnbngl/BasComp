`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:49:01 09/01/2016
// Design Name:   t_ff
// Module Name:   C:/Users/Bilgehan/Desktop/2016summer/basiccomputer/bascomp/t_ff_testbench.v
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_ff_testbench;

	// Inputs
	reg clk;
	reg tff_indata;
	reg tff_clr;
	reg reset;
	reg tff_en;

	// Outputs
	wire tff_outdata;
	wire tff_outdata_bar;
	
	//For tests
	integer err;

	// Instantiate the Unit Under Test (UUT)
	t_ff uut (
		.clk(clk), 
		.tff_indata(tff_indata), 
		.tff_clr(tff_clr), 
		.reset(reset), 
		.tff_en(tff_en), 
		.tff_outdata(tff_outdata), 
		.tff_outdata_bar(tff_outdata_bar)
	);
	
	always
		begin
			#10 clk = ~clk;
		end	

	initial begin
		// Initialize Inputs
		clk = 0;
		tff_indata = 0;
		tff_clr = 0;
		reset = 0;
		tff_en = 0;
		err = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		tff_en=1;
		tff_indata = 1;					//Toggling from 0
		#20; 
		$display("Toggling from 0");
		if (tff_outdata!=1 && tff_outdata_bar!=0)
			begin
				$display("time:",$time,":Error in structured tests, tff_outdata should have been 1, tff_outdata:%b tff_outdata_bar: %b",
				tff_outdata,tff_outdata_bar);
				err = err +1;
			end
		
		tff_indata = 0;					//Preserving the same value
		#20;				
		$display("Indata is 0, present value should be preserved");
		if (tff_outdata!=1 && tff_outdata_bar!=0)
			begin
				$display("time:",$time,":Error in structured tests, tff_outdata should have been 1, tff_outdata:%b tff_outdata_bar: %b",
				tff_outdata,tff_outdata_bar);
				err = err +1;
			end
		
		tff_indata=1;					//Toggling from 1
		#20; 
		$display("Toggling from 1");
		if (tff_outdata!=0 && tff_outdata_bar!=1)
			begin
				$display("time:",$time,":Error in structured tests, tff_outdata should have been 0, tff_outdata:%b tff_outdata_bar: %b",
				tff_outdata,tff_outdata_bar);
				err = err +1;
			end
		
		tff_clr=1;						//Clearing
		#20;
		$display("Clearing");
		if (tff_outdata!=0 && tff_outdata_bar!=1)
			begin
				$display("time:",$time,":Error in structured tests, tff_outdata should have been 0, tff_outdata:%b tff_outdata_bar: %b",
				tff_outdata,tff_outdata_bar);
				err = err +1;
			end

		tff_clr=0;
		tff_en=0;
		tff_indata=1;					// FF Disabled, so should remain the same	
		#20;
		$display("FF disabled, so it should remain the same");
		if (tff_outdata!=0 && tff_outdata_bar!=1)
			begin
				$display("time:",$time,":Error in structured tests, tff_outdata should have been 0, tff_outdata:%b tff_outdata_bar: %b",
				tff_outdata,tff_outdata_bar);
				err = err +1;
			end
			
		tff_en=1;
		#20;								//Toggling from 0
		$display("Toggling from 0");
		if (tff_outdata!=1 && tff_outdata_bar!=0)
			begin
				$display("time:",$time,":Error in structured tests, tff_outdata should have been 1, tff_outdata:%b tff_outdata_bar: %b",
				tff_outdata,tff_outdata_bar);
				err = err +1;
			end
			
		
		tff_en=0;
		tff_indata=1;					//Disabled, should remain the same
		#20;
		$display("Disabled, should remain the same");
		if (tff_outdata!=1 && tff_outdata_bar!=0)
			begin
				$display("time:",$time,":Error in structured tests, tff_outdata should have been 1, tff_outdata:%b tff_outdata_bar: %b",
				tff_outdata,tff_outdata_bar);
				err = err +1;
			end
		
		#200;
		tff_en=0;
		reset=1;
		#20;
		if (tff_outdata!=0 && tff_outdata_bar!=1)
			begin
				$display("time:",$time,":Error in structured tests, tff_outdata should have been 0, tff_outdata:%b tff_outdata_bar: %b",
				tff_outdata,tff_outdata_bar);
				err = err +1;
			end
		$display("Finishing test, should be 0 if no errors, err: %d",err);
		$finish;
		
	end
      
endmodule

