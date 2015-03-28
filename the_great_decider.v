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
	number
	);
	
input [1:0] clock27;
input [8:0] keyDataOut;

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

input 		letter;
input 		number;  

reg 			whichKeyAreWeGetting = 0; // 0 - Letter, 1 - Number
reg 			fullCommand = 0;

reg 		 x;
reg [1:0] row;
reg       col;

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
				0: x = 0;
				1: x = 2;
				2: x = 4;
				3: x = 6;
				4: x = 8;
				5: x = 10;
				6: x = 12;
				7: x = 14;
				8: x = 16;
				9: x = 18;
			endcase
		 end
		 
		// Handle the number case
		if ( whichKeyAreWeGetting == 1 && fullCommand == 0 )
		 begin
			case( number )
				1: col = t_A1;
				2: col = t_B1;
				3: col = t_C1;
				4: col = t_D1;
				5: col = t_E1;
				6: col = t_F1;
				7: col = t_G1;
				8: col = t_H1;
				9: col = t_I1;
				0: col = t_J1;
			endcase
			
			fullCommand = 1;
		 end
		 
		// Execute the decision
		if ( fullCommand == 1 )
		 begin
			
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
assign t_OA = t_t_OA1;
assign t_OB = t_t_OB1;
assign t_OC = t_t_OC1;
assign t_OD = t_t_OD1;
assign t_OE = t_t_OE1;
assign t_OF = t_t_OF1;
assign t_OG = t_t_OG1;
assign t_OH = t_t_OH1;
assign t_OI = t_t_OI1;
assign t_OJ = t_t_OJ1;
assign t_OA = t_t_OA2;
assign t_OB = t_t_OB2;
assign t_OC = t_t_OC2;
assign t_OD = t_t_OD2;
assign t_OE = t_t_OE2;
assign t_OF = t_t_OF2;
assign t_OG = t_t_OG2;
assign t_OH = t_t_OH2;
assign t_OI = t_t_OI2;
assign t_OJ = t_t_OJ2;
endmodule