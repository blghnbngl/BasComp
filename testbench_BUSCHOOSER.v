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
// 3) There MIGHT be a PROBLEM: I included two more delay in lines 93 and 101 for the circuit to digest
// the input it takes. The existence of the delay in line 93 did not make any difference, so I turned it 
// into a comment. You can take the comment line out of it and see nothing changes.
// However, #5 delay in line 101 is necessary, because without it a wrong result comes out. Probably this is
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
// its inputs (like in line 101)
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
		bus_code = 3'b110;
		#5;
		$display("Testing for 6");
		if (bus_data != 15'b000000000000110)
			begin
				$display("time:",$time,":Error getting tr_outdata, bus_data %b should be 15'b000000000000110",bus_data);
				err=2;
			end
		#20;	
		if (err == 0) res = res + 1;
			begin
				$display("Test is over, showing result. Should be zero if test is successful: %d", err);
				$finish;
			end
	end
      
endmodule

