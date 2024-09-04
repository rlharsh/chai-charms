game_world = new World(16);

game_world.init();
game_world.generate_world();
alarm[0] = 20;

selector_scale = { scale: 1 };

tween_selector = TweenFire(selector_scale, EaseInOutQuad, TWEEN_MODE_PATROL, true, 0, .25, "scale", 1, 1.2);