menu_options = new gui_manager_create(0);
menu_options.add_page("main_screen", [
	new gui_button(10, 10, "Play Game", function() {
		
	}),
	new gui_button(10, 30, "Testing"),
]);
menu_options.add_page("options_screen", [
    new gui_button(10, 10, "Sound"),
    new gui_button(10, 40, "Graphics"),
    new gui_button(10, 70, "Back"),
]);

menu_options.load_page("main_screen");