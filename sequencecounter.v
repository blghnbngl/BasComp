`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232 Summer Project
// Engineer: Bilgehan
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sequencecounter(
	 input clk,
	 input inc,
	 input clr,
    output reg [3:0] sequence
    );

reg [3:0] sequence;
initial
	begin
		sequence<=4'b0000;
	end

//CHECK THIS!!!!! I DID THIS TO BE IN LINE WITH ASM CHART!!!
always @(negedge clk)			
	begin
		if (inc==0 & clr==1)
			sequence<=4'b0000;
		else if (inc==1 & clr==0)
			begin
				if (sequence==4'b1111)
					sequence<=4'b0000;
				else
					sequence=sequence+1;
			end 	
		else
			$display("Error: Multiple inputs to sequence counter");
	end
	
endmodule
