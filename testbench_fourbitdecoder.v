`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// Verilog Test Fixture created by ISE for module: fourbitdecoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 	As you can see, tests are evolving as time goes on. Rather than rather each 16 case one by one, I 
//    wrote the first two seperately and put the remaining 14 in a for loop. Also, now the number of random
//    tests is much larger and this number is limited with time (600 nanoseconds as denoted in line 134). 
// 	That time span is enough for 30 random tests. Module seems to pass both random and predetermined 
// 	tests correctly. 
////////////////////////////////////////////////////////////////////////////////

module testbench_fourbitdecoder;

	// Inputs
	reg [3:0] code;

	// Outputs
	wire [15:0] times;
	integer res = 0;
	integer err = 0;

	// Random number register
	reg [31:0] randomlarge;
	
	//For the random tests 
	integer j;
	reg clockworker;
	
	//For the loop to complete all 16 cases
	integer i;
	


	//Clocks
	reg clk;
	reg clock;
	
	// Instantiate the Unit Under Test (UUT)
	fourbitdecoder uut (
		.code(code), 
		.times(times)
	);
	
	always
		begin
			#10 clk = ~clk;
		end
		
	always @*
		clock=clk & clockworker;
		
	//Code for the random tests
	always @(posedge clock)
			begin
				#10;
				j=j+1;
				$display("Random testing %d", j);
				randomlarge=$random;
				code = randomlarge[3:0];
				#1;
				if (times != 2**(randomlarge[3]*8 + randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]))
					begin
						$display("time:",$time,":Error in Random testing No %d, times %b should have been %b",
									j, times, 2**(randomlarge[3]*8 + randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]));
						err=2;
					end
			end
	
	//Now the tests follow. 	
	
	initial begin
		// Initialize Inputs
		code = 0;
		clk= 1'b0;
		j=0;
		clockworker=1'b0;
		
		// Wait 10 ns for global reset to finish
		#10;
        
		// Add stimulus here
		
		$display("Starting Testbench");
		//initial values take place in the above part
		//From here on to line 133, all cases will be tried in order.
		
		#20;
		$display("Testing for times 15");
		code = 4'b1111;
		#1;
		if (times != 16'b1000000000000000)
		begin
				$display("time:",$time,":Error getting times15, %b should have been 16'b1000000000000000",times);
				err=2;
		end
		
		#20;
		$display("Testing for times 14");
		code = 4'b1110;
		#1;
		if (times != 16'b0100000000000000)
		begin
				$display("time:",$time,":Error getting times14, %b should have been 16'b0100000000000000",times);
				err=2;
		end
		
		for (i=13; i>=0; i=i-1)
			begin
				#20;
				$display("Testing for times %d",i);
				code = i;
				#1;
				if (times != 2**(i[3]*8 + i[2]*4 + i[1]*2 + i[0]))
					begin
						$display("time:",$time,":Error getting times %d , %b should have been %b",
						i, times, 2**(i[3]*8 + i[2]*4 + i[1]*2 + i[0]) );
						err=2;
					end
			end
		
		//Random testing begins
		#20;
		clockworker=1;
		
				
		#600; 	//Random testing ends.
		
			if (err == 0) res = res + 1;
				begin
					$display("Test is over, showing result. Should be zero if test is successful: %d", err);
					$finish;
				end
			$finish;

	end


      
endmodule

