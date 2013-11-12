`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:50:31 11/26/2012
// Design Name:   cs_component
// Module Name:   /home/seamas/FPGA_Projects/USRP/UHD_GIT/UHD-Mirror/fpga/usrp2/top/E1x0/build-E100/cs_teset.v
// Project Name:  u1e
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cs_component
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cs_teset;

	// Inputs
	reg clk;
	reg rst;
	reg set_stb_user;
	reg [7:0] set_addr_user;
	reg [31:0] set_data_user;
	reg [15:0] real_value;
	reg [15:0] img_value;
	reg strobe;
	reg run;

	// Outputs
	wire present_next;

	// Instantiate the Unit Under Test (UUT)
	cs_component uut (
		.clk(clk), 
		.rst(rst), 
		.set_stb_user(set_stb_user), 
		.set_addr_user(set_addr_user), 
		.set_data_user(set_data_user), 
		.real_value(real_value), 
		.img_value(img_value), 
		.strobe(strobe), 
		.run(run), 
		.present_next(present_next)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		set_stb_user = 0;
		set_addr_user = 0;
		set_data_user = 0;
		real_value = 0;
		img_value = 0;
		strobe = 0;
		run = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
		#10;
		real_value = 20;
		img_value=20;
		strobe=1;
		run=1;
		#1000;
		if(present_next ==1'b1 && uut.average==32'd2112);
		$display("Passed Basic Operation Test");
		else
		$display("Failed Basic Operation Test");
		#10;
		rst = 1;
		set_stb_user = 0;
		set_addr_user = 0;
		set_data_user = 0;
		real_value = 0;
		img_value = 0;
		strobe = 0;
		run = 0;
		#30;
		rst = 0;
		#10;
		set_stb_user = 1;
		set_addr_user = 1;
		set_data_user = 0;
		#10;
		set_stb_user = 0;
		set_addr_user = 0;
		set_data_user = 0;
		real_value = 20;
		img_value=20;
		strobe=1;
		run=1;
		#300;
		if(present_next==1'b0)
		  $display ("Passed Disable Test");
		else
		  $display ("Failed Disable Test");
		#10;
		rst = 1;
		set_stb_user = 0;
		set_addr_user = 0;
		set_data_user = 0;
		real_value = 0;
		img_value = 0;
		strobe = 0;
		run = 0;
		#30;
		rst = 0;
		#10;
		set_stb_user = 1;
		set_addr_user = 2;
		set_data_user = 32'hFFFFFFFF;
		#10;
		set_stb_user = 0;
		set_addr_user = 0;
		set_data_user = 0;
		real_value = 20;
		img_value=20;
		strobe=1;
		run=1;
		#300;
		if(present_next==1'b0)
		  $display ("Passed Threshold Test");
		else
		  $display ("Failed Threshold Test");
		  
		#10;
		rst = 1;
		set_stb_user = 0;
		set_addr_user = 0;
		set_data_user = 0;
		real_value = 0;
		img_value = 0;
		strobe = 0;
		run = 0;
		#30;
		rst = 0;
		#10;
		set_stb_user = 0;
		set_addr_user = 0;
		set_data_user = 0;
		real_value = 20;
		img_value=20;
		strobe=1;
		run=0;
		#300
		run=1;
		#10;
		run=0;
		#300;
		if(present_next==1'b0)
		  $display ("Passed Run Disable Test Test");
		else
		  $display ("Failed Run Disable Test Test");  
		  
		#10;
		rst = 1;
		set_stb_user = 0;
		set_addr_user = 0;
		set_data_user = 0;
		real_value = 0;
		img_value = 0;
		strobe = 0;
		run = 0;
		#30;
		rst = 0;
		#10;
		set_stb_user = 0;
		set_addr_user = 0;
		set_data_user = 0;
		real_value = 20;
		img_value=20;
		strobe=0;
		run=1;
		repeat(5)
		begin
		  strobe =1;
		  #10;
		  strobe=0;
		  #100;
		end
		
		#300;
		if(present_next==1'b1)
		  $display ("Passed Strobe Test Test");
		else
		  $display ("Failed Strobe Test Test");
		  
		$stop;
        
		// Add stimulus here

	end
   
   always
     #5 clk = ~clk;   
endmodule

