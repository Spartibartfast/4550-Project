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
		clock50, // 640x480 @ 25.175MHz Pixel Clock
					// 800x600 @ 40.0MHz pixel clock
		A, B, C, D, E, F, G, H, I, J, 
		playerTurn,
		vga_red, 
		vga_green, 
		vga_blue, 
		vga_hor_sync, 
		vga_ver_sync
);

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
reg   [19:0] empty_pattern = 20'b00000000000000000000;
reg 	[19:0] tempLetter;
reg    		 can_draw = 0;

// VGA stuff
integer 		 boardLevel;	
integer 		 i;
integer 		 k = 10;
output [2:0] vga_red; 
output [2:0] vga_green;
output [2:0] vga_blue;
output       vga_hor_sync;
output       vga_ver_sync;
reg          red;
reg          green;
reg          blue;
reg 			 display;
reg 	 [8:0] colour;
wire 			 board = ( pixel_x[9:3] == 0 ) || 
							( pixel_x[9:3] == 79 ) || 
							( pixel_y[8:3] == 0 ) || 
							( pixel_y[8:3] == 59 );
reg 	 [2:0] t_red;
reg 	 [2:0] t_green;
reg 	 [2:0] t_blue;
reg 	 	    t_hor;
reg 	       t_ver;
reg    [1:0] tempVal;
reg    [9:0] pixel_x = 0;
reg    [9:0] pixel_y = 0;



always @ ( posedge clock50 )
	begin
		// pixel_x & _y are used to generate the horizontal sync and the
		// vertical sync
		if ( pixel_x >= HORIZONTAL_DISPLAY ) // roughy 30us 767
		 begin
				// Go to begining of Horizontal, and go down a level of vertical
				pixel_x <= 0;
				pixel_y <= pixel_y + 1;
		 end
		else
		 begin
				pixel_x <= pixel_x + 1;
		 end
		
		//if ( pixel_y >= VERTICAL_TIMING )
		// begin
		//	pixel_y <= 0;
		// end
			
		// Horizontal and Vertical Sync
		t_hor <= ( pixel_x[9:4] == 45 ); // 6'h2D
		t_ver <= ( pixel_y == VERTICAL_DISPLAY ); // 500???
		//t_hor <= ( pixel_x == HORIZONTAL_DISPLAY ); // 16 clock cycles...
		//t_ver <= ( pixel_y < VERTICAL_DISPLAY ); // 800 clock cycles...
		
		if ( display == 0 )
			display <= ( pixel_x == HORIZONTAL_DISPLAY ) && ( pixel_y < VERTICAL_DISPLAY );
		else
			display <= !( pixel_x == HORIZONTAL_TIMING ); //&& !( pixel_y < VERTICAL_TIMING );
	end  // end vga sync logic
	
	
	
always @ ( posedge clock50 )
	begin
		// maybe just if statements checking the pixel_y for a certain pixel count to draw the 
		// the next letter? Every 48 pixels down draw another letter...
		// very low level hard coded values... starting at 96 and going down too 576.
		// Then pixel_x can just go across each letter and deal with it from 20 to 500 or something.
		
		// Choose a letter to draw
		if ( pixel_y > 0 && pixel_y < 96 )
		 begin
			can_draw = 0;
			colour = 9'b111111111;
			boardLevel = 99;
		 end
		else if ( pixel_y > 96 && pixel_y <= 144 )
		 begin
			can_draw = 1;
			boardLevel = 1;
		 end
		else if ( pixel_y > 144 && pixel_y <= 192 )
		 begin
			can_draw = 1;
			boardLevel = 2;
		 end
		else if ( pixel_y > 192 && pixel_y <= 240 )
		 begin
			can_draw = 1;
			boardLevel = 3;
		 end
		else if ( pixel_y > 240 && pixel_y <= 288 )
		 begin
			can_draw = 1;
			boardLevel = 4;
		 end
		else if ( pixel_y > 288 && pixel_y <= 336 )
		 begin
			can_draw = 1;
			boardLevel = 5;
		 end
		else if ( pixel_y > 336 && pixel_y <= 384 )
		 begin
			can_draw = 1;
			boardLevel = 6;
		 end
		else if ( pixel_y > 384 && pixel_y <= 432 )
		 begin
			can_draw = 1;
			boardLevel = 7;
		 end
		else if ( pixel_y > 432 && pixel_y <= 528 )
		 begin
			can_draw = 1;
			boardLevel = 8;
		 end
		else if ( pixel_y > 528 && pixel_y <= 576 )
		 begin
			can_draw = 1;
			boardLevel = 9;
		 end
		else if ( pixel_y > 576 && pixel_y <= 624 )
		 begin
			can_draw = 1;
			boardLevel = 10;
		 end
			
		case ( boardLevel )
			1:  tempLetter <= A;
			2:  tempLetter <= B;
			3:  tempLetter <= C;
			4:  tempLetter <= D;
			5:  tempLetter <= E;
			6:  tempLetter <= F;
			7:  tempLetter <= G;
			8:  tempLetter <= H;
			9:  tempLetter <= I;
			10: tempLetter <= J;
			99: tempLetter <= empty_pattern;
		endcase
			
		case ( k )
			10: tempVal = tempLetter[19:18];
			9:  tempVal = tempLetter[17:16];
			8:  tempVal = tempLetter[15:14];
			7:  tempVal = tempLetter[13:12];
			6:  tempVal = tempLetter[11:10];
			5:  tempVal = tempLetter[9:8];
			4:  tempVal = tempLetter[7:6];
			3:  tempVal = tempLetter[5:4];
			2:  tempVal = tempLetter[3:2];
			1:  tempVal = tempLetter[1:0];
		endcase
		
		case ( tempVal )
			2'b00: colour = 9'b000000111; // water
			2'b01: colour = 9'b000000000; // ship
			2'b10: colour = 9'b111111111; // miss
			2'b11: colour = 9'b111000000; // hit
		endcase
		
		if ( ( pixel_x % 48 == 0 ) && ( can_draw == 1 ) )
		 begin
			k = k - 1;
		
			if ( k < 1 )
			 begin
				k = 10;
			 end
		 end
			
		t_red   <=  colour[8:6];
		t_green <=  colour[5:3];
		t_blue  <=  colour[2:0];
	end // end board logic
	
assign vga_hor_sync = ~t_hor;
assign vga_ver_sync = ~t_ver;

assign vga_red   = t_red;   //& display;
assign vga_green = t_green; //& display;
assign vga_blue  = t_blue;  //& display;

endmodule