// Feather disable GM2017
function file_manager_create() constructor {
	menu_options = new gui_manager_create(0);
	menu_options.add_page("save_file_manager", [
		new gui_group("save_files", [
			new gui_button(display_get_gui_width() / 2 + (sprite_get_width(spr_backdrop_select_save) / 2), display_get_gui_height() - 26, "Start Game", function() {
				
			},,,,GUI_ALIGN.RIGHT),
		]),
	])
	
	step = function() {
		menu_options.step();
		
		if (input_check("cancel")) {
			room_goto(rm_menu_main);	
		}
	}
	
	draw = function() {

		live_name = "file_manager_create:draw";
		if (live_call()) return live_result;
		
		draw_sprite(spr_backdrop_select_save, 0, display_get_gui_width() / 2 - sprite_get_width(spr_backdrop_select_save) / 2, 0);
		
		draw_set_halign(fa_center);
		draw_text_shadow(display_get_gui_width() / 2, 36, "Select a save file.");
		draw_set_halign(fa_left);
		
		//draw_sprite_stretched(spr_panel_default, 1, 20, 20, 260, round(display_get_gui_height() - 40));
		menu_options.draw();
	}
}