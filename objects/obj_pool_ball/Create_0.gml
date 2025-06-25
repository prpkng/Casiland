color_idx = 0;

shot_impulse_force = 300;
phy_angular_damping = infinity;

sampler_idx = shader_get_sampler_index(shd_pool_ball, "color_pallete");
color_count_idx = shader_get_uniform(shd_pool_ball, "color_count");
pallete_count_idx = shader_get_uniform(shd_pool_ball, "pallete_count");
pallete_index_idx = shader_get_uniform(shd_pool_ball, "pallete_index");

hit_sfx = new EventInstance(new EventRef("event:/BOSSES/Snooker/SFX_BallHit"));

/// @desc Pushes the ball to the given direction
/// @param {Real} direction 
/// @param {Real} force 
function push_ball_to_dir(direction, force) {
    phy_linear_velocity_x = lengthdir_x(force, direction);
    phy_linear_velocity_y = lengthdir_y(force, direction);
    
}


function collision_with_ball() {
    hit_sfx.set_pos(x, y);
    fmod_studio_event_instance_set_parameter_by_name(hit_sfx.event_inst, "HitWhat", 0);

    hit_sfx.start();
}

function collision_with_solid() {
    hit_sfx.set_pos(x, y);
    fmod_studio_event_instance_set_parameter_by_name(hit_sfx.event_inst, "HitWhat", 1);

    hit_sfx.start();
}