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
// Additional Comments: 
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
