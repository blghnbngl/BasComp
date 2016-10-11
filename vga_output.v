`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
//
// Revision 0.01 - File Created
// Additional Comments: 
//
//	Parts of element 14 website and Pong P. Chu's book were helpful for developing this module. 
// Because of properties of VGA, this one must take a in clock with 25 Mhz frequency. It also takes data 
// from output register. In return, it sends out a output went flag and 3 signals to VGA device. These 
// signals are vsynch for vertical synchronization, hsynch for horizontal synchronization and an 8-bit
// color value rgb. First three bits are red, later three are green and final three bits are blue values.
//
//	Input data that comes from output register is used to create a different color on VGA for each different
//	input. The same color paints all the screen for each output register data.Using digital inputs for just 
//	to create a different color is not very meaningful, but the main purpose of this module is to complete
// a basic computer in the quickest way not to create a great output.
//
//////////////////////////////////////////////////////////////////////////////////
module vga_output_interface(
    input mhz25_clock,
    input [7:0] outr_outdata,
	 input clr,
    output vsynch,
    output hsynch,
    output reg [7:0] rgb,
	 output reg output_went_flag
    );

// video  constants for 640x480 VGA, these are the boundaries.
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 525; // vertical lines per frame
parameter HD=640; 	//horizontal display area
parameter HF=48;	//horizontal front(right) border
parameter HB=16;	//horizontal back(left) border
parameter HR = 96; 	// hsync retrace
parameter VD=480;	//vertical display area
parameter VF=10;	//vertical front(bottom) border
parameter VB=33;	//vertical back(top) border
parameter VR = 2; 	// vsync retrace
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 12; 		// end of vertical back porch
parameter vfp = 492; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 492 - 12 = 480


reg [18:0] fgo_signal_counter;
//This one is to send a completed signal to FGO when all the screen is covered.

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

initial
	begin
		hc<=0;
		vc<=0;
		output_went_flag<=0;
	end

always @(posedge mhz25_clock or posedge clr)
	begin
		if (clr == 1)	// reset condition
			begin
				hc <= 0;
				vc <= 0;
			end
	else
		begin
			if (hc < hpixels - 1) // keep counting until the end of the line
				hc <= hc + 1;
			else
			// When we hit the end of the line, reset the horizontal
			// counter and increment the vertical counter.
			// If vertical counter is at the end of the frame, then
			// reset that one too.
				begin
					hc <= 0;
					if (vc < vlines - 1)
						vc <= vc + 1;
					else
						vc <= 0;
		end
		
	end
end


// generate sync pulses (active low)
assign hsync = (hc < HR) ? 0:1;
assign vsync = (vc < VR) ? 0:1;

always @ (outr_outdata)			//When output register data changes, output went flag is restarted.
	begin
		fgo_signal_counter<=0;
		output_went_flag<=0;
	end

always @ (fgo_signal_counter)
	begin
		if (fgo_signal_counter==19'b1001011000000000000)	 
			output_went_flag<=1;								//When all the screen is covered, a signal is sent to FGO.
	end
	
always @(*)
	begin
		// first check if we're within vertical active video range
		if (vc  >= vbp && vc < vfp)
			begin
				if (hc >= hbp && hc < hfp)
					begin
						rgb[7:5] <= outr_outdata[7:5]; //red
						rgb[4:2] <= outr_outdata[4:2];	//green
						rgb[1:0] <= outr_outdata[1:0]; //blue
						fgo_signal_counter<=fgo_signal_counter+1;	//For each pixel, counter is increased one.
					end
				else
					rgb[7:0] <= 8'b00000000;		//All black
			end
		else // we're outside active vertical range so display black
			begin
				rgb[7:0] <= 8'b00000000;
			end
	end

endmodule
