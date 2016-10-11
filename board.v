`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:51:55 07/31/2016 
// Design Name: 
// Module Name:    board 
// Revision 0.01 - File Created
// Additional Comments: Under this file, we have the main module. This one also sets the relationship with 
// the physical components of FPGA.
//
//////////////////////////////////////////////////////////////////////////////////
module board(
	 input fpgaclock,
    input start,
    input interrupt,
    input reset,
	 input ps2d,
	 input ps2c,
	 output vsynch,
	 output hsynch,
	 output [7:0] rgb,
    output reg ready,
    output reg busy,
    output reg interrupted,
	 output reg halted_condition
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

reg mhz25_clock;	// A slower clock (at rate 25 MHz) is needed for VGA interface

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
// but I need a 25 Mhz clock for the input output module under main. 
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
				mhz25_clock<=~mhz25_clock;
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
	myclock=fpgaclock_counter[20] & clockworker;

always @(fpgaclock_counter[20])
	myclock2=fpgaclock_counter[20];
	
initial
	begin
		ready<=1;
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
	
always@ (state)
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
					clockworker<=1;
					halted_condition<=0;
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
