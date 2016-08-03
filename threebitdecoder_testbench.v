`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:41:43 08/03/2016
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
//	a) This one follows the same pattern testbench for buschooser. First it exhausts all possibilities
// one by one in an orderly fashion. Then it conducts tests with random inputs.
// b) The timing problem that appeared in buschooser continues here, so after sending each opcode, system 
//waits one second (#1) to get the result to avoid this problem. Other than this, tests work fine.
//
////////////////////////////////////////////////////////////////////////////////

module testbench_threebitdecoder;

	// Inputs
	reg [2:0] opcode;

	// Outputs
	wire [7:0] instruction;
	integer res = 0;
	integer err = 0;

	// Random number register
	reg [31:0] randomlarge;
	

	// Instantiate the Unit Under Test (UUT)
	threebitdecoder uut (
		.opcode(opcode), 
		.instruction(instruction)
	);

	initial begin
		// Initialize Inputs
		opcode = 0;

		// Wait 10 ns for global reset to finish
		#10;
   end 
		// Add stimulus here
		
	initial begin			
	$display("Starting Testbench");
		//initial values take place in the above part
		//From here on to line 133, all cases will be tried in order.
		
		#20;
		$display("Testing for Instruction 7");
		opcode = 3'b111;
		#1;
		if (instruction != 8'b10000000)
		begin
				$display("time:",$time,":Error getting instruction, %b should have been 8'b10000000",instruction);
				err=2;
		end
		
		#20;
		$display("Testing for Instruction 6");
		opcode = 3'b110;
		#1;		
		if (instruction != 8'b01000000)
			begin
				$display("time:",$time,":Error getting instruction, %b should have been 8'b01000000",instruction);
				err=2;
			end
		
		#20;
		$display("Testing for Instruction 5");
		opcode = 3'b101;
		#1;		
		if (instruction != 8'b00100000)
			begin
				$display("time:",$time,":Error getting instruction, %b should have been 8'b00100000",instruction);
				err=2;
			end
        
		#20;
		$display("Testing for Instruction 4");
		opcode = 3'b100;
		#1;		
		if (instruction != 8'b00010000)
			begin
				$display("time:",$time,":Error getting instruction, %b should have been 8'b00010000",instruction);
				err=2;
			end

		#20;
		$display("Testing for Instruction 3");
		opcode = 3'b011;
		#1;		
		if (instruction != 8'b00001000)
			begin
				$display("time:",$time,":Error getting instruction, %b should have been 8'b00001000",instruction);
				err=2;
			end
		
		#20;
		$display("Testing for Instruction 2");
		opcode = 3'b010;
		#1;		
		if (instruction != 8'b00000100)
			begin
				$display("time:",$time,":Error getting instruction, %b should have been 8'b00000100",instruction);
				err=2;
			end
			
		#20;
		$display("Testing for Instruction 1");
		opcode = 3'b001;
		#1;		
		if (instruction != 8'b00000010)
			begin
				$display("time:",$time,":Error getting instruction, %b should have been 8'b00000010",instruction);
				err=2;
			end
			
		#20;
		$display("Testing for Instruction 0");
		opcode = 3'b000;
		#1;		
		if (instruction != 8'b00000001)
			begin
				$display("time:",$time,":Error getting instruction, %b should have been 8'b00000000",instruction);
				err=2;
			end
			
//Random testing begins. A total of eight random tests exist.

		#20;
		$display("Random testing No1");
		randomlarge=$random;
		opcode = randomlarge[2:0];
		#1;
		if (instruction != 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]))
			begin
				$display("time:",$time,":Error in Random testing No1, instruction %b should have been %b",
							instruction, 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]));
				err=2;
			end

		#20;
		$display("Random testing No2");
		randomlarge=$random;
		opcode = randomlarge[2:0];
		#1;
		if (instruction != 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]))
			begin
				$display("time:",$time,":Error in Random testing No2, instruction %b should have been %b",
							instruction, 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]));
				err=2;
			end
		
		#20;
		$display("Random testing No3");
		randomlarge=$random;
		opcode = randomlarge[2:0];
		#1;
		if (instruction != 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]))
			begin
				$display("time:",$time,":Error in Random testing No3, instruction %b should have been %b",
							instruction, 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]));
				err=2;
			end
			
		#20;
		$display("Random testing No4");
		randomlarge=$random;
		opcode = randomlarge[2:0];
		#1;
		if (instruction != 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]))
			begin
				$display("time:",$time,":Error in Random testing No4, instruction %b should have been %b",
							instruction, 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]));
				err=2;
			end
			
		#20;
		$display("Random testing No5");
		randomlarge=$random;
		opcode = randomlarge[2:0];
		#1;
		if (instruction != 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]))
			begin
				$display("time:",$time,":Error in Random testing No5, instruction %b should have been %b",
							instruction, 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]));
				err=2;
			end
		
		#20;
		$display("Random testing No6");
		randomlarge=$random;
		opcode = randomlarge[2:0];
		#1;
		if (instruction != 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]))
			begin
				$display("time:",$time,":Error in Random testing No6, instruction %b should have been %b",
							instruction, 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]));
				err=2;
			end

		#20;
		$display("Random testing No7");
		randomlarge=$random;
		opcode = randomlarge[2:0];
		#1;
		if (instruction != 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]))
			begin
				$display("time:",$time,":Error in Random testing No7, instruction %b should have been %b",
							instruction, 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]));
				err=2;
			end
			
			#20;
		$display("Random testing No8");
		randomlarge=$random;
		opcode = randomlarge[2:0];
		#1;
		if (instruction != 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]))
			begin
				$display("time:",$time,":Error in Random testing No8, instruction %b should have been %b",
							instruction, 2**(randomlarge[2]*4+randomlarge[1]*2+randomlarge[0]));
				err=2;
			end
// End of random testing

		#20;
		if (err == 0) res = res + 1;
			begin
				$display("Test is over, showing result. Should be zero if test is successful: %d", err);
				$finish;
			end


	end
      
endmodule

