`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:15:37 09/15/2016 
// Design Name: 
// Module Name:    io_interface 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: This is the final and most complex part of the basic computer. This part deals with
// what comes in and gets out of Basic Computer. I thought best option for this basic computer is getting 
// inputs via a ps/2 keyboard and sending outputs to a VGA screen (Basys 2 Spartan 3-E FPGA has the necessary
//	plugins for both of these).
//
//	The two modules below are totally separate. They have only one mutual input, which is io_clr. This input
// is used to clear both input and output interfaces when a reset command is given. Other than this, the 
// two interfaces have the following inputs and outputs.
//
//	Keyboard interface inputs: io_clr, ps2c, ps2d, keyboard input data
//	io_clr comes from the control module, the others come from the keyboard
// Keyboard interface output: Input arrived flag 
// This output goes to the control module
//
//	Vga interface inputs: io_clr, mhz25_clock, output register data
//
// Vga interface outputs: vsynch, hsynch, rgb, output went flag
//	Vsynch, hsynch, rgb go to VGA screen, output went flag goes to the control module.
//
//	More detailed descriptions of each interface is in their respective modules.
//
//////////////////////////////////////////////////////////////////////////////////
module io_interface(
    input clock,
    input ps2d,
    input ps2c,
	 input mhz25_clock,
	 input io_clr,
	 input [7:0] outr_outdata,
	 output [7:0] keyboard_input_data ,
	 output input_arrived_flag,
    output vsynch,
    output hsynch,
    output [7:0] rgb,
	 output output_went_flag
    );
	 
keyboard_input_interface keyboard_input(.clr(io_clr), .ps2c(ps2c), .ps2d(ps2d), 
													 .keyboard_input_data(keyboard_input_data),
													 .input_arrived_flag(input_arrived_flag) );
 
vga_output_interface vga_output(.mhz25_clock(mhz25_clock), .outr_outdata(outr_outdata),  
										  .vsynch(vsynch), .hsynch(hsynch), .rgb(rgb),
										  .clr(io_clr), .output_went_flag(output_went_flag));




endmodule
