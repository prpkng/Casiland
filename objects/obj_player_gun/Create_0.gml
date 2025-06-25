recoil_counter = 0;
recoil_force = 5;

offset_x = 0;
offset_y = 0;

muzzle_distance = 5;

shot_sfx = new EventRef("event:/SFX/Player/ShotGun");

function shoot() {
    var dir = point_direction(x, y, mouse_x, mouse_y-2);
    recoil_counter = 1;
    
    offset_x = lengthdir_x(-recoil_force, dir);
    offset_y = lengthdir_y(-recoil_force, dir);
    
    var _x = x+lengthdir_x(muzzle_distance, dir);
    var _y = y+lengthdir_y(muzzle_distance, dir);
    var _bullet = instance_create_depth(_x, _y, depth, obj_player_bullet);
    _bullet.image_angle = dir;
    _bullet.move_dx = lengthdir_x(1, dir);
    _bullet.move_dy = lengthdir_y(1, dir);
    
    // Play sound effect
    PlayOneShot(shot_sfx);
}