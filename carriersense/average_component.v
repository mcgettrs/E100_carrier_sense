`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Trinity College, Virginia Tech
// Engineer: Kevin Anyanwu
//
// Create Date: 17:00:27 06/23/2011
// Design Name:
// Module Name: average_component
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
// When buffer has at least one entry, the buffer will output the entry
// automatically
//////////////////////////////////////////////////////////////////////////////////

module average_component#(parameter WINDOW_SIZE=64)(
//input to data path
input [15:0] x_out_mag,
input clk,
input rst,
input data_in_valid,
//output to upper layer
output wire [31:0] average

);
reg [32:0] average_reg,average_next;
assign average = (average_reg[32])?31'hFFFFFFFF: average_reg[31:0];

reg [15:0] data_queue [0:WINDOW_SIZE-1];
reg [15:0] i;
always @(posedge clk)
begin
	if(rst)
	begin
	  average_reg <= 33'b0;
	  for(i=0;i<WINDOW_SIZE; i=i+1)
	  begin
	    data_queue[i]<=16'b0;
	  end
	end
	else
	begin
	  average_reg <= average_next;
	  if(data_in_valid)
	    data_queue[0] <= x_out_mag;
	  else
	  begin
	    data_queue[0] <= data_queue[0];
	  end	 
	  for(i=1;i<WINDOW_SIZE; i=i+1)
	  begin
	    if(data_in_valid)
			data_queue[i]<=data_queue[i-1];
		 else
		   data_queue[i]<=data_queue[i];
	  end
	end
end

always @(data_in_valid, average_reg, x_out_mag, data_queue[WINDOW_SIZE-1])
begin
  average_next = average_reg;
  if(data_in_valid)
  begin
    average_next = average_reg-data_queue[WINDOW_SIZE-1]+x_out_mag;
  end
end

endmodule