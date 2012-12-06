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
	integer i;
	integer Remainder;
	
	reg [4:0] state;
	
	localparam
		START			= 5'b00001,
		LOAD_A		= 5'b00010,
		APPROX		= 5'b00100,
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
							textOut = "Square Root     Sqrts a Number  ";
							input_A <= 0;
							done <= 0;
							i <= 0;
							Remainder <= 0;
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
								state <= APPROX;
							end
						end
						APPROX:
						begin
							textOut = "Calculating...                  ";
							i <= i + 1;
							if ((i+1)*(i+1) > input_A)
							begin
								state <= CALCULATE;
							end
							else if ((i+1)*(i+1) == input_A)
							begin
								data_out <= i+1;
								state <= DONE;
							end
						end
						CALCULATE:
						begin
							textOut = {"Calculating...  ","Press Btnc      "};
							
							data_out <= ((i*i*i*i) + (6*i*i*input_A) + (input_A*input_A))/(4*i*i*i + 4*i*input_A);
							
							if (next)
								state <= DONE;
						end
						DONE:
						begin
							textOut = {"The Product is: ", bin2x(data_out[15:12]), bin2x(data_out[11:8]), bin2x(data_out[7:4]), bin2x(data_out[3:0]), ".           "};
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
