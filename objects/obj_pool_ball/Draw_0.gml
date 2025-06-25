shader_set(shd_pool_ball);
shader_set_uniform_i(color_count_idx, 5);
shader_set_uniform_i(pallete_count_idx, 6);
shader_set_uniform_i(pallete_index_idx, color_idx % 8);
texture_set_stage(sampler_idx, sprite_get_texture(ball_pallete, 0));

var _dir = point_direction(0, 0, phy_linear_velocity_x, phy_linear_velocity_y);
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, _dir, c_white, 1);

shader_reset();