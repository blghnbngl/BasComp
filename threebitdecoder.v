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
module threebitdecoder(
    input [2:0] opcode,
    output[7:0] instruction
    );

assign instruction[7]=(opcode[2] & opcode[1] & opcode[0]);
assign instruction[6]=(opcode[2] & opcode[1] & ~opcode[0]);
assign instruction[5]=(opcode[2] & ~opcode[1] & opcode[0]);
assign instruction[4]=(opcode[2] & ~opcode[1] & ~opcode[0]);
assign instruction[3]=(~opcode[2] & opcode[1] & opcode[0]);
assign instruction[2]=(~opcode[2] & opcode[1] & ~opcode[0]);
assign instruction[1]=(~opcode[2] & ~opcode[1] & opcode[0]);
assign instruction[0]=(~opcode[2] & ~opcode[1] & ~opcode[0]);

endmodule
