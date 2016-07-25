`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ceng232 Summer Project 
// Engineer: Bilgehan
// 
// Create Date:    02:09:17 07/10/2016 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module smallregister(
    input clk,
    input load,
    input inc,
    input clr,
    input [15:0] indata,
    output [11:0] outdata
    );
	 
reg [11:0] datasaved;

initial
	datasaved=12'b000000000000;
 
always @(posedge clk)				// Or,should this be a * rather than clock.
	begin
		if (load==1 & inc==0 & clr==0)
				datasaved<=indata[11:0];
		else if (load==0 & inc==1 & clr==0)
			datasaved<=datasaved+1;
		else if (load==0 & inc==0 & clr==1)
			datasaved<=0;
		else if (load+inc+clr>1)
			$display("Error: Multiple commands for adress register");
	end

assign outdata=datasaved;

endmodule
