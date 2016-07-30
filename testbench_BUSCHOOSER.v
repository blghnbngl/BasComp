`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: bascompsemibehavioral
// Engineer: Bilgehan
//
// Create Date:   23:23:11 07/29/2016
// Design Name:   buschooser
// Module Name:   C:/Users/Bilgehan/Desktop/2016summer/basiccomputer/bascomp/testbench_BUSCHOOSER.v
// Project Name:  bascomp
//
// Verilog Test Fixture created by ISE for module: buschooser
// NOTES: 
// 1) I deliberately chose a different name than the previous version to compare and use the best parts of both.
//
// 2) The main difference with previous version is changing signals with time, without it the testbench
// would not work.
//
// 3) There MIGHT be a PROBLEM: I included two more delay in lines 102 and 112 for the circuit to digest
// the input it takes. The existence of the delay in line 102 did not make any difference, so I turned it 
// into a comment. You can take the comment line out of it and see nothing changes.
// However, #1 delay in line 112 is necessary, because without it a wrong result comes out. Probably this is
// because after the bus_code is sent, the circuit needs some time to give the output, and without a 
//specified delay it directly gives out what was in it earlier (the result of previous bus_code).  
// 
// Why this might be a problem? Like many others, bus_chooser is a totally combinational circuit. Such a 
//problem  in timing might affect many modules and interfere with the total working of the system.
//
//	Why this might not be a problem? The control module deliberately sends the bus_code first, and the load
// signal second. If the time span for control module to send a signal is smaller than the time required for
// bus chooser to pick its output, then everthing should work fine.
//
// For now, I personally think that the second option is more likely. However, this should be tested in 
// another testbench that is testing the whole structure, ie. main module. But this is an issue of the 
// future, we should test smaller modules before the main.
// So for this testbench, we should put a small delay after each bus_code change for the circuit to analyze
// its inputs (like in line 112)
//
// UPDATE 1: a) For this timing problem, adding even a 1 timescale delay seems to be enough to solve the 
//problem. It looks like this is an instantenous problem, so I guess this will not create any problems
// for the overall structure of the basic computer.
// b) I added 8 more tests that take random inputs. They are in between lines 170-260.
////////////////////////////////////////////////////////////////////////////////

module testbench_BUSCHOOSER;

	// Inputs
	reg [2:0] bus_code;
	reg [11:0] ar_outdata;
	reg [11:0] pc_outdata;
	reg [15:0] dr_outdata;
	reg [15:0] ac_outdata;
	reg [15:0] ir_outdata;
	reg [15:0] tr_outdata;
	reg [15:0] mem_outdata;

	// Outputs
	wire [15:0] bus_data;
	integer res = 0;
	integer err = 0;

	// Random number register
	reg [31:0] randomlarge;
	
	// Instantiate the Unit Under Test (UUT)
	buschooser uut (
		.bus_code(bus_code), 
		.ar_outdata(ar_outdata), 
		.pc_outdata(pc_outdata), 
		.dr_outdata(dr_outdata), 
		.ac_outdata(ac_outdata), 
		.ir_outdata(ir_outdata), 
		.tr_outdata(tr_outdata), 
		.mem_outdata(mem_outdata), 
		.bus_data(bus_data)
	);

	initial begin
		// Initialize Inputs
		ar_outdata = 11'b00000000001;
		pc_outdata = 11'b00000000010;
		dr_outdata = 15'b000000000000011;
		ac_outdata = 15'b000000000000100;
		ir_outdata = 15'b000000000000101;
		tr_outdata = 15'b000000000000110;
		mem_outdata = 15'b000000000000111;

		// Wait 10 ns for global reset to finish
		#10;
        
		// Add stimulus here

	end
	
	initial begin
	$display("Starting Testbench");
		//initial values
		
		#20;
		$display("Testing for 7");
		bus_code = 3'b111;
		//#5;
		if (bus_data != 15'b000000000000111)
		begin
				$display("time:",$time,":Error getting mem_outdata, bus_data %b should be 15'b000000000000111",bus_data);
				err=2;
		end
		
		#20;
		$display("Testing for 6");
		bus_code = 3'b110;
		#1;		
		if (bus_data != 15'b000000000000110)
			begin
				$display("time:",$time,":Error getting tr_outdata, bus_data %b should be 15'b000000000000110",bus_data);
				err=2;
			end
			
		#20;	
		$display("Testing for 5");
		bus_code = 3'b101;
		#1;		
		if (bus_data != 15'b000000000000101)
			begin
				$display("time:",$time,":Error getting ir_outdata, bus_data %b should be 15'b000000000000101",bus_data);
				err=2;
			end
			
		#20;
		$display("Testing for 4");
		bus_code = 3'b100;
		#1;		
		if (bus_data != 15'b000000000000100)
			begin
				$display("time:",$time,":Error getting tr_outdata, bus_data %b should be 15'b000000000000100",bus_data);
				err=2;
			end
		
		#20;
		$display("Testing for 3");
		bus_code = 3'b011;
		#1;		
		if (bus_data != 15'b000000000000011)
			begin
				$display("time:",$time,":Error getting tr_outdata, bus_data %b should be 15'b000000000000011",bus_data);
				err=2;
			end
			
		#20;
		$display("Testing for 2");
		bus_code = 3'b010;
		#1;		
		if (bus_data != 15'b000000000000010)
			begin
				$display("time:",$time,":Error getting tr_outdata, bus_data %b should be 15'b000000000000010",bus_data);
				err=2;
			end
		
		#20;
		$display("Testing for 1");
		bus_code = 3'b001;
		#1;		
		if (bus_data != 15'b000000000000001)
			begin
				$display("time:",$time,":Error getting tr_outdata, bus_data %b should be 15'b000000000000001",bus_data);
				err=2;
			end
			
			
// NOW, THE RANDOM TESTING BEGINS!!!
		
		#20;
		$display("Random testing No1");
		randomlarge=$random;
		bus_code = randomlarge[2:0];
		#1;
		if (bus_data != {13'b0000000000000, randomlarge[2:0]})
			begin
				$display("time:",$time,":Error in Random testing No1, bus_data %b should be %b",bus_data,{13'b0000000000000, randomlarge[2:0]});
				err=2;
			end

		#20;
		$display("Random testing No2");
		randomlarge=$random;
		bus_code = randomlarge[2:0];
		#1;
		if (bus_data != {13'b0000000000000, randomlarge[2:0]})
			begin
				$display("time:",$time,":Error in Random testing No2, bus_data %b should be %b",bus_data,{13'b0000000000000, randomlarge[2:0]});
				err=2;
			end
		
		#20;
		$display("Random testing No3");
		randomlarge=$random;
		bus_code = randomlarge[2:0];
		#1;
		if (bus_data != {13'b0000000000000, randomlarge[2:0]})
			begin
				$display("time:",$time,":Error in Random testing No3, bus_data %b should be %b",bus_data,{13'b0000000000000, randomlarge[2:0]});
				err=2;
			end
		
		#20;
		$display("Random testing No4");
		randomlarge=$random;
		bus_code = randomlarge[2:0];
		#1;
		if (bus_data != {13'b0000000000000, randomlarge[2:0]})
			begin
				$display("time:",$time,":Error in Random testing No4, bus_data %b should be %b",bus_data,{13'b0000000000000, randomlarge[2:0]});
				err=2;
			end
		
		#20;
		$display("Random testing No5");
		randomlarge=$random;
		bus_code = randomlarge[2:0];
		#1;
		if (bus_data != {13'b0000000000000, randomlarge[2:0]})
			begin
				$display("time:",$time,":Error in Random testing No5, bus_data %b should be %b",bus_data,{13'b0000000000000, randomlarge[2:0]});
				err=2;
			end
		
		#20;
		$display("Random testing No6");
		randomlarge=$random;
		bus_code = randomlarge[2:0];
		#1;
		if (bus_data != {13'b0000000000000, randomlarge[2:0]})
			begin
				$display("time:",$time,":Error in Random testing No6, bus_data %b should be %b",bus_data,{13'b0000000000000, randomlarge[2:0]});
				err=2;
			end
		
		#20;
		$display("Random testing No7");
		randomlarge=$random;
		bus_code = randomlarge[2:0];
		#1;
		if (bus_data != {13'b0000000000000, randomlarge[2:0]})
			begin
				$display("time:",$time,":Error in Random testing No7, bus_data %b should be %b",bus_data,{13'b0000000000000, randomlarge[2:0]});
				err=2;
			end
			
		#20;
		$display("Random testing No8");
		randomlarge=$random;
		bus_code = randomlarge[2:0];
		#1;
		if (bus_data != {13'b0000000000000, randomlarge[2:0]})
			begin
				$display("time:",$time,":Error in Random testing No8, bus_data %b should be %b",bus_data,{13'b0000000000000, randomlarge[2:0]});
				err=2;
			end

// END OF RANDOM TESTING
		#20;
		if (err == 0) res = res + 1;
			begin
				$display("Test is over, showing result. Should be zero if test is successful: %d", err);
				$finish;
			end
	end
      

endmodule

