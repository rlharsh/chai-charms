function get_maximum_map() {
	if (instance_exists(obj_island_generator)) {
		return obj_island_generator.game_world._maximum_map;	
	}
}

function set_current_map(_id) {
	if (instance_exists(obj_island_generator)) {
		obj_island_generator.game_world._selected_map = _id;
	}
}
