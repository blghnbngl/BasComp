`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Verilog Test Fixture created by ISE for module: alu_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_alu;

	// Inputs
	reg [15:0] ac_outdata;
	reg [15:0] dr_outdata;
	reg e_outdata;
	reg [7:0] inpr_outdata;
	reg [3:0] alu_code;

	// Outputs
	wire [15:0] alu_outdata;
	wire e_indata;
	wire ff_en;
	
	//For tests
	reg clk;
	reg [31:0] randomlarge;			
	reg [31:0] randomlarge2;			
	reg [2:0] randomcommand1;
	integer j;

		
	//Error detection
	integer err;			//Error term to see mistakes in loading process
	integer res;

	// Instantiate the Unit Under Test (UUT)
	alu_unit uut (
		.ac_outdata(ac_outdata), 
		.dr_outdata(dr_outdata), 
		.e_outdata(e_outdata), 
		.inpr_outdata(inpr_outdata), 
		.alu_code(alu_code), 
		.alu_outdata(alu_outdata), 
		.e_indata(e_indata), 
		.ff_en(ff_en)
	);

	always
		begin
			#20 clk = ~clk;
		end
		
	always @(posedge clk)	//RANDOM TESTS ARE DONE HERE
			begin
				j=j+1;
				randomlarge=$random;
				randomlarge2=$random;
				ac_outdata= randomlarge[31:16];
				dr_outdata= randomlarge[15:0];
				e_outdata = randomlarge2[31];
				inpr_outdata = randomlarge2[30:23];
				randomcommand1 = randomlarge2[22:20];
				#2;
				$display("Random testing %d,alu_outdata: %b",j, alu_outdata);
				if (randomcommand1==3'b000) //This is the and accumulator and data register command
					begin
						alu_code=4'b0001;
						$display("Random testing %d,alu_code: %b, and AC and DR", j,alu_code);
						#2;
						if (((alu_outdata==(ac_outdata & dr_outdata)) && (e_indata==1'bx) && 
							(ff_en==0)) != 1 )
							begin
								$display("time:",$time,":Error in Random testing No %d, alu_code: %b, and AC and DR",
								j, alu_code);
								$display("alu_outdata %b, e_indata %b, ff_en %b", alu_outdata, e_indata, ff_en);
								$display("ac %b, dr %b, inpr %b", ac_outdata, dr_outdata, inpr_outdata);
								$display("e_outdata %b, alu_code %b", e_outdata, alu_code );
								$display("output should have been: %b", (ac_outdata & dr_outdata));
								err=err+1;				
							end
					end			
				else if (randomcommand1==3'b001) //This is the sum accumulator and data register command
					begin
						alu_code=4'b0010;	
						$display("Random testing %d,alu_code: %b, add AC and DR", j,alu_code);
						#2;
						if ((({e_indata,alu_outdata}==(ac_outdata + dr_outdata)) && (ff_en==1)) !=1 )
							begin
								$display("time:",$time,":Error in Random testing No %d, alu_code: %b, add AC and DR",
								j, alu_code);
								$display("alu_outdata %b, e_indata %b, ff_en %b", alu_outdata, e_indata, ff_en);
								$display("ac %b, dr %b, inpr %b", ac_outdata, dr_outdata, inpr_outdata);
								$display("e_outdata %b, alu_code %b", e_outdata, alu_code );						
								err=err+1;				
							end
					end
				else if (randomcommand1==3'b010) //This is loading the data register to accumulator command
					begin
						alu_code=4'b0011;
						$display("Random testing %d,alu_code: %b, load DR to AC", j,alu_code);
						#2;
						if (((alu_outdata==dr_outdata) && (e_indata==1'bx) && (ff_en==0)) !=1 )						
							begin
								$display("time:",$time,":Error in Random testing No %d, alu_code: %b, load DR to AC",
								j, alu_code);						
								$display("alu_outdata %b, e_indata %b, ff_en %b", alu_outdata, e_indata, ff_en);
								$display("ac %b, dr %b, inpr %b", ac_outdata, dr_outdata, inpr_outdata);
								$display("e_outdata %b, alu_code %b", e_outdata, alu_code );	
								err=err+1;				
							end	
					end
				else if (randomcommand1==3'b011) //This is loading the complement accumulator command
					begin
						alu_code=4'b1001;
						$display("Random testing %d,alu_code: %b, complement AC", j,alu_code);
						#2;
						if (((alu_outdata==~ac_outdata) && (e_indata==1'bx) && (ff_en==0)) !=1 )						
							begin
								$display("time:",$time,":Error in Random testing No %d, alu_code: %b, complement AC",
								j, alu_code);
								$display("alu_outdata %b, e_indata %b, ff_en %b", alu_outdata, e_indata, ff_en);
								$display("ac %b, dr %b, inpr %b", ac_outdata, dr_outdata, inpr_outdata);
								$display("e_outdata %b, alu_code %b", e_outdata, alu_code );
								err=err+1;				
							end
					end
				else if (randomcommand1==3'b100) //This is loading the complement E command
					begin 
						alu_code=4'b1010;	
						$display("Random testing %d,alu_code: %b, complement E", j,alu_code);
						#2;
						if (((alu_outdata==16'bxxxxxxxxxxxxxxxx) && (e_indata==~e_outdata) && (ff_en==1)) !=1 )						
							begin
								$display("time:",$time,":Error in Random testing No %d, alu_code: %b, complement E",
								j, alu_code);
								$display("alu_outdata %b, e_indata %b, ff_en %b", alu_outdata, e_indata, ff_en);
								$display("ac %b, dr %b, inpr %b", ac_outdata, dr_outdata, inpr_outdata);
								$display("e_outdata %b, alu_code %b", e_outdata, alu_code );
								err=err+1;				
							end
					end
				else if (randomcommand1==3'b101) //This is loading the circular shift right command
					begin
						alu_code=4'b1011;	
						$display("Random testing %d,alu_code: %b, CIR", j,alu_code);
						#2;
						if ( (({alu_outdata,e_indata}=={e_outdata,ac_outdata}) && (ff_en==1)) !=1 )						
							begin
								$display("time:",$time,":Error in Random testing No %d, alu_code: %b, CIR",
								j, alu_code);
								$display("alu_outdata %b, e_indata %b, ff_en %b", alu_outdata, e_indata, ff_en);
								$display("ac %b, dr %b, inpr %b", ac_outdata, dr_outdata, inpr_outdata);
								$display("e_outdata %b, alu_code %b", e_outdata, alu_code );
								err=err+1;				
							end
					end
				else if (randomcommand1==3'b110) //This is loading the circular shift left command
					begin
						alu_code=4'b1100;	
						$display("Random testing %d,alu_code: %b, CIL", j,alu_code);
						#2;
						if ((({e_indata,alu_outdata}=={ac_outdata,e_outdata}) && (ff_en==1)) !=1 )						
							begin
								$display("time:",$time,":Error in Random testing No %d, alu_code: %b, CIL",
								j, alu_code);
								$display("alu_outdata %b, e_indata %b, ff_en %b", alu_outdata, e_indata, ff_en);
								$display("ac %b, dr %b, inpr %b", ac_outdata, dr_outdata, inpr_outdata);
								$display("e_outdata %b, alu_code %b", e_outdata, alu_code );
								err=err+1;				
							end
					end
				else if (randomcommand1==3'b111) //This is loading the input character from accumulator command
					begin
						alu_code=4'b1101;
						$display("Random testing %d,alu_code: %b, load from IR to AC", j,alu_code);
						#2;
						if (((alu_outdata=={ac_outdata[15:8],inpr_outdata[7:0]}) && (ff_en==0)) !=1 )						
							begin
								$display("time:",$time,":Error in Random testing No %d, alu_code: %b, load from IR to AC",
								j, alu_code);
								$display("alu_outdata %b, e_indata %b, ff_en %b", alu_outdata, e_indata, ff_en);
								$display("ac %b, dr %b, inpr %b", ac_outdata, dr_outdata, inpr_outdata);
								$display("e_outdata %b, alu_code %b", e_outdata, alu_code );
								err=err+1;				
							end
					end

				
			end
					
	initial begin
		// Initialize Inputs
		ac_outdata = 0;
		dr_outdata = 0;
		e_outdata = 0;
		inpr_outdata = 0;
		alu_code = 0;
		
		j=0;
		clk=0;
		randomlarge=0;			
		randomlarge2=0;			
		randomcommand1=0;
		err=0;
		res=0;

		// Wait 100 ns for global reset to finish
		#200;
        
		// Add stimulus here
		#30000;

if (err == 0) res = res + 1;
			begin
				$display("Test is over, showing result. Should be zero if test is successful: err %d, ",err);
				$finish;
			end

	end
      
endmodule

