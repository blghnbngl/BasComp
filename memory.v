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
    input write,
    input [15:0] indata,
	 input clk,
    output reg [15:0] outdata
    );

/*reg [15:0] memory [0:2190];		
//This was [0:4095], but had to be downsized because such a large memory did not fit into the distributed RAM
//blocks of Basys 2-Spartan 3-E. In the main, I found another solution usnig Block RAM area to implement a 
//[0:4095] sized memory, but if a small memory is not a problem, this can be used without problems as well.*/
												
	  parameter RAM_WIDTH = 16;
   parameter RAM_ADDR_BITS = 12;
   
   (* RAM_STYLE="{AUTO | BLOCK |  BLOCK_POWER1 | BLOCK_POWER2}" *)
	
   reg [RAM_WIDTH-1:0] memory [0:(2**RAM_ADDR_BITS)-1];

	assign ram_enable=1;
	



   //  The following code is only necessary if you wish to initialize the RAM 
   //  contents via an external file (use $readmemb for binary data)
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
