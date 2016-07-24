`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232 Summer Project
// Engineer: Bilgehan
// 
// Create Date:    03:56:42 07/10/2016 
// Design Name: 
// Module Name:    fourbitdecoder 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fourbitdecoder(
    input [3:0] code,
    output [15:0] times
    );

assign times[15] =(code[3] & code[2] & code[1] & code[0]);
assign times[14] =(code[3] & code[2] & code[1] & ~code[0]);
assign times[13] =(code[3] & code[2] & ~code[1] & code[0]);
assign times[12] =(code[3] & code[2] & ~code[1] & ~code[0]);
assign times[11] =(code[3] & ~code[2] & code[1] & code[0]);
assign times[10] =(code[3] & ~code[2] & code[1] & ~code[0]);
assign times[9] =(code[3] & ~code[2] & ~code[1] & code[0]);
assign times[8] =(code[3] & ~code[2] & ~code[1] & ~code[0]);
assign times[7] =(~code[3] & code[2] & code[1] & code[0]);
assign times[6] =(~code[3] & code[2] & code[1] & ~code[0]);
assign times[5] =(~code[3] & code[2] & ~code[1] & code[0]);
assign times[4] =(~code[3] & code[2] & ~code[1] & ~code[0]);
assign times[3] =(~code[3] & ~code[2] & code[1] & code[0]);
assign times[2] =(~code[3] & ~code[2] & code[1] & ~code[0]);
assign times[1] =(~code[3] & ~code[2] & ~code[1] & code[0]);
assign times[0] =(~code[3] & ~code[2] & ~code[1] & ~code[0]);





endmodule
