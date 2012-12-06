`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:01:03 11/28/2012 
// Design Name: 
// Module Name:    sqrt_module 
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
module sqrt_module(Clk, data_in, reset, enable, textOut, next, done);
	input Clk;
	input [7:0] data_in;
	input reset;
	input enable;
	input next;
	
	output reg [8*32:0] textOut;
	output reg done;
	integer data_out;
	
	reg [7:0] input_A;
	integer i, k;
	integer Remainder;
	reg [15:0] out;
	reg Ready;
	
	reg [5:0] state;
	
	localparam
		START			= 7'b0000001,
		LOAD_A		= 7'b0000010,
		APPROX		= 7'b0000100,
		CALCULATE	= 7'b0001000,
		SUB			= 7'b0010000,
		OTHER_CALC	= 7'b0100000,
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
							textOut = "Square Root     Sqrts a Number  ";
							input_A <= 0;
							done <= 0;
							i <= 0;
							k <= 0;
							Remainder <= 0;
							data_out <= 0;
							out <= 0;
							Ready <= 0;
							if (next && enable)
								state <= LOAD_A;
						end
						LOAD_A:
						begin
							textOut = "Input 1st #     Then Press Btnc ";
							
							if (next)
							begin
								input_A <= data_in;
								state <= APPROX;
							end
						end
						APPROX:
						begin
							textOut = {"Calculating...  ",Ready?"Press Btnc      ":"                "};
							i <= i + 1;
							if (input_A == 1)
							begin
								data_out <= 1;
								state <= DONE;
							end
							if ((i+2)*(i+2) > input_A)
							begin
								state <= CALCULATE;
							end
							else if ((i+2)*(i+2) == input_A)
							begin
								data_out <= i+2;
								state <= DONE;
							end
						end
						CALCULATE: //PULL OUT DIVISION LOGIC FOR THIS ONE
						begin
							textOut = {"Calculating...  ",Ready?"Press Btnc      ":"                "};
							
							data_out <= ((i*i*i*i) + (6*i*i*input_A) + (input_A*input_A))/(4*i*i*i + 4*i*input_A);
							Remainder <= ((i*i*i*i) + (6*i*i*input_A) + (input_A*input_A))-((i*i*i*i) + (6*i*i*input_A) + (input_A*input_A))/(4*i*i*i + 4*i*input_A) * (4*i*i*i + 4*i*input_A);
							
							state <= SUB;
						end
						SUB:
						begin
							textOut = {"Calculating...  ",Ready?"Press Btnc      ":"                "};
							if (!Ready)
							begin
								Remainder <= Remainder << 1;
								state <= OTHER_CALC;
							end
							else if (next)
								state <= DONE;
						end
						OTHER_CALC:
						begin
							textOut = {"Calculating...  ",Ready?"Press Btnc      ":"                "};
							if (!Ready)
							begin
								if (Remainder >= (4*i*i*i + 4*i*input_A))
								begin
									out <= (out<<1) + 1;
									Remainder <= Remainder - (4*i*i*i + 4*i*input_A);
								end
								else
								begin
									out <= out << 1;
								end
								k <= k + 1;
								if (k >= 15)
									Ready <= 1;
								state <= SUB;
							end
							else if (next)
								state <= DONE;
						end
						DONE:
						begin
							textOut = {"The Product is: ", bin2x(data_out[3:0]), ".", bin2x(out[15:12]), bin2x(out[11:8]), bin2x(out[7:4]), bin2x(out[3:0]),"          "};
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
endmodule
