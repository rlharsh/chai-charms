/// @description Zoom GUI / Detectc Fullscreen Switch
var _full=window_get_fullscreen();
if(is_full_screen != _full)
{
	//instance_create_depth(0,0,-1000,obj_screen_fade);
	is_full_screen=_full;
	if(!is_full_screen)
	{
		RESIZE_WINDOW;
	}
}

if (keyboard_check_pressed(vk_enter)) {
	set_aspect(Aspects._21x9);	
}

if (keyboard_check_pressed(vk_space)) {
	set_aspect(Aspects._16x9);	
}

if (keyboard_check_pressed(vk_tab)) {
	window_set_fullscreen(!window_get_fullscreen());	
}


if(!mouse_wheel_up() && !mouse_wheel_down()) exit;

gui_scale+=(mouse_wheel_down()-mouse_wheel_up())*.25;
gui_scale=clamp(gui_scale,1,window_scale);

display_set_gui_size(current_width*gui_scale,
									   current_height*gui_scale);



