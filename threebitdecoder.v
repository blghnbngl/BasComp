`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232 Summer Project
// Engineer: Bilgehan
// 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: This one is a helper module to control. It decodes an instruction of 3 bits
//
//////////////////////////////////////////////////////////////////////////////////
module threebitdecoder(
    input [2:0] instruction,
    output[7:0] opcode
    );

assign opcode[7]=(instruction[2] & instruction[1] & instruction[0]);
assign opcode[6]=(instruction[2] & instruction[1] & ~instruction[0]);
assign opcode[5]=(instruction[2] & ~instruction[1] & instruction[0]);
assign opcode[4]=(instruction[2] & ~instruction[1] & ~instruction[0]);
assign opcode[3]=(~instruction[2] & instruction[1] & instruction[0]);
assign opcode[2]=(~instruction[2] & instruction[1] & ~instruction[0]);
assign opcode[1]=(~instruction[2] & ~instruction[1] & instruction[0]);
assign opcode[0]=(~instruction[2] & ~instruction[1] & ~instruction[0]);

endmodule
