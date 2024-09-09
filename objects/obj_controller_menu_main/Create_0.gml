menu_options = new gui_manager_create(0);

// Create groups
var main_menu_group = new gui_group("main_menu", [
    new gui_button(display_get_gui_width() / 2, display_get_gui_height() - 130, "Continue", function() {
        room_goto(rm_menu_select_save_file);
    },,,100,GUI_ALIGN.CENTER),
    new gui_button(display_get_gui_width() / 2, display_get_gui_height() - 110, "New Game", function() {
        menu_options.load_page("options_screen");
	},,,100,GUI_ALIGN.CENTER),
	new gui_button(display_get_gui_width() / 2, display_get_gui_height() - 90, "Load Game", function() {
		menu_options.load_page("options_screen");	
	},,,100,GUI_ALIGN.CENTER),
	new gui_button(display_get_gui_width() / 2, display_get_gui_height() - 70, "Multiplayer", function() {
		
	},,,100,GUI_ALIGN.CENTER),
	new gui_button(display_get_gui_width() / 2, display_get_gui_height() - 50, "Settings", function() {
		url_open("https://discord.gg/6c6rCfGa9P");	
	},,,100,GUI_ALIGN.CENTER),
	new gui_button(display_get_gui_width() / 2, display_get_gui_height() - 30, "Exit", function() {
		game_end(0);	
	},,,100,GUI_ALIGN.CENTER),
]);

var logos = new gui_group("gui_logos", [
	new gui_sprite(display_get_gui_width() - 20, display_get_gui_height() - 20, spr_ui_icons, 0)
]);

menu_options.add_persistent_group(logos);

var hud_group = new gui_group("hud", [
    // Add HUD elements here
]);

var map_group = new gui_group("map", [
    // Add map elements here
]);

// Add pages with groups
menu_options.add_page("main_screen", [main_menu_group, hud_group]);

menu_options.add_page("options_screen", [
    new gui_group("options", [
			new gui_button(4, display_get_gui_height() - 90, "Controls", function() {
			menu_options.load_page("main_menu");
		}),
		new gui_button(4, display_get_gui_height() - 70, "Audio", function() {
			menu_options.load_page("options_audio");
		}),
		new gui_button(4, display_get_gui_height() - 50, "Video", function() {
			menu_options.load_page("options_video");
		}),
		new gui_button(4, display_get_gui_height() - 30, "Back", function() {
			menu_options.load_page("main_screen");
		}),
    ])
]);

menu_options.add_page("options_audio", [
	new gui_group("audio", [
		new gui_label(4, display_get_gui_height() - 50, "Music Volume"),
		new gui_label(4, display_get_gui_height() - 70, "Ambient Volume"),
		new gui_label(4, display_get_gui_height() - 90, "Sound Volume"),
		new gui_selector(140, display_get_gui_height() - 54, "Music Volume", get_zero_to_one_hundred(), function(_val) {
			configuration_update_value("audio.music_volume", _val / 100);
		}, configuration_get_value("audio.music_volume") * 100),
		new gui_selector(140, display_get_gui_height() - 74, "Ambient Volume", get_zero_to_one_hundred(), function(_val) {
			configuration_update_value("audio.ambient_volume", _val / 100);
		}, configuration_get_value("audio.ambient_volume") * 100),
		new gui_selector(140, display_get_gui_height() - 94, "Sound Volume", get_zero_to_one_hundred(), function(_val) {
			configuration_update_value("audio.sound_volume", _val / 100);
		}, configuration_get_value("audio.sound_volume") * 100),
		new gui_button(4, display_get_gui_height() - 30, "Back", function() {
			menu_options.load_page("options_screen");
		}),
	])
]);

menu_options.add_page("options_video", [
	new gui_group("video", [
		new gui_button(4, display_get_gui_height() - 30, "Back", function() {
				menu_options.load_page("options_screen");
		}),
		new gui_label(4, display_get_gui_height() - 50, "Fullscreen"),
		new gui_label(4, display_get_gui_height() - 70, "Aspect Ratio"),
		new gui_selector(140, display_get_gui_height() - 54, "Fullscreen", ["False", "True"], function(_val) {
			configuration_update_value("video.fullscreen", _val);
		}, configuration_get_value("video.fullscreen")),
		new gui_selector(140, display_get_gui_height() - 74, "Aspect", ["16x9", "21x9", "1x1", "4x3", "9x16"], function(_val) {
			configuration_update_value("video.aspect_ratio", _val);
		}, configuration_get_value("video.aspect_ratio")),
	])
]);


menu_options.load_page("main_screen");