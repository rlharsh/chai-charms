function World(_ts) constructor {
    _tile_size = _ts;
    _world_grid = noone;
    _initialized = false;
    _grid_width = -1;
    _grid_height = -1;
    _tileset = spr_worldmap_tiles;
    _wave_up = false;
	_noise_scale = 0.2;
	_start_pos_x = 0;
	_start_pos_y = 0;
	_maximum_map = 0;
	_selected_map = 0;
    
    function init() {
        _grid_width = room_width div _tile_size;
        _grid_height = room_height div _tile_size;
        
        _world_grid = ds_grid_create(_grid_width, _grid_height);
        
        // Initialize the world grid with empty values.
        ds_grid_clear(_world_grid, noone);
        
        _initialized = true;
    }
    
	function generate_world() {
        randomize();
        var _cell_size = 4;
        var _grid_cells_width = _grid_width div _cell_size;
        var _grid_cells_height = _grid_height div _cell_size;
    
        var _random_cell_x = irandom(_grid_cells_width - 1);
        var _random_cell_y = irandom(_grid_cells_height - 1);
    
        var _start_x = _random_cell_x * _cell_size;
        var _start_y = _random_cell_y * _cell_size;
		_start_pos_x = _start_x;
		_start_pos_y = _start_y;
    
        generate_chunk(16, 8);
		generate_chunk(20, 8);
    }
	
	function update_world() {
		if (_selected_map > get_maximum_map()) return;
		
	    var _cell_size = 4 * _tile_size;
	    var _mouse_x = mouse_x;
	    var _mouse_y = mouse_y;

	    // Get the current viewport information
	    var _cam = view_camera[0];
	    var _view_x = camera_get_view_x(_cam);
	    var _view_y = camera_get_view_y(_cam);
	    var _view_height = camera_get_view_height(_cam);
		var _camera_width = camera_get_view_width(view_camera[0]);

	    var _cell_x = _mouse_x div _cell_size;
	    var _cell_y = _mouse_y div _cell_size;

	    // Check if the mouse is within the valid area of the current viewport
	    var _mouse_view_y = _mouse_y - _view_y;
	    if (_mouse_x >= 64 && _mouse_x < _view_x + _camera_width - 72 && 
	        _mouse_view_y >= 64 && _mouse_view_y < _view_height - 40) {
	        if (mouse_check_button_pressed(mb_left)) {
	            var _start_x = _cell_x * 4;
	            var _start_y = _cell_y * 4;
        
	            generate_chunk(_start_x, _start_y);
	        }
	    }
	}
    
    function draw_world(_draw_grid, _scale) {
        draw_grid_overlay(_draw_grid);
        draw_map_tiles();
		draw_mouse_grid(_scale);
    }
	
	function draw_mouse_grid(_scale) {
		if (_selected_map > get_maximum_map()) return;
		
	    var _cell_size = 4 * _tile_size;
	    var _mouse_x = mouse_x;
	    var _mouse_y = mouse_y;
    
	    // Get the current viewport information
	    var _cam = view_camera[0];
	    var _view_x = camera_get_view_x(_cam);
	    var _view_y = camera_get_view_y(_cam);
	    var _view_height = camera_get_view_height(_cam);
		
		var _camera_width = camera_get_view_width(view_camera[0]);
        var _camera_height = camera_get_view_height(view_camera[0]);
    
	    // Calculate which cell the mouse is in
	    var _cell_x = _mouse_x div _cell_size;
	    var _cell_y = _mouse_y div _cell_size;
    
	    // Check if the mouse is within the valid area of the current viewport
	    var _mouse_view_y = _mouse_y - _view_y;
	    if (_mouse_x >= 64 && _mouse_x < _view_x + _camera_width - 72  && 
	        _mouse_view_y >= 64 && _mouse_view_y < _view_height - 40) {
			draw_sprite_ext(spr_selector, 0, _cell_x * _cell_size + 32, _cell_y * _cell_size + 32, _scale, _scale, 0, c_white, 1);
	    }
	}
    
	function draw_grid_overlay(_draw_grid) {
	    if (_draw_grid) {
	        var _cell_size = 4 * _tile_size;
        
	        draw_set_alpha(.1);
        
	        // Draw vertical lines
	        for (var _i = 0; _i <= room_width; _i += _cell_size) {
	            draw_line(_i, 0, _i, room_height);    
	        }
        
	        // Draw horizontal lines
	        for (var _j = 0; _j <= room_height; _j += _cell_size) {
	            draw_line(0, _j, room_width, _j);
	        }
        
	        draw_set_alpha(1);
	    }
	}
    
    function draw_map_tiles() {
        var _camera_x = camera_get_view_x(view_camera[0]);
        var _camera_y = camera_get_view_y(view_camera[0]);
        var _camera_width = camera_get_view_width(view_camera[0]);
        var _camera_height = camera_get_view_height(view_camera[0]);
        
        var _min_tile_x = max(0, _camera_x div _tile_size);
        var _max_tile_x = min(_grid_width - 1, (_camera_x + _camera_width) div _tile_size);
        var _min_tile_y = max(0, _camera_y div _tile_size);
        var _max_tile_y = min(_grid_height - 1, (_camera_y + _camera_height) div _tile_size);
        
        for (var _i = _min_tile_x; _i <= _max_tile_x; _i++) {
            for (var _j = _min_tile_y; _j <= _max_tile_y; _j++) {
                var _tile_info = _world_grid[# _i, _j];    
                if (_tile_info != noone) {
                    var _autotile_index = get_autotile_index(_i, _j);
                    draw_sprite(_tileset, _autotile_index, round(_i * _tile_size + _tile_size / 2), round(_j * _tile_size + _tile_size / 2));
					//show_message(_tile_info);
					if(_tile_info.flower) {
						var _grass_pos = (_wave_up) ? 24 : 25;
						 //draw_sprite(_tileset, _grass_pos, round(_i * _tile_size + _tile_size / 2), round(_j * _tile_size + _tile_size / 2));
					}
                } else {
                    if (_j > 0 && _world_grid[# _i, _j-1] != noone) {
                        var _wave_pos = (_wave_up) ? 16 : 17;

                        // Check for both northwest and northeast tiles being empty
                        if (_i > 0 && _i < _grid_width - 1 && _world_grid[# _i-1, _j-1] == noone && _world_grid[# _i+1, _j-1] == noone) {
                            _wave_pos = (_wave_up) ? 22 : 23;
                        }
                        // Check for southwest corner
                        else if (_i > 0 && _world_grid[# _i-1, _j-1] == noone) {
                            _wave_pos = (_wave_up) ? 18 : 19;
                        }
                        // Check for southeast corner
                        else if (_i < _grid_width - 1 && _world_grid[# _i+1, _j-1] == noone) {
                            _wave_pos = (_wave_up) ? 20 : 21;
                        }

                        draw_sprite(_tileset, _wave_pos, round(_i * _tile_size + _tile_size / 2), round(_j * _tile_size + _tile_size / 2));
                    }
                }
            }
        }
    }
    
    function get_autotile_index(x, y) {
        var _north = (y > 0) && (_world_grid[# x, y-1] != noone);
        var _east = (x < _grid_width-1) && (_world_grid[# x+1, y] != noone);
        var _south = (y < _grid_height-1) && (_world_grid[# x, y+1] != noone);
        var _west = (x > 0) && (_world_grid[# x-1, y] != noone);

        // Isolated tile or tiles with only diagonal neighbors
        if (!_north && !_east && !_south && !_west) return 15;

        // Two-tile horizontal configuration
        if (!_north && !_south) {
            if (_east && !_west) return 10;
            if (!_east && _west) return 9;
            if (_east && _west) return 8;
        }

        // Two-tile vertical configuration
        if (!_east && !_west) {
            if (_north && !_south) return 13;
            if (!_north && _south) return 12;
            if (_north && _south) return 11;
        }

        // Corners
        if (!_north && !_west) return 0;
        if (!_north && !_east) return 2;
        if (!_south && !_west) return 5;
        if (!_south && !_east) return 7;

        // Edges
        if (!_north) return 1;
        if (!_east) return 4;
        if (!_south) return 6;
        if (!_west) return 3;

        // Fully surrounded
        return 14;
    }

	function generate_chunk(_start_x, _start_y) {
	    var _chunk_size = 4;
	    var _noise_seed = random(10000); // Random seed for varied chunks
    
	    // Calculate the center of the chunk
	    var _center_x = _start_x + _chunk_size / 2;
	    var _center_y = _start_y + _chunk_size / 2;

	    // First pass: Fill the entire chunk with land
	    for (var _i = 0; _i < _chunk_size; _i++) {
	        for (var _j = 0; _j < _chunk_size; _j++) {
	            var _grid_x = _start_x + _i;
	            var _grid_y = _start_y + _j;
            
	            _draw_grass_tile = random_range(1, 100) < 20;
				_draw_flower_tile = random_range(1, 100) < 10;
	            _world_grid[# _grid_x, _grid_y] = {
	                type: "land",
	                grass: _draw_grass_tile,
					flower: _draw_flower_tile,
	            };
	        }
	    }
    
	    // Second pass: Create water only along the edges
	    for (var _i = 0; _i < _chunk_size; _i++) {
	        for (var _j = 0; _j < _chunk_size; _j++) {
	            var _grid_x = _start_x + _i;
	            var _grid_y = _start_y + _j;
            
	            // Check if we're on the edge of the chunk
	            if (_i == 0 || _i == _chunk_size - 1 || _j == 0 || _j == _chunk_size - 1) {
	                // Calculate distance from center
	                var _dist_from_center = point_distance(_grid_x, _grid_y, _center_x, _center_y) / (_chunk_size / 2);
                
	                // Generate Perlin noise value
	                var _noise_x = (_grid_x + _noise_seed) * _noise_scale;
	                var _noise_y = (_grid_y + _noise_seed) * _noise_scale;
	                var _noise_value = (perlin_noise_2d(_noise_x, _noise_y) + 2) / 2; // Normalize to 0-1 range
                
	                // Combine distance and noise to determine land or water
	                var _land_value = _noise_value - _dist_from_center;
                
	                if (_land_value <= 0.1) { // Adjust this threshold to change coastline shape
	                    _world_grid[# _grid_x, _grid_y] = noone; // Water
	                }
	            }
	        }
	    }
    
	    // Ensure the center is always land
	    _world_grid[# floor(_center_x), floor(_center_y)] = { type: "land", grass: false, flower: false };
		
		spawn_trees_in_chunk(_start_x, _start_y);
		spawn_rocks_in_chunk(_start_x, _start_y);
	}
	
	function spawn_trees_in_chunk(_start_x, _start_y) {
		for (var _c = _start_x * 16; _c < _start_x * 16 + 96; _c += 16) {
		    for (var _r = (_start_y * 16) + 16; _r < _start_y * 16 + 96; _r += 16) {
		        if (random(1) < .2) {
		            var _grid_x = _c div 16;
		            var _grid_y = _r div 16;
            
		            if (_world_grid[# _grid_x, _grid_y] != noone) {
		                var _tile = _world_grid[# _grid_x, _grid_y];
		                if (_tile.type == "land") {
							if (!is_position_solid(_c, _r + 8)) {
			                    instance_create_layer(_c, _r + 8, "Instances", obj_spawn_tree);
							}
		                }
		            }
		        }
		    }
		}
	}
	
	function spawn_rocks_in_chunk(_start_x, _start_y) {
		for (var _c = _start_x * 16; _c < _start_x * 16 + 96; _c += 16) {
		    for (var _r = (_start_y * 16) + 16; _r < _start_y * 16 + 96; _r += 16) {
		        if (random(1) < .1) {
		            var _grid_x = _c div 16;
		            var _grid_y = _r div 16;
            
		            if (_world_grid[# _grid_x, _grid_y] != noone) {
		                var _tile = _world_grid[# _grid_x, _grid_y];
		                if (_tile.type == "land") {
							if (!is_position_solid(_c, _r + 8)) {
			                    instance_create_layer(_c, _r + 8, "Instances", obj_spawn_rock);
							}
		                }
		            }
		        }
		    }
		}
	}
	
	function is_position_solid(_x, _y) {
	    var _solid_parent = obj_solid; // Assume you have a parent object for all solid objects
    
	    with (all) {
	        if (object_is_ancestor(object_index, _solid_parent) || object_index == _solid_parent) {
	            if (position_meeting(_x, _y, id)) {
	                return true;
	            }
	        }
	    }
    
		return false;
	}

	function perlin_noise_2d(_x, _y) {
	    static p = array_create(512);
	    static initialized = false;
    
	    if (!initialized) {
	        // Initialize the permutation array
	        for (var i = 0; i < 256; i++) {
	            p[i] = i;
	        }
        
	        // Shuffle the array
	        for (var i = 255; i > 0; i--) {
	            var j = irandom(i);
	            var temp = p[i];
	            p[i] = p[j];
	            p[j] = temp;
	        }
        
	        // Duplicate the permutation array
	        for (var i = 0; i < 256; i++) {
	            p[i + 256] = p[i];
	        }
        
	        initialized = true;
	    }
    
	    function fade(_t) {
	        return _t * _t * _t * (_t * (_t * 6 - 15) + 10);
	    }
    
	    function lerp(_t, _a, _b) {
	        return _a + _t * (_b - _a);
	    }
    
	    function grad(_hash, _x, _y) {
	        var h = _hash & 15;
	        var u = (h < 8) ? _x : _y;
	        var v = (h < 4) ? _y : ((h == 12 || h == 14) ? _x : 0);
	        return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
	    }
    
	    var X = floor(_x) & 255;
	    var Y = floor(_y) & 255;
	    _x -= floor(_x);
	    _y -= floor(_y);
	    var u = fade(_x);
	    var v = fade(_y);
    
	    var A = p[X] + Y;
	    var B = p[X + 1] + Y;
    
	    return lerp(v, 
	        lerp(u, 
	            grad(p[A], _x, _y),
	            grad(p[B], _x - 1, _y)
	        ),
	        lerp(u, 
	            grad(p[A + 1], _x, _y - 1),
	            grad(p[B + 1], _x - 1, _y - 1)
	        )
	    );
	}
}