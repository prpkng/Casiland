image_speed = 0;

color_idx = ball_pick_color();
sprite_index = floor(color_idx / 8) == 1 ? spr_pool_flat_ball : spr_pool_line_ball;
print(color_idx);


sampler_idx = shader_get_sampler_index(shd_pool_ball, "color_pallete");
color_count_idx = shader_get_uniform(shd_pool_ball, "color_count");
pallete_count_idx = shader_get_uniform(shd_pool_ball, "pallete_count");
pallete_index_idx = shader_get_uniform(shd_pool_ball, "pallete_index");