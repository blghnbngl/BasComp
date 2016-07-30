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
	 
	
	assign bus_data[15:0]= (bus_code==3'b111) ? mem_outdata[15:0] : 
									((bus_code==3'b110) ? tr_outdata[15:0] : 
									((bus_code==3'b101) ? ir_outdata[15:0] :
									((bus_code==3'b100) ? ac_outdata[15:0] : 
									((bus_code==3'b011) ? dr_outdata[15:0] :
									((bus_code==3'b010) ? {4'b0000, pc_outdata[11:0]} :
									((bus_code==3'b001) ? {4'b0000, ar_outdata[11:0]} : 15'bxxxxxxxxxxxxxxx ))))));									
	
	
	
		/*case (bus_code)
			3'b111:
				begin
					assign bus_data=mem_outdata;
					//CHECK WHETHER THIS WORKS WITHOUT ADRESS!!!
				end
			3'b110:
				begin
					assign bus_data=tr_outdata;
				end
			3'b101:
				begin
					 assign bus_data=ir_outdata;
				end	
			3'b100:
				begin
					 assign bus_data=ac_outdata;
				end
			3'b011:
				begin
					 assign bus_data=dr_outdata;
				end
			3'b010:
				begin
					 assign bus_data[15:12]=4'b0000;
					 assign bus_data[11:0]=pc_outdata;
				end
			3'b001:
				begin
					 assign bus_data[15:12]=4'b0000;
					 assign bus_data[11:0]=ar_outdata;
				end
			3'b000:
				begin
					 assign bus_data=15'b000000000000000;
				end				
		endcase */
	
endmodule
