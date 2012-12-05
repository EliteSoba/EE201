/*
Alex Jones
Tobias Lee

11-27-12

*/
module calc_project_top(ClkPort,
								MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS,
								Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0,
								BtnC, BtnD, BtnR, BtnL, BtnU,
								Ld0, Ld1, Ld2, Ld3, Ld4, Ld5, Ld6, Ld7,
								/* LCD SIGNALS */
								/*LCD_data, LCD_e, LCD_rs, LCD_rw, LCD_bl,*/
								/*  */								
								An0, An1, An2, An3,
								Ca, Cb, Cc, Cd, Ce, Cf, Cg, 
								Dp
								);
		/*  INPUTS */
	// Clock & Reset I/O
	input		ClkPort;	
	// Project Specific Inputs
	input		BtnC, BtnD, BtnR, BtnL, BtnU;	
	input		Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0;
	
	
	/*  OUTPUTS */
	// ROM drivers 	
	output 	MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS;
	// Project Specific Outputs
	// LEDs
	output 	Ld0, Ld1, Ld2, Ld3, Ld4, Ld5, Ld6, Ld7;
	// LCD outputs
	/*output [7:0] LCD_data;
	output LCD_e, LCD_rs, LCD_rw, LCD_bl;*/
	/****UNCOMMENT ABOVE WHEN LCD USED *********/
	// SSD Outputs
	output 	Cg, Cf, Ce, Cd, Cc, Cb, Ca, Dp;
	output 	An0, An1, An2, An3;	
	
	/*  LOCAL SIGNALS */
	wire		Reset, ClkPort;
	wire		board_clk, sys_clk;
	wire [1:0] 	ssdscan_clk;
	
	
		//local data, assigned later to sw7-0
	wire [7:0] 	dataBus;
	
	//
	wire [7:0] Num1, Num2;
	
	wire		SCEN_BtnL, SCEN_BtnR, SCEN_BtnD, SCEN_BtnU, SCEN_BtnC; // Single CEN (one clock-wide Single Clock Enable for single-stepping)
	//state wires
	//--calc states
	wire StateIsPrime, StateSqrt, StateGCD, StateMult, StateDiv, StateSub, StateAdd, StateDone;
	//--select states
	wire sel1, sel2, sel3, sel4, sel5, sel6, sel7;
	
	//text wire from core to LCD
	wire [8*31:0] textToLCD;
	
// to produce divided clock
	reg [26:0]	DIV_CLK;
// SSD (Seven Segment Display)
	reg [3:0]	SSD;
	wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	reg [7:0]  	SSD_CATHODES;
	
	//intermediate data wires carrying the 32 characters to the LCD module
	wire [7:0]  data1, data2, data3, data4, data5, data6, data7, data8,
				   data9, data10, data11, data12, data13, data14, data15, data16,
					data17, data18, data19, data20, data21, data22, data23, data24,
					data25, data26, data27, data28, data29, data30, data31, data32;	

	//assign switches the data bus
	assign dataBus = {Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0};
	
	
	
	//core design entry uut
	main_calc_cu core_uut 
	(.Clk(sys_clk),.Reset(Reset), .dataInBus(dataBus), .btl(SCEN_BtnL), .btr(SCEN_BtnR), .btd(SCEN_BtnD), .btu(/*SCEN_BtnU*/), .btc(SCEN_BtnC),
			.sel1(sel1), .sel2(sel2), .sel3(sel3), .sel4(sel4), .sel5(sel5), .sel6(sel6), .sel7(sel7),
			.add(StateAdd), .sub(StateSub), .div(StateDiv), .mult(StateMult), .gcd(StateGCD), .isprime(StateIsPrime), .sqrt(StateSqrt), .done(StateDone),
			.num1_out(Num1), .num2_out(Num2), .textOut(textToLCD));
	
	
	//LED assignments
	assign Ld7 = 0;
	
	
	//6, 5, 4 are for the calculation display (1-7 in this order, add, sub,div, mult, gcd, isprime, sqrt)
	assign Ld6 = (StateMult || StateSqrt || StateIsPrime || StateGCD);
	assign Ld5 = (StateSqrt || StateIsPrime || StateDiv || StateSub);
	assign Ld4 = (StateAdd || StateDiv || StateGCD || StateSqrt);
	//led 3, 2, 1 are used for the selection display (binary representation
	assign Ld3 = (sel4 || sel5 || sel6 || sel7);
	assign Ld2 = (sel2 || sel3 || sel6 || sel7);
	assign Ld1 = (sel1 || sel3 || sel5 || sel7);
	
	assign Ld0 = StateDone;
	
//------------
// CLOCK DIVISION
	BUFGP BUFGP1 (board_clk, ClkPort); 	
	BUF BUF2 (Reset, BtnU);
	
	
	// Our clock is too fast (50MHz) for SSD scanning
	// create a series of slower "divided" clocks
	// each successive bit is 1/2 frequency
	// reg [26:0]	DIV_CLK;
	always @ (posedge board_clk, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
      else
			// just incrementing makes our life easier
			DIV_CLK <= DIV_CLK + 1'b1;
	end	
	
	// In this design, we run the core design at full 50MHz clock!
	assign	sys_clk = board_clk;
	
	// Disable the two memories on the board, since they are not used in this design
	assign {MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS} = {5'b11111};
       


	
	//debouncing for all 
	ee201_debouncer #(.N_dc(24)) ee201_debouncer_L
        (.CLK(sys_clk), .RESET(Reset), .PB(BtnL), .DPB( ), .SCEN(SCEN_BtnL), .MCEN( ), .CCEN( ));
	ee201_debouncer #(.N_dc(24)) ee201_debouncer_U
        (.CLK(sys_clk), .RESET(Reset), .PB(BtnU), .DPB( ), .SCEN(SCEN_BtnU), .MCEN( ), .CCEN( ));
	ee201_debouncer #(.N_dc(24)) ee201_debouncer_R
        (.CLK(sys_clk), .RESET(Reset), .PB(BtnR), .DPB( ), .SCEN( SCEN_BtnR), .MCEN( ), .CCEN( ));
	ee201_debouncer #(.N_dc(24)) ee201_debouncer_D 
        (.CLK(sys_clk), .RESET(Reset), .PB(BtnD), .DPB( ), .SCEN(SCEN_BtnD), .MCEN( ), .CCEN( ));		
	ee201_debouncer #(.N_dc(24)) ee201_debouncer_C
        (.CLK(sys_clk), .RESET(Reset), .PB(BtnC), .DPB( ), .SCEN(SCEN_BtnC), .MCEN( ), .CCEN( ));



// SSD (Seven Segment Display)
	// reg [3:0]	SSD;
	// wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	
	//SSD3 and 2 display hex version of num2, ssd1/0 display hex version of num1
	
	assign SSD3 = Num1[7:4];
	assign SSD2 = Num1[3:0];
	assign SSD1 = Num2[7:4]	;
	assign SSD0 = Num2[3:0];
	
	

	// need a scan clk for the seven segment display 
	// 191Hz (50MHz / 2^18) works well
	assign ssdscan_clk = DIV_CLK[18:17];	
	assign An0	= !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	assign An1	= !(~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 01
	assign An2	=  !((ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 10
	assign An3	=  !((ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11
	
	
	always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk) 
				  2'b00: SSD = SSD0;
				  2'b01: SSD = SSD1;
				  2'b10: SSD = SSD2;
				  2'b11: SSD = SSD3;
		endcase 
	end

	// Following is Hex-to-SSD conversion
	always @ (SSD) 
	begin : HEX_TO_SSD
		case (SSD) // in this solution file the dot points are made to glow by making Dp = 0
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
	
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES};
	

//------------ LCD interface starts here -------------------

	// we only write to the LCD panel, so ..
	assign LCD_bl = 0;	

	
	//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	//#########################################################################################################
	// THE STUDENTS NEED TO CHANGE JUST THE FOLLOWING PORTION OF THE CODE WHICH TAKES THE 32 DATA ITEMS TO BE 
	// GIVEN TO THE LCD CONTROLLER, REMEMBER TO USE THE FUNCTION bin2hex WHILE SENDING NUMERALS!!
	//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	//data assignment 
	
	//  NOTE: send the text message in character format and use "bin2hex" function for sending numerals
	/*
	
	//LINE 1
	assign data1 = " ";
	assign data2 = "X";
	assign data3 = " ";
	assign data4 = "=";
	assign data5 = " ";
	assign data6 = bin2x(0);  //note the use of function bin2hex
	assign data7 = bin2x(Xin);  //note the use of function bin2hex
	assign data8 = " ";
	assign data9 = " ";
	assign data10 = "Y";
	assign data11 = " ";
	assign data12 = "=";
	assign data13 = " ";
	assign data14 = bin2x(0);   //note the use of function bin2hex
	assign data15 = bin2x(Yin); //note the use of function bin2hex
	assign data16 = " ";
	
	// LINE 2
	assign data17 = " ";
	assign data18 = "Q";
	assign data19 = " ";
	assign data20 = "=";
	assign data21 = " ";
	assign data22 = bin2x(0);  //note the use of function bin2hex
	assign data23 = bin2x(Quotient);  //note the use of function bin2hex
	assign data24 = " ";
	assign data25 = " ";
	assign data26 = "R";
	assign data27 = " ";
	assign data28 = "=";
	assign data29 = " ";
	assign data30 = bin2x(0);   //note the use of function bin2hex
	assign data31 = bin2x(Remainder); //note the use of function bin2hex
	assign data32 = " ";	
	*/
	//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	//#########################################################################################################
	/*
	assign {data32, data31, data30, data29, data28, data27, data26, data25,
				   data24, data23, data22, data21, data20, data19, data18, data17,
					data16, data15, data14, data13, data12, data11, data10, data9,
					data8, data7, data6, data5, data4, data3, data2, data1} = (textToLCD);
					*/
	assign {data1, data2, data3, data4, data5, data6, data7, data8,
				   data9, data10, data11, data12, data13, data14, data15, data16,
					data17, data18, data19, data20, data21, data22, data23, data24,
					data25, data26, data27, data28, data29, data30, data31, data32}  = (textToLCD);
	/*				
	// Instantiate the Unit Under Test (UUT)
	lcd_core uut (
		.clk(board_clk), 
		.reset(reset), 
		.lcd_data(LCD_data), 
		.lcd_e(LCD_e), 
		.lcd_rs(LCD_rs),
		.lcd_rw(LCD_rw),
		.data_f1(data1), .data_f2(data2), .data_f3(data3), .data_f4(data4), .data_f5(data5),.data_f6(data6), 
		.data_f7(data7), .data_f8(data8), .data_f9(data9), .data_f10(data10), .data_f11(data11), .data_f12(data12), 
		.data_f13(data13), .data_f14(data14), .data_f15(data15), .data_f16(data16),.data_s1(data17), .data_s2(data18), 
		.data_s3(data19), .data_s4(data20), .data_s5(data21),.data_s6(data22), .data_s7(data23), .data_s8(data24),
		.data_s9(data25), .data_s10(data26), .data_s11(data27), .data_s12(data28), .data_s13(data29), .data_s14(data30),
		.data_s15(data31), .data_s16(data32)
	);*/
	

	
endmodule
