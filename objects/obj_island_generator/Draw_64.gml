if (game_world._selected_map > get_maximum_map()) {
	//draw_set_halign(fa_center);
	//draw_set_valign(fa_middle);
	draw_text_outline(4, display_get_gui_height() / 2, "Unlock this map.");
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}