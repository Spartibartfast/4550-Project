module LED_CONTROLLER ( 
		clock27, 
		led_r, 
		led_g, 
		keyPressed, 
		keyDataOut,
	   letter,
		number
);

reg 		[9:0]  r_led_value = 10'b0000000000;
reg 		[8:0]  g_led_value = 8'b11111111;
input 	[1:0]  clock27;
input 	[1:0]  keyPressed;
input  	[8:0]  keyDataOut;
input    [7:0]  letter;
input    [7:0]  number;
output 	[9:0]  led_r; // also 9 corresponding led's (red)
output 	[7:0]  led_g; // the other 9 led's 			 (green)

// The positive edge of clock 27 -> 27Hz clock...
always @ ( posedge clock27 )
	begin 		
		if (  keyDataOut == 8'h1C || // A
				keyDataOut == 8'h32 || // B
				keyDataOut == 8'h21 || // C
				keyDataOut == 8'h23 || // D
				keyDataOut == 8'h24 || // E
				keyDataOut == 8'h2B || // F
				keyDataOut == 8'h34 || // G
				keyDataOut == 8'h33 || // H 
				keyDataOut == 8'h43 || // I 
				keyDataOut == 8'h3B || // J
				keyDataOut == 8'h16 || // 1
				keyDataOut == 8'h1E || // 2
				keyDataOut == 8'h26 || // 3
				keyDataOut == 8'h25 || // 4
				keyDataOut == 8'h2E || // 5
				keyDataOut == 8'h36 || // 6
				keyDataOut == 8'h3D || // 7
				keyDataOut == 8'h3E || // 8
				keyDataOut == 8'h46 || // 9
				keyDataOut == 8'h45 )  // 0 -> 10
		 begin
			r_led_value = keyDataOut[7:0];
		 end
	end

// Assign is a continous non-blocking operation...
assign led_r = r_led_value;
assign led_g = g_led_value ;

endmodule