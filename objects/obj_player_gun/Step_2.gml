var dir = point_direction(x, y, mouse_x, mouse_y-2);

if InputPressed(INPUT_VERB.SHOOT) {
    shoot();
}
recoil_counter -= 1/20.0;
offset_x = lerp(offset_x, 0, 0.6);
offset_y = lerp(offset_y, 0, 0.6);

image_yscale = mouse_x < x ? -1 : 1;
obj_player.image_xscale = image_yscale;

if recoil_counter > 0 {
    dir += recoil_counter * image_yscale * 10;
}

image_angle = dir;

x = obj_player.x + offset_x;
y = obj_player.y + offset_y;