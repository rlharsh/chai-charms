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
var scroll_speed = 2;
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

// Right edge scrolling
if (mouse_x > cam_x + view_w - border_size) {
    var new_cam_x = min(cam_x + scroll_speed, current_screen_end - view_w);
    if (new_cam_x != cam_x) {
        cam_x = new_cam_x;
        camera_set_view_pos(view_camera[0], cam_x, cam_y);
    }
}

// Left edge scrolling
if (mouse_x < cam_x + border_size) {
    var new_cam_x = max(cam_x - scroll_speed, current_screen_start);
    if (new_cam_x != cam_x) {
        cam_x = new_cam_x;
        camera_set_view_pos(view_camera[0], cam_x, cam_y);
    } else if (cam_x <= current_screen_start && selected_room > 0) {
        // Move to previous screen
        //selected_room--;
        //change_view(selected_room);
        // Set camera to the right edge of the new screen
        //cam_x = (selected_room mod 10) * room_widths + room_widths - view_w;
        //camera_set_view_pos(view_camera[0], cam_x, cam_y);
    }
}