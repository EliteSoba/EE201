`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:01:03 11/28/2012 
// Design Name: 
// Module Name:    gcd_module 
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
module gcd_module(Clk, data_in, reset, enable, textOut, next, done);
	input Clk;
	input [7:0] data_in;
	input reset;
	input enable;
	input next;
	
	output reg [8*32:0] textOut;
	output reg done;
	reg [15:0] data_out;
	
	reg [7:0] input_A, input_B;
	
	reg [5:0] state;
	reg Ready;
	integer i;
	reg [7:0] GCD;
	
	localparam
		START			= 6'b000001,
		LOAD_A		= 6'b000010,
		LOAD_B		= 6'b000100,
		SUBTRACT		= 6'b001000,
		MULTIPLY		= 6'b010000,
		DONE			= 6'b100000;
		
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
							textOut = "Finds the GCD   Of Two Numbers  ";
							input_A <= 0;
							input_B <= 0;
							done <= 0;
							Ready <= 0;
							i <= 0;
							GCD <= 0;
							data_out <= 0;
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
								state <= SUBTRACT;
							end
						end
						SUBTRACT:
						begin
							textOut = {"Calculating...  ",Ready?"Press Btnc      ":"                "};
							if (!Ready)
								begin
								// state transfers
								if (input_A == input_B)
								begin
									if (i == 0)
									begin
										Ready <= 1;
									end
									else
										state <= MULTIPLY;
								end
								// data transfers
								if (input_A == input_B)
									GCD <=  input_A;		
								else if (input_A < input_B)
									begin
										// swap A and B
										input_B <= input_A;
										input_A <= input_B;
		 
		 
									end
								else						// if (A > B)
									begin	
										if (input_A[0] && input_B[0])
											input_A <= input_A-input_B;
										else if (input_A[0] && !input_B[0])
										begin
											input_B <= input_B >> 1;
										end
										else if (!input_A[0] && input_B[0])
										begin
											input_A <= input_A >> 1;
										end
										else if (!input_A[0] && !input_B[0])
										begin
											i <= i + 1;
											input_A <= input_A >> 1;
											input_B <= input_B >> 1;
									end
								end
							end
							else if (next)
								state <= DONE;
						end
						MULTIPLY:
						begin
							textOut = {"Calculating...  ",Ready?"Press Btnc      ":"                "};
							if (!Ready)
							begin
								// state transfers
								if (i == 0)
									Ready <= 1;
								// data transfers
								if (i != 0)
								begin
									GCD <= GCD + GCD; //OR GCD <= GCD << i_count;
									i <= i - 1; //OR i_count <= 0;
								end
							end
							else if (next)
								state <= DONE;
						end
						DONE:
						begin
							textOut = {"The GCD is:     ", bin2x(GCD[7:4]), bin2x(GCD[3:0]), "              "};
							done <= 1;
						end
					endcase
				end
			//end
		end
	
function [7:0] bin2x;
 input [3:0] data;
  begin
	case (data)
	4'h0:	bin2x = "0";4'h1:	bin2x = "1";4'h2:	bin2x = "2";4'h3:	bin2x = "3";
	4'h4:	bin2x = "4";4'h5:	bin2x = "5";4'h6:	bin2x = "6";4'h7:	bin2x = "7";
	4'h8:	bin2x = "8";4'h9:	bin2x = "9";4'hA:	bin2x = "A";4'hB:	bin2x = "B";
	4'hC:	bin2x = "C";4'hD:	bin2x = "D";4'hE:	bin2x = "E";4'hF:	bin2x = "F";
	default:bin2x = "0";
	endcase
  end
endfunction
function [7:0] modulus;
	input [7:0] input_X;
	input	[7:0] input_Y;
	begin
		
		modulus = input_X - input_Y*(input_X/input_Y);
	end
endfunction
endmodule
