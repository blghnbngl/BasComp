`timescale 1ns / 1ps
module testbench_BUS(
    );
	reg CLK;
    reg [2:0] buscode;
    reg [11:0] ar_outdata;
    reg [11:0] pc_outdata;
    reg [15:0] dr_outdata;
	reg [15:0] ac_outdata;
    reg [15:0] ir_outdata;
    reg [15:0] tr_outdata;
    reg [15:0] mem_outdata;
    wire [15:0] bus_data;
	integer res = 0;
	integer err = 0;
	
	//instances
	buschooser ins( buscode, ar_outdata, pc_outdata, dr_outdata, ac_outdata, ir_outdata, tr_outdata, mem_outdata, bus_data, CLK );

	initial CLK = 0;	
	initial ar_outdata = 11'b00000000001
	initial pc_outdata = 11'b00000000010
	initial dr_outdata = 15'b000000000000011
	initial ac_outdata = 15'b000000000000100
	initial ir_outdata = 15'b000000000000101
	initial tr_outdata = 15'b000000000000110
	initial mem_outdata = 15'b000000000000111

	initial begin
	$display("Starting Testbench");
		//initial values
		$display("Testing for 7");
		bus_code = 3'b111
		if (bus_data != 15'b000000000000111)
		begin
				$display("time:",$time,":Error getting mem_outdata, bus_data %b should be 7'b111111111",bus_data);
				err=1;
		end
		bus_code = 3'b111;
		$display("Testing for 6");
		if (bus_data != 15'b000000000000110)
		begin
				$display("time:",$time,":Error getting tr_outdata, bus_data %b should be 7'b111111111",bus_data);
				err=1;
		end
		if (err == 0) res = res + 1;
		$display("Test is over, showing result. Should be one if test is successful: %d");
		$finish
	end
