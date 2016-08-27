`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:51:55 07/31/2016 
// Design Name: 
// Module Name:    board 
// Revision 0.01 - File Created
// Additional Comments: Under this file, we have the main module working. Board module takes inputs and sends the necessary 
// signals to main module, also sets the clock and sends it to the main module. It also specifies the necessary outputs.
// These outputs are then turned into physical signals of FPGA by the UCF file.
//////////////////////////////////////////////////////////////////////////////////
module board(
	 input fpgaclock,
    input start,
    input interrupt,
    input reset,
    output reg ready,
    output reg busy,
    output reg interrupted
    );

reg clockworker;			// When this FF becomes 0 myclcok stops, when this becomes 1 myclock works.
reg [20:0] fpgaclock_counter;		//This counter is used to slow the FPGA's clock
reg myclock;				// That's the clock that goes in the main module
wire halted;				//This comes from main module as an out-signal.

main main(.start(start),.reset(reset),.myclock(myclock),.halted(halted),.value(value)); 

//Here, I slow the clock of FPGA, since it is too fast.
initial fpgaclock_counter<=0;

always @ (posedge fpgaclock)
	begin
		if (fpgaclock_counter==21'b111111111111111111111)
			fpgaclock_counter<=0;
		else
			fpgaclock_counter<=fpgaclock_counter+1;
	end

//Now, I set myclock as a combination of slowed fpga clock and my decision to start the process.
// If process should go on, then clockworker becomes 1 and clock works.
		
initial myclock<=0;
always @(fpgaclock_counter[20] or clockworker)	
	myclock=fpgaclock_counter[20] & clockworker;

    
initial
	begin
		ready=1;
		busy=0;
		interrupted=0;
	end
	
always @(posedge fpgaclock)
	begin
		if (ready==1)
			begin
				if (start==1)
					begin
						ready<=0;
						busy<=1;
						clockworker<=1;		//Now, myclock starts to work so main also works.
					end
			end
		else if (busy==1)
			begin 
				if (reset==1)				
					begin
						clockworker<=0;		//myclock becomes 0 permanently so main does not work.
						busy<=0;		// At the same time, reset signal causes main to return everything	
						ready<=1;		// in main to its initial status.
					end
				else if (interrupt==1)		// Interrupt and stop working.
					begin
						clockworker<=0;		//myclock becomes 0 until interrupt is pressed again and main doesn't work.
						busy<=0;		
						interrupted<=1;
					end 
				else if (halted==1)		//This halts the process with an order in the code.
					begin						// PROBLEM: But how does process continue to work after this??
						clockworker<=0;
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
							busy=1;	
						end
			end
	end 

endmodule