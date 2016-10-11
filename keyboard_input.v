`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:01:02 09/17/2016 
// Design Name: 
// Module Name:    keyboard_input 
// Revision 0.01 - File Created
// Additional Comments: 
//
//	A very simple PS/2 keyboard interface. Work of an Indian group of students was helpful in plannig this
// module.
//
// It takes two inputs from keyboard, ps2c (clock of keyboard) and ps2d (1 bit data). Due to properties of 
//	PS/2 keyboards, data are available at the negative edge of keyboard clock. When a key is pressed on, the
// 8 bit code sent by the keyboard is taken into registers. When all 8 bits are completed, this is sent out.
// In addition, a flag showing input has arrived is also sent.
//
//	Key point is between lines 70-83. After every pressed key, an end signal, 8'hf0 is sent. For example if
// A (which has code 1C) is pressed, what keyboard sents is 1C F0 bit by bit. If A is kept pressed for some
// time then 1C 1C 1C 1C ..... F0 is sent. My code accepts an input only when it sees F0 code in the end.  
//	
//	When the F0 code is seen, previously stored key code (1C for letter A) is sent as an output, and a flag
//	telling input has arrived is sent. A side effect of this design is even if a key is held for a long time,
//	it is sent to input register only once (because the module waits to see the F0 signal), but I think this
//	is a reasonable cost for a simple and efficient design. 
//
//////////////////////////////////////////////////////////////////////////////////
module keyboard_input_interface(
	 input clr,
    input ps2c,									//ps2 clock
    input ps2d,									//ps2 data
    output reg [7:0] keyboard_input_data,
    output reg input_arrived_flag
    );

	 
reg [7:0] data_curr;
reg [7:0] data_pre;
reg flag;
reg [3:0] b;


initial
	begin
		b<=4'h1;
		flag<=1'b0;
		input_arrived_flag<=1'b0;
		data_curr<=8'hf0;
		data_pre<=8'hf0;
		keyboard_input_data<=8'hf0;
	end
	
always @(negedge ps2c or posedge clr) //Activating at negative edge of clock from keyboard, becuase of properties of 
	begin					 // PS/2 devices.	Below, the input is stored.
		if (clr==1)
			begin
				b<=4'h1;
				flag<=1'b0;
				data_curr<=8'hf0;
			end
		else
			begin
				case(b)
				1:; //first bit, which should be 0.
				2:data_curr[0]<=ps2d;
				3:data_curr[1]<=ps2d;
				4:data_curr[2]<=ps2d;
				5:data_curr[3]<=ps2d;
				6:data_curr[4]<=ps2d;
				7:data_curr[5]<=ps2d;
				8:data_curr[6]<=ps2d;
				9:data_curr[7]<=ps2d;
				10:flag<=1'b1; //Parity bit
				11:flag<=1'b0; //Ending bit, which should be 1
				endcase
			if(b<=10)
				b<=b+1;
			else if(b==11)
				b<=1;
			end
	end
	
always@(posedge flag) // Printing data obtained to keyboard_input_data
	begin
		if(data_curr==8'hf0)				//This part makes this device send a single letter even if a key
			begin								//is pressed and held for a long time.
				keyboard_input_data<=data_pre;	
				input_arrived_flag<=1;	//Now the input and the sign that input register is ready are sent
			end
		else
			begin
				data_pre<=data_curr;
				if (data_curr!=8'b11111111)	//This makes input_arrived flag to remain unchanged when the bus 
					input_arrived_flag<=0;		//is idle (in that state it sends a constant stream of 1s).
			end
	end 

endmodule
