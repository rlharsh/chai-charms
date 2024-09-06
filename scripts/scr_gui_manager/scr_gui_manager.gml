// Feather disable GM2017
/// @desc Creates a new instance of the GUI manager.
/// @param {real} [_player_index]=0 The player allowed to control the given menu.
function gui_manager_create(_player_index = 0) constructor {
	
	pages = {};
	current_page = "";
	cursor_instance = -1;
	
	if (instance_exists(obj_cursor)) {
		with(obj_cursor) {
			if (player_index == _player_index) {
				other.cursor_instance = id;
			}
		}
	}
	
	if (cursor_instance == -1) {
		cursor_instance = instance_create_depth(0, 0, -9999, obj_cursor, { player_index: _player_index});
	}
	
	add_group = function(_name, _groups = []) {
		
	}
	
	add_page = function(_name, _groups = []) {
		if (!variable_struct_exists(pages, _name)) {
			pages[$ _name] = _groups;
			if (current_page == "") {
				current_page = _name;	
			}
		} else {
			show_debug_message("Page " + _name + " already exists.");	
		}
	}
	
	load_page = function(_name) {
		if (variable_struct_exists(pages, _name)) {
			current_page = _name;	
		} else {
			show_debug_message("Page " + _name + " does not exist.");	
		}
	}
	
	draw = function() {
		if (current_page != "") {
			var current_groups = pages[$ current_page];	
			for (var _i = 0; _i < array_length(current_groups); _i++) {
				current_groups[_i].draw();	
			}
		}
	}
	
	step = function() {
		if (current_page != "") {
			var current_groups = pages[$ current_page];
			for (var _i = 0; _i < array_length(current_groups); _i++) {
				current_groups[_i].step();	
			}
		}
	}
}

function gui_button(_x, _y, _text, _callback = undefined, _sprite_index = spr_ui_button_default, _height = -1, _width = -1) constructor {
	text = _text;
	xx = _x;
	yy = _y;
	callback = _callback;
	width = (_width == -1) ? string_width(_text) + 8: _width;
	height = (_height == -1) ? string_height(_text) + 8 : _height;
	s_index = _sprite_index;
	
	draw = function() {
		
	    var i_index = (point_in_rectangle(input_cursor_x(0), input_cursor_y(0), xx, yy, xx + width, yy + height)) ? 1 : 0;
		var colour = (point_in_rectangle(input_cursor_x(0), input_cursor_y(0), xx, yy, xx + width, yy + height)) ? c_white : make_color_rgb(58, 32, 50);
		
		draw_sprite_stretched(s_index, i_index, xx, yy, width, height);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(colour);
		draw_text(xx + width / 2, yy + height / 2, text);
		draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
	
	step = function() {
		if (point_in_rectangle(input_cursor_x(0), input_cursor_y(0), xx, yy, xx + width, yy + height) && (input_check_pressed("action") || input_mouse_check_pressed(mb_left))) {
			if (callback != undefined) {
				if (is_method(callback)) {
					callback();
				}
			}
		}
	}
}