menu_options = new gui_manager_create(0);

menu_options.add_page("main_screen", [
	new gui_group("primary_options", [
		new gui_sprite_stretched(40, 40, spr_panel_default, 0, display_get_gui_width() - 80, display_get_gui_height() - 80),
		new gui_button(display_get_gui_width() - 138, display_get_gui_height() - 60, "Start Game", function() {
			
		}),
		new gui_label_shadow(display_get_gui_width() / 2, 50, "Select a Save File!", true),
		new gui_sprite(display_get_gui_width() / 2 - 100, 46, spr_ui_icons, 2),
	]),
]);

menu_options.load_page("main_screen");