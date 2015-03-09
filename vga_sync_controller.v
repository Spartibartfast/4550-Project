module VGA_SYNC_CONTROLLER( clock50, vga_hor_sync, vga_ver_sync, display, pixel_x, pixel_y );
input        clock50;
output       vga_hor_sync;
output       vga_ver_sync;
output       display;
output [9:0] pixel_x;
output [8:0] pixel_y;
reg    [9:0] pixel_x;
reg    [8:0] pixel_y; 
endmodule 