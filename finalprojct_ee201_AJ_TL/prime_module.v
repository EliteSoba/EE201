`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:01:03 11/28/2012 
// Design Name: 
// Module Name:    prime_module 
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
module prime_module(Clk, data_in, reset, enable, textOut, next, done);
	input Clk;
	input [7:0] data_in;
	input reset;
	input enable;
	input next;
	
	output reg [8*32:0] textOut;
	output reg done;
	reg [15:0] data_out;
	
	reg [7:0] input_A;
	reg [7:0] i;
	
	reg [3:0] state;
	reg isNotPrime;
	reg Ready;
	
	localparam
		START			= 4'b0001,
		LOAD_A		= 4'b0010,
		CALCULATE	= 4'b0100,
		DONE			= 4'b1000;
		
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
							textOut = "Determinses if  A # is Prime    ";
							input_A <= 0;
							i <= 2;
							done <= 0;
							isNotPrime <= 0;
							Ready <= 0;
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
								state <= CALCULATE;
							end
						end
						CALCULATE:
						begin
							if (i > input_A>>1)
								Ready <= 1;
							else
							begin
								if (modulus(input_A, i) == 0)
								begin
									isNotPrime <= 1;
									Ready <= 1;
								end
								i <= i + 1;
							end
							data_out <= !isNotPrime;
							textOut = {"Calculating...  ",Ready?"Press Btnc      ":"                "};
							if (next && Ready)
								state <= DONE;
						end
						DONE:
						begin
							textOut = {"The Number is:  ", isNotPrime?"not":"   ", " Prime       "};
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
