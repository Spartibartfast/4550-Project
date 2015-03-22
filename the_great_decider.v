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

inout [19:0] t_A1;
inout [19:0] t_B1; 
inout [19:0] t_C1; 
inout [19:0] t_D1; 
inout [19:0] t_E1; 
inout [19:0] t_F1; 
inout [19:0] t_G1; 
inout [19:0] t_H1; 
inout [19:0] t_I1; 
inout [19:0] t_J1;

inout [19:0] t_OA1;
inout [19:0] t_OB1; 
inout [19:0] t_OC1;
inout [19:0] t_OD1;
inout [19:0] t_OE1;
inout [19:0] t_OF1; 
inout [19:0] t_OG1; 
inout [19:0] t_OH1; 
inout [19:0] t_OI1; 
inout [19:0] t_OJ1;

inout [19:0] t_A2;
inout [19:0] t_B2; 
inout [19:0] t_C2; 
inout [19:0] t_D2; 
inout [19:0] t_E2; 
inout [19:0] t_F2; 
inout [19:0] t_G2; 
inout [19:0] t_H2; 
inout [19:0] t_I2; 
inout [19:0] t_J2;  

inout [19:0] t_OA2;
inout [19:0] t_OB2; 
inout [19:0] t_OC2; 
inout [19:0] t_OD2; 
inout [19:0] t_OE2; 
inout [19:0] t_OF2; 
inout [19:0] t_OG2; 
inout [19:0] t_OH2; 
inout [19:0] t_OI2; 
inout [19:0] t_OJ2;

input 		letter;
input 		number;  

reg 			whichKeyAreWeGetting = 0; // 0 - Letter, 1 - Number
reg 			fullCommand = 0;

reg 		 x;
reg [1:0] row;
reg       col;


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
	
	
endmodule