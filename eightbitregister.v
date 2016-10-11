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
    input clr,
	 input reset,
    output [7:0] out_data,
    input [15:0] in_data
    );
	 
//////////////RESET SHOULD BE PUT IN HERE, OTHERWISE SINCE THERE IS NO CLEAR, ALL WILL STAY IN	 
wire alwaystrue;
wire alwayfalse;
wire [7:0] out_databar;

assign alwaystrue=1'b1;
assign alwaysfalse=1'b0;


ff outputregisterdata [7:0] (clk, in_data[7:0], alwaysfalse, reset, load, out_data, out_databar);	
//8 flip flops
//Here, this lining of input outputs should be correct otherwise there will be errors!

/*	 
reg [7:0] datasaved;

initial
	datasaved=8'b00000000;
 
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
*/

endmodule
