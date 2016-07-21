`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 	ceng232 Summer Project
// Engineer: 	Bilgehan
// 
// Create Date:    21:53:47 07/09/2016 
// Module Name:    main module for basic computer
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
//			1) Always blocks? Do timing works correctly?
//			2)Slowing of clock???
//			3) Start, interrupt, IO is problematic??
//			4) A board file with clock and IO.
//
//////////////////////////////////////////////////////////////////////////////////
module main(
    input start,
    input reset,
    input interrupt,
	 input fpgaclock,
    output ready,
    output busy,
    output interrupted,
    output [13:0] value
    );

	 wire ar_inc, ar_load, ar_clr;
	 wire [15:0] ar_outdata;
	 wire pc_inc, pc_load, pc_clr;
	 wire [15:0] pc_outdata;
	 wire dr_inc, dr_load, dr_clr;
	 wire [15:0] dr_outdata;
	 wire ir_inc, ir_load, ir_clr;
	 wire [15:0]  ir_outdata;
	 wire ac_inc, ac_load, ac_clr;
	 wire [15:0] ac_outdata;
	 wire [15:0] busdata;
	 reg FGI,FGO;
	 
// Here, fpgaclock should be slowed and should be anded with start. It then
// turns to my clock, but I leave it now.	 
	 
// In parantheses is what goes out, out parentheses is the in-module name.
memory mem(.clk(myclock),.adress(ar_outdata),.read(mem_read), .write(mem_write), .indata(bus_data), .outdata(mem_outdata));//!!!!A difference with Enes 
// I use bus data for indata. Should it be changed??
eightbitregister inpr(.clk(myclock), .load(inpr_load), .inc(inpr_inc), .clr(inpr_clr), .outdata(inpr_outdata), .indata(bus_data));
eightbitregister outr(.clk(myclock), .load(outr_load), .inc(outr_inc), .clr(outr_clr), .outdata(outr_outdata), .indata(bus_data));
//I will Deal with these 2 later.

smallregister ar(.clk(myclock), .load(ar_load), .inc(ar_inc), .clr(ar_clr), .outdata(ar_outdata), .indata(bus_data));
smallregister pc(.clk(myclock), .load(pc_load), .inc(pc_inc), .clr(pc_clr), .outdata(pc_outdata), .indata(bus_data));
register dr(.clk(myclock), .load(dr_load), .inc(dr_inc), .clr(dr_clr), .outdata(dr_outdata), .indata(bus_data),.inputload(dr_inputload),.input_data(input_data));
register ir(.clk(myclock), .load(ir_load), .inc(ir_inc), .clr(ir_clr), .outdata(ir_outdata), .indata(bus_data));
register ac(.clk(myclock), .load(ac_load), .inc(ac_inc), .clr(ac_clr), .outdata(ac_outdata), .indata(alu_outdata));
register tr(.clk(myclock), .load(tr_load), .inc(tr_inc), .clr(tr_clr), .outdata(tr_outdata), .indata(bus_data));


//ALU should be looked at carefully.
alu_unit alu(.ac_outdata(ac_outdata),.dr_outdata(dr_outdata),.inpr_outdata(inpr_outdata),.alu_code(alu_code),
				.e_outdata(e_outdata),.ff_en(ff_en),.e_indata(e_indata),alu_outdata(alu_outdata));
// Is that really enough???

sequencecounter seqcount(.clk(myclock),.clr(seq_clr),.inc(seq_inc),.sequence(sequence));

//Chooses bus
buschooser(.buscode(buscode),.ar_outdata(ar_outdata),.pc_outdata(pc_outdata),.dr_outdata(dr_outdata),
				.ac_outdata(ac_outdata),.ir_outdata(ir_outdata),.tr_outdata(tr_outdata),.mem_outdata(mem_outdata),
				.bus_data(bus_data));

ff e(.clk(myclock), e_indata(e_indata),.reset(reset),.e_clr(e_clr),.en(ff_en),.e_outdata(e_outdata));


threebitdecoder dec_opcode(.opcode(ir_outdata[14:12]), .instruction(instruction));
fourbitdecoder seq_code(.code(sequence), .times(times));
// Above two make things ready for control, and become inputs to control unit.
	
control controller(.ir_outdata(ir_outdata),.opcode(instruction),.times(times),
						.reset(reset),.interrupt(interrupt),.start(start),.clk(myclock),
						.dr_outdata(dr_outdata), .ac_outdata(ac_outdata),.e_outdata(e_outdata),
						.bus_code(bus_code), 
						.mem_write(mem_write),.mem_read(mem_read),
						.ar_load(ar_load), .ar_inc(ar_inc),.ar_clr(ar_clr),
						.pc_load(pc_load), .pc_inc(pc_inc),.pc_clr(pc_clr),
						.dr_load(dr_load), .dr_inc(dr_inc),.dr_clr(dr_clr),
						.ac_load(ac_load), .ac_inc(ac_inc),.ac_clr(ac_clr),
						.pc_load(pc_load), .pc_inc(pc_inc),.pc_clr(pc_clr),
						.ir_load(ir_load),.ir_inc(ir_inc),.ir_clr(ir_clr),
						.tr_load(tr_load), .tr_inc(tr_inc),.tr_clr(tr_clr),
						.outr_load(outr_load),.outr_inc(outr_inc),.outr_clr(outr_clr),
						.seq_clr(seq_clr),.seq_inc(seq_inc),
						.e_clr(e_clr),
						.alu_code(alu_code)
						);

endmodule
