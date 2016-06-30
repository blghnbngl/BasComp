`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232SummerProject
// Engineer: Bilgehan
// Create Date:    21:10:50 06/29/2016 
// Module Name:    bascompbehavioralVERB 
// Additional Comments: This one is more complete version of behavioral model. Consists of a single behavioral module.
//						One reason is that behavioral is hard to work in a modular fashion.
//	EXPLANATIONS:	Lines 18-49 are required definitions. Lines 47-57 initializations. Lines 59-71 are related to interrupt 
//	and reset, but are NOT complete. Lines 72-101 are the operations in the first three clock cycle (T0, T1, T2 in our lecture 
// notes, page 28. These 3 clock cycles are are same for all operations. Lines 101-291 are memory reference instructions.
// Lines 295-400 are register reference instructions.  Lines 400-446 are input output operations.
//	To get a clear picture, look at ASM in page 28 of our lecture notes and in instruction lists.
//
//WARNING: Parts related to interrupt are empty. Also, input-output parts should be developed.
//PARTS IN NEED OF IMMEDIATE CHECKS: L88,L301, L313, L321, L398
//////////////////////////////////////////////////////////////////////////////////
module bascompbehavioralVERB(
    input reset,
    input interrupt,
    output reg [31:0] Displayer//I created another variable for shoving values.But not exactly necessary, accumulator could be used too.
    );


parameter WIDTH=16;
parameter T0 = 32'd0, T1=32'd1, T2=32'd2, T3=32'd3, T4=32'd4, T5=32'd5, T6=32'd6,T7=32'd7, T8=32'd8, T9=32'd9;
/* If you need more than 9 clock cycles for your modules, feel free to increase the number of above parameters */
reg clock;
reg [WIDTH-1:0] InstructionMemory [4095:0];			// I decided to seperate instruction and data memory but later thought
reg [WIDTH-1:0] DataMemory [4095:0];					//this was a bad idea. So DataMemory was never used, and instruction
reg [11:0] ProgramCounter;									// memory is the same as the memory we saw in lectures.
reg [11:0] AdressRegister;
reg [WIDTH-1:0] InstructionRegister;
reg [WIDTH-1:0] TemporaryRegister;
reg [WIDTH-1:0] DataRegister;								
reg [WIDTH-1:0] Accumulator;								 
reg [WIDTH:0] CarryFlagAccumulator;						//To detect whether there is a carry.
reg [7:0] InputRegister;
reg [7:0] OutputRegister;
reg InputFlag,OutputFlag,InterruptEnable;
reg E;															//For carry outs.
reg S;															//Start signal
reg ErrorFlag;													// I use it to stop operations in case of an error
reg TemporaryOneBit;											// Necessary in shift operations
integer SequenceCounter;
integer D,D2;													// For decoding op-codes.
reg INTRP;														//Becomes 1 with interrupt signal.		
reg RST;															//Becomes 1 with reset signal.
reg Indirect; 													//To see whether a direct or indirect operation.

initial
	begin
		SequenceCounter<=0;
		INTRP <=0;
		RST<=0;
		ProgramCounter <=0; //I'm not totally sure about this. Should program counter be initialized?
	end

always@(posedge clock)
	if (reset==1)
		begin
			Displayer<=0; //This could be something else, like an unknown value like x of verilog.
			SequenceCounter<=0;
			Accumulator<=0;
			DataRegister <=0;
			ProgramCounter<=0;
		end
	else if (reset==0 && interrupt==1)
		begin
			INTRP<=1;
			//Here should come the interrupt part, for now I leave empty.
		end
	else if (reset==0 && interrupt==0 && SequenceCounter<3)		//First three clock cyclesç
		begin
			case (SequenceCounter)
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
							// The below D and D2 do not exist in lecture notes. But I have to use it in this clock cycle
							// to be able to decode op codes.
							D <= 4*InstructionRegister[14] + 2*InstructionRegister[13] + 1*InstructionRegister[12];
D2 <= 11*InstructionRegister[11]+10*InstructionRegister[10]+9*InstructionRegister[9]+8*InstructionRegister[8]//
		+7*InstructionRegister[7]+6*InstructionRegister[6]+5*InstructionRegister[5]+4*InstructionRegister[4] //
		+3*InstructionRegister[3]+2*InstructionRegister[2]+1*InstructionRegister[1]+0*InstructionRegister[0];
							SequenceCounter<=SequenceCounter+1;
						end
				endcase
			end
		else if (reset==0 && interrupt==0 && SequenceCounter>2)
			begin
				case(D)						// Cases 0-6 are memory reference instructions.
					0:							//And to Accumulator
						begin
							case (SequenceCounter)
								T3:
									begin
										if (Indirect==1)
											begin
												AdressRegister<=InstructionMemory[AdressRegister];
												SequenceCounter<=SequenceCounter+1;
											end
										else if (Indirect==0)
												SequenceCounter<=SequenceCounter+1;							
									end
								T4:
									begin 
										DataRegister<=InstructionMemory[AdressRegister];
										SequenceCounter<=SequenceCounter+1;
									end
								T5:
									begin 
										Accumulator<=Accumulator & DataRegister;
										SequenceCounter<=0;
									end
							endcase
					end
				1:								//Add to Accumulator, save the carry.
					begin
						case (SequenceCounter)
							T3:
								begin
									if (Indirect==1)
										begin
											AdressRegister<=InstructionMemory[AdressRegister];
											SequenceCounter<=SequenceCounter+1;
										end
									else if (Indirect==0)
											SequenceCounter<=SequenceCounter+1;							
								end
							T4:
								begin 
									DataRegister<=InstructionMemory[AdressRegister];
									CarryFlagAccumulator<=Accumulator + InstructionMemory[AdressRegister]; 
									//Above part does not exist in lecture notes, but I had to put it to find carry. 
									//Only alternative would be using a zero delay in part T5, which is not advised but I put it as a comment anyway.
									SequenceCounter<=SequenceCounter+1;
								end
							T5:
								begin 
									Accumulator<=Accumulator + DataRegister;
									//CarryFlagAccumulator<=Accumulator + DataRegister; 
									//	#1 E<=CarryFlagAccumulator[WIDTH];
									E<=CarryFlagAccumulator[WIDTH];
									SequenceCounter<=0;		
								end
						endcase
					end
				2:								//Load to accumulator
					begin
						case (SequenceCounter)
							T3:
									begin
										if (Indirect==1)
											begin
												AdressRegister<=InstructionMemory[AdressRegister];
												SequenceCounter<=SequenceCounter+1;
											end
										else if (Indirect==0)
												SequenceCounter<=SequenceCounter+1;							
									end
								T4:
									begin 
										DataRegister<=InstructionMemory[AdressRegister];
										SequenceCounter<=SequenceCounter+1;
									end
								T5:
									begin
										Accumulator <=DataRegister;
										SequenceCounter<=0;
									end
							endcase
						end
					3:						//Store Accumulator
						begin
							case (SequenceCounter)
								T3:
									begin
										if (Indirect==1)
											begin
												AdressRegister<=InstructionMemory[AdressRegister];
												SequenceCounter<=SequenceCounter+1;
											end
										else if (Indirect==0)
												SequenceCounter<=SequenceCounter+1;							
									end
								T4:
									begin
										InstructionMemory[AdressRegister]<=Accumulator;
										SequenceCounter<=0;							
									end
							endcase
						end
								
					4:						//Branch unconditionally
						begin
							case (SequenceCounter)
								T3:
									begin
										if (Indirect==1)
											begin
												AdressRegister<=InstructionMemory[AdressRegister];
												SequenceCounter<=SequenceCounter+1;
											end
										else if (Indirect==0)
												SequenceCounter<=SequenceCounter+1;							
									end
								T4:
									begin
										ProgramCounter<= AdressRegister;
										SequenceCounter<=0;							
									end
							endcase
						end
					5:							//Branch and save return
						begin
							case (SequenceCounter)
								T3:
									begin
										if (Indirect==1)
											begin
												AdressRegister<=InstructionMemory[AdressRegister];
												SequenceCounter<=SequenceCounter+1;
											end
										else if (Indirect==0)
												SequenceCounter<=SequenceCounter+1;							
									end
								T4:
									begin
										InstructionMemory[AdressRegister]<=ProgramCounter;
										#1 AdressRegister<= AdressRegister + 1; //An unadvised practice but I had to use it.
										SequenceCounter<=SequenceCounter+1;							
									end
								T5:
									begin
										ProgramCounter<=AdressRegister;
										SequenceCounter<=0;		
									end
							endcase
						end
					6:								//Increment and skip if zero
						begin
							case (SequenceCounter)
								T3:
									begin
										if (Indirect==1)
											begin
												AdressRegister<=InstructionMemory[AdressRegister];
												SequenceCounter<=SequenceCounter+1;
											end
										else if (Indirect==0)
												SequenceCounter<=SequenceCounter+1;							
									end
								T4:
									begin
										DataRegister<=InstructionMemory[AdressRegister];
										SequenceCounter<=SequenceCounter+1;							
									end
								T5:
									begin
										DataRegister<=DataRegister+1;
										SequenceCounter<=SequenceCounter+1;							
									end
								T6:
									begin
										if (DataRegister==0)
											begin
												InstructionMemory[AdressRegister] <= DataRegister;
												ProgramCounter<=ProgramCounter+1;
												SequenceCounter<=0;
											end
										else if (DataRegister==1)
											begin
												InstructionMemory[AdressRegister] <= DataRegister;
												SequenceCounter<=0;
											end
									end
							endcase
						end
					7:											//Below are register and input-output operations
						begin
							if (SequenceCounter==3) // To avoid any wrong-timed operations
								begin
									if (Indirect==0)			//Below here, there are register reference instructions
										begin
											case (D2)
												11:				//Clear Accumulator
													begin	
														Accumulator<=0;				// I guess I do not have to write WIDTH'b000, etc.
														SequenceCounter<=0;	
													end
												10:				//Clear carry
													begin	
														E<=0;
														SequenceCounter<=0;	
													end
												9:					//Bitwise invert the Accumulator
													begin	
														Accumulator<=~Accumulator; //May or may not work. NEED TO CHECK!!!!
														SequenceCounter<=0;	
													end
												8:					//Invert the carry
													begin	
														E<=~E;
														SequenceCounter<=0;	
													end
												7:					//Right shift the Accumulator, and carry too.
													begin	
														TemporaryRegister<=Accumulator;
														TemporaryOneBit <= E;
														#1 Accumulator[WIDTH-2:0] <= TemporaryRegister[WIDTH-1:1];
														#1 E<=TemporaryRegister[0];
														#1 Accumulator[WIDTH-1] <= TemporaryOneBit;
														SequenceCounter<=0;	
													end
												6:					//Left shift the Accumulator, and carry too.
													begin	
														TemporaryRegister<=Accumulator;
														TemporaryOneBit <= E;
														#1 Accumulator[WIDTH-1:1] <= TemporaryRegister[WIDTH-2:0];
														#1 E<=TemporaryRegister[WIDTH-1];
														#1 Accumulator[0] <= TemporaryOneBit;
														SequenceCounter<=0;	
														//Does this work, need to check. A not a great code actually.
													end
												5:					//Increment Accumulator
													begin	
														Accumulator<=Accumulator + 1;
														SequenceCounter<=0;	
													end
												4:					//Skip if positive
													begin	
														if (Accumulator[15]==0)
															begin
																ProgramCounter<=ProgramCounter+1;
																SequenceCounter<=0;	
															end
														else if (Accumulator[15]==1)
															SequenceCounter<=0;
													end
												3:					//Skip if negative
													begin	
														if (Accumulator[15]==1)
															begin
																ProgramCounter<=ProgramCounter+1;
																SequenceCounter<=0;	
															end
														else if (Accumulator[15]==0)
															SequenceCounter<=0;
													end
												2:					//Skip if zero
													begin	
														if (Accumulator==0)
															begin
																ProgramCounter<=ProgramCounter+1;
																SequenceCounter<=0;	
															end
														else if (Accumulator!=0)
															SequenceCounter<=0;
													end
												1:					//If carry is 0, skip
													begin	
														if (E==0)
															begin
																ProgramCounter<=ProgramCounter+1;
																SequenceCounter<=0;	
															end
														else if (E!=0)
															SequenceCounter<=0;
													end
												0:					//Halt
													begin 
														if (InstructionRegister[0]==0)
															begin
																$Display("Error in Decoding Register Reference Instruction B0");
																ErrorFlag<=1;
																SequenceCounter<=0;
															end
														else if (InstructionRegister[0]==1)
															begin
																S<=0;
																SequenceCounter<=0;
															end
													end
												default:
													$Display("Error in Decoding Register Reference Instructions, multiple 1 values in InstructionRegister[11:0]");
										endcase
									end
							else if (Indirect==1)				//Input-Output Operations
								begin
									case(D2)
										11:						//Get input to Accumulator
											begin
												Accumulator[7:0]<=InputRegister; 
												//In lectures notes, [0:7] is written for accumulator but verilog does not compile this way
												//Should be checked later to correct this.
												InputFlag<=0;
												SequenceCounter<=0;
											end
										10:						//Put output from Accumulator
											begin
												OutputRegister<=Accumulator[7:0];
												//In lectures notes, [0:7] is written for accumulator but verilog does not compile this way
												//Should be checked later to correct this.
												OutputFlag<=0;
												SequenceCounter<=0;
											end
										9:							//Skip on input flag
											begin
												if (InputFlag==1)
													begin
														ProgramCounter<=ProgramCounter+1;
														SequenceCounter<=0;
													end
												else if (InputFlag==0)
													SequenceCounter<=0;		
											end
										8:							//Skip on output flag
											begin
												if (OutputFlag==1)
													begin
														ProgramCounter<=ProgramCounter+1;
														SequenceCounter<=0;
													end
												else if (OutputFlag==0)
													SequenceCounter<=0;		
											end
										7:						//Interrupt enable on
											begin
												InterruptEnable<=1;	
												SequenceCounter<=0;														
											end
										6: 					//Interrupt enable off
											begin
												InterruptEnable<=0;	
												SequenceCounter<=0;												
											end
										default:
											$Display("Error in Decoding Input-Output Instructions, undefined instruction observed");
									endcase
								end							
							end
					end
		endcase
	end
endmodule
