`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:51:55 07/31/2016 
// Design Name: 
// Module Name:    board 
// Revision 0.01 - File Created
// Additional Comments: This one is the top module. This helps arranging the relationship between the physical
// components of FPGA and the Basic Computer (which is the main module here). 
//		Please note that for input-output on the FPGA to work, a UCF file should be correctly specified. But 
//	since the final output of this Basic Computer is undecided yet, I leave the UCF file unfinished.
//		FPGA's internal clock, fpgaclock always works. But the Basic Computer's clock, which is called myclock
//	and goes into the main module must work only if the Basic Computer is given the start command. This is 
// assured by a flip-flop named clockworker and the ASM between 116-197. If the system is given the start  
//	command and not interrupted, halted or reseted then clockworker is one, Basic Computer (and it's clock)
//	works. If start order is not given or system is interrupted, halted or reseted then clockworker is 0. Then 
// Basic Computer's clock is always 0 and it does not work.
//
//////////////////////////////////////////////////////////////////////////////////
module board(
	 input fpgaclock,				//This one is FPGA's internal clock
    input start,					//A kkey on FPGA
    input interrupt,				//A key on FPGA
    input reset,					//A key on FPGA
	 input ps2d,					//Ps/2 Keyboard data
	 input ps2c,					//Ps/2 keyboard's clock
	 output vsynch,				//Output for VGA
	 output hsynch,				//Output for VGA
	 output [7:0] rgb,			//Output for VGA
    output reg ready,			//A sign on FPGA
    output reg busy,				//A sign of FPGA
    output reg interrupted,	//A sign on FPGA
	 output reg halted_condition//A sign on FPGA
    );

parameter S0=0, S1=1, S2=2, S3=3;

wire alwaysfalse;
wire alwaystrue;

reg [2:0] state;
reg [2:0] next_state;
reg clockworker;			// When this FF becomes 0 myclcok stops, when this becomes 1 myclock works.
reg [20:0] fpgaclock_counter;		//This counter is used to slow the FPGA's clock
reg myclock;				// That's the clock that goes in the main module
reg myclock2;				//That's required to synchronize the ASM here and the process in main
								//myclock2 does not go into the main module.

reg mhz25_clock;	// A slower clock (at rate 25 MHz) is needed for VGA interface. I produce this below

assign alwayfalse=0;
assign alwaytrue=1;

/*
ff clockworker(.clk(fpgaclock), .ff_indata(start && (~interrupt) && (~resetFF) && (~halted)),
					.ff_clr(alwasfalse),.reset(alwaysfalse),.ff_en(start || interrupt ||resetFF ||halted),
					.ff_outdata(clockwerker_outdata), .ff_outdata_bar(clockwerker_outdata_bar));
*/



main main(.start(start),.reset(reset),.myclock(myclock),.ps2d(ps2d),.ps2c(ps2c),.vsynch(vsynch),
			.hsynch(hsynch),.rgb(rgb),.halted(halted),.value(value),.mhz25_clock(mhz25_clock)); 
			


//Here, I slow the clock of FPGA, since it is too fast. Also, FPGA clock has 50 Mhz frequency
// but I need a 25 Mhz clock for the input output module under main due to properties of VGA display. 
initial
	begin
		fpgaclock_counter<=0;
		mhz25_clock<=0;
	end

always @ (posedge fpgaclock)
	begin
		if (fpgaclock_counter==21'b111111111111111111111)		
			begin
				fpgaclock_counter<=0;
				mhz25_clock<=~mhz25_clock;				//This assures mhz25 clock has half the speed of FPGA clock
			end
		else
			begin
				fpgaclock_counter<=fpgaclock_counter+1;
				mhz25_clock<=~mhz25_clock;
			end
	end

//Now, I set myclock as a combination of slowed fpga clock and my decision to start the process.
// If process should go on, then clockworker becomes 1 and clock works.
initial 
	begin
		myclock<=0;
		myclock2<=0;
	end
	
always @(fpgaclock_counter[20] or clockworker)	
	myclock=fpgaclock_counter[20] & clockworker;			//This one goes into the main

always @(fpgaclock_counter[20])
	myclock2=fpgaclock_counter[20];
	
initial
	begin
		ready<=1;					//Initially, ready sign is flashing
		busy<=0;
		interrupted<=0;
		clockworker<=0;
		halted_condition<=0;
		state<=0;
		next_state<=0;
	end

always @ (posedge myclock2)
	begin
		state<=next_state;
	end
	
always @ (posedge myclock2)
	begin
		case (state)
			S0: 							//Ready, waiting to start
				begin
					if (start)
						next_state<=S1;
					else 
						next_state<=S0;
				end	
			S1:						//Started to work, busy
				begin
					if (interrupt)
						next_state<=S2;
					else if (halted)
						next_state<=S3;
					else if (reset)
						next_state<=S0;
					else
						next_state<=S1;
				end
			S2:							//Interrupted
				begin
					if (interrupt)		//If user presses interrupt again, system keeps on working
						next_state<=S1;
					else if (reset)
						next_state<=S0;
					else 
						next_state<=S2;
				end
			S3:							//Halted by program inside 
				begin
					if (reset)
						next_state<=S0;
					else
						next_state<=S3;
				end			
		endcase
	end
	
always@ (state)							//THis one shows which signs on FPGA are flashing under which condition.
	begin
		case (state)
			S0:
				begin
					ready<=1;
					busy<=0;
					interrupted<=0;
					clockworker<=0;
					halted_condition<=0;
				end
			S1:			
				begin
					ready<=0;
					busy<=1;
					interrupted<=0;
					clockworker<=1;			//With clockworker=1, Basic Computer's clock begins to work and 
					halted_condition<=0;		//Basic Computer starts processing.
				end
			S2:
				begin
					ready<=0;
					busy<=0;
					interrupted<=1;
					clockworker<=0;
					halted_condition<=0;
				end
			S3:
				begin
					ready<=0;
					busy<=0;
					interrupted<=0;
					clockworker<=0;
					halted_condition<=1;
				end
		endcase
	end

    


/*	
always @(posedge fpgaclock or posedge start or posedge reset)
	begin
		if (ready==1)
			begin
				if (start==1)
					begin
						ready<=0;
						busy<=1;
						clockworker_outdata<=1;		//Now, myclock starts to work so main also works.
					end
			end
		else if (busy==1)
			begin 
				if (reset==1)				
					begin
						clockstopper<=1;		//myclock becomes 0 permanently so main does not work.
						busy<=0;		// At the same time, reset signal causes main to return everything	
						ready<=1;		// in main to its initial status.
					end
				else if (interrupt==1)		// Interrupt and stop working.
					begin
						clockstopper<=1;		//myclock becomes 0 until interrupt is pressed again and main doesn't work.
						busy<=0;		
						interrupted<=1;
					end 
				else if (halted==1)		//This halts the process with an order in the code.
					begin						// PROBLEM: But how does process continue to work after this??
						clockstopper<=1;
					end
			end	
		else if (interrupted==1)
			begin
					if (reset==1)
						begin
							clockworker<=0;
							interrupted<=0;
							ready<=1;
						end
					else if (interrupt==1)		//Interruption starts, process goes on again.
						begin
							clockworker<=1; 	//myclock and main continue working.	
							interrupted<=0;
							busy<=1;	
						end
			end
	end 
*/
endmodule
