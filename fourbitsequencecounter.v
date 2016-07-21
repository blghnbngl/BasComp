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
module fourbitsequencecounter(
    input clk,
    output reg [3:0] count
    );

reg [3:0] count;

always @(posedge clk)
	begin
		if (count==4'b15)
			count<=4'b0;
		else
			count<=count+1;
	end
	
endmodule
