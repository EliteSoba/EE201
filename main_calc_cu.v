//Alex Jones, Tobias Lee
//11-27-12


module  main_calc_cu (Clk, Reset, dataInBus, btl, btr, btd, btu, btc,
			sel1, sel2, sel3, sel4, sel5, sel6, sel7,
			add, sub, div, mult, gcd, isprime, sqrt, done,
			num1_out, num2_out,
			textOut);

input [7:0] dataInBus;
input btl, btr, btd, btu, btc; //5 buttons
input Clk, Reset;


//output
//--select states
output sel1, sel2, sel3, sel4, sel5, sel6, sel7;
//--calc states
output add, sub, div, mult, gcd, isprime, sqrt, done;
//--text
/*output [31:0] textOut [7:0];*/
output reg [8*32:0] textOut;
reg [15:0] line1 [7:0];
reg [15:0] line2 [7:0];

//output, will be used on the SSDs
output [7:0] num1_out, num2_out;
reg [7:0] num1, num2;

reg [14:0] state;

//Variables for each submodule
wire [8*32:0] textOut_Add;
wire [8*32:0] textOut_Sub;
wire [8*32:0] textOut_Mult;
wire done_Add, done_Sub, done_Mult;

//assign state outputs to the state register
assign {sel1, sel2, sel3, sel4, sel5, sel6, sel7, add, sub, div, mult, gcd, isprime, sqrt, done} = state;

//assign number outputs to the num1 and 2 reg
assign num1_out = num1;
assign num2_out = num2;



localparam
SEL1 	= 15'b100000000000000,
SEL2	= 15'b010000000000000,
SEL3 	= 15'b001000000000000,
SEL4 	= 15'b000100000000000,
SEL5 	= 15'b000010000000000,
SEL6 	= 15'b000001000000000,
SEL7 	= 15'b000000100000000,
ADD 	= 15'b000000010000000,
SUB 	= 15'b000000001000000,
DIV 	= 15'b000000000100000,
MULT	= 15'b000000000010000,
GCD		= 15'b000000000001000,
ISPRIME	= 15'b000000000000100,
SQRT 	= 15'b000000000000010, 
DONE 	= 15'b000000000000001;


add_module add_uut(.Clk(Clk), .data_in(dataInBus), .reset(state==SEL1), .enable(state==ADD), .textOut(textOut_Add), .next(btc), .done(done_Add));
subtract_module sub_uut(.Clk(Clk), .data_in(dataInBus), .reset(state==SEL2), .enable(state==SUB), .textOut(textOut_Sub), .next(btc), .done(done_Sub));
mult_module mult_uut(.Clk(Clk), .data_in(dataInBus), .reset(state==SEL4), .enable(state==MULT), .textOut(textOut_Mult), .next(btc), .done(done_Mult));
//assign textOut = {line1, line2};

always @(posedge Clk, posedge Reset) 

  begin  : CU_n_DU
    if (Reset)
       begin
        	state <= SEL1;
			//do all resets
			//just for testing these random numbers
			num1 <= 8'h00;
			num2 <= 8'h00;
			textOut = "xxxxxxxxxxresetxxxxxxxxxxxxxxxxx";
			/*
			line1 <= "reset-----------";   
			line2 <= "reset-----------";
			*/
		end
    else
       begin
         (* full_case, parallel_case *)
         case (state)
	        SEL1	: 
	          begin
		         // state transitions in the control unit
				if (btc)
					state <= ADD; //move to add
				else if (btd )
					state <= SEL5;
				else if (btr)
					state <= SEL2;
				else if (btl)
					state <= SEL4;	
				 // RTL operations in the Data Path 
				 textOut = "*Add Sub Div Mlt GCD isPrme Sqrt";
				 /*line1 <= "*Add Sub Div Mlt";
				 line2 <= " GCD isPrme Sqrt";*/
	          end
			SEL2	: 
	          begin
		         // state transitions in the control unit
				if (btc)
					state <= SUB; //move to sub
				else if (btd)
					state <= SEL6;
				else if (btr)
					state <= SEL3;
				else if (btl)
					state <= SEL1;
					
				
		         // RTL operations in the Data Path 
					textOut = " Add*Sub Div Mlt GCD isPrme Sqrt";
				 /*line1 <= " Add*Sub Div Mlt";
				 line2 <= " GCD isPrme Sqrt";*/
	          end
			SEL3	: 
	          begin
			  // state transitions in the control unit
			  	if (btc)
					state <= DIV; //move to div
				else if (btd)
					state <= SEL7;
				else if (btl)
					state <= SEL2;
				else if (btr)
					state <= SEL4;
		         
		         // RTL operations in the Data Path
					textOut = " Add Sub*Div Mlt GCD isPrme Sqrt";
						/*
				 line1 <= " Add Sub*Div Mlt";
				 line2 <= " GCD isPrme Sqrt";*/
	          end
			SEL4	: 
	          begin
		         // state transitions in the control unit
				if (btc)
					state <= MULT; //move to mult
				else if (btd )
					state <= SEL7;
				else if (btl)
					state <= SEL3;
				else if (btr)
					state <= SEL1;
		         // RTL operations in the Data Path
					textOut = " Add Sub Div*Mlt GCD isPrme Sqrt";
					/*
				 line1 <= " Add Sub Div*Mlt";
				 line2 <= " GCD isPrme Sqrt";*/
	          end
			SEL5	: 
	          begin
			  // state transitions in the control unit
		         
			  	if (btc)
					state <= GCD; //move to gcd
				else if (btd )
					state <= SEL1;
				else if (btl)
					state <= SEL7;
				else if (btr)
					state <= SEL6;
		         // RTL operations in the Data Path
					textOut = " Add Sub Div Mlt*GCD isPrme Sqrt";
					/*
				 line1 <= " Add Sub Div Mlt";
				 line2 <= "*GCD isPrme Sqrt";		*/		 

	          end
			SEL6	: 
	          begin
		         // state transitions in the control unit
				if (btc)
					state <= ISPRIME; //move to gcd
				else if (btd )
					state <= SEL2;
				else if (btl)
					state <= SEL5;
				else if (btr)
					state <= SEL7; 
		         // RTL operations in the Data Path 
					textOut = " Add Sub Div Mlt GCD*isPrme Sqrt";
					/*
				 line1 <= " Add Sub Div Mlt";
				 line2 <= " GCD*isPrme Sqrt";*/
	          end
			SEL7	: 
	          begin
			  	if (btc)
					state <= SQRT; //move to gcd
				else if (btd )
					state <= SEL3;
				else if (btl)
					state <= SEL6;
				else if (btr)
					state <= SEL5;
		         // state transitions in the control unit
		         // RTL operations in the Data Path
					textOut = " Add Sub Div Mlt GCD isPrme*Sqrt";
					/*
				 line1 <= " Add Sub Div Mlt";
				 line2 <= " GCD isPrme*Sqrt";*/

	          end
			ADD	: 
	          begin
		         // state transitions in the control unit
					
		         // RTL operations in the Data Path 
					//textOut = "ADD state                       ";
								//just for testing these random numbers
					num1 <= 8'h0A;
					num2 <= 8'hDD;
					
					textOut = textOut_Add;
					if (done_Add && btc)
						state <= SEL1;
	          end 
			SUB	: 
	          begin
		         // state transitions in the control unit
		         // RTL operations in the Data Path 
					textOut = textOut_Sub;
					if (done_Sub && btc)
						state <= SEL2;
	          end 
			DIV	: 
	          begin
		         // state transitions in the control unit
		         // RTL operations in the Data Path 

	          end 
			MULT	: 
	          begin
		         // state transitions in the control unit
		         // RTL operations in the Data Path 
					textOut = textOut_Mult;
					if (done_Mult && btc)
						state <= SEL4;
	          end	
			GCD	: 
	          begin
		         // state transitions in the control unit
		         // RTL operations in the Data Path 

	          end	
			ISPRIME	: 
	          begin
		         // state transitions in the control unit
		         // RTL operations in the Data Path 

	          end 
			SQRT	: 
	          begin
		         // state transitions in the control unit
		         // RTL operations in the Data Path 

	          end 
			DONE	: 
	          begin
		         // state transitions in the control unit
		         // RTL operations in the Data Path 

	          end 
		endcase
    end 
  end
 //function for binary to hexadecimal(character) conversion



endmodule  

