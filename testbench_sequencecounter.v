`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:14:35 08/27/2016
// Design Name:   sequencecounter
//
// 
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_sequencecounter;

	// Inputs
	reg clk;
	reg inc;
	reg clr;

	// Outputs
	wire [3:0] sequence;
	
	//For loops
	integer i;
	
		//For random tests
	integer j;
	reg [31:0] randomlarge;	
	reg [3:0] priordata;
	reg randomcommand1;
	integer commandnumber;
	reg clockk;
	reg clockworker;
	
	//Error detection
	integer err;			//Error term to see mistakes in loading process
	integer err2;			//Error term to see mistakes in clearing process
	integer err3;			//Error term to see mistakes in random testing process
	integer res;
	
	// Instantiate the Unit Under Test (UUT)
	sequencecounter uut (
		.clk(clk), 
		.inc(inc), 
		.clr(clr), 
		.sequence(sequence)
	);
	
	always
		begin
			#10 clk =~clk;
		end
		
	always @*					//This is to delay the random tests becuase structured tests need to be done first.
		clockk=clk & clockworker ;	//This clockk has the same frequency and same period (20 seconds) with clk.

	always @(posedge clockk)	//RANDOM TESTS ARE DONE HERE
			begin
				j=j+1;
				priordata=sequence;
				randomlarge=$random;
				randomcommand1= randomlarge[0];
				if (randomcommand1==0) //This is the inc command
					begin
						inc=1;
						clr=0;
						commandnumber=1;
						$display("Random testing %d, command no %d: 1-inc, 2-clr", j,commandnumber);
					end
				else if (randomcommand1==1) //This is the clear command
					begin
						inc=0;
						clr=1;
						commandnumber=2;
						$display("Random testing %d, command no %d: 1-inc, 2-clr", j,commandnumber);
					end	
				#11;
				//$display("priordata %b, indata %b, sequence %b", priordata, randomlarge[31:16], sequence);
				if ( (((sequence==((priordata+1)%16)) && (commandnumber==1)) || 
				((sequence==0) && (commandnumber==2))) !=1 )
					begin
						$display("time:",$time,":Error in Random testing No %d, command is %d: 1-inc, 2-clr",
									j, commandnumber);
						
					$display("priordata %b, indata %b, sequence %b", priordata, randomlarge[31:16], sequence);
						err3=err3+1;				//err4 is the error for random tests.
					end
			end

	initial begin
		// Initialize Inputs
		clk = 0;
		inc = 0;
		clr = 0;
		i = 0;
		j = 0;
		err = 0;
		err2 = 0;
		err3 = 0;
		res = 0;
		clockworker=0;
		
		// Wait 100 ns for global reset to finish
		#100;
       
		
		// Add stimulus here
		#10;
		inc=1;
		for (i=0;i<1000;i=i+1)
			begin
				$display("Testing sequence for incrementing %dth time",i+1);
				#20;
				if (sequence !=((i+1)%16))
						begin
							$display("time:",$time,":Error incrementing %dth time , %b should have been %b",
							i+1, sequence, ((i+1)%16) );
							err=1;
						end		
			end
			
		inc=0;					//Clear is tested for once here.
		clr=1;
		$display("Testing for clear %b",sequence);
		#20;	
		if (sequence !=0)
						begin
							$display("time:",$time,":Error in clearing, %b should have been 0", sequence);	
							err2=1;
						end
						
		#20;
			
		clockworker=1;
		#30000;									//This time defines the number of random tests.
		
		clockworker=0;
		#100;
		if (err+err2+err3 == 0) res = res + 1;
			begin
				$display("Test is over, showing result. Should be zero if test is successful: err %d, err2 %d err3 %d",
				err,err2,err3);
				$finish;
			end
			$display("Test is over, but there are mistakes:err %d, err2 %d, err3 %d",err,err2,err3);
			$finish;

	end
      
endmodule

