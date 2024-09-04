enum Aspects
{
	_16x9,
	_21x9,
	_1x1,
	_4x3,
	_9x16	
}

function set_aspect(argument0) {
	with(obj_controller_aspect_manager)
	{
		switch(argument0)
		{
			case Aspects._16x9: 
				current_height = BASE_HEIGHT;
				current_width = BASE_HEIGHT*(16/9);
				break;
			case Aspects._21x9: 
				current_height = BASE_HEIGHT;
				current_width = BASE_HEIGHT*(21/9);
				break;
			case Aspects._4x3: 
				current_height = BASE_HEIGHT;
				current_width = BASE_HEIGHT*(4/3);
				break;
			case Aspects._1x1: 
				current_height = BASE_HEIGHT;
				current_width = BASE_HEIGHT;
				break;
			case Aspects._9x16: 
				current_width = BASE_HEIGHT;
				current_height = BASE_HEIGHT;
				break;
		}
	
		//instance_create_depth(0,0,-1000,obj_screen_fade);
		RESIZE_WINDOW;
	}


}
