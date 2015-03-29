//BATTLESHIP!
module Battleship( 
		clock24,  		// The three clocks used for the program
		clock27,  		// 27 MHz clock
		clock50,       // 50 MHz clock -> will probably use this for VGA
		led_r,    		// The LED's
		led_g, 
		switch,   		// Switch control, if we want it
		keyDataOut, 
		keyboardClock, // All the keyboard data
		keyboardData,
		numDisplay0, 	// The hexidecimal display for the 4 hex thingy's
		numDisplay1,
		numDisplay2,
		numDisplay3,
		vga_red, 		// All the VGA stuff
		vga_green,
		vga_blue,
		vga_hor_sync,
		vga_ver_sync,
		letter,
		number
);
// [7:0] - 8 bits
// wire =/= output.... ??????
// input [#:#] var <- BUS
// input var[#:#] <- Array

// Clocks
input  [1:0] 	clock24;
input  [1:0] 	clock27;
input  			clock50;

// Keyboard Stuff
input  			keyboardClock;
input  			keyboardData;
output [8:0] 	keyDataOut;
output [3:0]   letter;
output [3:0]   number;
wire   			keyPressed;

input  [9:0] 	switch; // 9 switches...

// LED Stuff
output [9:0] 	led_r; // also 9 corresponding led's
output [7:0] 	led_g; // the other 9 led's

// HEX Stuff
output [6:0] 	numDisplay0;
output [6:0] 	numDisplay1;
output [6:0] 	numDisplay2;
output [6:0] 	numDisplay3;

// VGA Stuff
output [9:0] 	vga_red; 
output [9:0] 	vga_green;
output [9:0] 	vga_blue;
output       	vga_hor_sync;
output       	vga_ver_sync;

// Game Stuff
parameter 		BOARD_SIZE  = 10;
parameter 		PLAYER_ONE  = 0;
parameter 		PLAYER_TWO  = 1;
wire    		 	playerTurn;
reg    [20:0] 	heartbeat   = 21'b0;
reg 				t_player_turn = PLAYER_ONE;
//integer        canSwitchPlayer; // Determines if the enter button can be pressed...


// the 10x10 battleship board!
// Blue  - Water
// Grey  - Ship
// Red   - Hit
// White - Miss
// 00 - water, 01 - ship to pass into VGA
// 10 - miss,  11 - hit
// Each two bit section indicates a thingy to draw
reg    [19:0] A;
reg    [19:0] B; 
reg    [19:0] C; 
reg    [19:0] D; 
reg    [19:0] E; 
reg    [19:0] F; 
reg    [19:0] G; 
reg    [19:0] H; 
reg    [19:0] I; 
reg    [19:0] J;

// Board for the oppisite player's board, so you can see what you did
reg    [19:0] OA;
reg    [19:0] OB; 
reg    [19:0] OC; 
reg    [19:0] OD; 
reg    [19:0] OE; 
reg    [19:0] OF; 
reg    [19:0] OG; 
reg    [19:0] OH; 
reg    [19:0] OI; 
reg    [19:0] OJ;

// Player 1 start board
wire    [19:0] t_A1;
wire    [19:0] t_B1; 
wire    [19:0] t_C1; 
wire    [19:0] t_D1; 
wire    [19:0] t_E1; 
wire    [19:0] t_F1; 
wire    [19:0] t_G1; 
wire    [19:0] t_H1; 
wire    [19:0] t_I1; 
wire    [19:0] t_J1;

// Player 2 start board
wire    [19:0] t_A2;
wire    [19:0] t_B2; 
wire    [19:0] t_C2; 
wire    [19:0] t_D2; 
wire    [19:0] t_E2; 
wire    [19:0] t_F2; 
wire    [19:0] t_G2; 
wire    [19:0] t_H2; 
wire    [19:0] t_I2; 
wire    [19:0] t_J2;  

// View for opposite players board
// Player 1 start board
wire    [19:0] t_OA1;
wire    [19:0] t_OB1; 
wire    [19:0] t_OC1;
wire    [19:0] t_OD1;
wire    [19:0] t_OE1;
wire    [19:0] t_OF1; 
wire    [19:0] t_OG1; 
wire    [19:0] t_OH1; 
wire    [19:0] t_OI1; 
wire    [19:0] t_OJ1;

// Player 2 start board
wire    [19:0] t_OA2;
wire    [19:0] t_OB2; 
wire    [19:0] t_OC2; 
wire    [19:0] t_OD2; 
wire    [19:0] t_OE2; 
wire    [19:0] t_OF2; 
wire    [19:0] t_OG2; 
wire    [19:0] t_OH2; 
wire    [19:0] t_OI2; 
wire    [19:0] t_OJ2;

// our heartbeat timer
always @ ( posedge clock50 ) 
begin
	heartbeat <= heartbeat+1'b1;
end

// Positive edge of the heartbeat when it hits
// 20'b10000000000000000000 (possibly)
always @ ( posedge heartbeat[20] )
	begin
		 A = switch[0] ? t_A2 : t_A1;
		 B = switch[0] ? t_B2 : t_B1;
		 C = switch[0] ? t_C2 : t_C1;
		 D = switch[0] ? t_D2 : t_D1;
		 E = switch[0] ? t_E2 : t_E1;
		 F = switch[0] ? t_F2 : t_F1;
		 G = switch[0] ? t_G2 : t_G1;
		 H = switch[0] ? t_H2 : t_H1;
		 I = switch[0] ? t_I2 : t_I1;
		 J = switch[0] ? t_J2 : t_J1;
		 OA = switch[0] ? t_OA1 : t_OA2;
		 OB = switch[0] ? t_OB1 : t_OB2;
		 OC = switch[0] ? t_OC1 : t_OC2;
		 OD = switch[0] ? t_OD1 : t_OD2;
		 OE = switch[0] ? t_OE1 : t_OE2;
		 OF = switch[0] ? t_OF1 : t_OF2;
		 OG = switch[0] ? t_OG1 : t_OG2;
		 OH = switch[0] ? t_OH1 : t_OH2;
		 OI = switch[0] ? t_OI1 : t_OI2;
		 OJ = switch[0] ? t_OJ1 : t_OJ2;
	end
	
always @ ( posedge clock24 ) 
	begin 
		if ( number == 55 )//( keyDataOut == 8'h5A )
		 begin
			if ( playerTurn == PLAYER_ONE )
			 begin
				t_player_turn = PLAYER_TWO;
			 end
				
			if ( playerTurn == PLAYER_TWO )
			 begin
				t_player_turn = PLAYER_ONE;
			 end
		 end
	end

// "main"
	// Flash the LED's cause that is cool
	KEY_CONTROLLER KEY_CONTROLLER_OJB( 
											clock27, 
											keyboardClock, 
											keyPressed, 
											keyDataOut, 
											keyboardData,
											number,
											letter
											);
											
	LED_CONTROLLER LED_CONTROLLER_OJB( 
											clock27, 
											led_r, 
											led_g, 
											keyPressed, 
											keyDataOut,
											);
	
	HEX_CONTROLLER HEX_CONTROLLER_OJB( 
											clock27, 
											numDisplay0, 
											numDisplay1, 
											numDisplay2, 
											numDisplay3, 
											playerTurn, 
											keyboardData,
											letter,
											number	
											);
	
	VGA_CONTROLLER VGA_CONTROLLER_OJB( 
											clock27,
											clock50, 
											A, B, C, D, E, F, G, H, I, J,
										   OA, OB, OC, OD, OE, OF, OG, OH, OI, OJ,	
											playerTurn,
											vga_red, 
											vga_green, 
											vga_blue, 
											vga_hor_sync, 
											vga_ver_sync 
											);
	THE_GREAT_DECIDER THE_GREAT_DECIDER_OJB (
											clock27,
											t_A1, t_B1, t_C1, t_D1, t_E1, t_F1, t_G1, t_H1, t_I1, t_J1, 
											t_A2, t_B2, t_C2, t_D2, t_E2, t_F2, t_G2, t_H2, t_I2, t_J2, 
											t_OA1, t_OB1, t_OC1, t_OD1, t_OE1, t_OF1, t_OG1, t_OH1, t_OI1, t_OJ1, 
											t_OA2, t_OB2, t_OC2, t_OD2, t_OE2, t_OF2, t_OG2, t_OH2, t_OI2, t_OJ2,
											keyDataOut,
											letter,
											number,
											playerTurn
											);
	
	// Determine which players turn it is, for debug purposes mostly
	//assign playerTurn = switch[0] ? PLAYER_TWO : PLAYER_ONE;
	assign playerTurn = t_player_turn;
	
//end
endmodule