`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Ceng232 Summer Project
// Engineer: Bilgehan
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module buschooser(
    input [2:0] bus_code,
    input [11:0] ar_outdata,
    input [11:0] pc_outdata,
    input [15:0] dr_outdata,
    input [15:0] ac_outdata,
    input [15:0] ir_outdata,
    input [15:0] tr_outdata,
    input [15:0] mem_outdata,
    output [15:0] bus_data
    );
integer z;	 

initial
	begin
		bus_data<=15'b000000000000000;
	end
	
always@*
	begin
		z=4*bus_code[2]+2*bus_code[1]+bus_code[0];
		case (z)
			7:
				begin
					bus_data<=mem_outdata;
					//CHECK WHETHER THIS WORKS WITHOUT ADRESS!!!
				end
			6:
				begin
					bus_data<=tr_outdata;
				end
			5:
				begin
					bus_data<=ir_outdata;
				end	
			4:
				begin
					bus_data<=ac_outdata;
				end
			3:
				begin
					bus_data<=dr_outdata;
				end
			2:
				begin
					bus_data[15:12]<=4'b0000;
					bus_data[11:0]<=pc_outdata;
				end
			1:
				begin
					bus_data[15:12]<=4'b0000;
					bus_data[11:0]<=ar_outdata;
				end
			default:
				begin
					$display("Erroneous input in buschooser");
				end
		endcase
	end
endmodule
