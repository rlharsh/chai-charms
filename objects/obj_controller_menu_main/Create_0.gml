menu_options = new gui_manager_create(0);

// Create groups
var main_menu_group = new gui_group("main_menu", [
    new gui_button(4, display_get_gui_height() - 130, "Start Game", function() {
        // Play game logic
    }),
    new gui_button(4, display_get_gui_height() - 110, "Join Game", function() {
        menu_options.load_page("options_screen");
	}),
	new gui_button(4, display_get_gui_height() - 90, "Settings", function() {
		menu_options.load_page("options_screen");	
	}),
	new gui_button(4, display_get_gui_height() - 70, "MODS"),
	new gui_button(4, display_get_gui_height() - 50, "Discord", function() {
		url_open("https://discord.gg/6c6rCfGa9P");	
	}),
	new gui_button(4, display_get_gui_height() - 30, "Quit", function() {
		game_end(0);	
	}),
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
			menu_options.load_page("main_menu");
		}),
		new gui_button(4, display_get_gui_height() - 50, "Video", function() {
			menu_options.load_page("main_menu");
		}),
		new gui_button(4, display_get_gui_height() - 30, "Back", function() {
			menu_options.load_page("main_screen");
		}),
    ])
]);

// Add a group to an existing page
menu_options.add_group_to_page("main_screen", map_group);


menu_options.load_page("main_screen");