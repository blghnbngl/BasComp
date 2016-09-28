`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:53:53 09/17/2016 
// Design Name: 
// Module Name:    input_register 
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
module input_register(
    input clk,
    input [7:0] keyboard_input,
    input input_arrived_flag,
    output [7:0] input_data
    );

wire alwaystrue;
wire alwayfalse;
wire [7:0] out_databar;

assign alwaystrue=1'b1;
assign alwaysfalse=1'b0;


ff inputregisterdata [7:0] (input_arrived_flag, keyboard_input, alwaysfalse, alwaysfalse, alwaystrue,
										input_data, out_databar);	//8 flip flops


/*
always@ (posedge input_arrived_flag)
	begin
		input_data[7:0] <= keyboard_input;
	end
*/
endmodule
