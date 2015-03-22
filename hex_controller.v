module HEX_CONTROLLER ( 
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

input  [1:0] clock27;
output [6:0] numDisplay0; 
output [6:0] numDisplay1; // The number entered in
output [6:0] numDisplay2; // The letter entered in
output [6:0] numDisplay3; // Which player's turn it is
reg 	 [6:0] t_display0  = 7'b1111111;
reg 	 [6:0] t_display1  = 7'b1111111;
reg 	 [6:0] t_display2  = 7'b1111111;
reg 	 [6:0] t_display3  = 7'b1111111;
input  		 playerTurn;
input  		 keyboardData;
input        letter;
input        number;

always @ ( posedge clock27 )
	begin
		if ( playerTurn == 0 )
		 begin 
			t_display3 = 7'b1111001; // Player 1
		 end
		else
		 begin
			t_display3 = 7'b0100100; // Player 2
		 end 
		 
		case ( letter )
			0: t_display2 = 7'b1000001;
			1: t_display2 = 7'b1010001;
			2: t_display2 = 7'b1000101;
			3: t_display2 = 7'b1000001;
			4: t_display2 = 7'b1100001;
			5: t_display2 = 7'b1000000;
			6: t_display2 = 7'b1000001;
			7: t_display2 = 7'b1001101;
			8: t_display2 = 7'b1110001;
			9: t_display2 = 7'b0011101;
			default: t_display2 = 7'b0000000;
		endcase
		
		case ( number )
			0: t_display1 = 7'b0000001;
			1: t_display1 = 7'b0000010;
			2: t_display1 = 7'b0000100;
			3: t_display1 = 7'b0001000;
			4: t_display1 = 7'b0010000;
			5: t_display1 = 7'b0100000;
			6: t_display1 = 7'b1000000;
			7: t_display1 = 7'b1100000;
			8: t_display1 = 7'b1110000;
			9: t_display1 = 7'b1111000;
			default: t_display1 = 7'b0000000;
		endcase
		
		 
		t_display0 = 7'b1111111;
	end

assign numDisplay0 = t_display0;
assign numDisplay1 = t_display1;
assign numDisplay2 = t_display2;	
assign numDisplay3 = t_display3;

endmodule