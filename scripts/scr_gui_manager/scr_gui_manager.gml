enum GUI_ALIGN {
    LEFT,
    CENTER,
    RIGHT
}

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
	
	if (_default_value != undefined) {
		selected_index = _default_value;	
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

function gui_scrollable_list(_x, _y, _width, _height, _item_height, _items = []) constructor {
    xx = _x;
    yy = _y;
    width = _width;
    height = _height;
    item_height = _item_height;
    items = _items;
    
    visible_items = floor(height / item_height);
    max_scroll = max(0, array_length(items) - visible_items);
    
    slider = new gui_vertical_slider(xx + width - 20, yy, height, 0, max_scroll, 0, function(_value) {
        scroll_position = _value;
    });
    
    scroll_position = 0;
    
    x_percent = _x / display_get_gui_width();
    y_percent = _y / display_get_gui_height();
    
    surface = -1;
    
    update_position = function() {
        xx = x_percent * display_get_gui_width();
        yy = y_percent * display_get_gui_height();
        slider.xx = xx + width - 20;
        slider.yy = yy;
        slider.update_position();
    }
    
    add_item = function(_item) {
        array_push(items, _item);
        max_scroll = max(0, array_length(items) - visible_items);
        slider.max_value = max_scroll;
    }
    
    remove_item = function(_index) {
        if (_index >= 0 && _index < array_length(items)) {
            array_delete(items, _index, 1);
            max_scroll = max(0, array_length(items) - visible_items);
            slider.max_value = max_scroll;
            scroll_position = min(scroll_position, max_scroll);
        }
    }
    
    draw = function() {
        // Create or recreate surface if needed
        if (!surface_exists(surface)) {
            surface = surface_create(width, height);
        }
        
        // Draw items to surface
        surface_set_target(surface);
        draw_clear_alpha(c_black, 0);
        
        var start_index = floor(scroll_position);
        var end_index = min(start_index + visible_items + 1, array_length(items));
        
        for (var i = start_index; i < end_index; i++) {
            var item_y = (i - start_index) * item_height - (scroll_position - floor(scroll_position)) * item_height;
            draw_set_color(c_white);
            draw_rectangle(0, item_y, width - 22, item_y + item_height - 1, true);
            
            draw_set_color(c_black);
            draw_set_valign(fa_middle);
            draw_text(5, item_y + item_height / 2, items[i]);
            draw_set_valign(fa_top);
            draw_set_color(c_white);
        }
        
        surface_reset_target();
        
        // Draw surface
        draw_surface(surface, xx, yy);
        
        // Draw slider
        slider.draw();
    }
    
    step = function() {
        slider.step();
        
        // Mouse wheel scrolling
        var wheel = mouse_wheel_down() - mouse_wheel_up();
        if (wheel != 0 && point_in_rectangle(input_cursor_x(0), input_cursor_y(0), xx, yy, xx + width, yy + height)) {
            scroll_position = clamp(scroll_position + wheel, 0, max_scroll);
            slider.current_value = scroll_position;
        }
        
        // Click handling for items
        if (input_mouse_check_pressed(mb_left)) {
            var mx = input_cursor_x(0);
            var my = input_cursor_y(0);
            if (point_in_rectangle(mx, my, xx, yy, xx + width - 22, yy + height)) {
                var clicked_index = floor((my - yy) / item_height) + floor(scroll_position);
                if (clicked_index >= 0 && clicked_index < array_length(items)) {
                    // Handle item click (e.g., load save file)
                    show_debug_message("Clicked item: " + string(items[clicked_index]));
                }
            }
        }
    }
    
    // Clean up surface when destroying the instance
    clean_up = function() {
        if (surface_exists(surface)) {
            surface_free(surface);
        }
    }
}

function gui_vertical_slider(_x, _y, _height, _min_value, _max_value, _default_value, _callback = undefined) constructor {
    xx = _x;
    yy = _y;
    height = _height;
    min_value = _min_value;
    max_value = _max_value;
    current_value = _default_value;
    callback = _callback;
    
    thumb_sprite = spr_control_slider_thumb_vertical;
    thumb_width = sprite_get_width(thumb_sprite);
    thumb_height = sprite_get_height(thumb_sprite);
    
    slider_width = thumb_width;
    
    dragging = false;
    
    x_percent = _x / display_get_gui_width();
    y_percent = _y / display_get_gui_height();
    
    update_position = function() {
        xx = x_percent * display_get_gui_width();
        yy = y_percent * display_get_gui_height();
    }
    
    get_thumb_y = function() {
        var value_range = max_value - min_value;
        var position_range = height - thumb_height;
        var relative_value = current_value - min_value;
        return yy + position_range - (relative_value / value_range) * position_range;
    }
    
    set_value_from_y = function(_y) {
        var position_range = height - thumb_height;
        var relative_y = _y - (yy + thumb_height / 2);
        var clamped_y = clamp(relative_y, 0, position_range);
        var value_range = max_value - min_value;
        current_value = max_value - (clamped_y / position_range) * value_range;
        current_value = clamp(current_value, min_value, max_value);
        
        if (is_method(callback)) {
            callback(current_value);
        }
    }
    
    draw = function() {
        // Draw slider background
        draw_set_color(c_dkgray);
        draw_rectangle(xx, yy, xx + slider_width, yy + height, false);
        
        // Draw thumb
        var thumb_y = get_thumb_y();
        draw_sprite(thumb_sprite, 0, xx, thumb_y);
        
        // Draw current value
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text(xx + slider_width + 5, yy, string(round(current_value)));
    }
    
    step = function() {
        var _mouse_x = input_cursor_x(0);
        var _mouse_y = input_cursor_y(0);
        var thumb_y = get_thumb_y();
        
        if (point_in_rectangle(_mouse_x, _mouse_y, xx, thumb_y, xx + thumb_width, thumb_y + thumb_height) && input_mouse_check_pressed(mb_left)) {
            dragging = true;
        }
        
        if (dragging) {
            set_value_from_y(_mouse_y);
            
            if (!input_mouse_check(mb_left)) {
                dragging = false;
            }
        }
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
		draw_sprite(s_index, i_index, round(xx), round(yy));
	}
	
	step = function() {
		
	}
}

function gui_sprite_stretched(_x, _y, _sprite_index, _image_index, _width, _height) constructor {
	xx = _x;
	yy = _y;
	s_index = _sprite_index;
	i_index = _image_index;
	width = _width;
	height = _height;
	
	x_percent = _x / display_get_gui_width();
    y_percent = _y / display_get_gui_height();
	
    update_position = function() {
        xx = x_percent * display_get_gui_width();
        yy = y_percent * display_get_gui_height();
    }
	
	draw = function() {
		draw_sprite_stretched(s_index, i_index, round(xx), round(yy), round(width), round(height));
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
		draw_set_color(c_black);
		draw_text(xx, yy, text);
		draw_set_color(c_white);
	}
	
	step = function() {
		
	}
}

function gui_label_shadow(_x, _y, _text, _centered = false) constructor {
	xx = _x;
	yy = _y;
	text = _text;
	centered = _centered;
	
	x_percent = _x / display_get_gui_width();
	y_percent = _y / display_get_gui_height();
	
	update_position = function() {
		xx = x_percent * display_get_gui_width();
		yy = y_percent * display_get_gui_height();
	}
	
	draw = function() {
		if (centered) {
			draw_set_halign(fa_center);	
		}
		draw_set_color(c_black);
		draw_text_shadow(round(xx), round(yy), text, c_black);
		draw_set_color(c_white);
		draw_set_halign(fa_left);
	}
	
	step = function() {
		
	}
}

function gui_save_file_manager(_x, _y, _width, _height, _callback = undefined) constructor {
	xx = _x;
	yy = _y;
	callback = _callback;
	height = _height;
	width = _width;
	
	x_percent = _x / display_get_gui_width();
    y_percent = _y / display_get_gui_height();
	
    update_position = function() {
        xx = x_percent * display_get_gui_width();
        yy = y_percent * display_get_gui_height();
    }
	
	draw = function() {
		draw_sprite_stretched(spr_panel_default, 0, xx, yy, width, height);
	}
	
	step = function() {
		
	}
}

function gui_icon_button(_x, _y, _callback = undefined, _sprite_index = undefined, _image_index = 0) constructor {
	xx = _x;
	yy = _y;
	callback = _callback;
	s_index = _sprite_index;
	i_index = _image_index;
	
	x_percent = _x / display_get_gui_width();
    y_percent = _y / display_get_gui_height();
	
    update_position = function() {
        xx = x_percent * display_get_gui_width();
        yy = y_percent * display_get_gui_height();
    }
	
	step = function() {
		
	}
	
	draw = function() {
		draw_sprite(s_index, i_index, xx, yy);
	}
}

function gui_button(_x, _y, _text, _callback = undefined, _image_index = spr_ui_button_default, _height = -1, _width = -1, _align = GUI_ALIGN.LEFT) constructor {
	text = _text;
    xx = _x;
    yy = _y;
    callback = _callback;
    width = (_width == -1) ? string_width(_text) + 8 : _width;
    height = (_height == -1) ? string_height(_text) + 8 : _height;
    s_index = _image_index;
    align = _align;
    
    x_percent = _x / display_get_gui_width();
    y_percent = _y / display_get_gui_height();
    
    update_position = function() {
        //xx = x_percent * display_get_gui_width();
        //yy = y_percent * display_get_gui_height();
    }
    
    // Adjust x position based on alignment
    switch (align) {
        case GUI_ALIGN.CENTER:
            xx -= width / 2;
            break;
        case GUI_ALIGN.RIGHT:
            xx -= width * 2;
            break;
    }
    
    draw = function() {
        var i_index = (point_in_rectangle(input_cursor_x(0), input_cursor_y(0), xx, yy, xx + width, yy + height)) ? 1 : 0;
        var colour = (point_in_rectangle(input_cursor_x(0), input_cursor_y(0), xx, yy, xx + width, yy + height)) ? c_white : make_color_rgb(181, 108, 78);
        
        draw_sprite_stretched(s_index, i_index, round(xx), round(yy), width, height);
        
		draw_set_halign(fa_center);
		draw_text_shadow(round(xx + width / 2), round(yy + sprite_get_height(s_index) / 4), text);
        draw_set_halign(fa_left);
		
        draw_set_valign(fa_middle);
        draw_set_color(colour);
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
