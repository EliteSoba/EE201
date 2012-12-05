`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:38:07 11/17/2011
// Design Name:   lcd_screen_core
// Module Name:   C:/Users/Byeongju/Downloads/EE201L/LCD_project/lcd_screen_core_tb.v
// Project Name:  LCD_project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lcd_screen_core
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module lcd_screen_core_tb;

	// Inputs
	reg Clk;
	reg reset;
	reg [7:0] data_f1;
	reg [7:0] data_f2;
	reg [7:0] data_f3;
	reg [7:0] data_f4;
	reg [7:0] data_f5;
	reg [7:0] data_f6;
	reg [7:0] data_f7;
	reg [7:0] data_f8;
	reg [7:0] data_f9;
	reg [7:0] data_f10;
	reg [7:0] data_f11;
	reg [7:0] data_f12;
	reg [7:0] data_f13;
	reg [7:0] data_f14;
	reg [7:0] data_f15;
	reg [7:0] data_f16;
	reg [7:0] data_s1;
	reg [7:0] data_s2;
	reg [7:0] data_s3;
	reg [7:0] data_s4;
	reg [7:0] data_s5;
	reg [7:0] data_s6;
	reg [7:0] data_s7;
	reg [7:0] data_s8;
	reg [7:0] data_s9;
	reg [7:0] data_s10;
	reg [7:0] data_s11;
	reg [7:0] data_s12;
	reg [7:0] data_s13;
	reg [7:0] data_s14;
	reg [7:0] data_s15;
	reg [7:0] data_s16;

	// Outputs
	wire [7:0] lcd_data;
	wire lcd_e;
	wire lcd_rs;

	// Instantiate the Unit Under Test (UUT)
	lcd_screen_core uut (
		.Clk(Clk), 
		.reset(reset), 
		.lcd_data(lcd_data), 
		.lcd_e(lcd_e), 
		.lcd_rs(lcd_rs), 
		.data_f1(data_f1), 
		.data_f2(data_f2), 
		.data_f3(data_f3), 
		.data_f4(data_f4), 
		.data_f5(data_f5), 
		.data_f6(data_f6), 
		.data_f7(data_f7), 
		.data_f8(data_f8), 
		.data_f9(data_f9), 
		.data_f10(data_f10), 
		.data_f11(data_f11), 
		.data_f12(data_f12), 
		.data_f13(data_f13), 
		.data_f14(data_f14), 
		.data_f15(data_f15), 
		.data_f16(data_f16), 
		.data_s1(data_s1), 
		.data_s2(data_s2), 
		.data_s3(data_s3), 
		.data_s4(data_s4), 
		.data_s5(data_s5), 
		.data_s6(data_s6), 
		.data_s7(data_s7), 
		.data_s8(data_s8), 
		.data_s9(data_s9), 
		.data_s10(data_s10), 
		.data_s11(data_s11), 
		.data_s12(data_s12), 
		.data_s13(data_s13), 
		.data_s14(data_s14), 
		.data_s15(data_s15), 
		.data_s16(data_s16)
	);

	initial begin
		// Initialize Inputs
		Clk = 0;
		reset = 0;
		data_f1 = 0;
		data_f2 = 0;
		data_f3 = 0;
		data_f4 = 0;
		data_f5 = 0;
		data_f6 = 0;
		data_f7 = 0;
		data_f8 = 0;
		data_f9 = 0;
		data_f10 = 0;
		data_f11 = 0;
		data_f12 = 0;
		data_f13 = 0;
		data_f14 = 0;
		data_f15 = 0;
		data_f16 = 0;
		data_s1 = 0;
		data_s2 = 0;
		data_s3 = 0;
		data_s4 = 0;
		data_s5 = 0;
		data_s6 = 0;
		data_s7 = 0;
		data_s8 = 0;
		data_s9 = 0;
		data_s10 = 0;
		data_s11 = 0;
		data_s12 = 0;
		data_s13 = 0;
		data_s14 = 0;
		data_s15 = 0;
		data_s16 = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

