#macro CAM view_camera[0]
#macro BASE_WIDTH 480
#macro BASE_HEIGHT 270

current_width = BASE_WIDTH
current_height = BASE_HEIGHT

#macro CENTER_WINDOW alarm[0] = 1
#macro RESIZE_WINDOW alarm[1] = 1

#macro RESIZE_APP_SURFACE surface_resize(application_surface, current_width * sub_pixel_scale, current_height * sub_pixel_scale)

window_scale = 2;
gui_scale = 1;
sub_pixel_scale = window_scale;
is_full_screen = window_get_fullscreen();

RESIZE_APP_SURFACE;
RESIZE_WINDOW;

game_set_speed(60, gamespeed_fps);