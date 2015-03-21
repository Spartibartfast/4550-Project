/* The Great Decider will take in keyboard input, 
who's player turn it is, and the players board
*/
module THE_GREAT_DECIDER ( 
	clock27,
	A, B, C, D, E, F, G, H, I, J,
	OA, OB, OC, OD, OE, OF, OG, OH, OI, OJ,
	keyDataOut,
	letter,
	number
	);
	
input [1:0] clock27;
input [8:0] keyDataOut;

// Take it in and push it out
inout [19:0] A;
inout [19:0] B; 
inout [19:0] C; 
inout [19:0] D; 
inout [19:0] E; 
inout [19:0] F; 
inout [19:0] G; 
inout [19:0] H; 
inout [19:0] I; 
inout [19:0] J;

inout [19:0] OA;
inout [19:0] OB; 
inout [19:0] OC; 
inout [19:0] OD; 
inout [19:0] OE; 
inout [19:0] OF; 
inout [19:0] OG; 
inout [19:0] OH; 
inout [19:0] OI; 
inout [19:0] OJ;

inout [8:0] letter;
inout [8:0] number;  

reg 			whichKeyAreWeGetting = 0; // 0 - Letter, 1 - Number
reg   [8:0] letter;
reg   [8:0] number;

always @ ( posedge clock27 )
	begin
		// Handle the letter case
		if ( whichKeyAreWeGetting == 0 )
		 begin
			
		 end
	end

	
endmodule