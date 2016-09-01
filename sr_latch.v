`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:56:12 08/30/2016 
// Design Name: 
// Module Name:    sr_latch 
// Project Name: 
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sr_latch(
    input r,
    input s,
    input c,
    output q,
    output qbar
    );
	 
	 assign q = ~((c & r) | qbar);
	 assign qbar = ~((c & s) | q);

endmodule
