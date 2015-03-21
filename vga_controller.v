// VGA controller

// This will draw a 10x10 board onto the screen, with a ribbion on the top,
// Blue on the Ribbion is Player 1, Red on the Ribbion is Player 2.
// There will be a black buffer around the board, and then the 10x10 board itself.

// The Board colours are as follows:
// 					RED  GREEN  BLUE
// Blue  - Water   0     0     1 
// Black - Ship    0     0     0
// Red   - Hit     1     0     0
// White - Miss    1     1     1

// 800x600 Horizontal Refresh: 60Hz
// Vertical Refresh:   37.87kHz
// Pixel Frequency:    40.0MHz

module VGA_CONTROLLER ( 
		clock27,
		clock50, // 640x480 @ 25.175MHz Pixel Clock
					// 800x600 @ 40.0MHz pixel clock <--- ????????????
		A, B, C, D, E, F, G, H, I, J, 
		OA, OB, OC, OD, OE, OF, OG, OH, OI, OJ,
		playerTurn,
		vga_red, 
		vga_green, 
		vga_blue, 
		vga_hor_sync, 
		vga_ver_sync
);

input [1:0] clock27;
input  clock50;

// 800 x 600 resolution...
parameter HORIZONTAL_DISPLAY = 800;
parameter VERTICAL_DISPLAY   = 600;
// has a blanking time of:
//Resolution (pixels) (https://eewiki.net/pages/viewpage.action?pageId=15925278)
// Resolution  freq  pixel disp  front  sync   back
//                   clock       porch  pulse  porch
// 800x600	    60	 40	 800	 40	 128	   88	    h_sync polarity: p  ??
//                          600	  1	  4	   23	    v_sync polarity: p  ??

// Timing = disp + front porth + sync pulse + back porch
parameter HORIZONTAL_TIMING  = 1056;
parameter VERTICAL_TIMING    = 628;
parameter HORIZONTAL_RETRACE = 120;
parameter VERTICAL_RETRACE   = 6;
parameter H_FRONT_PORCH 	  = 40;
parameter V_FRONT_PORCH 	  = 1;
parameter H_SYNC_PULSE 		  = 128;
parameter V_SYNC_PULSE 		  = 4;
parameter H_BACK_PORCH 		  = 88;
parameter V_BACK_PORCH 		  = 23;

parameter BLOCK_SIZE  		  = 32;
parameter INDEX_START 		  = 3; // This has to be BLOCK_SIZE * X = 96!!!!!!!!!!!!! STOP FORGETTING THIS!
											 // This is done for a good reason Chris...
parameter K_VAL 				  = 14;

// Board stuff
// the 10x10 battleship board! 48x48 pixel boxes
// Blue  - Water
// Grey  - Ship
// Red   - Hit
// White - Miss
// 00 - water, 01 - ship
// 10 - miss,  11 - hit
// Each two bit section indicates a thingy to draw
input  		 playerTurn;
input [19:0] A;
input [19:0] B; 
input [19:0] C; 
input [19:0] D; 
input [19:0] E; 
input [19:0] F; 
input [19:0] G; 
input [19:0] H; 
input [19:0] I; 
input [19:0] J;
input [19:0] OA;
input [19:0] OB; 
input [19:0] OC; 
input [19:0] OD; 
input [19:0] OE; 
input [19:0] OF; 
input [19:0] OG; 
input [19:0] OH; 
input [19:0] OI; 
input [19:0] OJ;   
reg   [19:0] empty_pattern = 20'b00000000000000000000;
reg 	[19:0] tempLetter;
reg    		 can_draw = 0;
reg 			 stupidCaseCheck = 0;
reg 			 whichBoard = 0; // o - Your board, 1 - ENEMY BOARD!!!

// VGA stuff
integer 		 boardLevel;	
integer 		 i;
integer 		 k = K_VAL;
output [2:0] vga_red; 
output [2:0] vga_green;
output [2:0] vga_blue;
output       vga_hor_sync;
output       vga_ver_sync;
//reg          red;
//reg          green;
//reg          blue;
reg 			 canDisplay;
reg 	 [8:0] colour;
wire 			 board = ( pixel_x[9:3] == 20 ) || 
							( pixel_x[9:3] == 780 ) || 
							( pixel_y[8:3] == 20 ) || 
							( pixel_y[8:3] == 580 );
reg 	 [3:0] t_red;
reg 	 [3:0] t_green;
reg 	 [3:0] t_blue;
reg 	 	    t_hor;
reg 	       t_ver;
reg    [1:0] tempVal;
reg    [9:0] pixel_x = 0;
reg    [8:0] pixel_y = 0;


// Vertical and Horizontal Sync going
always @ ( posedge clock27 )
	begin
		// horizontal sync
		if ( pixel_x < HORIZONTAL_TIMING )
		 begin
			pixel_x <= pixel_x + 1;
		 end
		else
		 begin
			pixel_x <= 0;
		 end
		 
		if ( pixel_x < H_SYNC_PULSE )
		 begin
			t_hor <= 0;
		 end
		else
		 begin
			t_hor <= 1;
		 end
		 
		 
		// vertical sync
		// When pixel_x is done ( i.e. end of the line, drop pixel_y )
		if ( pixel_x == HORIZONTAL_DISPLAY - 1 )
		 begin
			if ( pixel_y < VERTICAL_TIMING )
			 begin
				pixel_y <= pixel_y + 1;
			 end
			else
			 begin
				pixel_y <= 0;
			 end
			 
			if ( pixel_y < V_SYNC_PULSE )
			 begin
				t_ver <= 0;
			 end
			else
			 begin
				t_ver <= 1;
			 end
		 end
		 
		 // Determine if we are in the drawing area or the blanking area
		 // of the screen
		 canDisplay <= ( pixel_x >= H_BACK_PORCH + H_FRONT_PORCH && 
						 pixel_x < HORIZONTAL_TIMING && 
						 pixel_y >= V_BACK_PORCH + V_FRONT_PORCH && 
						 pixel_y < VERTICAL_TIMING );
	end
	
	
always @ ( posedge clock27 )
	begin
		// maybe just if statements checking the pixel_y for a certain pixel count to draw the 
		// the next letter? Every 48 pixels down draw another letter...
		// very low level hard coded values... starting at 96 and going down too 576.
		// Then pixel_x can just go across each letter and deal with it from 20 to 500 or something.

		// Choose a letter to draw
		// The Banner
		if ( pixel_y > 0 && pixel_y < 90 )
		 begin
			// Banner
			can_draw   = 0;
			//colour    <= playerTurn == 1'b0 ? 9'b111111111 : 9'b000000000; // boring black and white
			colour    <= playerTurn == 1'b0 ? 9'b101010101 : 9'b010101010; // random funky colours
			boardLevel = 99;
		 end
		else if ( pixel_y > 90 && pixel_y < 96 )
		 begin
			// Line...
			can_draw   = 0;
			colour    <= 9'b000000000; // A nice border :)
			boardLevel = 99;
		 end
		// The Board:
		else if ( pixel_y > ( BLOCK_SIZE * INDEX_START ) && 
					 pixel_y <= ( BLOCK_SIZE * ( INDEX_START + 1 ) ) )
		 begin
			// A
			can_draw   = 1;
			boardLevel = 1;
		 end
		else if ( pixel_y > ( BLOCK_SIZE * ( INDEX_START + 1 ) ) && 
					 pixel_y <= ( BLOCK_SIZE * ( INDEX_START + 2 ) ) )
		 begin
			// B
			can_draw   = 1;
			boardLevel = 2;
		 end
		else if ( pixel_y > ( BLOCK_SIZE * ( INDEX_START + 2 ) ) && 
					 pixel_y <= ( BLOCK_SIZE * ( INDEX_START + 3 ) ) )
		 begin
			// C
			can_draw   = 1;
			boardLevel = 3;
		 end
		else if ( pixel_y > ( BLOCK_SIZE * ( INDEX_START + 3 ) ) && 
				    pixel_y <= ( BLOCK_SIZE * ( INDEX_START + 4 ) ) )
		 begin
			// D
			can_draw   = 1;
			boardLevel = 4;
		 end
		else if ( pixel_y > ( BLOCK_SIZE * ( INDEX_START + 4 ) ) && 
					 pixel_y <= ( BLOCK_SIZE * ( INDEX_START + 5 ) ) )
		 begin
			// E
			can_draw   = 1;
			boardLevel = 5;
		 end
		else if ( pixel_y > ( BLOCK_SIZE * ( INDEX_START + 5 ) ) && 
					 pixel_y <= ( BLOCK_SIZE * ( INDEX_START + 6 ) ) )
		 begin
			// F
			can_draw   = 1;
			boardLevel = 6;
		 end
		else if ( pixel_y >( BLOCK_SIZE * ( INDEX_START + 6 ) ) && 
					 pixel_y <= ( BLOCK_SIZE * ( INDEX_START + 7 ) ) )
		 begin
			// G
			can_draw   = 1;
			boardLevel = 7;
		 end
		else if ( pixel_y > ( BLOCK_SIZE * ( INDEX_START + 7 ) ) && 
					 pixel_y <= ( BLOCK_SIZE * ( INDEX_START + 8 ) ) )
		 begin
			// H
			can_draw   = 1;
			boardLevel = 8;
		 end
		else if ( pixel_y > ( BLOCK_SIZE * ( INDEX_START + 8 ) ) && 
					 pixel_y <= ( BLOCK_SIZE * ( INDEX_START + 9 ) ) )
		 begin
			// I
			can_draw   = 1;
			boardLevel = 9;
		 end
		else if ( pixel_y > ( BLOCK_SIZE * ( INDEX_START + 9 ) ) && 
					 pixel_y <= ( BLOCK_SIZE * ( INDEX_START + 10 ) ) )
		 begin
			// J
			can_draw   = 1;
			boardLevel = 10;
		 end
		 
		// Supposed to be vertical lines
		///////
		/*if ( pixel_y > ( BLOCK_SIZE * INDEX_START ) )
		 begin
			can_draw = 0;
			colour <= 9'b000000000;
		 end
		else if ( pixel_y == ( BLOCK_SIZE * ( INDEX_START + 1 ) ) )
		 begin
			can_draw = 0;
			colour <= 9'b000000000;
		 end
		else if ( pixel_y == ( BLOCK_SIZE * ( INDEX_START + 2 ) ) )
		 begin
			can_draw = 0;
			colour <= 9'b000000000;
		 end
		else if ( pixel_y == ( BLOCK_SIZE * ( INDEX_START + 3 ) ) )
		 begin
			can_draw = 0;
			colour <= 9'b000000000;
		 end
		else if ( pixel_y == ( BLOCK_SIZE * ( INDEX_START + 4 ) ) )
		 begin
			can_draw = 0;
			colour <= 9'b000000000;
		 end
		else if ( pixel_y == ( BLOCK_SIZE * ( INDEX_START + 5 ) ) )
		 begin
			can_draw = 0;
			colour <= 9'b000000000;
		 end
		else if ( pixel_y == ( BLOCK_SIZE * ( INDEX_START + 6 ) ) )
		 begin
			can_draw = 0;
			colour <= 9'b000000000;
		 end
		else if ( pixel_y == ( BLOCK_SIZE * ( INDEX_START + 7 ) ) )
		 begin
			can_draw = 0;
			colour <= 9'b000000000;
		 end
		else if ( pixel_y == ( BLOCK_SIZE * ( INDEX_START + 8 ) ) )
		 begin
			can_draw = 0;
			colour <= 9'b000000000;
		 end
		else if ( pixel_y == ( BLOCK_SIZE * ( INDEX_START + 9 ) ) )
		 begin
			can_draw = 0;
			colour <= 9'b000000000;
		 end
		else
		 begin
			can_draw = 1;
		 end
		*/
		///////
			

		case ( boardLevel )
			1:  tempLetter <= whichBoard == 0 ? A : OA;
			2:  tempLetter <= whichBoard == 0 ? B : OB;
			3:  tempLetter <= whichBoard == 0 ? C : OC;
			4:  tempLetter <= whichBoard == 0 ? D : OD;
			5:  tempLetter <= whichBoard == 0 ? E : OE;
			6:  tempLetter <= whichBoard == 0 ? F : OF;
			7:  tempLetter <= whichBoard == 0 ? G : OG;
			8:  tempLetter <= whichBoard == 0 ? H : OH;
			9:  tempLetter <= whichBoard == 0 ? I : OI;
			10: tempLetter <= whichBoard == 0 ? J : OJ;
			99: tempLetter <= empty_pattern;
		endcase
			
		// This should be for pixel_x...
		case ( k )
			10: tempVal <= tempLetter[19:18];
			9:  tempVal <= tempLetter[17:16];
			8:  tempVal <= tempLetter[15:14];
			7:  tempVal <= tempLetter[13:12];
			6:  tempVal <= tempLetter[11:10];
			5:  tempVal <= tempLetter[9:8];
			4:  tempVal <= tempLetter[7:6];
			3:  tempVal <= tempLetter[5:4];
			2:  tempVal <= tempLetter[3:2];
			1:  tempVal <= tempLetter[1:0];
			default: stupidCaseCheck = 1;
			//default: colour <= can_draw == 1 ? 9'b000000000;
		endcase
		
		// I feel this is self explanitory 
		if ( stupidCaseCheck == 1 )
		 begin
			stupidCaseCheck = 0; // suuuuper stupid
			// i.e. if we are below the banner
			if ( can_draw == 1 )
			 begin
				colour <= 9'b000000000;
			 end
		 end
	
		// Actually make sure we can draw the board, otherwise, we are drawing the
		// banner based on player turn. Colour is gotten from that place then
		if ( can_draw == 1 && k <= 10 )
		 begin
			case ( tempVal )
				2'b00: colour <= 9'b000000111; // water
				//2'b01: colour <= 9'b000000000; // ship
				2'b01: colour <= 9'b001001001; // ship
				2'b10: colour <= 9'b111111111; // miss
				2'b11: colour <= 9'b111000000; // hit
			endcase
		 end
		 
		if ( k == 75 )
		 begin
			colour <= 9'b000000000;
			//k = 10;
		 end
		
		if ( ( pixel_x > BLOCK_SIZE * 2 ) &&
			  ( pixel_x % BLOCK_SIZE == 0 ) && 
			  ( can_draw == 1 ) )
		 begin
			if ( k == 75 )
			 begin
				k = 10;
			 end
			else
			 begin
				k = k - 1;
			 end
		
			// Draw the second board
			if ( ( k < 1 ) && whichBoard == 0 )
			 begin
				k = 75;
				whichBoard = 1;
			 end
			 // Don't duplicate the board
			if ( ( k < 1 ) && ( pixel_x < BLOCK_SIZE * 20 ) )
			 begin
				k = K_VAL;
				whichBoard = 0;
			 end
			else
			 begin
				// So this makes vertical lines apparently... COOL
				colour <= 9'b000000000;
			 end
		 end // end big if
		 
		// Cut off the boards, otherwise they just extend the last cell
		if ( pixel_x > BLOCK_SIZE * 28 && can_draw == 1 )
		 begin
			colour <= 9'b000000000;
		 end
		 
		if ( pixel_y > BLOCK_SIZE * 13 && can_draw == 1 )
		 begin
			colour <= 9'b000000000;
		 end
					 
		t_red   <= canDisplay ? colour[8:6] : 0;
		t_green <= canDisplay ? colour[5:3] : 0;
		t_blue  <= canDisplay ? colour[2:0] : 0;
	end // end board logic
	
assign vga_hor_sync = ~t_hor;
assign vga_ver_sync = ~t_ver;

assign vga_red   = t_red;   //& canDisplay;
assign vga_green = t_green; //& canDisplay;
assign vga_blue  = t_blue;  //& canDisplay;

endmodule