Battleship Project
By: 

So I got the LED's, and the HEX display working pretty well. I can read in keyboard data and display it to the LED's.
The Keyboard is a bit jumpy at the moment, I have to stabilize that somehow ( probably going to use hysteresis or something on it ). I am also not doing any error checking right now (parity bit) so I might try to implement that in the future to see if that makes it more responsive.

VGA is drawing stuff to the screen, it's nothing what I want it to draw yet, but there are colours.
The vsync and hsync are out of whack, I'll have to figure out what is wrong with that and fix it. The h and v sync cause a lot of drifting bars and jumping that hurts your eyes if you look at it for a while...

This originally started as an Amtel Project, but switched over to FPGA.

Also, I had trouble assigning the pins on my personal project, so I stole the .qsf from a sample project and modified it to suit my variables. Something about the pins being auto assigned but Quartus II wasn't actually auto signing them... So there are a lot of useless pins signed out right now which are causing a tonne of errors. It's the lowest priority for me right now but I'll fix it yet maybe...

That should be all.

The FGPA board takes in the Keyboard Data, letters A B C D E F G H I J and numbers 1 2 3 4 5 6 7 8 9 0 ( 0 -> 10)
The Enter Button is supposed to change the player number, and it works mostly. However, you have to use Switch 0 to change the player board at the moment. This is mostly for debugging purposes, since the Enter Button is jumpy...

VGA runs at 800x600x60Hz.