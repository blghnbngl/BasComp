`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232 Summer Project
// Engineer: Bilgehan
// 
// Create Date:    17:53:29 07/10/2016 
// Design Name: 
// Module Name:    control 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module control(
    input [15:0] ir_outdata,
    input [7:0] opcode,
    input [15:0] times,
    input reset,
    input interrupt,
    input start,
	 input clk, 
	 input dr_outdata,
	 input ac_outdata,
	 input e_outdata,
	 input fgi_outdata,
	 input fgo_outdata,
	 input ien_outdata,
    output [2:0] bus_code,
    output ar_load,
    output ar_inc,
    output ar_clr,
    output pc_load,
    output pc_inc,
    output pc_clr,
    output dr_load,
    output dr_inc,
    output dr_clr,
    output ac_load,
    output ac_inc,
    output ac_clr,
    output ir_load,
	 output ir_inc,
	 output ir_clr,
    output tr_load,
    output tr_inc,
    output tr_clr,
	 output mem_write,
	 output mem_read,			//This might be useless
	 output e_clr,
    output outr_load,
    output [3:0] alu_code,
	 output seq_clr,
	 output seq_inc,
	 output fgi_indata,
	 output ff_fgien,
	 output fgo_indata,
	 output ff_fgoen,
	 output ien_indata,
	 output ff_ienen,
	 output clockstopper
    );
	 
parameter T0 = 32'd0, T1=32'd1, T2=32'd2, T3=32'd3, T4=32'd4, T5=32'd5, T6=32'd6,T7=32'd7, T8=32'd8, T9=32'd9;	 
integer sequence_count;
reg indirect;
integer opcode_errorchecker;
integer registerreference_errorchecker;
reg starter;
	 
initial
	begin
		sequence_count=15*times[15]+14*times[14]+13*times[13]+12*times[12]+11*times[11]+10*times[10]+9*times[9]+
		8*times[8]+7*times[7]+6*times[6]+5*times[5]+4*times[4]+3*times[3]+2*times[2]+1*times[1];
		bus_code=3'b000;
		ar_load=0;
		ar_inc=0;
		ar_clr=0;
		pc_load=0;
		pc_inc=0;
      pc_clr=0;
		dr_load=0;
		dr_inc=0;
		dr_clr=0;
		ac_load=0;
		ac_inc=0;
		ac_clr=0;
		ir_load=0;
		ir_inc=0;
		ir_clr=0;
		tr_load=0;
		tr_inc=0;
		tr_clr=0;
		outr_load=0;
		alu_code=4'b0000;
		seqcountclr=0;
		clockstopper=0;
	end

always @(posedge clock)
	begin
		if (reset==1)
			begin
				ar_clr=1;
				pc_clr=1;
				dr_clr=1;
				ac_clr=1;
				tr_clr=1;
				seq_clr=1;
				pc_load=0;
				dr_load=0;
				ac_load=0;
				ir_load=0;
				tr_load=0;
				ar_load=0;
				outr_load=0;
				mem_write=0;
				mem_read=0;
				bus_code=3'b000;
				starter=0;
			end
		else if (interrupt==1)
			clockstopper=1; //TAKE A LOOK AT THIS!!!!!
		else if (starter==0 & reset==0 & interrupt==0)
			starter<=start;
		else if (starter==1 && sequence_count<3)
			begin
				case(sequence_count)
					T0:
						begin
							pc_load=0;
							dr_load=0;
							ac_load=0;
							ir_load=0;
							tr_load=0;
							outr_load=0;
							mem_write=0;
							mem_read=0;
							seq_clr=0;
							bus_code=3'b010;
							ar_load=1;
							seq_inc=1;
						end  
					T1:
						begin
							ar_load=0;
							mem_read=1;
							bus_code=3'b111;
							ir_load=1;
							seq_inc=1;
						end
					T2:
						begin
						// I GUESS (or hope) the decoding is done in the main module,
						// so there is no need to write here
							mem_read=0;
							ir_load=0;
							bus_code=3'b101;
							ar_load=1;
							indirect=ir_outdata[15];						
							opcode_errorchecker=instruction[7]+instruction[6]+instruction[5]+instruction[4]+instruction[3]
														+instruction[2]+instruction[1]+instruction[0]; //That's for checking errors.
							registerreference_errorchecker = 11*ir_outdata[11]+10*ir_outdata[10]+9*ir_outdata[9]
							+8*ir_outdata[8] +7*ir_outdata[7]+6*ir_outdata[6]+5*ir_outdata[5]+4*ir_outdata[4]
							+3*ir_outdata[3]	+2*ir_outdata[2]+1*ir_outdata[1]+0*ir_outdata[0];
							seq_inc=1;
						end
				endcase	
			end
		else if (starter==1 && sequence_count>2)
			begin 
				if (opcode_errorchecker!=1)
					$display("Error in decoding opcode, in control unit");
				else if (instruction[0]==1)			//And operation of Accumulator and Memory data
					begin
						case(sequence_count)
							T3:
								begin 
									if (indirect==1)
										begin
											bus_code=3'b111;
											mem_read=1;
											ar_load=1;
											seq_inc=1;
										end
									else
										begin
											bus_code=3'b000;
											ar_load=0;
											seq_inc=1;
										end
								end
							T4:
								begin
									ar_load=0;
									bus_code=3'b111;
									mem_read=1;
									dr_load=1;
									seq_inc=1;
								end
							T5:
								begin
									dr_load=0;
									bus_code=3'b000;
									mem_read=0;
									alu_code=4'b0001;
									ac_load=1;
									seq_inc=0;
									seq_clr=1;
								end
						endcase
					end
				else if(instruction[1]==1)	//Sum operation of Accumulator and Memory data
					begin
						case (sequence_count)
							T3:
								begin 
									if (indirect==1)
										begin
											bus_code=3'b111;
											mem_read=1;
											ar_load=1;
											seq_inc=1;
										end
									else
										begin
											bus_code=3'b000;
											ar_load=0;
											seq_inc=1;	
										end
								end
							T4:
								begin
									ar_load=0;
									bus_code=3'b111;
									mem_read=1;
									dr_load=1;
									seq_inc=1;			
								end
							T5:
								begin
									dr_load=0;
									bus_code=3'b000;
									mem_read=0;
									alu_code=4'b0010;
									ac_load=1;
									seq_inc=0;
									seq_clr=1;									
								end
						endcase
					end
				else if (instruction[2]==1)	//Load memory data to AC
					begin
						case (sequence_count)
							T3:
								begin 
									if (indirect==1)
										begin
											bus_code=3'b111;
											mem_read=1;
											ar_load=1;
											seq_inc=1;
										end
									else
										begin
										bus_code=3'b000;
										ar_load=0;
										seq_inc=1;
										end
								end
							T4:
								begin
									ar_load=0;
									bus_code=3'b111;
									mem_read=1;
									dr_load=1;
									seq_inc=1;	
								end
							T5:
								begin
									dr_load=0;
									mem_read=0;
									bus_code=3'b000;
									alu_code=4'b011;
									ac_load=1;
									seq_inc=0;
									seq_clr=1;
								end
						endcase
					end
				else if (instruction[3]==1)	//Store AC to memory
					begin
						case(sequence_count)
							T3:
								begin 
									if (indirect==1)
										begin
											bus_code=3'b111;
											mem_read=1;
											ar_load=1;
											seq_inc=1;
										end
									else
										begin
											bus_code=3'b000;
											ar_load=0;
											seq_inc=1;	
										end	
								end
							T4:
								begin
									ar_load=0;
									mem_read=0;
									bus_code=3'b100;
									mem_write=1;
									seq_inc=0;
									seq_clr=1;
								end
						endcase
					end
				else if (instruction[4]==1)	//Branch unconditionally
					begin
						case(sequence_count)
							T3:
								begin 
									if (indirect==1)
										begin
											bus_code=3'b111;
											mem_read=1;
											ar_load=1;
											seq_inc=1;
										end
									else
										begin
											bus_code=3'b000;
											ar_load=0;
											seq_inc=1;	
										end	
								end
							T4:
								begin
									ar_load=0;
									mem_read=0;
									bus_code=3'b001;
									pc_load=1;
									seq_inc=0;
									seq_clr=1;
								end
						endcase
					end
				else if (instruction[5]==1)		//Branch to subroutine
					begin
						case (sequence_count)
							T3:
								begin 
									if (indirect==1)
										begin
											bus_code=3'b111;
											mem_read=1;
											ar_load=1;
											seq_inc=1;
										end
									else
										begin
											bus_code=3'b000;
											ar_load=0;
											seq_inc=1;	
										end
								end
							T4:
								begin
									ar_load=0;
									mem_read=0;
									bus_code=3'b010;
									mem_write=1;
									ar_inc=1;
									seq_inc=1;
								end
							T5:
								begin
									mem_write=0;
									ar_inc=0;
									bus_code=3'b001;
									pc_load=1;
									seq_inc=0;
									seq_clr=1;
								end
						endcase
					end
				else if (instruction[6]==1)	// Increment and skip if zero
					begin
						case(sequence_count)
							T3:
								begin 
									if (indirect==1)
										begin
											bus_code=3'b111;
											mem_read=1;
											ar_load=1;
											seq_inc=1;
										end
									else
										begin
											bus_code=3'b000;
											ar_load=0;
											seq_inc=1;	
										end	
								end
							T4:
								begin
									ar_load=0;
									bus_code=3'b111;
									mem_read=1;
									dr_load=1;
									seq_inc=1;	
								end
							T5:
								begin
									dr_load=0;
									bus_code=3'b000;
									dr_inc=1;
									seq_inc=1;
								end
							T6:
								begin
									dr_inc=0;
									bus_code=3'b011;
									mem_write=1;
									seq_inc=0;
									if (dr_outdata==16'b0000000000000000)
										begin
											pc_inc=1;
											seq_clr=1;
										end			
									else
										seq_clr=1;									
								end
						endcase
					end
				else if (instruction[7]==1)
					begin
						if (SequenceCounter==3) // To avoid any wrong-timed operations
								begin
									if (Indirect==0)			//Below here, there are REGISTER REFERENCE instructions
										begin
											if (ir_outdata[11]==1 && registerreference_errorchecker==11)	//Clear AC
											//errochecker is to check errors, multiple 1's in 12 command bits
												begin
													bus_code=3'b000;
													ar_load=0;
													seq_inc=0;
													ac_clr=1;
													seq_clr=1;
												end
											else if (ir_outdata[10]==1 && registerreference_errorchecker==10)	//Clear E
												begin
													bus_code=3'b000;
													ar_load=0;
													seq_inc=0;
													e_clr=1;
													seq_clr=1;
												end
											else if (ir_outdata[9]==1 && registerreference_errorchecker==9)	//Complement AC	
												begin
													bus_code=3'b000;
													ar_load=0;
													seq_inc=0;
													alu_code=4'b1001;
													ac_load=1;
													seq_clr=1;												
												end
											else if (ir_outdata[8]==1 && registerreference_errorchecker==8)	//Complement E
												begin
													bus_code=3'b000;
													ar_load=0;											
													seq_inc=0;
													alu_code=4'b1010;
													seq_clr=1;
												end
											else if (ir_outdata[7]==1 && registerreference_errorchecker==7)	//Circular Shift to Right
												begin
													bus_code=3'b000;
													ar_load=0;											
													seq_inc=0;
													alu_code=4'b1011;
													ac_load=1;
													seq_clr=1;
												end
											else if (ir_outdata[6]==1 && registerreference_errorchecker==6)	//Circular Shift to Left
												begin
													bus_code=3'b000;
													ar_load=0;											
													seq_inc=0;
													alu_code=4'b1100;
													ac_load=1;
													seq_clr=1;
												end
											else if (ir_outdata[5]==1 && registerreference_errorchecker==5)	//Increment AC
												begin
													bus_code=3'b000;
													ar_load=0;											
													seq_inc=0;
													ac_inc=1;
													seq_clr=1;
												end
											else if (ir_outdata[4]==1 && registerreference_errorchecker==4)	//Skip if positive
												begin
													if (ac_outdata[15]==0)
														begin
															bus_code=3'b000;
															ar_load=0;											
															seq_inc=0;
															pc_inc=1;
															seq_clr=1;
														end
													else
														begin
															bus_code=3'b000;
															ar_load=0;											
															seq_inc=0;
															seq_clr=1;
														end
												end
											else if (ir_outdata[3]==1 && registerreference_errorchecker==3)	//Skip if negative
												begin
													if (ac_outdata[15]==1)
														begin
															bus_code=3'b000;
															ar_load=0;											
															seq_inc=0;
															pc_inc=1;
															seq_clr=1;
														end
													else
														begin
															bus_code=3'b000;
															ar_load=0;											
															seq_inc=0;
															seq_clr=1;
														end
												end
											else if (ir_outdata[2]==1 && registerreference_errorchecker==2)	//Skip if zero
												begin
													if (|ac_outdata==0)
														begin
															bus_code=3'b000;
															ar_load=0;											
															seq_inc=0;
															pc_inc=1;
															seq_clr=1;
														end
													else
														begin
															bus_code=3'b000;
															ar_load=0;											
															seq_inc=0;
															seq_clr=1;
														end
												end
											else if (ir_outdata[1]==1 && registerreference_errorchecker==1)	//Skip if E is 0
												begin
													if (e_outdata==0)
														begin
															bus_code=3'b000;
															ar_load=0;											
															seq_inc=0;
															pc_inc=1;
															seq_clr=1;
														end
													else
														begin
															bus_code=3'b000;
															ar_load=0;											
															seq_inc=0;
															seq_clr=1;
														end
												end
											else if (ir_outdata[0]==1 && registerreference_errorchecker==0)	//Halt
												begin
													bus_code=3'b000;
													ar_load=0;											
													seq_inc=0;
													starter<=0;		//Tie START to the user also
													seq_clr=1;
												end				
										end
									else if (indirect==1)		//Below here, there are INPUT/OUTPUT instructions
										begin
												if (ir_outdata[11]==1 && registerreference_errorchecker==11)	//Input character to AC
													begin
														bus_code=3'b000;
														ar_load=0;
														seq_inc=0;
														alu_code=4'b1101;
														ac_load=1;	
														ff_fgien=1;
														fgi_indata=0;
														seq_clr=1;
													end
												else if (ir_outdata[10]==1 && registerreference_errorchecker==10)	//Output character from AC
													begin
														ar_load=0;
														seq_inc=0;
														bus_code=3'b100;
														outr_load=1;
														ff_fgoen=1;
														fgo_indata=0;
														seq_clr=1;											
													end
												else if (ir_outdata[9]==1 && registerreference_errorchecker==9)	//Skip on input flag.
													begin
														if (fgi_outdata==1)
															begin
																bus_code=3'b000;
																ar_load=0;											
																seq_inc=0;
																pc_inc=1;
																seq_clr=1;
															end
														else
															begin
																bus_code=3'b000;
																ar_load=0;											
																seq_inc=0;
																seq_clr=1;
															end
													end
												else if (ir_outdata[8]==1 && registerreference_errorchecker==8)	//Skip on output flag.
													begin
														if (fgo_outdata==1)
															begin
																bus_code=3'b000;
																ar_load=0;											
																seq_inc=0;
																pc_inc=1;
																seq_clr=1;
															end
														else
															begin
																bus_code=3'b000;
																ar_load=0;											
																seq_inc=0;
																seq_clr=1;
															end
													end
												else if (ir_outdata[7]==1 && registerreference_errorchecker==7)	//Interrupt enable on
													begin
														ff_fgien=1;
														ien_indata=1;
													end
												else if (ir_outdata[6]==1 && registerreference_errorchecker==6)	//Interrupt enable off
													begin
														ff_fgien=1;
														ien_indata=0;
													end
										end
								end
							end
						end
					end
endmodule
