`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:06:55 12/18/2012
// Design Name:   backoff_generator
// Module Name:   /home/seamas/FPGA_Projects/USRP/UCHE/usrp2/carriersense/backoff_gen_tb.v
// Project Name:  u1e
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: backoff_generator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module backoff_gen_tb;

	// Inputs
	reg clk;
	reg rst;
	reg strobe;
	reg enable;
	reg run_tx;
	reg run_rx;
	reg burst_done;
	reg data_waiting;
	reg [31:0] max_backoff;
	reg carrier_present_from_CS;

	// Outputs
	wire carrier_present_out;

	// Instantiate the Unit Under Test (UUT)
	backoff_generator uut (
		.clk(clk), 
		.rst(rst), 
		.strobe(strobe), 
		.enable(enable), 
		.run_tx(run_tx), 
		.run_rx(run_rx), 
		.burst_done(burst_done), 
		.data_waiting(data_waiting), 
		.max_backoff(max_backoff), 
		.carrier_present_from_CS(carrier_present_from_CS), 
		.carrier_present_out(carrier_present_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		strobe = 0;
		enable = 1;
		run_tx = 0;
		run_rx = 0;
		burst_done = 0;
		data_waiting = 0;
		max_backoff = 32'h000007FF;
		carrier_present_from_CS = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst =0;
      carrier_present_from_CS =0;
      data_waiting =0;
      #10;
      run_tx = 1'b1;
      #50;
      data_waiting =1;
		#20;
		carrier_present_from_CS=1;
		#20;
		run_tx=0;
		run_rx=1;
		carrier_present_from_CS=0;
      #100;
      #1000;
      $stop;		
		// Add stimulus here

	end
   

   always 
     #5 clk = ~clk;
   always
     begin
	    @(posedge clk);
	    strobe = 1;
		 @(posedge clk);
		 strobe =0;
		 #50;
		 
     end	  
endmodule

