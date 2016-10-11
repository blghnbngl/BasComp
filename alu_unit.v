`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:27:20 07/15/2016 
// Design Name: 
// Module Name:    alu_unit 
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
//
//////////////////////////////////////////////////////////////////////////////////
module alu_unit(
    input [15:0] ac_outdata,
    input [15:0] dr_outdata,
    input e_outdata,
    input [7:0] inpr_outdata,
	 input [3:0] alu_code,
    output [15:0] alu_outdata,
    output e_indata,
	 output ff_en
    );

genvar i;
genvar j;

wire [15:0] sxtnbitsum;
wire sxtnbitcarry_out;
wire alwaystrue, alwaysfalse;


assign alwaystrue = 1'b1;
assign alwaysfalse = 1'b0;

sixteenbitadder sxtnbitadder(.sixteenbitinput1(ac_outdata), .sixteenbitinput2(dr_outdata),
									.sixteenbitsum(sxtnbitsum), .sixteenbitcarry_out(sxtnbitcarry_out));
									

									
assign ff_en = (alu_code==4'b0010) ? 1'b1:
					(alu_code==4'b1010) ? 1'b1:
					(alu_code==4'b1011) ? 1'b1:
					(alu_code==4'b1100) ? 1'b1: 
					/*Default*/				 1'b0;

assign e_indata = (alu_code==4'b0010) ? sxtnbitcarry_out:
						(alu_code==4'b1010) ? ~e_outdata:
						(alu_code==4'b1011) ? ac_outdata[0]:
						(alu_code==4'b1100) ? ac_outdata[15]: 
						/*Default */		  	 1'bx;

assign alu_outdata[15] = ( alu_code==4'b0001) ? (ac_outdata[15] & dr_outdata[15]): 
								(( alu_code==4'b0010) ? sxtnbitsum[15] :
								(( alu_code==4'b0011) ? dr_outdata[15] :
								(( alu_code==4'b1001) ? ~ac_outdata[15] :
								(( alu_code==4'b1011) ? e_outdata:
								(( alu_code==4'b1100) ? ac_outdata[14]:
								(( alu_code==4'b1101) ? ac_outdata[15] : 16'bxxxxxxxxxxxxxxxx))))));
				
generate				
	for (i=14; i>7;i=i-1)
		begin: outputs8to14
			assign alu_outdata[i] = ( alu_code==4'b0001) ? (ac_outdata[i] & dr_outdata[i]): 
									(( alu_code==4'b0010) ? sxtnbitsum[i] :
									(( alu_code==4'b0011) ? dr_outdata[i] :
									(( alu_code==4'b1001) ? ~ac_outdata[i] :
									(( alu_code==4'b1011) ? ac_outdata[i+1]:
									(( alu_code==4'b1100) ? ac_outdata[i-1]:
									(( alu_code==4'b1101) ? ac_outdata[i] : 16'bxxxxxxxxxxxxxxxx))))));								
		end
endgenerate
	
generate
	for (j=7; j>0;j=j-1)
		begin: outputs0to7
			assign alu_outdata[j] = ( alu_code==4'b0001) ? (ac_outdata[j] & dr_outdata[j]): 
									(( alu_code==4'b0010) ? sxtnbitsum[j] :
									(( alu_code==4'b0011) ? dr_outdata[j] :
									(( alu_code==4'b1001) ? ~ac_outdata[j] :
									(( alu_code==4'b1011) ? ac_outdata[j+1]:
									(( alu_code==4'b1100) ? ac_outdata[j-1]:
									(( alu_code==4'b1101) ? inpr_outdata[j] : 16'bxxxxxxxxxxxxxxxx))))));								
		end
endgenerate

assign alu_outdata[0] = ( alu_code==4'b0001) ? (ac_outdata[0] & dr_outdata[0]): 
								(( alu_code==4'b0010) ? sxtnbitsum[0] :
								(( alu_code==4'b0011) ? dr_outdata[0] :
								(( alu_code==4'b1001) ? ~ac_outdata[0] :
								(( alu_code==4'b1011) ? ac_outdata[1]:
								(( alu_code==4'b1100) ? e_outdata:
								(( alu_code==4'b1101) ? inpr_outdata[0] : 16'bxxxxxxxxxxxxxxxx))))));

/*
	initial
		begin
			alu_outdata=16'b0000000000000000;
			e_indata=0;
			ff_en=0;
		end
	always @*				
		begin
			if (alu_code==4'b0001)					//And data register (from memory) word to AC
				begin										// In control, in prior clock cycles data is taken from memory
					alu_outdata<= (ac_outdata & dr_outdata);		//and put into data register.
					e_indata<=1'bx;
					ff_en<=0;
				end
			else if (alu_code==4'b0010)			//Add data register (from memory) word to AC
				begin
					ff_en<=1;
					{e_indata,alu_outdata} <= (ac_outdata+dr_outdata);	
				end	
			else if (alu_code==4'b0011)		//Load data register word (from memory) to AC
				begin
					alu_outdata<=dr_outdata;
					ff_en<=0;
					e_indata<=1'bx;
				end
			else if (alu_code==4'b1001)			//Complement AC
				begin
						ff_en<=0;
						e_indata<=1'bx;
						alu_outdata<=~ac_outdata;
				end
			else if (alu_code==4'b1010)			//Complement E
				begin
					if (e_outdata==1)
						begin
							alu_outdata<=16'bxxxxxxxxxxxxxxxx;
							ff_en<=1;
							e_indata<=0;
						end
					else 
						begin
							alu_outdata<=16'bxxxxxxxxxxxxxxxx;
							ff_en<=1;
							e_indata<=1;
						end
				end
			else if (alu_code==4'b1011)		//Circular Shift Right
				begin
					e_indata<=ac_outdata[0];
					alu_outdata[14:0]<=ac_outdata[15:1];
					alu_outdata[15]<=e_outdata;
					ff_en<=1;	
				end
			else if (alu_code==4'b1100)			//Circular Shift Left
				begin
					e_indata<=ac_outdata[15];
					alu_outdata[15:1]<=ac_outdata[14:0];
					alu_outdata[0]<=e_outdata;
					ff_en<=1;
				end
			else if (alu_code==4'b1101)			//Input character to AC (from input register)
				begin
					alu_outdata[15:8]<=ac_outdata[15:8];
					alu_outdata[7:0]<=inpr_outdata[7:0];
					e_indata<=1'bx;
					ff_en<=0;
				end
		end
*/
					
endmodule
