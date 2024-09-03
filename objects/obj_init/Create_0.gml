controllers = [{
	controller: obj_controller_gui,
	controller_ref: -1,
	controller_initialized: false,
	name: "controller_gui",
}];

array_foreach(controllers, function(_controller) {
	try {
		_controller.controller_ref = instance_create_layer(0, 0, "Controllers", _controller.controller);	
		_controller.controller_initialized = true;
	} catch(_e) {
		
	}
});

room_goto(rm_world_generation);