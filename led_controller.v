module LED_CONTROLLER ( 
		clock27, 
		led_r, 
		led_g, 
		keyPressed, 
		keyDataOut 
);

reg 		[9:0]  r_led_value = 10'b0000000000;
reg 		[8:0]  g_led_value = 8'b11111111;
input 	[1:0]  clock27;
input 	[1:0]  keyPressed;
input  	[7:0]  keyDataOut;
output 	[9:0]  led_r; // also 9 corresponding led's (red)
output 	[7:0]  led_g; // the other 9 led's 			 (green)

// The positive edge of clock 27 -> 27Hz clock...
always @ ( posedge clock27 )
	begin 
		r_led_value[9:2] = keyDataOut[7:0];
		
		if ( keyPressed <= 0 )
		 begin
			g_led_value = 8'b11111111;
		 end
		else
		 begin
			g_led_value = 8'b00000000;
		 end
	end

// Assign is a continous non-blocking operation...
assign led_r = r_led_value;
assign led_g = g_led_value;

endmodule