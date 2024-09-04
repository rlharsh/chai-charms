display_set_gui_size(640, 360);

initialized = false;

#region Setup fonts.
default_font = noone;

font_database = [
	{
		name: "Carton",
		asset: spr_carton,
		attribution: "https://damieng.com/typography/zx-origins/carton/",
		separation: 3,
		font_ref: -1,
		font_default: true,
	}
];

array_foreach(font_database, function(_font) {
	try {
		_font.font_ref = font_add_sprite_ext(_font.asset, " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~", 1, _font.separation);
		if (_font.font_default) {
			default_font = _font.font_ref;
			set_font(_font.name);
		}
		//write_log(LOG_LEVEL.INFO, "obj_controller_user_interface():create", $"Added font [{_font.name}] to fonts database.");
	} catch (_error) {
		//write_log(LOG_LEVEL.FATAL, "obj_controller_user_interface():create", _error.message);
	}
});
#endregion
