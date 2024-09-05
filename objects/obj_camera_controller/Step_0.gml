if (keyboard_check_pressed(vk_right)) {
    //var _next_room = (selected_room + 1) mod get_maximum_map();
	if (selected_room + 1 <= get_maximum_map() + 1) {
		selected_room++;
		change_view(selected_room);
	} else {
		selected_room = 0;
		change_view(selected_room);
	}
}

if (keyboard_check_pressed(vk_left)) {
	if (selected_room - 1 > -1) {
		selected_room--;
		change_view(selected_room);
	} else {
		selected_room = get_maximum_map() + 1;
		change_view(selected_room);
	}
}

// Edge Scrolling for Multiple Screens
var scroll_speed = 1;
var border_size = 32;
var room_widths = 840;

// Get current camera position
var cam_x = camera_get_view_x(view_camera[0]);
var cam_y = camera_get_view_y(view_camera[0]);

// Get view dimensions
var view_w = camera_get_view_width(view_camera[0]);
var view_h = camera_get_view_height(view_camera[0]);

// Calculate current screen boundaries
var current_screen_start = (selected_room mod 10) * room_widths;
var current_screen_end = current_screen_start + room_widths;

// Calculate current screen boundaries
var current_screen_start_x = (selected_room mod 10) * room_width;
var current_screen_end_x = current_screen_start_x + room_width;
var current_screen_start_y = floor(selected_room / 10) * room_height;
var current_screen_end_y = current_screen_start_y + room_height;

// Right edge scrolling
if (mouse_x > cam_x + view_w - border_size || keyboard_check(ord("D"))) {
    var new_cam_x = min(cam_x + scroll_speed, current_screen_end - view_w);
    if (new_cam_x != cam_x) {
        cam_x = new_cam_x;
        camera_set_view_pos(view_camera[0], round(cam_x), round(cam_y));
    }
}

// Left edge scrolling
if (mouse_x < cam_x + border_size || keyboard_check(ord("A"))) {
    var new_cam_x = max(cam_x - scroll_speed, current_screen_start);
    if (new_cam_x != cam_x) {
        cam_x = new_cam_x;
        camera_set_view_pos(view_camera[0], round(cam_x), round(cam_y));
    }
}

// Down edge scrolling
if (mouse_y > cam_y + view_h - border_size || keyboard_check(ord("S"))) {
    var new_cam_y = min(cam_y + scroll_speed, current_screen_end_y - view_h);
    if (new_cam_y != cam_y) {
        cam_y = new_cam_y;
        camera_set_view_pos(view_camera[0], round(cam_x), round(cam_y));
    }
}

// Up edge scrolling
if (mouse_y < cam_y + border_size || keyboard_check(ord("W"))) {
    var new_cam_y = max(cam_y - scroll_speed, current_screen_start_y);
    if (new_cam_y != cam_y) {
        cam_y = new_cam_y;
        camera_set_view_pos(view_camera[0], round(cam_x), round(cam_y));
    }
}