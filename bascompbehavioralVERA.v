`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232SummerProject
// Engineer: Bilgehan
// Create Date:    21:23:28 06/27/2016
// Module Name:    bhvframework
// Project Name:  behavioralbasiccomputerversionA
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module bhvframework(
    input reset,
	 input interrupt,
    output reg [31:0] Displayer//I created another variable for shoving values.But not exactly necessary, accumulator could be used too.
    );

parameter WIDTH=16;
parameter T0 = 32'd0, T1=32'd1, T2=32'd2, T3=32'd3, T4=32'd4, T5=32'd5, T6=32'd6,T7=32'd7, T8=32'd8, T9=32'd9;
/* If you need more than 9 clock cycles for your modules, feel free to increase the number of above parameters */
reg clock;
reg [WIDTH-1:0] InstructionMemory [4095:0];
reg [WIDTH-1:0] DataMemory [4095:0];
reg [11:0] ProgramCounter;
reg [11:0] AdressRegister;
reg [WIDTH-1:0] InstructionRegister;
reg [WIDTH-1:0] TemporaryRegister;
reg [WIDTH-1:0] DataRegister;
reg [WIDTH-1:0] Accumulator;
reg [7:0] InputRegister;
reg [7:0] OutputRegister;
integer SequenceCounter;
reg INTRP;
reg RST;
reg Indirect;
reg D0,D1,D2,D3,D4,D5,D6,D7;

initial
	begin
		clock<=1'b0;
		SequenceCounter<=0;
		INTRP <=0;
		RST<=0;
		forever #10 clock <= ~clock;
	end

always@(posedge clock)
	if (reset==1)
		begin
			Displayer<=0; //This could be something else, like an unknown value like x of verilog.
			SequenceCounter<=0;
			Accumulator<=0;
			ProgramCounter<=0;
		end
	else if (reset==0 && interrupt==1)
		begin
			INTRP<=1;
			//Here should come the interrupt part, for now I leave empty.
		end
	else if (reset==0 && interrupt==0)
		case(SequenceCounter)
			T0:
				begin
					AdressRegister<=ProgramCounter;
					SequenceCounter<=SequenceCounter+1;
				end
			T1:
				begin
					InstructionRegister<=InstructionMemory[AdressRegister];
					ProgramCounter<=ProgramCounter+1;
					SequenceCounter<=SequenceCounter+1;
				end
			T2:
				begin
					AdressRegister <= InstructionRegister[11:0];
					//In lecture notes, that's written as IR[0:11] but I think that's more correct. We can ask Uluc Hoca.
					Indirect<= InstructionRegister[15];
					Decoder D1(D7,D6,D5,D4,D3,D2,D1,D0,InstructionRegister[14],InstructionRegister[13],InstructionRegister[12]);
					SequenceCounter<=SequenceCounter+1;
				end
			default:
				begin
					SequenceCounter<=SequenceCounter+1;
					//Here comes your modules related to register or memory operations.
				end
		endcase
endmodule



