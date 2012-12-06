`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:46:58 11/29/2012 
// Design Name: 
// Module Name:    calc_core_tb 
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




module calc_core_tb;
	 

			
		reg Clk, Reset;
		reg [7:0]dataInBus;
		reg btl, btr, btd, btu, btc;
		wire sel1, sel2, sel3, sel4, sel5, sel6, sel7,add, sub, div, mult, gcd, isprime, sqrt, done;
		wire [7:0] num1_out, num2_out;
		wire [8*32:0] textOut;
		
		
	main_calc_cu uut(Clk, Reset, dataInBus, btl, btr, btd, btu, btc,
			sel1, sel2, sel3, sel4, sel5, sel6, sel7,
			add, sub, div, mult, gcd, isprime, sqrt, done,
			num1_out, num2_out,
			textOut);
	
		
			//Clk = 0;
		
	initial
	  begin  : CLK_GENERATOR
		 Clk = 0;
		 forever
			 begin
				#5 Clk = ~Clk;
			 end 
	  end
	  
	  
	initial 
		begin
		#55;
		Reset = 1;
		#11;
		Reset = 0;
		#10;
		btl = 1;
		#10;
		btl=0;
		#10;
		btd=1;
		#10;
		btd=0;
		#10;
		btc=1;
		#10;
		btc=0;
		#10;
		btc=1;
		#10;
		btc=0;
		dataInBus=8'b10000100;
		#10;
		btc=1;
		#10;
		btc=0;
		#300;
		btc=1;
		#10
		btc=0;
		
		end
endmodule
