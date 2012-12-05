
//////////////////////////////////////////////////////////////////////////////////
// Author:			Mi Zhang, Gandhi Puvvada
// Create Date:	03/29/2008
// Revised to suit Nexys-3: 3/8/2012 
// File Name:		merge_arrays_mcu_top.v 
// Description: 
//
//
// Revision: 		2.0
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module merge_arrays_mcu_top 
		(MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS, // Disable the three memory chips

        ClkPort,                           // the 100 MHz incoming clock signal
		
		BtnL, BtnU, BtnD, BtnR,            // the Left, Up, Down, and the Right buttons BtnL, BtnR,
		BtnC,                              // the center button (this is our reset in most of our designs)
		Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0, // 8 switches
		Ld7, Ld6, Ld5, Ld4, Ld3, Ld2, Ld1, Ld0, // 8 LEDs
		An3, An2, An1, An0,			       // 4 anodes
		Ca, Cb, Cc, Cd, Ce, Cf, Cg,        // 7 cathodes
		Dp                                 // Dot Point Cathode on SSDs
	  );


	/*  INPUTS */
	// Clock & Reset I/O
	input		ClkPort;	
	// Project Specific Inputs
	input		BtnL, BtnU, BtnD, BtnR, BtnC;	
	input		Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0;
	
	
	/*  OUTPUTS */
	// Control signals on Memory chips 	(to disable them)
	output 	MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS;
	// Project Specific Outputs
	// LEDs
	output 	Ld0, Ld1, Ld2, Ld3, Ld4, Ld5, Ld6, Ld7;
	// SSD Outputs
	output 	Cg, Cf, Ce, Cd, Cc, Cb, Ca, Dp;
	output 	An0, An1, An2, An3;	
	
	/*  LOCAL SIGNALS */
	wire		Reset, ClkPort;
	wire		board_clk, sys_clk;
	wire [1:0] 	ssdscan_clk;
	reg [26:0]	DIV_CLK;

	reg [3:0]	SSD;
	wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	reg [7:0]  SSD_CATHODES;
	
	// Inputs to the core design
	wire Start, Ack;
	wire [2:0] array_R_Index;
	// Outputs from the core design
	wire [3:0] array_R_Data;
	wire Done;
	
	
//------------	
// Disable the three memories so that they do not interfere with the rest of the design.
	assign {MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS} = 5'b11111;
	
	
//------------
// CLOCK DIVISION

	// The clock division circuitary works like this:
	//
	// ClkPort ---> [BUFGP2] ---> board_clk
	// board_clk ---> [clock dividing counter] ---> DIV_CLK
	// DIV_CLK ---> [constant assignment] ---> sys_clk;
	
	BUFGP BUFGP1 (board_clk, ClkPort); 	

// As the ClkPort signal travels throughout our design,
// it is necessary to provide global routing to this signal. 
// The BUFGPs buffer these input ports and connect them to the global 
// routing resources in the FPGA.

	// BUFGP BUFGP2 (Reset, BtnC); In the case of Spartan 3E (on Nexys-2 board), we were using BUFGP to provide global routing for the reset signal. But Spartan 6 (on Nexys-3) does not allow this.
	assign Reset = BtnC;
	
//------------
	// Our clock is too fast (100MHz) for SSD scanning
	// create a series of slower "divided" clocks
	// each successive bit is 1/2 frequency
  always @(posedge board_clk, posedge Reset) 	
    begin							
        if (Reset)
		DIV_CLK <= 0;
        else
		DIV_CLK <= DIV_CLK + 1'b1;
    end
//-------------------	
	// In this design, we run the core design at full 100MHz clock!
	// assign	sys_clk = board_clk;
	// In this design, we run the core design at a low frequency of 100MHz divided by 2**26 = 1.5 Hz
	 assign	sys_clk = DIV_CLK[25];

//------------
	
// Buttons and Switches usage here	
	assign Start = BtnL;
	assign Ack   = BtnR;
	assign array_R_Index = {Sw2,Sw1,Sw0};
	

// LEDs
	assign Ld7 = sys_clk;	
	assign Ld6 = Sw7 & Sw6 & Sw5 & Sw4 & Sw3; // Just to combine unused inputs and outputs so that we can use the UCF
	                                          //  file with all basic I/O resources uniformly with all our designs 
	assign Ld5 = Done; // show the DONE signal on Ld5
	assign Ld4 = BtnL; // Start
	assign Ld3 = BtnU;
	assign Ld2 = BtnR; // Ack
	assign Ld1 = BtnD;
	assign Ld0 = BtnC;
	
//------------
// SSD (Seven Segment Display)
	
	//SSDs show Ain and Bin in initial state, A and B in subtract state, and GCD and i_count in multiply and done states.
	// ****** TODO  in Part 2 ******
	// assign y = s ? i1 : i0;  // an example of a 2-to-1 mux coding
	// assign y = s1 ? (s0 ? i3: i2): (s0 ? i1: i0); // an example of a 4-to-1 mux coding
	assign SSD3 = {1'b0,array_R_Index};
	assign SSD2 = 4'b0000; // This not actually displayed
	assign SSD1 = 4'b0000; // This not actually displayed
	assign SSD0 = array_R_Data;


	// need a scan clk for the seven segment display 
	// 191Hz (100 MHz / 2^19) works well
	assign ssdscan_clk = DIV_CLK[19:18];
	
	// assign An0	= !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	// assign An1	= !(~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 01
	// assign An2	=  !((ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 10
	// assign An3	=  !((ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11
	
	assign An0	=  ~(~(ssdscan_clk[1]));
	assign An1	=  1'b1; // The SSD1 is off permanently
	assign An2	=  1'b1; // The SSD2 is off permanently
	assign An3	=  ~((ssdscan_clk[1]));
	
	// always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3)
	// begin : SSD_SCAN_OUT
		// case (ssdscan_clk) 
				  // 2'b00: SSD = SSD0;
				  // 2'b01: SSD = SSD1;
				  
				  // 2'b10: SSD = SSD2;
				  // 2'b11: SSD = SSD3;
		// endcase 
	// end
	
	always @ (ssdscan_clk, SSD0, SSD3)
		begin : SSD_SCAN_OUT
			if (ssdscan_clk[1])
				SSD = SSD3;
			else
				SSD = SSD0;
		end
	
	// and finally convert SSD_num to ssd
	// We convert the output of our 4-bit 4x1 mux

	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES}; // Dp is off in student design

	// assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES[7:1],sys_clk}; // Dp flashes at sys_clk rate in the solution

	// // Following is Hex-to-SSD conversion
	// always @ (SSD) 
	// begin : HEX_TO_SSD
		// case (SSD) // in this solution file the dot points are made to glow by making Dp = 0
		    // //                                                                abcdefg,Dp
			// 4'b0000: SSD_CATHODES = 8'b00000010; // 0
			// 4'b0001: SSD_CATHODES = 8'b10011110; // 1
			// 4'b0010: SSD_CATHODES = 8'b00100100; // 2
			// 4'b0011: SSD_CATHODES = 8'b00001100; // 3
			// 4'b0100: SSD_CATHODES = 8'b10011000; // 4
			// 4'b0101: SSD_CATHODES = 8'b01001000; // 5
			// 4'b0110: SSD_CATHODES = 8'b01000000; // 6
			// 4'b0111: SSD_CATHODES = 8'b00011110; // 7
			// 4'b1000: SSD_CATHODES = 8'b00000000; // 8
			// 4'b1001: SSD_CATHODES = 8'b00001000; // 9
			// 4'b1010: SSD_CATHODES = 8'b00010000; // A
			// 4'b1011: SSD_CATHODES = 8'b11000000; // B
			// 4'b1100: SSD_CATHODES = 8'b01100010; // C
			// 4'b1101: SSD_CATHODES = 8'b10000100; // D
			// 4'b1110: SSD_CATHODES = 8'b01100000; // E
			// 4'b1111: SSD_CATHODES = 8'b01110000; // F    
			// default: SSD_CATHODES = 8'bXXXXXXXX; // default is not needed as we covered all cases
		// endcase
	// end	

	// Following is Hex-to-SSD conversion
	always @ (SSD) 
	begin : HEX_TO_SSD
		case (SSD) // in the file given to students the dot points are switched off by making Dp = 1
		    //                                                                abcdefg,Dp
			4'b0000: SSD_CATHODES = 8'b00000011; // 0
			4'b0001: SSD_CATHODES = 8'b10011111; // 1
			4'b0010: SSD_CATHODES = 8'b00100101; // 2
			4'b0011: SSD_CATHODES = 8'b00001101; // 3
			4'b0100: SSD_CATHODES = 8'b10011001; // 4
			4'b0101: SSD_CATHODES = 8'b01001001; // 5
			4'b0110: SSD_CATHODES = 8'b01000001; // 6
			4'b0111: SSD_CATHODES = 8'b00011111; // 7
			4'b1000: SSD_CATHODES = 8'b00000001; // 8
			4'b1001: SSD_CATHODES = 8'b00001001; // 9
			4'b1010: SSD_CATHODES = 8'b00010001; // A
			4'b1011: SSD_CATHODES = 8'b11000001; // B
			4'b1100: SSD_CATHODES = 8'b01100011; // C
			4'b1101: SSD_CATHODES = 8'b10000101; // D
			4'b1110: SSD_CATHODES = 8'b01100001; // E
			4'b1111: SSD_CATHODES = 8'b01110001; // F    
			default: SSD_CATHODES = 8'bXXXXXXXX; // default is not needed as we covered all cases
		endcase
	end	
	


// Instantiate the UUT
   merge_arrays_mcu UUT (
		.SYS_CLK(sys_clk),
		.RESET(Reset),		
		.START(Start), 
		.ACK(Ack), 
		.R_ADDR(array_R_Index), 
		.R_DATA(array_R_Data),
		.DONE (Done)
   );
	
endmodule
