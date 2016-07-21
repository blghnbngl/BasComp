`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232 Summer Project
// Engineer: Bilgehan
// 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module memory(
    input clk,
    input [11:0] adress,
    input read,
    input write,
    input [15:0] indata,
    output [15:0] outdata
    );

reg [15:0] memorydata [0:4095];

initial
	begin
		outdata=memorydata[adress];
	end

always @*
	begin
			if (read==1 & write==0)
				outdata=memorydata[adress];
			else if (read==0 & write==1)
				memorydata[adress]=indata;
			else if (read==1 & write==1)
				$display("Error: Multiple commands on memory");
				outdata=memorydata[adress];
			else 
				outdata=memorydata[adress];	//I assume it always points this one out. It should be okey.
	end
	
endmodule
