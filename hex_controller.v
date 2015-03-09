module HEX_CONTROLLER ( 
		clock27,
 		numDisplay0,
		numDisplay1,
		numDisplay2,
		numDisplay3,
		playerTurn,
		keyboardData
);

input  [1:0] clock27;
output [6:0] numDisplay0; 
output [6:0] numDisplay1; // The number entered in
output [6:0] numDisplay2; // The letter entered in
output [6:0] numDisplay3; // Which player's turn it is
reg 	 [6:0] t_display0;
reg 	 [6:0] t_display1;
reg 	 [6:0] t_display2;
reg 	 [6:0] t_display3;
input  		 playerTurn;
input  		 keyboardData;

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
		t_display0 = 7'b1111111;
		t_display1 = 7'b1111111;
		t_display2 = 7'b1111111;
	end

assign numDisplay0 = t_display0;
assign numDisplay1 = t_display1;
assign numDisplay2 = t_display2;	
assign numDisplay3 = t_display3;

endmodule