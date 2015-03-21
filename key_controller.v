//Keyboard Controller
module KEY_CONTROLLER( 
		clock27, 
		keyboardClock, 
		keyPressed, 
		keyDataOut, 
		keyboardData,
		letter,
		number
);
// For PS/2 keyboard
// PS2_DAT - keyboardData
// PS2_CLK - keyboardClock

// Msgs (11 bits)
// 1 start bit, is always 0
// 8 data bits <- ONLY RETURN THIS!
// 1 parity bit <- checks if number of bits is even or odd. Like a checksum???
//     prolly gonna ignore this one...
// 1 stop bit, is always 1. Hurray.

// Only care about:
// A B C D E F G H I J
// 1 2 3 4 5 6 7 8 9 0
// Much less RAM/ROM/whatever to use up!

// 8'h1c <- hex rep

//   Make Code | Break Code         Make Code | Break Code
// A:   1C         F0,1C       1:      16          F0,16
// B:   32         F0,32       2:      1E	         F0,1E
// C:   21         F0,21       3:      26	         F0,26
// D:   23         F0,23       4:      25	         F0,25
// E:   24         F0,24       5:      2E	         F0,2E
// F:   2B         F0,2B       6:      36	         F0,36
// G:   34         F0,34       7:      3D	         F0,3D
// H:   33         F0,33       8:      3E	         F0,3E
// I:   43         F0,43       9:      46	         F0,46
// J:   3B         F0,3B       0:      45	         F0,45 
// 								Enter: 		5A  			F0,5A

// Translated to:
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

input  		  keyboardClock;
input  [1:0]  clock27;
input  [10:0] keyboardData;
output [1:0]  keyPressed; // If a key (any key) has been pressed. Like an intr
output [8:0]  keyDataOut; 		// The specific key in particular // 8 data bits
output [8:0]  letter;
output [8:0]  number;
reg 	 [8:0]  t_letter;
reg 	 [8:0]  t_number;
reg 	 [1:0]  t_key_press = 1'b0;
reg 	 [8:0]  t_keyDataOut;
reg 	 [10:0] dataReceieved; // [11:0]???
reg 	 [11:0] count_clock = 12'b0;
integer numLetterSelect = 0;

always @ ( posedge clock27 )
	begin
		count_clock = count_clock + 1;
	end

// Negedge for key release
always @ ( negedge keyboardClock )
	begin
		dataReceieved <= 8'h00;
		dataReceieved <= { keyboardData, dataReceieved[8:1] };
		
		// 11 should be the start bit...
		if ( t_keyDataOut[7:1] > 0 )
		 begin
			//numLetterSelect = numLetterSelect + 1;
			t_key_press = 1'b1;
		 end
		else
		 begin
			t_key_press = 1'b0;
		 end
	end
	

always @ ( posedge count_clock[10] )
	begin
		t_keyDataOut <= dataReceieved[8:1];
	end

// Continous non-blocking assignment...
assign letter = t_letter;
assign number = t_number;
assign keyPressed = t_key_press;
assign keyDataOut = t_keyDataOut;

endmodule