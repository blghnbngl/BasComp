`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
//
// Create Date:   17:43:27 08/25/2016
//
//	Between 113-183, structured tests are done.That is, first every possible number is loaded one by one,then
//	every possible number is incremented and the results are checked. In lines 184-185, it tells that for 
// 30000 seconds, random tests are done. The code for random tests is between 67-111. It starts in negedge
// clock because as it gets random inputs in the negative edge, it can give out the outputs in the next 
// positive edge. 
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_register;

	// Inputs
	reg clk;
	reg load;
	reg inc;
	reg clr;
	reg [15:0] indata;

	// Outputs
	wire [15:0] outdata;
	
	//For loops
	integer i;
	
	//For random tests
	reg [31:0] randomlarge;			
	reg [31:0] randomlarge2;			
	reg randomcommand1;
	reg randomcommand2;
	reg [15:0] randomindata;
	integer j;
	integer commandnumber;
	reg clockk;
	reg clockworker;
	reg [15:0] priordata;
		
	//Error detection
	integer err;			//Error term to see mistakes in loading process
	integer err2;			//Error term to see mistakes in incrementing process
	integer err3;			//Error term to see mistakes in clearing process
	integer err4;			//Error term to see mistakes in random testing process
	integer res;

	// Instantiate the Unit Under Test (UUT)
	register uut (
		.clk(clk), 
		.load(load), 
		.inc(inc), 
		.clr(clr), 
		.indata(indata), 
		.outdata(outdata)
	);
	
	always
		begin
			#10 clk = ~clk;
		end
		
	always @*					//This is to delay the random tests becuase structured tests need to be done first.
		clockk=clk & clockworker ;	//This clockk has the same frequency and same period (20 seconds) with clk.
	
	always @(negedge clockk)	//RANDOM TESTS ARE DONE HERE
			begin
				j=j+1;
				priordata=outdata;
				randomlarge=$random;
				randomlarge2=$random;
				randomcommand1= randomlarge[0];
				randomcommand2= randomlarge2[0];
				randomindata=randomlarge[31:16];
				if (randomcommand1==0 && randomcommand2==1) //This is the load command
					begin
						inc=0;
						clr=0;
						load=1;
						indata=randomindata;
						commandnumber=1;
						$display("Random testing %d, command no %d: 1-load, 2-clr, 3-inc", j,commandnumber);
					end
				else if (randomcommand1==0 && randomcommand2==0) //This is the clear command
					begin
						inc=0;
						clr=1;
						load=0;
						commandnumber=2;
						$display("Random testing %d, command no %d: 1-load, 2-clr, 3-inc", j,commandnumber);
					end
				else if (randomcommand1==1) //This is the increment command
					begin
						inc=1;
						clr=0;
						load=0;
						commandnumber=3;
						$display("Random testing %d, command no %d: 1-load, 2-clr, 3-inc", j,commandnumber);
					end
				#12;
				//$display("priordata %b, indata %b, outdata %b", priordata, randomlarge[31:16], outdata);
				if ((((outdata==randomlarge[31:16]) && (commandnumber==1)) || ((outdata==0) && (commandnumber==2))
					|| ((outdata==priordata+1) && (commandnumber==3))) !=1 )
					begin
						$display("time:",$time,":Error in Random testing No %d, command is %d: 1-load, 2-clr, 3-inc",
									j, commandnumber);
					//	$display("priordata %b, indata %b, outdata %b", priordata, randomlarge[31:16], outdata);
						err4=err4+1;				//err4 is the error for random tests.
					end
			end
			
	initial begin				//Structural tests below
		// Initialize Inputs
		clk = 0;
		load = 0;
		inc = 0;
		clr = 0;
		indata = 0;
		clockworker=0;
		commandnumber=0;
		j=0;
		err=0;				
		err2=0;				
		err3=0;
		err4=0;
		res=0;

		// Wait 100 ns for global reset to finish
		#100;
       
		// Add stimulus here
		load=1;				//In the below for, I load every single number between 2^16-1 and 0, and check whether
								// output is correct. Load command is tested		
		for (i=2**16-1;i>=0;i=i-1)
			begin
				$display("Testing for outdata for loading %d",i);
				indata=i;
				#20;
				if (outdata !=i)
						begin
							$display("time:",$time,":Error loading %d , %b should have been %b",
							i, outdata, i );
							err=1;
						end
			end

		load=0;					//Clear is tested for once here.
		clr=1;
		$display("Testing for clear %b",outdata);
		#20;	
		if (outdata !=0)
						begin
							$display("time:",$time,":Error in clearing , %b should have been 0", outdata);	
							err3=1;
						end
		#20;
		
		//Below, the increment command is tested. 
		clr=0;
		inc=1;
		for (i=0;i<2**16-1;i=i+1)
			begin
				#20;
				$display("Testing for incrementing %d",i);
				if (outdata !=i+1)
						begin
							$display("time:",$time,":Error in increment %d , %b should have been %b",
							i, outdata, i+1 );
							err2=1;
						end
			end
			
		inc=0;					//Clear is tested for once here.
		clr=1;
		$display("Testing for clear %b",outdata);
		#20;	
		if (outdata !=0)
						begin
							$display("time:",$time,":Error in clearing , %b should have been 0", outdata);	
							err3=1;
						end
		clockworker=1;
		#30000;									//This time defines the number of random tests.
		
		clockworker=0;
		#100;
		if (err+err2+err3+err4 == 0) res = res + 1;
			begin
				$display("Test is over, showing result. Should be zero if test is successful: err %d, err2 %d err3 %d err4 %d",
				err,err2,err3,err4);
				$finish;
			end
			$display("Test is over, but there are mistakes:err %d, err2 %d, err3 %d, err4 %d",err,err2,err3, err4);
			$finish;

	end
      
endmodule

