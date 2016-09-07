`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Description: 
//
// Verilog Test Fixture created by ISE for module: fulladder
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//	Each possible 8 input combination is tried one by one.
//
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_fulladder;

	// Inputs
	reg input1;
	reg input2;
	reg carry_in;

	// Outputs
	wire carry_out;
	wire sum;
	
	//For tests
	integer err;
	integer res;

	// Instantiate the Unit Under Test (UUT)
	fulladder uut (
		.input1(input1), 
		.input2(input2), 
		.carry_in(carry_in), 
		.carry_out(carry_out), 
		.sum(sum)
	);

	initial begin
		// Initialize Inputs
		input1 = 0;
		input2 = 0;
		carry_in = 0;
		err=0;
		res=0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		input1 = 0;
		input2 = 0;
		carry_in = 0;
		
		$display("Testing input1 = 0, input2 = 0,	carry_in = 0");
		if (carry_out!=0 && sum!=0)
			begin
				$display("time:",$time,":Error in structured tests, carry_out should have been 0, sum should have been 0, carry_out:%b sum: %b",
				carry_out,sum);
				err = err +1;
			end
		

		input1 = 0;
		input2 = 0;
		carry_in = 1;
		
		#1;
		
		$display("Testing: input1 = 0, input2 = 0, carry_in = 1");
		if (carry_out!=0 && sum!=1)
			begin
				$display("time:",$time,":Error in structured tests, carry_out should have been 0, sum should have been 1, carry_out:%b sum: %b",
				carry_out,sum);
				err = err +1;
			end


		input1 = 0;
		input2 = 1;
		carry_in = 0;
		
		#1;
		
		$display("Testing: input1 = 0, input2 = 1, carry_in = 0");
		if (carry_out!=0 && sum!=1)
			begin
				$display("time:",$time,":Error in structured tests, carry_out should have been 0, sum should have been 1, carry_out:%b sum: %b",
				carry_out,sum);
				err = err +1;
			end
		
		input1 = 1;
		input2 = 0;
		carry_in = 0;
		
		#1;
		
		$display("Testing: input1 = 1, input2 = 0, carry_in = 0");
		if (carry_out!=0 && sum!=1)
			begin
				$display("time:",$time,":Error in structured tests, carry_out should have been 0, sum should have been 1, carry_out:%b sum: %b",
				carry_out,sum);
				err = err +1;
			end
		
		input1 = 0;
		input2 = 1;
		carry_in = 1;
		
		#1;
		
		$display("Testing: input1 = 0, input2 = 1, carry_in = 1");
		if (carry_out!=1 && sum!=0)
			begin
				$display("time:",$time,":Error in structured tests, carry_out should have been 1, sum should have been 0, carry_out:%b sum: %b",
				carry_out,sum);
				err = err +1;
			end

		input1 = 1;
		input2 = 0;
		carry_in = 1;
		
		#1;
		
		$display("Testing: input1 = 1, input2 = 0, carry_in = 1");
		if (carry_out!=1 && sum!=0)
			begin
				$display("time:",$time,":Error in structured tests, carry_out should have been 1, sum should have been 0, carry_out:%b sum: %b",
				carry_out,sum);
				err = err +1;
			end

		input1 = 1;
		input2 = 1;
		carry_in = 0;
		
		#1;
		
		$display("Testing: input1 = 1, input2 = 1, carry_in = 0");
		if (carry_out!=1 && sum!=0)
			begin
				$display("time:",$time,":Error in structured tests, carry_out should have been 1, sum should have been 0, carry_out:%b sum: %b",
				carry_out,sum);
				err = err +1;
			end

		input1 = 1;
		input2 = 1;
		carry_in = 1;
		
		#1;
		
		$display("Testing: input1 = 1, input2 = 1, carry_in = 1");
		if (carry_out!=1 && sum!=0)
			begin
				$display("time:",$time,":Error in structured tests, carry_out should have been 1, sum should have been 1, carry_out:%b sum: %b",
				carry_out,sum);
				err = err +1;
			end
		
		#1;
		
		if (err == 0) res = res + 1;
			begin
				$display("Test is over, showing result. Should be zero if test is successful: err %d",err);
				$finish;
			end
		$finish;
			
	end
      
endmodule

