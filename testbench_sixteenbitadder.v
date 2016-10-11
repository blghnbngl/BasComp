`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
//
// Create Date:   23:11:37 09/07/2016
// Design Name:   sixteenbitadder
// Description: 
//
// Verilog Test Fixture created by ISE for module: sixteenbitadder
// Revision 0.01 - File Created
// Additional Comments:
//
//	Here sixteenbitadder is tested. In all tests, there are random inputs. Time limit in line 83 determines
//	the number of random tests, which is 1500 here. 
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_sixteenbitadder;

	// Inputs
	reg [15:0] sixteenbitinput1;
	reg [15:0] sixteenbitinput2;

	// Outputs
	wire [15:0] sixteenbitsum;
	wire sixteenbitcarry_out;

	//For tests
	reg clk;					//A clock that will be used to get random inputs
	reg [31:0] randomlarge;			
	reg [31:0] randomlarge2;
	integer err;
	integer j;
	integer res;
	
	// Instantiate the Unit Under Test (UUT)
	sixteenbitadder uut (
		.sixteenbitinput1(sixteenbitinput1), 
		.sixteenbitinput2(sixteenbitinput2), 
		.sixteenbitsum(sixteenbitsum), 
		.sixteenbitcarry_out(sixteenbitcarry_out)
	);

	
	always
		begin
			#10 clk = ~clk;
		end
	
	always @(posedge clk)	//RANDOM TESTS ARE DONE HERE
			begin
				j=j+1;
				randomlarge=$random;
				randomlarge2=$random;
				sixteenbitinput1 = randomlarge[15:0];		//Random inputs are put into the adder module
				sixteenbitinput2 = randomlarge2[15:0];
				$display("Random testing %d", j);
				#1;
				if ({sixteenbitcarry_out,sixteenbitsum} != sixteenbitinput1 + sixteenbitinput2)
						begin
							$display("time:",$time,":Error in Random testing No %d, output is: %b, input1:%b, input2:%b",
									j, {sixteenbitcarry_out,sixteenbitsum}, sixteenbitinput1, sixteenbitinput2);			
							err=err +1;				
						end		
			end
				

	initial begin
		// Initialize Inputs
		sixteenbitinput1 = 0;
		sixteenbitinput2 = 0;
		clk=0;
		j=0;
		err=0;
		res=0;

		// Wait 5 ns for global reset to finish
		#5;
        
		// Add stimulus here
		
		#30000;
		if (err == 0) res = res + 1;
			begin
				$display("Test is over, showing result. Should be zero if test is successful: err %d",err);
				$finish;
			end
		$finish;
	end
      
endmodule

