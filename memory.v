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
    input [11:0] adress,
    input read,
    input write,
    input [15:0] indata,
	 input clk,
    output reg [15:0] outdata
    );

reg [15:0] memorydata [0:2190];		
//This was [0:4095], but had to be downsized because such a large memory did not fit into the distributed RAM
//blocks of Basys 2-Spartan 3-E. In the main, I found another solution usnig Block RAM area to implement a 
//[0:4095] sized memory, but if a small memory is not a problem, this can be used without problems as well.
												
integer i;			

initial
	begin
		outdata=16'bxxxxxxxxxxxxxxxx;
		for( i = 0; i < 2190; i = i + 1 ) 
			begin
				memorydata[i] <= 16'b0000000000000000;
			end
	end

always @(posedge clk)
	begin
			if (read==1 & write==0)
				outdata<=memorydata[adress];
			else if (read==0 & write==1)
					memorydata[adress]<=indata;
			else if (read==1 & write==1)
				begin
					//$display("Error: Multiple commands on memory");
					outdata<=memorydata[adress];
				end			
			else 
				outdata<=memorydata[adress];	//I assume it always points this one out. It should be okey.
	end
	
endmodule
