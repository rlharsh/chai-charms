// Feather disable GM2017
function configuration_manager() constructor {
    config_dir = environment_get_variable("APPDATA") + "\\CHAICHARMS\\config";
    config_file = "\\conf.json";
    config_data = {};
    
    initialize_configuration = function() {
        initialize_directories();
        initialize_config_file();
    }
    
    initialize_directories = function() {
        if (!sanitize_directory(config_dir)) {
            show_debug_message("Could not sanitize directories.");
            // Consider adding error handling or user notification here
        }
    }
    
    initialize_config_file = function() {
        var full_path = config_dir + config_file;
        if (!file_exists(full_path)) {
            build_configuration();
            save_config_file();
        } else {
            load_config_file();
        }
        refresh_configuration();
    }
    
    load_config_file = function() {
        var full_path = config_dir + config_file;
        var file_content = "";
        var c_file = file_text_open_read(full_path);
        while (!file_text_eof(c_file)) {
            file_content += file_text_read_string(c_file);
            file_text_readln(c_file);
        }
        file_text_close(c_file);
        
        try {
            config_data = json_parse(file_content);
        } catch (e) {
            show_debug_message("Error parsing config file: " + string(e));
            build_configuration(); // Use default config if parsing fails
        }
    }
    
    refresh_configuration = function() {
		set_aspect(config_data.video.aspect_ratio);
		window_set_fullscreen(config_data.video.fullscreen);
    }
    
    save_config_file = function() {
        var full_path = config_dir + config_file;
        var c_file = file_text_open_write(full_path);
        file_text_write_string(c_file, json_stringify(config_data, true));
        file_text_close(c_file);
        
        show_debug_message("Configuration saved to: " + full_path);
    }
	
	get_value = function(_key) {
		var keys = string_split(_key, ".");
		var current = config_data;
		
		for (var _i = 0; _i < array_length(keys) - 1; _i++) {
			if (!variable_struct_exists(current, keys[_i])) {
				show_debug_message("Key not found: " + keys[_i]);
				return false;
			}
			current = current[$ keys[_i]];
		}
		var last_key = keys[array_length(keys) - 1];
		return current[$ last_key];
	}
	
	update_value = function(_key, _value) {
        var keys = string_split(_key, ".");
        var current = config_data;
        
        for (var i = 0; i < array_length(keys) - 1; i++) {
            if (!variable_struct_exists(current, keys[i])) {
                show_debug_message("Key not found: " + keys[i]);
                return false;
            }
            current = current[$ keys[i]];
        }
        
        var last_key = keys[array_length(keys) - 1];
        current[$ last_key] = _value;
        
        save_config_file();
        refresh_configuration();
        return true;
    }
    
    build_configuration = function() {
        config_data = {
            video: {
                aspect_ratio: Aspects._16x9,
                fullscreen: true,
            },
            audio: {
                music_volume: 1,
                ambient_volume: 1,
                sound_volume: 1,
            },
        };
    }
}

function sanitize_directory(_dir) {
    if (!directory_exists(_dir)) {
        try {
            directory_create(_dir);    
        } catch (_error) {
            show_debug_message("Error creating directory: " + string(_error));
            return false;
        }
    }
    return true;
}

function configuration_update_value(_key, _value) {
    if (instance_exists(obj_controller_configuration)) {
        return obj_controller_configuration.config_manager.update_value(_key, _value);
    }
    return false;
}

function configuration_get_value(_key) {
    if (instance_exists(obj_controller_configuration)) {
        return obj_controller_configuration.config_manager.get_value(_key);
    }
    return undefined;
}