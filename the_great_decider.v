/* The Great Decider will take in keyboard input, 
who's player turn it is, and the players board
*/
module THE_GREAT_DECIDER ( 
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
	
parameter PLAYER_ONE = 0;
parameter PLAYER_TWO = 1;	
	
input [1:0] clock27;
input [8:0] keyDataOut;
input  		playerTurn;

output [19:0] t_A1;
output [19:0] t_B1; 
output [19:0] t_C1; 
output [19:0] t_D1; 
output [19:0] t_E1; 
output [19:0] t_F1; 
output [19:0] t_G1; 
output [19:0] t_H1; 
output [19:0] t_I1; 
output [19:0] t_J1;

output [19:0] t_OA1;
output [19:0] t_OB1; 
output [19:0] t_OC1;
output [19:0] t_OD1;
output [19:0] t_OE1;
output [19:0] t_OF1; 
output [19:0] t_OG1; 
output [19:0] t_OH1; 
output [19:0] t_OI1; 
output [19:0] t_OJ1;

output [19:0] t_A2;
output [19:0] t_B2; 
output [19:0] t_C2; 
output [19:0] t_D2; 
output [19:0] t_E2; 
output [19:0] t_F2; 
output [19:0] t_G2; 
output [19:0] t_H2; 
output [19:0] t_I2; 
output [19:0] t_J2;  

output [19:0] t_OA2;
output [19:0] t_OB2; 
output [19:0] t_OC2; 
output [19:0] t_OD2; 
output [19:0] t_OE2; 
output [19:0] t_OF2; 
output [19:0] t_OG2; 
output [19:0] t_OH2; 
output [19:0] t_OI2; 
output [19:0] t_OJ2;

// Super Temporary Vars!
reg [19:0] t_t_A1;
reg [19:0] t_t_B1; 
reg [19:0] t_t_C1; 
reg [19:0] t_t_D1; 
reg [19:0] t_t_E1; 
reg [19:0] t_t_F1; 
reg [19:0] t_t_G1; 
reg [19:0] t_t_H1; 
reg [19:0] t_t_I1; 
reg [19:0] t_t_J1;

reg [19:0] t_t_OA1;
reg [19:0] t_t_OB1; 
reg [19:0] t_t_OC1;
reg [19:0] t_t_OD1;
reg [19:0] t_t_OE1;
reg [19:0] t_t_OF1; 
reg [19:0] t_t_OG1; 
reg [19:0] t_t_OH1; 
reg [19:0] t_t_OI1; 
reg [19:0] t_t_OJ1;

reg [19:0] t_t_A2;
reg [19:0] t_t_B2; 
reg [19:0] t_t_C2; 
reg [19:0] t_t_D2; 
reg [19:0] t_t_E2; 
reg [19:0] t_t_F2; 
reg [19:0] t_t_G2; 
reg [19:0] t_t_H2; 
reg [19:0] t_t_I2; 
reg [19:0] t_t_J2;  

reg [19:0] t_t_OA2;
reg [19:0] t_t_OB2; 
reg [19:0] t_t_OC2; 
reg [19:0] t_t_OD2; 
reg [19:0] t_t_OE2; 
reg [19:0] t_t_OF2; 
reg [19:0] t_t_OG2; 
reg [19:0] t_t_OH2; 
reg [19:0] t_t_OI2; 
reg [19:0] t_t_OJ2;

input[3:0] letter;
input[3:0] number;  

reg 			whichKeyAreWeGetting = 0; // 0 - Letter, 1 - Number
reg 			fullCommand = 0;

integer	  x;
reg [1:0]  row;
reg [19:0] col;

integer 	 start = 1;

// Key Guide:
// A -> 0 			0 (10) -> 0
// B -> 1 			1 -> 1
// C -> 2 			... 
// D -> 3
// E -> 4
// F -> 5
// G -> 6
// H -> 7
// I -> 8
// J -> 9
// Unknown -> 99  Unknown -> 88
// Enter -> 55
always @ ( posedge clock27 )
	begin
		if ( start == 1 )
		 begin
			t_t_A1 = 20'b00010000000000000000;
			t_t_B1 = 20'b00010000000001010000; 
			t_t_C1 = 20'b00010000000000000000; 
			t_t_D1 = 20'b00010000000000000000; 
			t_t_E1 = 20'b00010000010101010000; 
			t_t_F1 = 20'b00000000000000000000; 
			t_t_G1 = 20'b00010000000000000000; 
			t_t_H1 = 20'b00010000000000000000; 
			t_t_I1 = 20'b00010000010101000000; 
			t_t_J1 = 20'b00000000000000000000;
			t_t_A2 = 20'b00000000000000000001;
			t_t_B2 = 20'b00010000000000000001; 
			t_t_C2 = 20'b00010000000101010000; 
			t_t_D2 = 20'b00010000000000000000; 
			t_t_E2 = 20'b00010000000000000000; 
			t_t_F2 = 20'b00000000000000000000; 
			t_t_G2 = 20'b00000000000000000000; 
			t_t_H2 = 20'b01000001010101010000; 
			t_t_I2 = 20'b01000000000000000000; 
			t_t_J2 = 20'b01000000000000000000;  
			t_t_OA1 = 20'b00000000000000000000;
			t_t_OB1 = 20'b00000000000000000000; 
			t_t_OC1 = 20'b00000000000000000000;
			t_t_OD1 = 20'b00000000000000000000;
			t_t_OE1 = 20'b00000000000000000000;
			t_t_OF1 = 20'b00000000000000000000; 
			t_t_OG1 = 20'b00000000000000000000; 
			t_t_OH1 = 20'b00000000000000000000; 
			t_t_OI1 = 20'b00000000000000000000; 
			t_t_OJ1 = 20'b00000000000000000000;
			t_t_OA2 = 20'b00000000000000000000;
			t_t_OB2 = 20'b00000000000000000000; 
			t_t_OC2 = 20'b00000000000000000000; 
			t_t_OD2 = 20'b00000000000000000000; 
			t_t_OE2 = 20'b00000000000000000000; 
			t_t_OF2 = 20'b00000000000000000000; 
			t_t_OG2 = 20'b00000000000000000000; 
			t_t_OH2 = 20'b00000000000000000000; 
			t_t_OI2 = 20'b00000000000000000000; 
			t_t_OJ2 = 20'b00000000000000000000;
			start = 0;
		 end
	end

always @ ( posedge clock27 )
	begin
		// Handle the letter case
		if ( whichKeyAreWeGetting == 0 && fullCommand == 0 )
		 begin
			case( letter )
				4'b0000: x = 0;
				4'b0001: x = 2;
				4'b0010: x = 4;
				4'b0011: x = 6;
				4'b0100: x = 8;
				4'b0101: x = 10;
				4'b0110: x = 12;
				4'b0111: x = 14;
				4'b1000: x = 16;
				4'b1001: x = 18;
			endcase
		 end
		 
		// Handle the number case
		if ( whichKeyAreWeGetting == 1 && fullCommand == 0 )
		 begin
			if ( playerTurn == PLAYER_ONE )
			 begin
				case( number )
					4'b0001: col = t_t_A1;
					4'b0010: col = t_t_B1;
					4'b0011: col = t_t_C1;
					4'b0100: col = t_t_D1;
					4'b0101: col = t_t_E1;
					4'b0110: col = t_t_F1;
					4'b0111: col = t_t_G1;
					4'b1000: col = t_t_H1;
					4'b1001: col = t_t_I1;
					4'b0000: col = t_t_J1;
				endcase
			 end
			else if ( playerTurn == PLAYER_TWO )
			 begin
				case( number )
					4'b0001: col = t_t_A2;
					4'b0010: col = t_t_B2;
					4'b0011: col = t_t_C2;
					4'b0100: col = t_t_D2;
					4'b0101: col = t_t_E2;
					4'b0110: col = t_t_F2;
					4'b0111: col = t_t_G2;
					4'b1000: col = t_t_H2;
					4'b1001: col = t_t_I2;
					4'b0000: col = t_t_J2;
				endcase
			 end
			
			fullCommand = 1;
		 end
		 
		// Execute the decision
		if ( fullCommand == 1 )
		 begin
			/*if ( playerTurn == PLAYER_ONE )
			 begin
				case( x )
					0: ( ( col[19:18] == 2'b01 ) ? col[19:18] = 2b'11 : col[19:18] = 2b'10 );
				endcase
			 end
			else if ( playerTurn == PLAYER_TWO )
			 begin
				case( x )
					0: ;
				endcase
			 end*/
			
			
			fullCommand = 0;
			whichKeyAreWeGetting = 0;
		 end
	end


always @ ( posedge clock27 )
	begin
		
	end
	
// This is clearly the best way to do this...
assign t_A1 = t_t_A1;
assign t_B1 = t_t_B1;
assign t_C1 = t_t_C1;
assign t_D1 = t_t_D1;
assign t_E1 = t_t_E1;
assign t_F1 = t_t_F1;
assign t_G1 = t_t_G1;
assign t_H1 = t_t_H1;
assign t_I1 = t_t_I1;
assign t_J1 = t_t_J1;
assign t_A2 = t_t_A2;
assign t_B2 = t_t_B2;
assign t_C2 = t_t_C2;
assign t_D2 = t_t_D2;
assign t_E2 = t_t_E2;
assign t_F2 = t_t_F2;
assign t_G2 = t_t_G2;
assign t_H2 = t_t_H2;
assign t_I2 = t_t_I2;
assign t_J2 = t_t_J2;
assign t_OA1 = t_t_OA1;
assign t_OB1 = t_t_OB1;
assign t_OC1 = t_t_OC1;
assign t_OD1 = t_t_OD1;
assign t_OE1 = t_t_OE1;
assign t_OF1 = t_t_OF1;
assign t_OG1 = t_t_OG1;
assign t_OH1 = t_t_OH1;
assign t_OI1 = t_t_OI1;
assign t_OJ1 = t_t_OJ1;
assign t_OA2 = t_t_OA2;
assign t_OB2 = t_t_OB2;
assign t_OC2 = t_t_OC2;
assign t_OD2 = t_t_OD2;
assign t_OE2 = t_t_OE2;
assign t_OF2 = t_t_OF2;
assign t_OG2 = t_t_OG2;
assign t_OH2 = t_t_OH2;
assign t_OI2 = t_t_OI2;
assign t_OJ2 = t_t_OJ2;
endmodule