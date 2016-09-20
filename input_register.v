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
    input keyboard_input [7:0],
    input input_arrived_flag,
    output reg [7:0] input_data
    );

always@ (posedge input_arrived_flag)
	begin
		input_data[7:0] <= keyboard_input;
	end

endmodule
