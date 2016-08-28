`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Flip Flop (ff)
//
//	Between 116-171, structured tests are done, that is all possible operations are tried one by one. 173-174
//	tells that random tests have started and they decide the amount of random tests that will be done. Between
//	65-94 there is random tests code. A random set of inputs is given every time and the results are checked.
//	Random test inputs are given in negative edge because the ff circuit works at positive edges. So, giving
// inputs in negative edge gives ff enough time to digest them and give outputs before the next negative
// edge.
////////////////////////////////////////////////////////////////////////////////

module testbench_ff;

	// Inputs
	reg clk;
	reg e_indata;
	reg e_clr;
	reg reset;
	reg ff_en;

	// Outputs
	wire e_outdata;
	
	//Error detection
	integer err;			//Error term to see mistakes in structured tests.
	integer err2;			//Error term to see mistakes in random tests.
	integer res;
	
	//For random tests
	integer j;
	reg [31:0] randomlarge;					
	reg randomcommand1;
	reg randomcommand2;
	reg randomcommand3;
	reg priordata;
	reg randomindata;
	reg clockk;
	reg clockworker;

	// Instantiate the Unit Under Test (UUT)
	ff uut (
		.clk(clk), 
		.e_indata(e_indata), 
		.e_clr(e_clr), 
		.reset(reset), 
		.ff_en(ff_en), 
		.e_outdata(e_outdata)
	);

	always
		begin
			#10 clk = ~clk;
		end		
		
	always @*					//This is to delay the random tests becuase structured tests need to be done first.
		clockk=clk & clockworker ;	//This clockk has the same frequency and same period (20 seconds) with clk.
	
	always @(negedge clockk)	//RANDOM TESTS ARE DONE HERE
		begin
			if (clockworker==1)
				begin
					j=j+1;
					priordata = e_outdata;
					randomlarge=$random;
					randomcommand1= randomlarge[0];
					randomcommand2= randomlarge[1];
					randomcommand3= randomlarge[2];
					randomindata=randomlarge[3];
				
					reset = randomcommand1;
					ff_en = randomcommand2;
					e_clr = randomcommand3;
					e_indata = randomindata;
				
					$display("Random testing %d", j);
					#12;
/*$display("time:",$time,"j: %d, reset: %b, ff_en: %b, e_clr: %b, e_indata: %b, e_outdata: %b, priordata: %b",
j,reset,ff_en, e_clr, e_indata, e_outdata, priordata);*/
					if (((reset==1 && e_outdata==0) || (reset==0 && ff_en==1 && e_clr==0 && 
					e_outdata==e_indata) || (reset==0 && ff_en==1 && e_clr==1 && e_outdata==0) || 
					(reset==0 && ff_en==0 && e_outdata==priordata))!=1)
						begin
								$display("time:",$time,":Error in Random testing No %d",j);
								err2=err2+1;	
						end
				end
		end
		
	initial begin
		// Initialize Inputs
		clk = 0;
		e_indata = 0;
		e_clr = 0;
		reset = 0;
		ff_en = 0;
		err = 0;
		err2 = 0;
		j = 0;
		clockk=0;
		clockworker=0;
		randomcommand1= 0;
		randomcommand2= 0;
		randomcommand3= 0;
		randomindata= 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        		
		// Add stimulus here
		#10;
		ff_en = 1;

		e_indata=0;			//Putting in 0 is tested
		#20
		$display("time:",$time,":Testing loading %d to ff",e_indata);		
		if (e_outdata !=0)
					begin
						$display("time:",$time,":Error loading %d to ff , %b should have been %b",
						e_indata, e_outdata, e_indata );
						err=1;
					end
						
		e_indata=1;			//Putting in 1 is tested
		#20
		$display("time:",$time,":Testing loading %d to ff",e_indata);		
					
		if (e_outdata !=1)
					begin
						$display("time:",$time,":Error loading %d to ff , %b should have been %b",
						e_indata, e_outdata, e_indata);
						err=1;
					end

		e_clr=1;				//Clearing is tested.
		#20
			$display("time:",$time,":Testing clearing ff");		
		if (e_outdata !=0)
					begin
						$display("time:",$time,":Error clearing ff, %b should have been 0", e_outdata,);
						err=1;
					end
			
		e_clr=0;
		e_indata=1;			//Put 1 inside
		#20
		$display("time:",$time,":Testing loading %d to ff",e_indata);		
		if (e_outdata !=1)
					begin
						$display("time:",$time,":Error loading %d to ff , %b should have been %b",
						e_indata, e_outdata, e_indata);
						err=1;
					end

		e_indata=1;
		reset=1;				//Resetting is tested.
		$display("time:",$time,":Testing resetting ff");		
		#20;
		if (e_outdata !=0)
					begin
						$display("time:",$time,":Error resetting ff, %b should have been 0", e_outdata,);
						err=1;
					end
					
		#10;
		
		clockworker=1;
		#30000;									//This time defines the number of random tests.
		
		clockworker=0;
		#100;
		if (err+err2 == 0) res = res + 1;
			begin
				$display("Test is over, showing result. Should be zero if test is successful: err %d, err2 %d",
				err,err2);
				$finish;
			end
			$display("Test is over, but there are mistakes:err %d, err2 %d",err,err2);
			$finish;
					
	end
      
endmodule

