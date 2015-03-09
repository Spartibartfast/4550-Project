//Keyboard Controller
module KEY_CONTROLLER( 
		clock27, 
		keyboardClock, 
		keyPressed, 
		keyDataOut, 
		keyboardData 
);
// For PS/2 keyboard
// PS2_DAT - keyboardData
// PS2_CLK - keyboardClock

// Msgs (11 bits)
// 1 start bit, is always 0
// 8 data bits <- ONLY RETURN THIS!
// 1 parity bit <- checks if number of bits is even or odd. Like a checksum???
//     prolly gonna ignore this one...
// 1 stop bit, is always 1

// Only care about:
// A B C D E F G H I J
// 1 2 3 4 5 6 7 8 9 0
// Much less RAM/ROM/whatever to use up!
// Actually I don't think I am even going to translate them to ascii... 
// only if I have free time at the end... (hah). Hopefully this doesn't
// come back to bite me.

// 'h 1c <- hex rep

//   Make Code | Break Code         Make Code | Break Code
// A:   1C         F0,1C       1:      16          F0,16
// B:   32         F0,32       2:      1E	         F0,1E
// C:   21         F0,32       3:      26	         F0,26
// D:   32         F0,32       4:      25	         F0,25
// E:   24         F0,24       5:      2E	         F0,2E
// F:   2B         F0,2B       6:      36	         F0,36
// G:   34         F0,34       7:      3D	         F0,3D
// H:   33         F0,33       8:      3E	         F0,3E
// I:   43         F0,43       9:      46	         F0,46
// J:   3B         F0,3B       0:      45	         F0,45 
// 								Enter: 		5A  			F0,5A

input  keyboardClock;
input  [1:0]  clock27;
input  [11:0] keyboardData;
output [1:0]  keyPressed; // If a key (any key) has been pressed. Like an intr
output [7:0]  keyDataOut; 		// The specific key in particular // 8 data bits
reg 	 [1:0]  t_key_press = 1'b0;
reg 	 [8:0]  t_keyDataOut;
reg 	 [8:0]  dataReceieved = 8'b0; // [11:0]???
reg 	 [20:0] timer_count = 21'b0;

always @ ( posedge clock27 )
	begin 
		timer_count <= timer_count+1'b1;
	end
	
always @ ( posedge timer_count[20] )
	begin
		
	end

// Negedge for key release
always @ ( negedge keyboardClock )
	begin
		//assign key = keyboardData;
		//dataReceieved <= keyboardData[7:0];
		//t_keyDataOut = dataReceieved;
		t_keyDataOut <= keyboardData[7:0];
		
		// 11 should be the start bit...
		if ( /*dataReceieved*/t_keyDataOut > 0 )
		 begin
			t_key_press = 1'b1;
		 end
		else
		 begin
			t_key_press = 1'b0;
		 end

	end
	
/*always begin
		
	end*/

// Continous non-blocking assignment...
assign keyPressed = t_key_press;
assign keyDataOut = t_keyDataOut;

endmodule