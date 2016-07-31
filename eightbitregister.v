`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:28:22 07/12/2016 
// Design Name: 
// Module Name:    eightbitregister 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module eightbitregister(
    input clk,
    input load,
    input inc,
    input clr,
    output [7:0] out_data,
    input [15:0] in_data
    );

reg [7:0] datasaved;
 
always @(posedge clk)
	begin
		if (load==1 & inc==0 & clr==0)
				datasaved<=in_data[7:0];
		else if (load==0 & inc==1 & clr==0)
			$display("Erronous command on input-output register");
		else if (load==0 & inc==0 & clr==1)
			$display("Erronous command on input-output register");
		else if (load+inc+clr>1)
			$display("Erronous command on input-output register");
	end

assign outdata=datasaved;

endmodule
