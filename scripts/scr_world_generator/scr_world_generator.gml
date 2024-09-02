function World(_ts) constructor {
    _tile_size = _ts;
    _world_grid = noone;
    _initialized = false;
    _grid_width = -1;
    _grid_height = -1;
    _tileset = spr_worldmap_tiles;
    _wave_up = false;
    
    function init() {
        _grid_width = room_width div _tile_size;
        _grid_height = room_height div _tile_size;
        
        _world_grid = ds_grid_create(_grid_width, _grid_height);
        
        // Initialize the world grid with empty values.
        ds_grid_clear(_world_grid, noone);
        
        _initialized = true;
    }
    
    function generate_world(_start_size) {
        randomize();
        var _center_x = _grid_width div 2;
        var _center_y = _grid_height div 2;
        
        // Create the starting island.
        for (var _i = 0; _i < _start_size; _i++) {
            for (var _j = 0; _j < _start_size; _j++) {
                var _grid_x = _center_x + _i - (_start_size div 2);
                var _grid_y = _center_y + _j - (_start_size div 2);
                
                // Check if the coordinates are within the grid bounds
                if (_grid_x >= 0 && _grid_x < _grid_width && _grid_y >= 0 && _grid_y < _grid_height) {
                    _world_grid[# _grid_x, _grid_y] = {
                        type: "land"    
                    };
                    
                    var _world_x = _grid_x * _tile_size;
                    var _world_y = _grid_y * _tile_size;
                    
                    if (random(1) < .2) {
                        // Create random item here.    
                    }
                }
            }
        }
    }
    
    function draw_world(_draw_grid) {
        draw_grid_overlay(_draw_grid);
        draw_map_tiles();
    }
    
    function draw_grid_overlay(_draw_grid) {
        var _camera_x = camera_get_view_x(view_camera[0]);
        var _camera_y = camera_get_view_y(view_camera[0]);
        var _camera_width = camera_get_view_width(view_camera[0]);
        var _camera_height = camera_get_view_height(view_camera[0]);
        
        var _min_tile_x = max(0, _camera_x div _tile_size);
        var _max_tile_x = min(_grid_width - 1, (_camera_x + _camera_width) div _tile_size);
        var _min_tile_y = max(0, _camera_y div _tile_size);
        var _max_tile_y = min(_grid_height - 1, (_camera_y + _camera_height) div _tile_size);
        
        // If true we will draw the overlay grid, otherwise we will not.
        if (_draw_grid) {
            draw_set_alpha(.1);
            for (var _i = _min_tile_x; _i <= _max_tile_x; _i++) {
                draw_line(_i * _tile_size, _camera_y, _i * _tile_size, _camera_y + _camera_height);    
            }
            for (var _j = _min_tile_y; _j <= _max_tile_y; _j++) {
                draw_line(_camera_x, _j * _tile_size, _camera_x + _camera_width, _j * _tile_size);
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
                } else {
                    if (_j > 0 && _world_grid[# _i, _j-1] != noone) {
                        var wave_pos = (_wave_up) ? 15 : 16;

                        // Check for both northwest and northeast tiles being empty
                        if (_i > 0 && _i < _grid_width - 1 && _world_grid[# _i-1, _j-1] == noone && _world_grid[# _i+1, _j-1] == noone) {
                            wave_pos = (_wave_up) ? 17 : 18;
                        }
                        // Check for southwest corner
                        else if (_i > 0 && _world_grid[# _i-1, _j-1] == noone) {
                            wave_pos = (_wave_up) ? 19 : 20;
                        }
                        // Check for southeast corner
                        else if (_i < _grid_width - 1 && _world_grid[# _i+1, _j-1] == noone) {
                            wave_pos = (_wave_up) ? 21 : 22;
                        }

                        draw_sprite(_tileset, wave_pos, round(_i * _tile_size + _tile_size / 2), round(_j * _tile_size + _tile_size / 2));
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
}