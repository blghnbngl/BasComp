`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232 Summer Project
// Engineer: Bilgehan
// 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: This is the main memory of the Basic Computer. It holds both instructions and the data.
//
//	WARNING: Unlike most other modules, this is written with behavioral modelling, not with dataflow modelling.
//
//	Initially, I had defined a memory consisting of 4096 lines of 16-bit registers. This is quite simple
// and can be defined as: reg [15:0] memory [0:4095]
//
//	But Basys 2 Spartan 3-E FPGA has two types of RAM: Distributed RAM and Block RAM. When you define a memory as in the
//	above, you are using the Distributed RAM. The problem is, Distributed RAM is quite small (compared to
// Block RAM) and 4096 lines of 16-bit register do not fit in. When I tried, I saw the maximum I can put it
//	this basic computer is close to 2200 lines. If you do not need a very large memory, you can go on with this.
//	The commented part between lines 38-41 use such an approach. 
//
//	The better and more complex approach is to use the Block RAM. In ISE Project Navigator 12.4 that I use,
// this can be done via Block RAM generator. Lines 43-49 describe the Block RAM created by the generator
//	and lines 60-67 describe operations on this memory.
// 
//	If you are intersted in this issue you can take a look at this Xilinx documentation about Block RAM:
//	https://www.xilinx.com/support/documentation/application_notes/xapp463.pdf
//
//////////////////////////////////////////////////////////////////////////////////
module memory(
    input [11:0] adress,
    input write,
    input [15:0] indata,
	 input clk,
    output reg [15:0] outdata
    );

/*reg [15:0] memory [0:2190];		
//This was [0:4095], but had to be downsized because such a large memory did not fit into the distributed RAM
//blocks of Basys 2-Spartan 3-E. I found another solution usnig Block RAM area to implement a 
//[0:4095] sized memory, but if a small memory is not a problem, this can be used without problems as well.*/
												
	  parameter RAM_WIDTH = 16;
   parameter RAM_ADDR_BITS = 12;
   
   (* RAM_STYLE="{AUTO | BLOCK |  BLOCK_POWER1 | BLOCK_POWER2}" *)
	
   reg [RAM_WIDTH-1:0] memory [0:(2**RAM_ADDR_BITS)-1];

	assign ram_enable=1;
	



   //  The following code is only necessary if you wish to initialize the RAM 
   //  contents via an external file (use $readmemb for binary data) (for example, if you want to install a program)
  /* initial
      $readmemh("<data_file_name>", <rom_name>, <begin_address>, <end_address>);*/

   always @(posedge clk)
			begin
				if (write)
					memory[adress] <= indata;
					//outdata <=memory[adress];
				else
					outdata <=memory[adress];
			end
		
											
	
				
endmodule
