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
	 input myclock,
	 input ps2d,
	 input ps2c,
	 input mhz25_clock,
	 output vsynch,
	 output hsynch,
	 output [7:0] rgb,
	 output reg halted,
    output reg [15:0] value
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
	 wire e_indata, e_clr, ff_een, e_outdata; //For the Flip-Flop E.
	 wire fgi_indata, fgi_clr, ff_fgien, fgi_outdata; //For the Flip-Flop FGI, ie. input flag.
	 wire fgo_indata, fgo_clr, ff_fgoen, fgo_outdata; //For the Flip-Flop FGO, ie. output flag.
	 wire ien_indata, ien_clr, ff_ienen, ien_outdata; //For the Flip-Flop IEN, ie. interrupt enable.
	 wire [7:0] instruction;
	 wire [15:0] times;
	 wire input_arrived_flag;				
	 wire alwaystrue, alwaysfalse;
	
	 
assign alwaystrue=1'b1;
assign alwaysfalse=1'b0;

   	
	 

 
//For inputs and outputs
io_interface io(.clock(myclock), .mhz25_clock(mhz25_clock), .ps2c(ps2c), .ps2d(ps2d),
					 .outr_outdata(outr_outdata), .io_clr(io_clr),
					 .keyboard_input_data(keyboard_input_data), 
					 .input_arrived_flag(input_arrived_flag), .output_went_flag(output_went_flag), 
					 .vsynch(vsynch), .hsynch(hsynch), .rgb(rgb));
					 
// WARNING: Below, there is the definition of our RAM. But this module is different than others. It is generated
// by CoreGen operator of ISE. The reason is that ordinary memory modules use distributed RAM, which is about 
// 35 kilobits and it does not suppost a 64 kilobits memory (4k x 16). Therefore, I had to use Block RAM by 
// using CoreGen. The below module cannot be changed by writing in it (writing in is not allowed),
// it can only be changed by using CoreGen.

//	For the same reason, this module is not among the other Github files because it cannot be uploaded. The 
//	memory in Github is a classical distributed RAM module. It works perfectly, the only thing is that it
//	had to be downsized because of physical limitations of Basys 2 Spartan 3-E.	
// In parantheses is what goes out, out parentheses is the in-module name.
blockmem mem(.addra(ar_outdata), .clka(myclock), .wea(wea2), .rsta(mem_clr),
						 .dina(bus_data), .douta(mem_outdata));
assign wea2 = mem_write & ~mem_read;	//If that's 1 write in RAM, if 0 read from RAM. 

						 
						 
						 
// I use bus data for indata.  As name suggests, these are 8-bit registers. Note that some inputs are never used, like increment
//but I kept them to have a general register framework.
   
input_register inpr(.keyboard_input(keyboard_input), .input_arrived_flag(input_arrived_flag), .reset(inpr_clr),
							.input_data(input_data));
eightbitregister outr(.clk(myclock), .load(outr_load), .clr(alwaysfalse), .reset(outr_clr),
							 .out_data(outr_outdata), .in_data(bus_data));

//smallregisters are 12-bit registers.
smallregister ar(.clk(myclock), .load(ar_load), .inc(ar_inc), .clr(ar_clr), .outdata(ar_outdata), .indata(bus_data));
smallregister pc(.clk(myclock), .load(pc_load), .inc(pc_inc), .clr(pc_clr), .outdata(pc_outdata), .indata(bus_data));

//Below are 16-bit registers.
register dr(.clk(myclock), .load(dr_load), .inc(dr_inc), .clr(dr_clr), .outdata(dr_outdata), .indata(bus_data));
register ir(.clk(myclock), .load(ir_load), .inc(ir_inc), .clr(ir_clr), .outdata(ir_outdata), .indata(bus_data));
register ac(.clk(myclock), .load(ac_load), .inc(ac_inc), .clr(ac_clr), .outdata(ac_outdata), .indata(alu_outdata));
register tr(.clk(myclock), .load(tr_load), .inc(tr_inc), .clr(tr_clr), .outdata(tr_outdata), .indata(bus_data));

//ALU unit takes inputs from E-flipflop, DataRegister, Accumulator, InputRegister (not bus) and sends data only 
//to Accumulator and flip-flop E.
alu_unit alu(.ac_outdata(ac_outdata),.dr_outdata(dr_outdata),.inpr_outdata(inpr_outdata),.alu_code(alu_code),
				.e_outdata(e_outdata),.ff_en(ff_een),.e_indata(e_indata),.alu_outdata(alu_outdata));

//To keep track of time.
sequencecounter seqcount(.clk(myclock),.clr(seq_clr),.inc(seq_inc),.sequence(sequence));

//Chooses bus. Note the bus choosing numbers are exactly the same with our lecture notes.
buschooser bus_chooser(.bus_code(bus_code),.ar_outdata(ar_outdata),.pc_outdata(pc_outdata),.dr_outdata(dr_outdata),
				.ac_outdata(ac_outdata),.ir_outdata(ir_outdata),.tr_outdata(tr_outdata),.mem_outdata(mem_outdata),
				.bus_data(bus_data));

//Below are the necessary Flip Flops. E, FGI&FGO (Input-output clocks), IEN (interrupt enable)
//r input/output interrupt.
// Probably a few more FFs will come here in the future (for interrupt, ready, busy signals).
ff e(.clk(myclock), .ff_indata(e_indata),.reset(e_reset),.ff_clr(e_clr),.ff_en(ff_een),.ff_outdata(e_outdata), .ff_outdata_bar(e_outdata_bar));
ff fgi(.clk(myclock), .ff_indata(~control_fgi_indata & input_arrived_flag),.reset(alwaysfalse),.ff_clr(fgi_clr),.ff_en(alwaystrue),.ff_outdata(fgi_outdata), .ff_outdata_bar(fgi_outdata_bar));
ff fgo(.clk(myclock), .ff_indata(~control_fgo_indata & output_went_flag),.reset(alwaysfalse),.ff_clr(fgo_clr),.ff_en(alwaystrue),.ff_outdata(fgo_outdata), .ff_outdata_bar(fgo_outdata_bar));
ff ien(.clk(myclock), .ff_indata(ien_indata),.reset(alwaysfalse),.ff_clr(ien_clr),.ff_en(alwaystrue),.ff_outdata(ien_outdata), .ff_outdata_bar(ien_outdata_bar));
ff r(.clk(myclock), .ff_indata(r_indata),.reset(alwaysfalse),.ff_clr(r_clr),.ff_en(alwaystrue),.ff_outdata(r_outdata), .ff_outdata_bar(r_outdata_bar));

assign r_indata = ((sequence[3] || sequence[2] || (sequence[1] && sequence[0]))==1) ? 
						(ien_outdata & (fgo_outdata || fgi_outdata)) : 1'b0; 				
// The interrupt flag: r is assigned 1 if al three conditions are satisfied: 1)We are not in T0,T1 or T2. 
// 2) Interrupt is enabled. 3) One of the output or input flags are up. Above assignment assures this.

	
threebitdecoder dec_opcode(.opcode(ir_outdata[14:12]), .instruction(instruction));
fourbitdecoder seq_code(.code(sequence), .times(times));
// Above two make things ready for control, and become inputs to control unit. I'm not sure whether
// they are exactly necessary, but created them since they are in our lecture notes.
	
control controller(.ir_outdata(ir_outdata),.opcode(instruction),.times(times),
						.reset(reset),.start(start),.clk(myclock),
						.dr_outdata(dr_outdata), .ac_outdata(ac_outdata),
						.e_outdata(e_outdata),.r_outdata(r_outdata),
						.bus_code(bus_code), 
						.mem_write(mem_write),.mem_read(mem_read), .mem_clr(mem_clr),
						.ar_load(ar_load), .ar_inc(ar_inc),.ar_clr(ar_clr),
						.pc_load(pc_load), .pc_inc(pc_inc),.pc_clr(pc_clr),
						.dr_load(dr_load), .dr_inc(dr_inc),.dr_clr(dr_clr),
						.ac_load(ac_load), .ac_inc(ac_inc),.ac_clr(ac_clr),
						.ir_load(ir_load),.ir_inc(ir_inc),.ir_clr(ir_clr),
						.tr_load(tr_load), .tr_inc(tr_inc),.tr_clr(tr_clr),
						.outr_load(outr_load), .outr_clr(outr_clr),
						.inpr_clr(inpr_clr),		//Not in lecture notes, but added for synchronous resets.
						.seq_clr(seq_clr),.seq_inc(seq_inc),
						.fgi_outdata(fgi_outdata),.control_fgi_indata(control_fgi_indata),
						.fgo_outdata(fgo_outdata),.control_fgo_indata(control_fgo_indata),
						.ien_outdata(ien_outdata),.ien_indata(ien_indata),
						.e_reset(e_reset), .r_clr(r_clr), 
						.fgi_clr(fgi_clr), .fgo_clr(fgo_clr), .ien_clr(ien_clr),
						.io_clr(io_clr),
						.alu_code(alu_code)
						);
 

endmodule
