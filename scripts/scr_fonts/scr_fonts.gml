#macro COLOUR_BLACK make_color_rgb(19, 19, 39)


/// @desc Sets the currently displayed font via the font title.
/// @param {string} _font_name The name of the font to be located.
function set_font(_font_name) {
	if (instance_exists(obj_controller_gui)) {
		var _font_controller = obj_controller_gui;
		var _font_array_length = array_length(obj_controller_gui.font_database);
		
		for (var _i = 0; _i < _font_array_length; _i++) {
			if (_font_controller.font_database[_i].name == _font_name) {
				_font_controller.default_font = _font_controller.font_database[_i];
				draw_set_font(_font_controller.default_font.font_ref);
			}
		}
	}
}

/// @desc  Draws text with an outline.
/// @param {real} _x The x position to draw the text.
/// @param {real} _y The y position to draw the text.
/// @param {string} _text The text to be drawn to the screen.
/// @param {color} [_color]=c_white The color of the inside text.
/// @param {real} [_scale]=1 The scale of the text to be drawn.
/// @param {real} [_rotation]=0 The rotation of the text to be drawn.
/// @param {color} [_outline_color]=c_black The color of the outline.
/// @param {real} [_outline_width]=1 The width of the outline.
/// @param {real} [_outline_quality]=4 The quality of the outline (number of iterations).
function draw_text_outline(_x, _y, _text, _color = c_white, _scale = 1, _rotation = 0, _outline_color = COLOUR_BLACK, _outline_width = 1, _outline_quality = 4) {
    var _angle_step = 360 / _outline_quality;
    var _prev_color = draw_get_color();
    var _prev_alpha = draw_get_alpha();
    
    // Draw the outline
    draw_set_color(_outline_color);
    draw_set_alpha(draw_get_alpha());
    for (var _i = 0; _i < _outline_quality; _i++) {
        var _angle = _i * _angle_step;
        var _offset_x = lengthdir_x(_outline_width, _angle) * _scale;
        var _offset_y = lengthdir_y(_outline_width, _angle) * _scale;
        draw_text_transformed(round(_x + _offset_x), round(_y + _offset_y), _text, _scale, _scale, _rotation);
    }
    
    // Draw the main text
    draw_set_color(_color);
    draw_text_transformed(round(_x), round(_y), _text, _scale, _scale, _rotation);
    
    // Reset draw color and alpha
    draw_set_color(_prev_color);
    draw_set_alpha(_prev_alpha);
}

function draw_text_shadow(_x, _y, _text, _color = c_white, _scale = 1) {
	
}