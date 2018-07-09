// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	DE2 Music Synthesizer
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date   :| Changes Made:
//   V1.0 :| Joe Yang          :| 10/25/2006  :| Initial Revision
// --------------------------------------------------------------------

/////////////////////////////////////////////
////     2Channel-Music-Synthesizer     /////
/////////////////////////////////////////////
/*******************************************/
/*             KEY & SW List               */
/* KEY[0]: I2C reset                       */
/* KEY[1]: Demo Sound repeat               */
/* KEY[2]: Keyboard code Reset             */
/* KEY[3]: Keyboard system Reset           */
/* SW[0] : 0 Brass wave ,1 String wave     */
/* SW[1] : 0 CH1_ON ,1 CH1_OFF             */
/* SW[2] : 0 CH2_ON ,1 CH2_OFF             */
/* SW[9] : 0 DEMO Sound ,1 KeyBoard Play   */
/*******************************************/


module DE2_synthesizer (

		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_27,							//	27 MHz
		CLOCK_50,							//	50 MHz
		EXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		KEY,							//	Button[3:0]
		////////////////////	DPDT Switch		////////////////////
		SW,						//	DPDT Switch[17:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,							//	Seven Segment Digital 0
		HEX1,							//	Seven Segment Digital 1
		HEX2,							//	Seven Segment Digital 2
		HEX3,							//	Seven Segment Digital 3
		HEX4,							//	Seven Segment Digital 4
		HEX5,							//	Seven Segment Digital 5
		HEX6,							//	Seven Segment Digital 6
		HEX7,							//	Seven Segment Digital 7
		////////////////////////	LED		////////////////////////
		LEDG,						//	LED Green[8:0]
		LEDR,						//	LED Red[17:0]
		////////////////////////	UART	////////////////////////
		UART_TXD,						//	UART Transmitter
		UART_RXD,						//	UART Rceiver
		////////////////////////	IRDA	////////////////////////
		IRDA_TXD,						//	IRDA Transmitter
		IRDA_RXD,						//	IRDA Rceiver
		/////////////////////	SDRAM Interface		////////////////
		DRAM_DQ,						//	SDRAM Data bus 16 Bits
		DRAM_ADDR,						//	SDRAM Address bus 12 Bits
		DRAM_LDQM,						//	SDRAM Low-byte Data Mask 
		DRAM_UDQM,						//	SDRAM High-byte Data Mask
		DRAM_WE_N,						//	SDRAM Write Enable
		DRAM_CAS_N,						//	SDRAM Column Address Strobe
		DRAM_RAS_N,						//	SDRAM Row Address Strobe
		DRAM_CS_N,						//	SDRAM Chip Select
		DRAM_BA_0,						//	SDRAM Bank Address 0
		DRAM_BA_1,						//	SDRAM Bank Address 0
		DRAM_CLK,						//	SDRAM Clock
		DRAM_CKE,						//	SDRAM Clock Enable
		////////////////////	Flash Interface		////////////////
		FL_DQ,							//	FLASH Data bus 8 Bits
		FL_ADDR,						//	FLASH Address bus 20 Bits
		FL_WE_N,						//	FLASH Write Enable
		FL_RST_N,						//	FLASH Reset
		FL_OE_N,						//	FLASH Output Enable
		FL_CE_N,						//	FLASH Chip Enable
		////////////////////	SRAM Interface		////////////////
		SRAM_DQ,						//	SRAM Data bus 16 Bits
		SRAM_ADDR,						//	SRAM Adress bus 18 Bits
		SRAM_UB_N,						//	SRAM Low-byte Data Mask 
		SRAM_LB_N,						//	SRAM High-byte Data Mask 
		SRAM_WE_N,						//	SRAM Write Enable
		SRAM_CE_N,						//	SRAM Chip Enable
		SRAM_OE_N,						//	SRAM Output Enable
		////////////////////	ISP1362 Interface	////////////////
		OTG_DATA,						//	ISP1362 Data bus 16 Bits
		OTG_ADDR,						//	ISP1362 Address 2 Bits
		OTG_CS_N,						//	ISP1362 Chip Select
		OTG_RD_N,						//	ISP1362 Write
		OTG_WR_N,						//	ISP1362 Read
		OTG_RST_N,						//	ISP1362 Reset
		OTG_FSPEED,						//	USB Full Speed,	0 = Enable, Z = Disable
		OTG_LSPEED,						//	USB Low Speed, 	0 = Enable, Z = Disable
		OTG_INT0,						//	ISP1362 Interrupt 0
		OTG_INT1,						//	ISP1362 Interrupt 1
		OTG_DREQ0,						//	ISP1362 DMA Request 0
		OTG_DREQ1,						//	ISP1362 DMA Request 1
		OTG_DACK0_N,					//	ISP1362 DMA Acknowledge 0
		OTG_DACK1_N,					//	ISP1362 DMA Acknowledge 1
		////////////////////	LCD Module 16X2		////////////////
		LCD_ON,							//	LCD Power ON/OFF
		LCD_BLON,						//	LCD Back Light ON/OFF
		LCD_RW,							//	LCD Read/Write Select, 0 = Write, 1 = Read
		LCD_EN,							//	LCD Enable
		LCD_RS,							//	LCD Command/Data Select, 0 = Command, 1 = Data
		LCD_DATA,						//	LCD Data bus 8 bits
		////////////////////	SD_Card Interface	////////////////
		SD_DAT,							//	SD Card Data
		SD_DAT3,						//	SD Card Data 3
		SD_CMD,							//	SD Card Command Signal
		SD_CLK,							//	SD Card Clock
		////////////////////	USB JTAG link	////////////////////
		TDI,  							// CPLD -> FPGA (data in)
		TCK,  							// CPLD -> FPGA (clk)
		TCS,  							// CPLD -> FPGA (CS)
	    TDO,  							// FPGA -> CPLD (data out)
		////////////////////	I2C		////////////////////////////
		I2C_SDAT,						//	I2C Data
		I2C_SCLK,						//	I2C Clock
		////////////////////	PS2		////////////////////////////
		PS2_DAT,						//	PS2 Data
		PS2_CLK,						//	PS2 Clock
		////////////////////	VGA		////////////////////////////
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  						//	VGA Blue[9:0]
		////////////	Ethernet Interface	////////////////////////
		ENET_DATA,						//	DM9000A DATA bus 16Bits
		ENET_CMD,						//	DM9000A Command/Data Select, 0 = Command, 1 = Data
		ENET_CS_N,						//	DM9000A Chip Select
		ENET_WR_N,						//	DM9000A Write
		ENET_RD_N,						//	DM9000A Read
		ENET_RST_N,						//	DM9000A Reset
		ENET_INT,						//	DM9000A Interrupt
		ENET_CLK,						//	DM9000A Clock 25 MHz
		////////////////	Audio CODEC		////////////////////////
		AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
		AUD_ADCDAT,						//	Audio CODEC ADC Data
		AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
		AUD_DACDAT,						//	Audio CODEC DAC Data
		AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
		AUD_XCK,						//	Audio CODEC Chip Clock
		////////////////	TV Decoder		////////////////////////
		TD_DATA,    					//	TV Decoder Data bus 8 bits
		TD_HS,							//	TV Decoder H_SYNC
		TD_VS,							//	TV Decoder V_SYNC
		TD_RESET,						//	TV Decoder Reset
		////////////////////	GPIO	////////////////////////////
		GPIO_0,							//	GPIO Connection 0
		GPIO_1							//	GPIO Connection 1
	);

////////////////////////	Clock Input	 	////////////////////////
	input			CLOCK_27;					//	27 MHz
	input			CLOCK_50;					//	50 MHz
	input			EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
	input	[3:0]	KEY;					//	Button[3:0]
////////////////////////	DPDT Switch		////////////////////////
	input	[17:0]	SW;				//	DPDT Switch[17:0]
////////////////////////	7-SEG Dispaly	////////////////////////
	output	[6:0]	HEX0;					//	Seven Segment Digital 0
	output	[6:0]	HEX1;					//	Seven Segment Digital 1
	output	[6:0]	HEX2;					//	Seven Segment Digital 2
	output	[6:0]	HEX3;					//	Seven Segment Digital 3
	output	[6:0]	HEX4;					//	Seven Segment Digital 4
	output	[6:0]	HEX5;					//	Seven Segment Digital 5
	output	[6:0]	HEX6;					//	Seven Segment Digital 6
	output	[6:0]	HEX7;					//	Seven Segment Digital 7
////////////////////////////	LED		////////////////////////////
	output	[8:0]	LEDG;				//	LED Green[8:0]
	output	[17:0]	LEDR;				//	LED Red[17:0]
////////////////////////////	UART	////////////////////////////
	output			UART_TXD;				//	UART Transmitter
	input			UART_RXD;				//	UART Rceiver
////////////////////////////	IRDA	////////////////////////////
	output			IRDA_TXD;				//	IRDA Transmitter
	input			IRDA_RXD;				//	IRDA Rceiver
///////////////////////		SDRAM Interface	////////////////////////
	inout	[15:0]	DRAM_DQ;				//	SDRAM Data bus 16 Bits
	output	[11:0]	DRAM_ADDR;				//	SDRAM Address bus 12 Bits
	output			DRAM_LDQM;				//	SDRAM Low-byte Data Mask 
	output			DRAM_UDQM;				//	SDRAM High-byte Data Mask
	output			DRAM_WE_N;				//	SDRAM Write Enable
	output			DRAM_CAS_N;				//	SDRAM Column Address Strobe
	output			DRAM_RAS_N;				//	SDRAM Row Address Strobe
	output			DRAM_CS_N;				//	SDRAM Chip Select
	output			DRAM_BA_0;				//	SDRAM Bank Address 0
	output			DRAM_BA_1;				//	SDRAM Bank Address 0
	output			DRAM_CLK;				//	SDRAM Clock
	output			DRAM_CKE;				//	SDRAM Clock Enable
////////////////////////	Flash Interface	////////////////////////
	inout	[7:0]	FL_DQ;					//	FLASH Data bus 8 Bits
	output	[19:0]	FL_ADDR;				//	FLASH Address bus 20 Bits
	output			FL_WE_N;				//	FLASH Write Enable
	output			FL_RST_N;				//	FLASH Reset
	output			FL_OE_N;				//	FLASH Output Enable
	output			FL_CE_N;				//	FLASH Chip Enable
////////////////////////	SRAM Interface	////////////////////////
	inout	[15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
	output	[17:0]	SRAM_ADDR;				//	SRAM Adress bus 18 Bits
	output			SRAM_UB_N;				//	SRAM Low-byte Data Mask 
	output			SRAM_LB_N;				//	SRAM High-byte Data Mask 
	output			SRAM_WE_N;				//	SRAM Write Enable
	output			SRAM_CE_N;				//	SRAM Chip Enable
	output			SRAM_OE_N;				//	SRAM Output Enable
////////////////////	ISP1362 Interface	////////////////////////
	inout	[15:0]	OTG_DATA;				//	ISP1362 Data bus 16 Bits
	output	[1:0]	OTG_ADDR;				//	ISP1362 Address 2 Bits
	output			OTG_CS_N;				//	ISP1362 Chip Select
	output			OTG_RD_N;				//	ISP1362 Write
	output			OTG_WR_N;				//	ISP1362 Read
	output			OTG_RST_N;				//	ISP1362 Reset
	output			OTG_FSPEED;				//	USB Full Speed,	0 = Enable, Z = Disable
	output			OTG_LSPEED;				//	USB Low Speed, 	0 = Enable, Z = Disable
	output			OTG_INT0;				//	ISP1362 Interrupt 0
	output			OTG_INT1;				//	ISP1362 Interrupt 1
	output			OTG_DREQ0;				//	ISP1362 DMA Request 0
	output			OTG_DREQ1;				//	ISP1362 DMA Request 1
	output			OTG_DACK0_N;			//	ISP1362 DMA Acknowledge 0
	output			OTG_DACK1_N;			//	ISP1362 DMA Acknowledge 1
////////////////////	LCD Module 16X2	////////////////////////////
	inout	[7:0]	LCD_DATA;				//	LCD Data bus 8 bits
	output			LCD_ON;					//	LCD Power ON/OFF
	output			LCD_BLON;				//	LCD Back Light ON/OFF
	output			LCD_RW;					//	LCD Read/Write Select, 0 = Write, 1 = Read
	output			LCD_EN;					//	LCD Enable
	output			LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data
////////////////////	SD Card Interface	////////////////////////
	inout			SD_DAT;					//	SD Card Data
	inout			SD_DAT3;				//	SD Card Data 3
	inout			SD_CMD;					//	SD Card Command Signal
	output			SD_CLK;					//	SD Card Clock
////////////////////////	I2C		////////////////////////////////
	inout			I2C_SDAT;				//	I2C Data
	output			I2C_SCLK;				//	I2C Clock
////////////////////////	PS2		////////////////////////////////
	inout		 	PS2_DAT;				//	PS2 Data
	input			PS2_CLK;				//	PS2 Clock
////////////////////	USB JTAG link	////////////////////////////
	input  			TDI;					// CPLD -> FPGA (data in)
	input  			TCK;					// CPLD -> FPGA (clk)
	input  			TCS;					// CPLD -> FPGA (CS)
	output 			TDO;					// FPGA -> CPLD (data out)
////////////////////////	VGA			////////////////////////////
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
////////////////	Ethernet Interface	////////////////////////////
	inout	[15:0]	ENET_DATA;				//	DM9000A DATA bus 16Bits
	output			ENET_CMD;				//	DM9000A Command/Data Select, 0 = Command, 1 = Data
	output			ENET_CS_N;				//	DM9000A Chip Select
	output			ENET_WR_N;				//	DM9000A Write
	output			ENET_RD_N;				//	DM9000A Read
	output			ENET_RST_N;				//	DM9000A Reset
	input			ENET_INT;				//	DM9000A Interrupt
	output			ENET_CLK;				//	DM9000A Clock 25 MHz
////////////////////	Audio CODEC		////////////////////////////
	inout			AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
	inout			AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
	input			AUD_ADCDAT;			    //	Audio CODEC ADC Data
	output			AUD_DACDAT;				//	Audio CODEC DAC Data
	inout			AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
	output			AUD_XCK;				//	Audio CODEC Chip Clock


////////////////////	TV Devoder		////////////////////////////
	input	[7:0]	TD_DATA;    			//	TV Decoder Data bus 8 bits
	input			TD_HS;					//	TV Decoder H_SYNC
	input			TD_VS;					//	TV Decoder V_SYNC
	output			TD_RESET;				//	TV Decoder Reset
////////////////////////	GPIO	////////////////////////////////
	inout	[35:0]	GPIO_0;					//	GPIO Connection 0
	inout	[35:0]	GPIO_1;					//	GPIO Connection 1
////////////////////////////////////////////////////////////////////

//	All inout port turn to tri-state
	
	assign	DRAM_DQ		=	16'hzzzz;
	assign	FL_DQ		=	8'hzz;
	assign	SRAM_DQ		=	16'hzzzz;
	assign	SD_DAT		=	1'bz;
	assign	GPIO_1		=	36'hzzzzzzzzz;
	assign	GPIO_0		=	36'hzzzzzzzzz;	
	
//  TV DECODER ENABLE 
	
	assign  TD_RESET    =   1;
	
//  7-SEG 
			
	SEG7_LUT_8 			u0	(	HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,31'h00001112 );

//  I2C
	
	wire I2C_END;
	
	I2C_AV_Config 		u7	(	//	Host Side
								.iCLK		( CLOCK_50 ),
								.iRST_N		( KEY[0] ),
								.o_I2C_END	( I2C_END ),
								//	I2C Side
								.I2C_SCLK	( I2C_SCLK ),
								.I2C_SDAT	( I2C_SDAT )	
								
								);



//	AUDIO SOUND

	wire    AUD_CTRL_CLK;
	
	assign	AUD_ADCLRCK	=	AUD_DACLRCK;

	assign	AUD_XCK		=	AUD_CTRL_CLK;			


//  AUDIO PLL

	VGA_Audio_PLL 		u1	(	
								.areset ( ~I2C_END ),
								
								.inclk0 ( CLOCK_27 ),

								.c1		( AUD_CTRL_CLK )	
							
								);


// Music Synthesizer Block //

// TIME & CLOCK Generater //

	reg    [31:0]VGA_CLK_o;

	wire   keyboard_sysclk = VGA_CLK_o[11];

	wire   demo_clock      = VGA_CLK_o[18]; 

	assign VGA_CLK         = VGA_CLK_o[0];

	always @( posedge CLOCK_50 ) VGA_CLK_o = VGA_CLK_o + 1;
		

// DEMO SOUND //

// DEMO Sound (CH1) //

	wire [7:0]demo_code1;

	demo_sound1	dd1(
		.clock   ( demo_clock ),
		.key_code( demo_code1 ),
		.k_tr    ( KEY[1] )
	);

// DEMO Sound (CH2) //

	wire [7:0]demo_code2;

	demo_sound2	dd2(
		.clock   ( demo_clock ),
		.key_code( demo_code2 ),
		.k_tr    ( KEY[1] )
	);

// KeyBoard Scan //

	wire [7:0]scan_code;

	wire get_gate;

	wire key1_on;

	wire key2_on;

	wire [7:0]key1_code;

	wire [7:0]key2_code;

	PS2_KEYBOARD keyboard(
	
		.ps2_dat  ( PS2_DAT ),		    //ps2bus data  		
		.ps2_clk  ( PS2_CLK ),		    //ps2bus clk      	
		.sys_clk  ( keyboard_sysclk ),  //system clock		
		.reset    ( KEY[3] ), 		    //system reset		
    	.reset1   ( KEY[2] ),			//keyboard reset	
    	.scandata ( scan_code ),		//scan code    		
    	.key1_on  ( key1_on ),			//key1 triger
    	.key2_on  ( key2_on ),			//key2 triger
    	.key1_code( key1_code ),		//key1 code
    	.key2_code( key2_code ) 		//key2 code
	);
	
////////////Sound Select/////////////	

	wire [15:0]sound1;

	wire [15:0]sound2;

	wire [15:0]sound3;

	wire [15:0]sound4;

	wire sound_off1;

	wire sound_off2;

	wire sound_off3;

	wire sound_off4;

	wire [7:0]sound_code1 = ( !SW[9] )? demo_code1 : key1_code ; //SW[9]=0 is DEMO SOUND,otherwise key

	wire [7:0]sound_code2 = ( !SW[9] )? demo_code2 : key2_code ; //SW[9]=0 is DEMO SOUND,otherwise key

	wire [7:0]sound_code3 = 8'hf0;

	wire [7:0]sound_code4 = 8'hf0;

// Staff Display & Sound Output //

	wire   VGA_R1,VGA_G1,VGA_B1;

	wire   VGA_R2,VGA_G2,VGA_B2;
	
	assign VGA_R=( VGA_R1 )? 10'h3f0 : 0 ;
	
	assign VGA_G=( VGA_G1 )? 10'h3f0 : 0 ;
	
	assign VGA_B=( VGA_B1 )? 10'h3f0 : 0 ;

	staff st1(
		
		// VGA output //
		
		.VGA_CLK   		( VGA_CLK ),   
		.vga_h_sync		( VGA_HS ), 
		.vga_v_sync		( VGA_VS ), 
		.vga_sync  		( VGA_SYNC ),	
	    .inDisplayArea	( VGA_BLANK ),
		.vga_R			( VGA_R1 ), 
		.vga_G			( VGA_G1 ), 
		.vga_B			( VGA_B1 ),
		
		// Key code-in //
		
		.scan_code1( sound_code1 ),
		.scan_code2( sound_code2 ),
		.scan_code3( sound_code3 ), // OFF
		.scan_code4( sound_code4 ), // OFF
		
		//Sound Output to Audio Generater//
		
		.sound1( sound1 ),
		.sound2( sound2 ),
		.sound3( sound3 ), // OFF
		.sound4( sound4 ), // OFF
		
		.sound_off1( sound_off1 ),
		.sound_off2( sound_off2 ),
		.sound_off3( sound_off3 ), //OFF
		.sound_off4( sound_off4 )	 //OFF
		
	);

///////LED Display////////

	assign LEDR[9:6] = { sound_off4,sound_off3,sound_off2,sound_off1 };

	assign LEDG[7:0] = scan_code;
						
// 2CH Audio Sound output -- Audio Generater //

	adio_codec ad1	(	
	        
		// AUDIO CODEC //
		
		.oAUD_BCK ( AUD_BCLK ),
		.oAUD_DATA( AUD_DACDAT ),
		.oAUD_LRCK( AUD_DACLRCK ),																
		.iCLK_18_4( AUD_CTRL_CLK ),
		
		// KEY //
		
		.iRST_N( KEY[0] ),							
		.iSrc_Select( 2'b00 ),

		// Sound Control //

		.key1_on( ~SW[1] & sound_off1 ),//CH1 ON / OFF		
		.key2_on( ~SW[2] & sound_off2 ),//CH2 ON / OFF
		.key3_on( 1'b0 ), // OFF
    	.key4_on( 1'b0 ), // OFF							
		.sound1( sound1 ),// CH1 Freq
		.sound2( sound2 ),// CH2 Freq
		.sound3( sound3 ),// OFF,CH3 Freq
		.sound4( sound4 ),// OFF,CH4 Freq							
		.instru( SW[0] )  // Instruction Select
	);


//	LCD 

	assign	LCD_ON		=	1'b1;
	
	assign	LCD_BLON	=	1'b1;	
	
	LCD_TEST 			u5	(	
	
							//	Host Side
							
							.iCLK  	( CLOCK_50 ),
							.iRST_N	( KEY[0] & I2C_END ),
							
							//	LCD Side
							
							.LCD_DATA( LCD_DATA ),
							.LCD_RW  ( LCD_RW ),
							.LCD_EN	 ( LCD_EN ),
							.LCD_RS  ( LCD_RS )	
							
							);
				
endmodule
