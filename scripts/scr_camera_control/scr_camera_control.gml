function change_view(_room_number) {
    var _cam = view_camera[0];
    
    // Define room dimensions
    var _room_width = 576;
    var _room_height = 384;
    
    // Calculate row and column
    var _row = _room_number div 10;  // Integer division to get row (0-3)
    var _col = _room_number mod 10;  // Modulo to get column (0-9)
    
    // Calculate camera position
    var _cam_x = _col * _room_width;
    var _cam_y = _row * _room_height;
    
    // Set camera position
    camera_set_view_pos(_cam, _cam_x, _cam_y);
    
    // Optional: Update selected_room global variable
    selected_room = _room_number;
    
    // Debug message
    show_debug_message("Moved to room " + string(_room_number) + 
                       " at position (" + string(_cam_x) + ", " + string(_cam_y) + ")");
}