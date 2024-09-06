/// @description resize_window && app surface (when not in fullscreen)
surface_resize(application_surface,
							 round(current_width*sub_pixel_scale),
							 round(current_height*sub_pixel_scale));
display_set_gui_size(round(current_width*gui_scale),
									   round(current_height*gui_scale));

if(!window_get_fullscreen())
{	//We aren't in full screen, 
	window_set_size(current_width*window_scale,current_height*window_scale);
	CENTER_WINDOW;
}

// ui_element_update_positions();