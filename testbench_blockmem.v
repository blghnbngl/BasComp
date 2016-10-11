`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:58:38 10/09/2016
// Design Name:   blockmem
// Module Name:   C:/Users/Bilgehan/Desktop/2016summer/basiccomputer/bascomp/testbench_blockmem.v
// Project Name:  bascomp
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: blockmem
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_blockmem;

	// Inputs
	reg clka;
	reg [0:0] wea;
	reg [11:0] addra;
	reg [15:0] dina;

	// Outputs
	wire [15:0] douta;

	integer res = 0;
	integer err = 0;				// Error flag for structured inputs.
	integer err2 = 0;				// Error flag error for random inputs.

	//For the loop
	integer i;
	
	// Random number register
	reg [31:0] randomlarge;
	reg [31:0] randomlarge2;			//First one is to randomize addra, second one is to randomize inputs.
	
	//For the random tests. I need three different clocks, because I 
	integer j;
	reg clockk;
	reg clockkworker;
	reg clockk2;
	reg clockk3;
	reg mem_write;
	reg mem_read;
	
	// Instantiate the Unit Under Test (UUT)
	blockmem uut (
		.clka(clka), 
		.wea(mem_write & ~mem_read), 
		.addra(addra), 
		.dina(dina), 
		.douta(douta)
	);
	
	
	always
		begin
			#10 clka = ~clka;
		end

	always @*			//This is to delay the random tests becuase structured tests need to be done first.
		clockk=clka & clockkworker ;		//This clockk has the same frequency and same period (20 seconds) with clk.
	
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
				addra = randomlarge[11:0];
				dina=randomlarge2[15:0];
				mem_read=0;
				mem_write=1;
				#25;
				mem_write=0;
				mem_read=1;
				#25;
				if (douta != randomlarge2[15:0])
					begin
						$display("time:",$time,":Error in Random testing No %d, douta %b should have been %b",
									j, douta, randomlarge2[15:0]);
						err2=2;				//err2 is the error for random tests.
					end
			end


	initial begin
		// Initialize Inputs
		clka = 0;
		addra = 0;
		dina = 0;
		mem_read = 0;
		mem_write = 0;
		j=0;
		clockkworker=1'b0;
		clockk=1'b0;
		clockk2=1'b0;
		clockk3=1'b0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
	
	
		#10;
		mem_write=1;
		for (i=0; i<4096; i=i+1)		//Here I put the addra number in every addra.
			begin								// That is, in jth place in memory, there will be number j.
					addra=i;
					dina=i;
					#20;
			end
		
		// Wait 20 ns for global reset to finish
		#20;
		
		// Add stimulus here. Now, the test.
		mem_write=0;
      mem_read=1; 
		for (i=0; i<4096; i=i+1)
			begin
				#5
				$display("Testing for douta of memory place %d",i);
				addra = i;
				#20;
				if (douta !=i)
					begin
						$display("time:",$time,":Error getting addra %d , %b should have been %b",
						i, douta, i );
						err=2;
					end
			end
		
		// Now, random replacement of memory data and to test whether these random data comes out.
		
		#20;
		clockkworker=1;
		
				
		#3000; 	//Random testing ends. Until time is filled, it does 3750 random tests. 
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

