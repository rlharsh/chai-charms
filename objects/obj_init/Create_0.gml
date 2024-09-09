/// @function get_primary_aspect_ratio()
/// @description Returns the aspect ratio of the user's primary monitor as a string (e.g., "21:9").

function get_primary_aspect_ratio() {
    var width = display_get_width();
    var height = display_get_height();
    
    // Function to calculate the Greatest Common Divisor (GCD)
    var get_gcd = function(a, b) {
        while (b != 0) {
            var temp = b;
            b = a mod b;
            a = temp;
        }
        return a;
    };
    
    var gcd = get_gcd(width, height);
    var aspect_width = width / gcd;
    var aspect_height = height / gcd;

    // Check for common aspect ratios to provide a more intuitive result
    if (aspect_width == 64 && aspect_height == 27) {
        set_aspect(Aspects._21x9);
		return "21:9";
    } else if (aspect_width == 16 && aspect_height == 9) {
		set_aspect(Aspects._16x9);
        return "16:9";
    } else if (aspect_width == 4 && aspect_height == 3) {
		set_aspect(Aspects._4x3);
        return "4:3";
    } else if (aspect_width == 16 && aspect_height == 10) {
		set_aspect(Aspects._16x9);
        return "16:10";
    } else if (aspect_width == 5 && aspect_height == 4) {
        return "5:4";
    }
    
    // Return the raw aspect ratio if it's an uncommon resolution
    return string(aspect_width) + ":" + string(aspect_height);
}


controllers = [{
	controller: obj_controller_gui,
	controller_ref: -1,
	controller_initialized: false,
	name: "controller_gui",
}, {
	controller: obj_controller_aspect_manager,
	controller_ref: -1,
	controller_initialized: false,
	name: "controller_aspect",
}, {
	controller: obj_controller_configuration,
	controller_ref: -1,
	controller_initialized: false,
	name: "controller_configuration",
}];

array_foreach(controllers, function(_controller) {
	try {
		_controller.controller_ref = instance_create_layer(0, 0, "Controllers", _controller.controller);	
		_controller.controller_initialized = true;
	} catch(_e) {
		
	}
});

var aspect = get_primary_aspect_ratio();
alarm[0] = 1;