`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:23:17 12/18/2012 
// Design Name: 
// Module Name:    backoff_generator 
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
module backoff_generator(
    input clk, // clock signal
    input rst, // reset signal
    input strobe, // new data signal
    input enable, // enable backoff - otherwise just pass carrier_present
	 input run_tx,
	 input run_rx,
	 input burst_done,
	 input data_waiting, // data waiting in transmit queue
    input [31:0] max_backoff, // max random delay that can be applied to data
    input carrier_present_from_CS, // carrier found
    output reg carrier_present_out // output to tx chain
    );
	 parameter [1:0] IDLE=2'b00,
						  COUNTDOWN = 2'b01,
						  SENDING = 2'b10;
	 reg carrier_present_out_next;
	 reg [31:0] countdown, countdown_next; // the back off value being used
	 reg [31:0] random_number; // random number generator
	 reg [31:0] random_scaled; // scaled random number
	 reg [1:0] state, state_next;
	 
	 //clock block
	 always @(posedge clk)
	 begin
	   if(rst)
		begin
		  carrier_present_out <= 1'b0;
		  countdown <=31'b0;
		  random_number <=31'hAAAAAAAA;
		  random_scaled <=31'b0;
		  state <= IDLE;
		end
		else
		begin
		  carrier_present_out <= carrier_present_out_next;
		  countdown <= countdown_next;
		  random_number <= {random_number[30:0],(random_number[31]^random_number[21]^random_number[1]^random_number[0])}; //LFSR
		  random_scaled <=random_number&max_backoff;
		  state<=state_next;
		end
	 end
	 
	 
	 // Finite state machine to make the decisions
	 always @*
	 begin
	   state_next = state;
		countdown_next = countdown;
		
		case(state)
			IDLE:
			begin
			  if(enable)
			  begin
			    carrier_present_out_next = carrier_present_from_CS;
			    if(run_tx && strobe  && data_waiting )
				 begin
				   // TX chain wants to send
					if( carrier_present_out)
					begin
						state_next = COUNTDOWN;
						countdown_next = random_scaled;
					end
					else
					begin
					   state_next = SENDING;
					end
				 end
			  end
			  else
			  begin
			    // back off disabled just output carrier sense
			    carrier_present_out_next = carrier_present_from_CS;
			  end
			end
			COUNTDOWN:
			begin
			   carrier_present_out_next = 1'b1;
				if(run_rx&&strobe&&carrier_present_from_CS==1'b0)
				begin
				  // count how long the carrier sense stays low
				  countdown_next =countdown-1;
				end
				if(countdown ==31'b0)
				begin
				  // if backoff expires send
				  state_next =SENDING;
				end
			end
			SENDING:
			begin
			   carrier_present_out_next = carrier_present_from_CS;
			  if(burst_done)
			   state_next = IDLE;
			end
			default:
			begin
			  state_next=IDLE;
			end
		endcase
	 end
	 


endmodule
