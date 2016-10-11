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
// Between 101-120, memory is initalized and every single memory place is filled by the number of its adress.
// Between 126-141, these are checked one-by-one, in order. Read command is given, and if the outdata 
// of memory module is not equal to the address number, then an error signal is given.
// Between 79-99, random tests are done. A random number is put into a random adress. Write signal is given
// and system waits 25 seconds for memory to write it. Then the write signal is turned to read signal and 
// system waits another 25 seconds. If outdata is not equal to what was written in, system gives an error message.
// What's important here is, for the random tests I need another clock which is slower than the original 
// clock that gets into the memory module. Here, the original clk has a period of 20 seconds, clockk has
// a period of 20 seconds, clockk2 has a period of 40 seconds and clockk3 has a period of 80 seconds. 
// The final 80 seconds is larger than 50 seconds(25x2) required for random tests,clockk3 is used in line 79.
// Number of random tests is determined by the time delay in line 149.
////////////////////////////////////////////////////////////////////////////////

module testbench_memory;

	// Inputs
	reg [11:0] adress;
	reg read;
	reg write;
	reg [15:0] indata;
	reg clk;

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
	
	//For the random tests. I need three different clocks, because I 
	integer j;
	reg clockk;
	reg clockkworker;
	reg clockk2;
	reg clockk3;

	// Instantiate the Unit Under Test (UUT)
	memory uut (
		.adress(adress), 
		.read(read), 
		.write(write), 
		.indata(indata),
		.clk(clk),	
		.outdata(outdata)
	);
	
	always
		begin
			#10 clk = ~clk;
		end

	always @*			//This is to delay the random tests becuase structured tests need to be done first.
		clockk=clk & clockkworker ;		//This clockk has the same frequency and same period (20 seconds) with clk.
	
	always @(posedge clockk)
		clockk2 = ~clockk2;				//clockk2 has half the frequency and twice the period of clk, ie. 40 sec.
		
	always @(posedge clockk2)	//clockk3 has half the frequency and twice the period of clockk2, ie. 80 sec.
		clockk3 = ~clockk3;
	
	//Code for the random tests
	always @(posedge clockk3)	//I had to use clockk3 with 80 seconds period.
			begin
				j=j+1;
				$display("Random testing %d", j);
				randomlarge=$random;
				randomlarge2=$random;
				adress = randomlarge[11:0];
				indata=randomlarge2[15:0];
				read=0;
				write=1;
				#25;
				write=0;
				read=1;
				#25;
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
		clockkworker=1'b0;
		clockk=1'b0;
		clockk2=1'b0;
		clockk3=1'b0;
		
		#10;
		write=1;
		for (i=0; i<4096; i=i+1)		//Here I put the adress number in every adress.
			begin								// That is, in jth place in memory, there will be number j.
					adress=i;
					indata=i;
					#20;
			end
		
		// Wait 20 ns for global reset to finish
		#20;
		
		// Add stimulus here. Now, the test.
		write=0;
      read=1; 
		for (i=0; i<4096; i=i+1)
			begin
				#5
				$display("Testing for outdata of memory place %d",i);
				adress = i;
				#20;
				if (outdata !=i)
					begin
						$display("time:",$time,":Error getting adress %d , %b should have been %b",
						i, outdata, i );
						err=2;
					end
			end
		
		// Now, random replacement of memory data and to test whether these random data comes out.
		
		#20;
		clockkworker=1;
		
				
		#300000; 	//Random testing ends. Until time is filled, it does 3750 random tests. 
						// To change the number of random tests, this delay time should be changed.
		if (err == 0) res = res + 1;
				begin
					$display("Test is over, showing result. Should be zero if test is successful: err %d, err2 %d",
					err, err2);
					$finish;
				end
			$finish;
		
		

	end
      
endmodule

