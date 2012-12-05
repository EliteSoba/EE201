//----------------------------------------------------------------------------------
//-- Translated to Verilog from VHDL by Byeongju Cha on 11/19/11
//-- This translation is not the work of Digilent.
//-- This is an independent file translation intended for educational use only.
//
//------------------------------------------------------------------
//--  Author -- Dan Pederson, 2004
//--			  -- Barron Barnett, 2004
//--			  -- Jacob Beck, 2006
//--			  -- Tudor Ciuleanu, 2007
//------------------------------------------------------------------
//--  This module writes 32 texts onto the character
//--  LCD from the CLP module
//------------------------------------------------------------------
//--  The LCD module requires the following initialization steps:
//--  1. Power On (stPowerOn_Delay), waits for 20ms
//--  2. Set Function (stFunctionSet, stFunctionSet_Delay), waits for 37us
//--  3. Display Set (stDisplayCtrlSet, stDisplayCtrlSet_Delay), waits for 37us
//--  4. Display Clear (stDisplayClear, stDisplayClear_Delay), waits for 1.52ms
//--  5. Initialization Done (stInitDne)
//--  End of initialzation steps
//--  
//--  6. Write one character (stActWr)
//--  7. Waits for 40us (stCharDelay) and go to step 5 (if all the 30 characters were written) or go to step 6 (if there're more to write)
//------------------------------------------------------------------

module lcd_core (clk, reset, lcd_data, lcd_e, lcd_rs, lcd_rw, data_f1, data_f2, data_f3, data_f4, data_f5, data_f6, data_f7, data_f8, data_f9, data_f10, data_f11, data_f12, data_f13, data_f14, data_f15, data_f16, data_s1, data_s2, data_s3, data_s4, data_s5, data_s6, data_s7, data_s8, data_s9, data_s10, data_s11, data_s12, data_s13, data_s14, data_s15, data_s16);

	input reset, clk;
	input [7:0] data_f1, data_f2, data_f3, data_f4, data_f5, data_f6, data_f7, data_f8, data_f9, data_f10, data_f11, data_f12, data_f13, data_f14, data_f15, data_f16, data_s1, data_s2, data_s3, data_s4, data_s5, data_s6, data_s7, data_s8, data_s9, data_s10, data_s11, data_s12, data_s13, data_s14, data_s15, data_s16;
	
	output [7:0] lcd_data;
	output lcd_rs, lcd_rw, lcd_e; // lcd_rs: register select (high for data transfer, low for instruction transfer)
									// lcd_rw: Read/Write select
									// lcd_e: Read/Write strobe
	reg lcd_e;

	//LCD control state machine

	parameter 
		stFunctionSet 			= 10'b0000000001,		 		//Initialization states
		stDisplayCtrlSet		= 10'b0000000010,
		stDisplayClear			= 10'b0000000100,
		stPowerOn_Delay			= 10'b0000001000,  				//Delay states
		stFunctionSet_Delay		= 10'b0000010000,
		stDisplayCtrlSet_Delay  = 10'b0000100000,	
		stDisplayClear_Delay	= 10'b0001000000,
		stInitDne				= 10'b0010000000,			// Display charachters and perform standard operations
		stActWr					= 10'b0100000000,
		stCharDelay				= 10'b1000000000;			//Write delay for operations
	
		
	reg [6:0] clkCount;
	reg [16:0] count;	// 15 bit count variable for timing delays
	reg delayOK;	//High when count has reached the right delay time
	reg oneUSClk;	// std_logic;									--Signal is treated as a 1.5 MHz clock	
	reg [9:0] stCur;	// LCD control state machine
	reg [9:0] stNext;			  	
	reg writeDone;		// Command set finish

	reg [7:0] lcd_cmd_ptr; // pointer to update LCD_CMDS depending on the current state
	reg [9:0] LCD_CMDS; // Bit 9: RS,  Bit 8: RW,  Bit 0-7: LCD data

// Signal Declarations and Constants
// These constants are used to initialize the LCD pannel.

//	--Set Function:
//		--Bit 0 and 1 are arbitrary
//		--Bit 2:  Displays font type(0=5x8, 1=5x11)
//		--Bit 3:  Numbers of display lines (0=1, 1=2)
//		--Bit 4:  Data length (0=4 bit, 1=8 bit)
//		--Bit 5-7 are set
//	--Display Set:
//		--Bit 0:  Blinking cursor control (0=off, 1=on)
//		--Bit 1:  Cursor (0=off, 1=on)
//		--Bit 2:  Display (0=off, 1=on)
//		--Bit 3-7 are set
//	--Display Clear:
//		--Bit 1-7 are set	
//  --Return Home: 
//		--Bit 1: Return cursor to upper left corner
//		--Bit 2-7: zeros 
	
	always @ (lcd_cmd_ptr) 
	begin
		case(lcd_cmd_ptr)
		// INITIALIZATION COMMAND
		8'h00:	LCD_CMDS <= 10'b0000111100;	// Set Function
		8'h01:	LCD_CMDS <= 10'b0000001100; // Display Set
		8'h02:	LCD_CMDS <= 10'b0000000001; // Display Clear
		8'h03:	LCD_CMDS <= 10'b0000000010; // Return Home
		
		// LINE 1
		8'h04:	LCD_CMDS <= {2'b10, data_f1};
		8'h05:	LCD_CMDS <= {2'b10, data_f2};
		8'h06:	LCD_CMDS <= {2'b10, data_f3};
		8'h07:	LCD_CMDS <= {2'b10, data_f4};
		8'h08:	LCD_CMDS <= {2'b10, data_f5};
		8'h09:	LCD_CMDS <= {2'b10, data_f6};
		8'h0A:	LCD_CMDS <= {2'b10, data_f7};
		8'h0B:	LCD_CMDS <= {2'b10, data_f8};
		8'h0C:	LCD_CMDS <= {2'b10, data_f9};
		8'h0D:	LCD_CMDS <= {2'b10, data_f10};
		8'h0E:	LCD_CMDS <= {2'b10, data_f11};
		8'h0F:	LCD_CMDS <= {2'b10, data_f12};
		8'h10:	LCD_CMDS <= {2'b10, data_f13};
		8'h11:	LCD_CMDS <= {2'b10, data_f14};
		8'h12:	LCD_CMDS <= {2'b10, data_f15};
		8'h13:	LCD_CMDS <= {2'b10, data_f16};
				
		8'h14:	LCD_CMDS <= 10'b0011000000; // Change Line

		// LINE 2

		8'h15:	LCD_CMDS <= {2'b10, data_s1};
		8'h16:	LCD_CMDS <= {2'b10, data_s2};
		8'h17:	LCD_CMDS <= {2'b10, data_s3};
		8'h18:	LCD_CMDS <= {2'b10, data_s4};
		8'h19:	LCD_CMDS <= {2'b10, data_s5};
		8'h1A:	LCD_CMDS <= {2'b10, data_s6};
		8'h1B:	LCD_CMDS <= {2'b10, data_s7};
		8'h1C:	LCD_CMDS <= {2'b10, data_s8};
		8'h1D:	LCD_CMDS <= {2'b10, data_s9};
		8'h1E:	LCD_CMDS <= {2'b10, data_s10};
		8'h1F:	LCD_CMDS <= {2'b10, data_s11};
		8'h20:	LCD_CMDS <= {2'b10, data_s12};
		8'h21:	LCD_CMDS <= {2'b10, data_s13};
		8'h22:	LCD_CMDS <= {2'b10, data_s14};
		8'h23:	LCD_CMDS <= {2'b10, data_s15};
		8'h24:	LCD_CMDS <= {2'b10, data_s16};
		default: LCD_CMDS <= 10'b0000111100;
		endcase
	end
	
	//the backlight is off
	
	//This process counts to 38, and then resets.  It is used to divide the clock signal time.
	//This makes oneUSClock peak aprox. once every 1.5 microsecond
	//clk is 100MHz (Nexys-3 board)
   always @ (posedge clk, posedge reset)
   begin
		if (reset)
		begin
			oneUSClk <= 1'b0;
			clkCount <= 7'b0000000;
		end
		else
		begin
        if(clkCount == 7'b1001100 )
           begin
            oneUSClk 		<= ~oneUSClk;
            clkCount 	<= 7'b0000000;
           end
  		  else
			clkCount <= clkCount + 1'b1;
		end
   end	

	// This process increments the count variable unless delayOK = 1.
   always @ (posedge oneUSClk, posedge reset)
   begin
		if(reset)
			count <= 17'b00000000000000000;
		else
		begin
			if(delayOK == 1'b1)
			begin
					count 	<= 17'b00000000000000000;
			end
			else
				count <= count + 1'b1;
		end
   end	

	// Determines when count has gotten to the right number, depending on the state.		
	always @ (posedge oneUSClk, posedge reset)
	begin
		if (reset)
			delayOK <= 1'b0;
		else
		begin
		if ((stCur == stPowerOn_Delay) && (count >= 17'b00011010000010101))
			delayOK <= 1'b1;
		else if ((stCur == stFunctionSet_Delay) && (count >= 17'b00000000000011010))
			delayOK <= 1'b1;
		else if ((stCur == stDisplayCtrlSet_Delay) && (count >= 17'b00000000000011010))
			delayOK <= 1'b1;
		else if ((stCur == stDisplayClear_Delay) && (count >= 17'b00000010000101010))
			delayOK <= 1'b1;
		else if ((stCur == stCharDelay) && (count >= 17'b00000000000011010))
			delayOK <= 1'b1;
		else
			delayOK <= 1'b0;
		end
	end
	
	//Increments the pointer so the statemachine goes through the commands
	always @ (posedge oneUSClk, posedge reset)
   	begin
		if (reset)
			lcd_cmd_ptr <= 8'h00;
		else
		begin
			if ((stNext == stInitDne) || (stNext == stDisplayCtrlSet) || (stNext == stDisplayClear))
				lcd_cmd_ptr <= lcd_cmd_ptr + 1'b1;
			else if (lcd_cmd_ptr == 8'h24)
				lcd_cmd_ptr <= 8'h03;
			else if ((stCur == stPowerOn_Delay) || (stNext == stPowerOn_Delay))
				lcd_cmd_ptr <= 8'h00;
			else
				lcd_cmd_ptr <= lcd_cmd_ptr;
		end
	end
	
	// This process runs the LCD state machine
	always @ (posedge oneUSClk, posedge reset)
	begin
		if (reset)
			stCur <= stPowerOn_Delay;
		else
			stCur <= stNext;
	end
	
	// This process generates the sequence of outputs needed to initialize and write to the LCD screen
	always @ (stCur, delayOK, lcd_cmd_ptr)
	begin   
		case(stCur)		
			// Delays the state machine for 20ms which is needed for proper startup.
			stPowerOn_Delay :
			begin
				if (delayOK == 1'b1)
					stNext <= stFunctionSet;
				else
					stNext <= stPowerOn_Delay;
			end

			// This issues the function set to the LCD as follows 
			// 8 bit data length, 1 lines, font is 5x8.
			stFunctionSet :
			begin
				stNext <= stFunctionSet_Delay;
			end

			// Gives the proper delay of 37us between the function set and
			// the display control set.
			stFunctionSet_Delay :
			begin
				if (delayOK == 1'b1)
					stNext <= stDisplayCtrlSet;
				else
					stNext <= stFunctionSet_Delay;
			end

			// Issuse the display control set as follows
			// Display ON,  Cursor OFF, Blinking Cursor OFF.
			stDisplayCtrlSet :
			begin
				stNext <= stDisplayCtrlSet_Delay;
			end

			// Gives the proper delay of 37us between the display control set
			// and the Display Clear command. 
			stDisplayCtrlSet_Delay :
			begin
				if (delayOK == 1'b1)
					stNext <= stDisplayClear;
				else
					stNext <= stDisplayCtrlSet_Delay;
			end
				
			// Issues the display clear command.
			stDisplayClear :
			begin
				stNext <= stDisplayClear_Delay;
			end

			// Gives the proper delay of 1.52ms between the clear command
			// and the state where you are clear to do normal operations.
			stDisplayClear_Delay :
			begin
				if (delayOK == 1'b1)
					stNext <= stInitDne;
				else
					stNext <= stDisplayClear_Delay;
			end
				
			// State for normal operations for displaying characters, changing the
			// Cursor position etc.
			stInitDne :		
			begin
				stNext <= stActWr;
			end

			stActWr :
			begin
				stNext <= stCharDelay;
			end
					
			// Provides a max delay between instructions.
			stCharDelay :
			begin
				if (delayOK == 1'b1)
					stNext <= stInitDne;
				else
					stNext <= stCharDelay;
			end
			
			default :
			begin
				stNext <= stPowerOn_Delay;
			end
		endcase	
	end					
	
	assign lcd_rs = LCD_CMDS[9];
	assign lcd_rw = LCD_CMDS[8];
	assign lcd_data = LCD_CMDS[7:0];
	assign usclk = stCur;
	
	always @ (stCur)
	begin
		if ((stCur == stFunctionSet) || (stCur == stDisplayCtrlSet) || (stCur == stDisplayClear) || (stCur == stActWr))
			lcd_e <= 1'b1;
		else 
			lcd_e <= 1'b0;	
	end
						
endmodule

