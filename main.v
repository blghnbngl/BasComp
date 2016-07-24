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
	 input myclock,
    output ready,
    output busy,
    output interrupted,
    output [13:0] value
    );
		
	 
	 wire mem_read, mem_write;
	 wire [15:0] mem_outdata;
	 wire inpr_load, inpr_inc, inpr_clr, outr_load, outr_inc, outr_clr;
	 wire [7:0] inpr_outdata, outr_outdata;
	 wire pc_load, pc_inc, pc_clr, ar_load, ar_inc, ar_clr;
	 wire [11:0] ar_outdata, pc_outdata;
	 wire dr_load, dr_inc, dr_clr;
	 wire [15:0] dr_outdata;
	 wire ir_load, ir_inc, ir_clr;
	 wire [15:0] ir_outdata;
	 wire ac_load, ac_inc, ac_clr;
	 wire [15:0] ac_outdata;
	 wire tr_load, tr_inc, tr_clr;
	 wire [15:0] tr_outdata;
	 wire [3:0] alu_cde;
	 wire [15:0] alu_outdata;
	 wire seq_clr,seq_inc;
	 wire [3:0] sequence;
	 wire [2:0] bus_code;
	 wire [15:0] bus_data;
	 wire e_indata, e_clr, ff_en, e_outdata; //For the Flip-Flop E.
	 wire fgi_indata, fgi_clr, ff_fgien, fgi_outdata; //For the Flip-Flop FGI, ie. input flag.
	 wire fgo_indata, fgo_clr, ff_fgoen, fgo_outdata; //For the Flip-Flop FGO, ie. output flag.
	 wire ien_indata, ien_clr, ff_ienen, ien_outdata; //For the Flip-Flop IEN, ie. interrupt enable.
	 wire [7:0] instruction;
	 wire [15:0] times;
		 
	 
// In parantheses is what goes out, out parentheses is the in-module name.
memory mem(.clk(myclock),.adress(ar_outdata),.read(mem_read), .write(mem_write), .indata(bus_data), .outdata(mem_outdata));//!!!!A difference with Enes 

// I use bus data for indata. It should be changed for input register since it takes from outside. Will deal
//with this later. As name suggests, these are 8-bit registers. Note that some inputs are never used, like increment
//but I kept them to have a general register framework.
eightbitregister inpr(.clk(myclock), .load(inpr_load), .inc(inpr_inc), .clr(inpr_clr), .outdata(inpr_outdata), .indata(bus_data));
eightbitregister outr(.clk(myclock), .load(outr_load), .inc(outr_inc), .clr(outr_clr), .outdata(outr_outdata), .indata(bus_data));

//smallregisters are 12-bit registers.
smallregister ar(.clk(myclock), .load(ar_load), .inc(ar_inc), .clr(ar_clr), .outdata(ar_outdata), .indata(bus_data));
smallregister pc(.clk(myclock), .load(pc_load), .inc(pc_inc), .clr(pc_clr), .outdata(pc_outdata), .indata(bus_data));

//Below are 16-bit registers.
register dr(.clk(myclock), .load(dr_load), .inc(dr_inc), .clr(dr_clr), .outdata(dr_outdata), .indata(bus_data));
register ir(.clk(myclock), .load(ir_load), .inc(ir_inc), .clr(ir_clr), .outdata(ir_outdata), .indata(bus_data));
register ac(.clk(myclock), .load(ac_load), .inc(ac_inc), .clr(ac_clr), .outdata(ac_outdata), .indata(alu_outdata));
register tr(.clk(myclock), .load(tr_load), .inc(tr_inc), .clr(tr_clr), .outdata(tr_outdata), .indata(bus_data));

//ALU unit takes inputs from DataRegister, Accumulator, InputRegister (not bus) and sends data only to Accumulator.
alu_unit alu(.ac_outdata(ac_outdata),.dr_outdata(dr_outdata),.inpr_outdata(inpr_outdata),.alu_code(alu_code),
				.e_outdata(e_outdata),.ff_en(ff_en),.e_indata(e_indata),alu_outdata(alu_outdata));

//To keep track of time.
sequencecounter seqcount(.clk(myclock),.clr(seq_clr),.inc(seq_inc),.sequence(sequence));

//Chooses bus. Note the bus choosing numbers are exactly the same with our lecture notes.
buschooser(.bus_code(bus_code),.ar_outdata(ar_outdata),.pc_outdata(pc_outdata),.dr_outdata(dr_outdata),
				.ac_outdata(ac_outdata),.ir_outdata(ir_outdata),.tr_outdata(tr_outdata),.mem_outdata(mem_outdata),
				.bus_data(bus_data));

//Below are the necessary Flip Flops. E, FGI&FGO (Input-output clocks), IEN (interrupt enable)
// Probably a few more FFs will come here in the future (for interrupt, ready, busy signals).
ff e(.clk(myclock), e_indata(e_indata),.reset(reset),.e_clr(e_clr),.en(ff_en),.e_outdata(e_outdata));
ff fgi(.clk(myclock), e_indata(fgi_indata),.reset(reset),.e_clr(fgi_clr),.en(ff_fgien),.e_outdata(fgi_outdata));
ff fgo(.clk(myclock), e_indata(fgo_indata),.reset(reset),.e_clr(fgo_clr),.en(ff_fgoen),.e_outdata(fgo_outdata));
ff ien(.clk(myclock), e_indata(ien_indata),.reset(reset),.e_clr(ien_clr),.en(ff_ienen),.e_outdata(ien_outdata));

threebitdecoder dec_opcode(.opcode(ir_outdata[14:12]), .instruction(instruction));
fourbitdecoder seq_code(.code(sequence), .times(times));
// Above two make things ready for control, and become inputs to control unit. I'm not sure whether
// they are exactly necessary, but created them since they are in our lecture notes.
	
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
						.fgi_outdata(fgi_outdata),.fgi_indata(fgi_indata),.ff_fgien(ff_fgien),
						.fgo_outdata(fgo_outdata),.fgo_indata(fgo_indata),.ff_fgoen(ff_fgoen),
						.ien_outdata(ien_outdata),.ien_indata(ien_indata),.ff_ienen(ff_ienen),
						.e_clr(e_clr),
						.alu_code(alu_code)
						);

endmodule
