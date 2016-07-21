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
    input [7:0] instruction,
    input e_outdata,
    input [7:0] inpr_outdata,
	 input [3:0] alu_code,
    output [15:0] alu_outdata,
    output e_indata,
	 output ff_en
    );
	 
reg [16:0] temp_alu;
reg temp_e;

	initial
		begin
			alu_outdata=16'b0000000000000000;
			e_indata=0;
			temp_e=0;
			ff_en=0;
		end
	always @*				//????????????????Would this work with a vector
		begin
			if (alu_code==4'b0001)
				begin
					temp_alu[15:0]<=ac_outdata & dr_outdata;
					alu_outdata=temp_alu[15:0];
				end
			else if (alu_code==4'b0010)
				begin
					temp_alu <= ac_outdata+dr_outdata;
					alu_outdata=temp_alu[15:0];
					if (temp_alu[16]==1)
						begin
							ff_en=1;
							e_indata=1;
						end
					else
						begin
							ff_en=1;
							e_indata=0;	
						end
				end	
			else if (alu_code==4'b0011)
				begin
					temp_alu[15:0]<=dr_outdata;
					alu_outdata=temp_alu[15:0];
				end
			else if (alu_code==4'b1001)			//Complement AC
				begin
					temp_alu[15:0]<=~ac_outdata;
					alu_outdata=temp_alu[15:0];
				end
			else if (alu_code==4'b1010)			//Complement E
				begin
					if (e_outdata==1)
						begin
							ff_en=1;
							e_indata=0;
						end
					else 
						begin
							ff_en=1;
							e_indata=1;
						end
				end
			else if (alu_code==4'b1011)		//Circular Shift Right
				begin
					temp_e<=ac_outdata[0];
					alu_outdata[14:0]=ac_outdata[15:1];
					alu_outdata[15]=e_outdata;
					ff_en=1;
					e_indata=temp_e;
				end
			else if (alu_code==4'b1100)			//Circular Shift Left
				begin
					temp_e<=ac_outdata[15];
					alu_outdata[15:1]=ac_outdata[14:0];
					alu_outdata[0]=e_outdata;
					ff_en=1;
					e_indata=temp_e;
				end
			else if (alu_code==4'b1101)			//Input character to AC (from input register)
				begin
					temp_alu[15:8]=ac_outdata[15:8];
					temp_alu[7:0]=inpr_outdata[7:0];
					alu_outdata=temp_alu[15:0];
				end

					
		end

endmodule
