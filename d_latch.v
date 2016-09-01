`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:07:34 08/30/2016 
// Design Name: 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module d_latch(
    input d,
    input c,
    output q,
    output qbar
    );

	assign q = ~((~d & c) | qbar);
	 assign qbar = ~((d & c) | q);

endmodule
