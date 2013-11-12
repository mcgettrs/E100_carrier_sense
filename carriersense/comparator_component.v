`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Trinity College, Virgina Tech
// Engineer: Kevin Anyanwu
// 
// Create Date:    16:30:03 06/24/2011 
// Design Name: 
// Module Name:    comparator_component 
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
module comparator_component(
     input [31:0] threshold,
	  input [31:0] average,
	  input rst,
	  input clk	,
	  input enable,
	  input run_rx0,
	  output reg carrier_present
    );
	 
	 reg carrier_present_next;
	
	always @(posedge clk)
	begin
	  if(rst)
	    carrier_present <=1'b0;
	  else
	    carrier_present <= carrier_present_next;
	end
	
	always @(threshold,average,enable, run_rx0,carrier_present)
	begin
	  if(enable)
	  begin
	     // carrier sense module enabled
		  if(run_rx0) // in recieve mode can update carrier sense
			  if((average > threshold ))
				 carrier_present_next = 1'b1;
			  else
				 carrier_present_next = 1'b0;
		  else // not in recieve mode so ignore changes in threshold
           carrier_present_next = carrier_present;		  
	  end
	  else
	  begin
	    // carrier sense module disabled always output 0
		 carrier_present_next =1'b0;
	  end
	end


endmodule
