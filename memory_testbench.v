`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:43:27 08/06/2016
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_memory;

	// Inputs
	reg [11:0] adress;
	reg read;
	reg write;
	reg [15:0] indata;

	// Outputs
	wire [15:0] outdata;
	integer res = 0;
	integer err = 0;				// Error flag for structured inputs.
	integer err2 = 0;				// Error flag error for random inputs.

	//For the loop
	integer i;
	
	// Random number register
	reg [31:0] randomlarge;
	reg [31:0] randomlarge2;			//First one is to randomize adress, second one is to randomize inputs.
	
	//For the random tests 
	integer j;
	reg clk;
	reg clock;
	reg clockworker;

	// Instantiate the Unit Under Test (UUT)
	memory uut (
		.adress(adress), 
		.read(read), 
		.write(write), 
		.indata(indata), 
		.outdata(outdata)
	);
	
	always
		begin
			#10 clk = ~clk;
		end
		
	always @*			//This is to delay the random tests becuase structured tests need to be done first.
		clock=clk & clockworker;
		
	//Code for the random tests
	always @(posedge clock)
			begin
				j=j+1;
				$display("Random testing %d", j);
				randomlarge=$random;
				randomlarge2=$random;
				adress = randomlarge[3:0];
				indata=randomlarge2[15:0];
				read=0;
				write=1;
				#1;
				write=0;
				read=1;
				#1;
				if (outdata != randomlarge2[15:0])
					begin
						$display("time:",$time,":Error in Random testing No %d, outdata %b should have been %b",
									j, outdata, randomlarge2[15:0]);
						err2=2;				//err2 is the error for random tests.
					end
			end

	initial begin
		// Initialize Inputs
		adress = 0;
		read = 0;
		write = 0;
		indata = 0;
		clk= 1'b0;
		j=0;
		clockworker=1'b0;
		
		#10;
		write=1;
		for (i=0; i<4096; i=i+1)		//Here I put the adress number in every adress.
			begin								// That is, in jth place in memory, there will be number j.
					adress=i;
					indata=i;
			end
		
		// Wait 100 ns for global reset to finish
		#20;
		
		// Add stimulus here. Now, the test.
		write=0;
      read=1; 
		for (i=0; i<4096; i=i+1)
			begin
				#5
				$display("Testing for outdata of memory place %d",i);
				adress = i;
				#1;
				if (outdata !=i)
					begin
						$display("time:",$time,":Error getting adress %d , %b should have been %b",
						i, outdata, i );
						err=2;
					end
			end
		
		// Now, random replacement of memory data and to test whether these random data comes out.
		
		#20;
		clockworker=1;
		
				
		#30000; 	//Random testing ends.
		
		if (err == 0) res = res + 1;
				begin
					$display("Test is over, showing result. Should be zero if test is successful: err %d, err2 %d",
					err, err2);
					$finish;
				end
			$finish;
		
		

	end
      
endmodule

