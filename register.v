`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ceng232 Summer Project
// Engineer: Bilgehan
// 
// Create Date:    01:53:37 07/10/2016 
// Module Name:    register 
// Project Name: 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module register(
    input clk,
    input load,
    input inc,
    input clr,
    input [15:0] indata,
    output [15:0] outdata
    );

reg [15:0] datasaved;
 
always @(posedge clk)
	begin
		if (load==1 & inc==0 & clr==0)
			datasaved<=indata;
		else if (load==0 & inc==1 & clr==0)
			datasaved<=datasaved+1;
		else if (load==0 & inc==0 & clr==1)
			datasaved<=0;
		else if (load+inc+clr>1)
			$display("Error: Multiple commands for a register");
	end

assign outdata=datasaved;

endmodule
