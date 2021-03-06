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
		vga_ver_sync
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
//reg    [7:0]   letter; // later...
//reg    [7:0]   number;
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

// Player 1 start board
reg    [19:0] t_A1 = 20'b00010000000000000000;
reg    [19:0] t_B1 = 20'b00010000000001010000; 
reg    [19:0] t_C1 = 20'b00010000000000000000; 
reg    [19:0] t_D1 = 20'b00010000000000000000; 
reg    [19:0] t_E1 = 20'b00010000010101010000; 
reg    [19:0] t_F1 = 20'b00000000000000000000; 
reg    [19:0] t_G1 = 20'b00010000000000000000; 
reg    [19:0] t_H1 = 20'b00010000000000000000; 
reg    [19:0] t_I1 = 20'b00010000010101000000; 
reg    [19:0] t_J1 = 20'b00000000000000000000;

// Player 2 start board
reg    [19:0] t_A2 = 20'b00000000000000000001;
reg    [19:0] t_B2 = 20'b00010000000000000001; 
reg    [19:0] t_C2 = 20'b00010000000101010000; 
reg    [19:0] t_D2 = 20'b00010000000000000000; 
reg    [19:0] t_E2 = 20'b00010000000000000000; 
reg    [19:0] t_F2 = 20'b00000000000000000000; 
reg    [19:0] t_G2 = 20'b00000000000000000000; 
reg    [19:0] t_H2 = 20'b01000000000000000000; 
reg    [19:0] t_I2 = 20'b01000001010101010000; 
reg    [19:0] t_J2 = 20'b01000000000000000000;  

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
	end
	
always @ ( posedge clock24 ) 
	begin 
		if ( keyDataOut == 8'h5A )
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
	KEY_CONTROLLER KEY_CONTROLLER1( 
											clock27, 
											keyboardClock, 
											keyPressed, 
											keyDataOut, 
											keyboardData,
											//letter,
											//number
											);
											
	LED_CONTROLLER LED_CONTROLLER1( 
											clock27, 
											led_r, 
											led_g, 
											keyPressed, 
											keyDataOut 
											);
	
	HEX_CONTROLLER HEX_CONTROLLER1( 
											clock27, 
											numDisplay0, 
											numDisplay1, 
											numDisplay2, 
											numDisplay3, 
											playerTurn, 
											keyboardData 
											);
	
	VGA_CONTROLLER VGA_CONTROLLER1( 
											clock50, 
											A, B, C, D, E, F, G, H, I, J, 
											playerTurn,
											vga_red, 
											vga_green, 
											vga_blue, 
											vga_hor_sync, 
											vga_ver_sync 
											);
	
	// Determine which players turn it is, for debug purposes mostly
	//assign playerTurn = switch[0] ? PLAYER_TWO : PLAYER_ONE;
	assign playerTurn = t_player_turn;
//end
endmodule


/*
Player 1 Start Board:
00010000000000000000
00010000000001010000
00010000000000000000
00010000000000000000
00010000010101010000
00000000000000000000
00010000000000000000
00010000000000000000
00010000010101000000
00000000000000000000

Player 2 Start Board:
00000000000000000001
00010000000000000001
00010000000101010000
00010000000000000000
00010000000000000000
00000000000000000000
00000000000000000000
01000000000000000000
01000001010101010000
01000000000000000000
*/