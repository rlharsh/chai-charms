// Feather disable GM2017
/// @desc Creates a new instance of the GUI manager.
/// @param {real} [_player_index]=0 The player allowed to control the given menu.
function gui_manager_create(_player_index = 0) constructor {
	
	pages = {};
	persistent_groups = [];
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
	
	add_group_to_page = function(_page_name, _group = []) {
		if (variable_struct_exists(pages, _page_name)) {
			array_push(pages[$ _page_name], _group);
		} else {
			show_debug_message("Page " + _page_name + " does not exist.");	
		}
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
	
	add_persistent_group = function(_group) {
		array_push(persistent_groups, _group);	
	}
	
	load_page = function(_name) {
		if (variable_struct_exists(pages, _name)) {
			current_page = _name;	
		} else {
			show_debug_message("Page " + _name + " does not exist.");	
		}
	}
	
	update_positions = function() {
		
		for (var _i = 0; _i < array_length(persistent_groups); _i++) {
			persistent_groups[_i].update_positions();	
		}
		
		if (current_page != "") {
			var current_groups = pages[$ current_page];
			for (var _i = 0; _i < array_length(current_groups); _i++) {
				current_groups[_i].update_positions();	
			}
		}
	}
	
	draw = function() {
		for (var _i = 0; _i < array_length(persistent_groups); _i++) {
			persistent_groups[_i].draw();	
		}
		
		if (current_page != "") {
			var current_groups = pages[$ current_page];
			for (var _i = 0; _i < array_length(current_groups); _i++) {
				current_groups[_i].draw();	
			}
		}
	}
	
	step = function() {
		update_positions();
		
		for (var _i = 0; _i < array_length(persistent_groups); _i++) {
			persistent_groups[_i].step();	
		}
		
		if (current_page != "") {
			var current_groups = pages[$ current_page];
			for (var _i = 0; _i < array_length(current_groups); _i++) {
				current_groups[_i].step();	
			}
		}
	}
}

function gui_group(_name, _elements = []) constructor {
	name = _name;
	elements = _elements;
	
	add_element = function(_element) {
		array_push(elements, _element);	
	}
	
	update_positions = function() {
		for (var _i = 0; _i < array_length(elements); _i++) {
			if (variable_struct_exists(elements[_i], "update_position")) {
				elements[_i].update_position();	
			}
		}
	}
	
	draw = function() {
		for (var _i = 0; _i < array_length(elements); _i++) {
			elements[_i].draw();	
		}
	}
	
	step = function() {
		for (var _i = 0; _i < array_length(elements); _i++) {
			elements[_i].step();	
		}
	}
}

function gui_selector(_x, _y, _title = "", _options = [], _callback = undefined, _default_value = 0) constructor {
	xx = _x;
	yy = _y;
	options = _options;
	callback = _callback;
	selected_index = 0;
	default_value = _default_value;
	
	_s_width = string_width("superdaddy");
	_t_width = 32 + 4 + _s_width;
	
    if (_default_value != undefined) {
        for (var i = 0; i < array_length(options); i++) {
            if (options[i] == _default_value) {
                selected_index = i;
                break;
            }
        }
    }
	
	left_button = new gui_button(xx, yy, " -", function() {
		if (selected_index - 1 > -1) {
			selected_index--;
		} else {
			selected_index = array_length(options) - 1;		
		}
		if (is_method(callback)) {
			callback(selected_index);
		}
	},,16, 16);
	right_button = new gui_button(xx + _s_width + 4, yy, " +", function() {
		if (selected_index + 1 < array_length(options)) {
			selected_index++;
		} else {
			selected_index = 0;	
		}
		if (is_method(callback)) {
			callback(selected_index);	
		}
	},,16,16);
	
	draw = function() {
		left_button.draw();
		right_button.draw();
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text(round(xx + _t_width / 2), round(yy + 8), options[selected_index]);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
	
	step = function() {
		left_button.step();
		right_button.step();
	}
}

function gui_sprite(_x, _y, _sprite_index, _image_index) constructor {
	xx = _x;
	yy = _y;
	s_index = _sprite_index;
	i_index = _image_index;
	
	x_percent = _x / display_get_gui_width();
    y_percent = _y / display_get_gui_height();
	
    update_position = function() {
        xx = x_percent * display_get_gui_width();
        yy = y_percent * display_get_gui_height();
    }
	
	draw = function() {
		draw_sprite(s_index, i_index, xx, yy);
	}
	
	step = function() {
		
	}
}

function gui_label(_x, _y, _text) constructor {
	xx = _x;
	yy = _y;
	text = _text;
	
	x_percent = _x / display_get_gui_width();
	y_percent = _y / display_get_gui_height();
	
	update_position = function() {
		xx = x_percent * display_get_gui_width();
		yy = y_percent * display_get_gui_height();
	}
	
	draw = function() {
		draw_text(xx, yy, text);
	}
	
	step = function() {
		
	}
}

function gui_button(_x, _y, _text, _callback = undefined, _sprite_index = spr_ui_button_default, _height = -1, _width = -1, _centered = false) constructor {
	text = _text;
	xx = _x;
	yy = _y;
	callback = _callback;
	width = (_width == -1) ? string_width(_text) + 8: _width;
	height = (_height == -1) ? string_height(_text) + 8 : _height;
	s_index = _sprite_index;
	centered = _centered;
	
	x_percent = _x / display_get_gui_width();
    y_percent = _y / display_get_gui_height();
	
    update_position = function() {
        xx = x_percent * display_get_gui_width();
        yy = y_percent * display_get_gui_height();
    }
	
	if (centered) {
		xx -= width / 2;	
	}
	
	draw = function() {
		
	    var i_index = (point_in_rectangle(input_cursor_x(0), input_cursor_y(0), xx, yy, xx + width, yy + height)) ? 1 : 0;
		var colour = (point_in_rectangle(input_cursor_x(0), input_cursor_y(0), xx, yy, xx + width, yy + height)) ? c_white : make_color_rgb(181, 108, 78);
		
		draw_sprite_stretched(s_index, i_index, round(xx), round(yy), width, height);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(colour);
		draw_text(round(xx + width / 2), round(yy + height / 2), text);
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

function get_zero_to_one_hundred() {
    var _new_array = [];
    
    for (var _i = 0; _i <= 100; _i += 1) {
        array_push(_new_array, _i);
    }
    
    return _new_array;
}
