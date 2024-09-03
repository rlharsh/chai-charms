if (keyboard_check_pressed(vk_right)) {
    var _next_room = (selected_room + 1) mod 40;
    change_view(_next_room);
}

if (keyboard_check_pressed(vk_left)) {
    var _prev_room = (selected_room - 1 + 40) mod 40;
    change_view(_prev_room);
}