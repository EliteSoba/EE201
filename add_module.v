`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:01:03 11/28/2012 
// Design Name: 
// Module Name:    add_module 
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
module add_module(Clk, data_in, reset, enable, textOut, next, done);
	input Clk;
	input [7:0] data_in;
	input reset;
	input enable;
	input next;
	
	output reg [8*32:0] textOut;
	output reg done;
	
	reg [7:0] input_A, input_B;
	
	reg [4:0] state;
	
	localparam
		START			= 5'b00001,
		LOAD_A		= 5'b00010,
		LOAD_B		= 5'b00100,
		CALCULATE	= 5'b01000,
		DONE			= 5'b10000;
		
	always @(posedge Clk, posedge reset) 
		begin
			//if (!enable)
			//begin
			//end
			//else
			//begin
				if (reset)
				begin
					state <= START;
				end
				else
				begin
					case (state)
						START:
						begin
							textOut = "Addition        Adds 2 Numbers  ";
							input_A <= 0;
							input_B <= 0;
							done <= 0;
							if (next && enable)
								state <= LOAD_A;
						end
						LOAD_A:
						begin
							textOut = "Input 1st #     Then Press Btnc ";
							
							if (next)
							begin
								input_A <= data_in;
								state <= LOAD_B;
							end
						end
						LOAD_B:
						begin
							textOut = "Input 2nd #     Then Press Btnc ";
							
							if (next)
							begin
								input_B <= data_in;
								state <= CALCULATE;
							end
						end
						CALCULATE:
						begin
							textOut = "The Sum is:                  42 ";
							if (next)
								state <= DONE;
						end
						DONE:
						begin
							textOut = "Press Btnc to continue         L";
							done <= 1;
						end
					endcase
				end
			//end
		end
	
endmodule
