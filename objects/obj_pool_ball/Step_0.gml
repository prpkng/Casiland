var move_speed = point_distance(0, 0, phy_linear_velocity_x, phy_linear_velocity_y);
image_speed = move_speed / 200;

if place_meeting(x, y, obj_player_bullet) {
    var _bullet = obj_player_bullet;

    var dir = point_direction(0, 0, _bullet.move_dx, _bullet.move_dy);
    push_ball_to_dir(dir, shot_impulse_force);
    
    
    instance_destroy(obj_player_bullet);
}