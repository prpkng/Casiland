shader_set(shd_pool_ball);
shader_set_uniform_i(color_count_idx, 5);
shader_set_uniform_i(pallete_count_idx, 6);
shader_set_uniform_i(pallete_index_idx, color_idx % 8);
texture_set_stage(sampler_idx, sprite_get_texture(ball_pallete, 0));

draw_self();

shader_reset();