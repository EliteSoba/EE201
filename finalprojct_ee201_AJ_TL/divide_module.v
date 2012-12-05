`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:01:03 11/28/2012 
// Design Name: 
// Module Name:    divide_module 
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
module divide_module(Clk, data_in, reset, enable, textOut, next, done);
	input Clk;
	input [7:0] data_in;
	input reset;
	input enable;
	input next;
	
	output reg [8*32:0] textOut;
	output reg done;
	reg [15:0] data_out;
	
	reg [7:0] input_A, input_B;
	
	reg [6:0] state;
	reg Ready;
	integer i;
	integer Remainder;
	reg [16:0] out;
	
	localparam
		START			= 7'b0000001,
		LOAD_A		= 7'b0000010,
		LOAD_B		= 7'b0000100,
		BEGIN			= 7'b0001000,
		CALCULATE	= 7'b0010000,
		SUBTRACT		= 7'b0100000,
		DONE			= 7'b1000000;
		
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
							textOut = "Division        Divides 2 Nums  ";
							input_A <= 0;
							input_B <= 0;
							done <= 0;
							Ready <= 0;
							Remainder <= 0;
							i <= 0;
							out <= 0;
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
								state <= BEGIN;
							end
						end
						BEGIN:
						begin
							data_out <= input_A / input_B;
							Remainder <= modulus(input_A, input_B);
							textOut = {"Calculating...  ",Ready?"Press Btnc      ":"                "};
							state <= CALCULATE;
						end
						CALCULATE:
						begin
							textOut = {"Calculating...  ",Ready?"Press Btnc      ":"                "};
							if (!Ready)
								begin
								//if (Remainder == 0)
									//Ready <= 1;
								Remainder <= Remainder << 1;
								state <= SUBTRACT;
							end
							else if (next)
								state <= DONE;
						end
						SUBTRACT: //TODO: Convert the output after the decimal point to hex.
						/* Algorithm is:
							Same Exit statements
							Left Shift Remainder 4 (<<4)
							out <= {out, bin2x(Remainder / input_B);
							Remainder <= Remainder % input_B;
						*/
						begin
							textOut = {"Calculating...  ",Ready?"Press Btnc      ":"                "};
							if (!Ready)
							begin
								if (Remainder >= input_B)
								begin
									//out <= {out, "1"};
									//out <= {out[14:0], 1};
									out <= (out<<1) + 1;
									Remainder <= Remainder - input_B;
								end
								else
									//out <= {out, "0"};
									out <= out << 1;
								i <= i + 1;
								if (i >= 15)
									Ready <= 1;
								state <= CALCULATE;
							end
							else if (next)
								state <= DONE;
						
						end
						DONE:
						begin
							textOut = {"The Quotient is:", bin2x(data_out[7:4]), bin2x(data_out[3:0]), ".", bin2x(out[15:12]), bin2x(out[11:8]), bin2x(out[7:4]), bin2x(out[3:0]),"         "};
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
