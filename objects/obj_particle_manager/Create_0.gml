
global.ps_above = part_system_create();

global.pt_bullet_trail_particles = part_type_create();
part_type_shape(global.pt_bullet_trail_particles, pt_shape_sphere);
part_type_size_y(global.pt_bullet_trail_particles, 0.1, 0.1, -.015, 0);
part_type_size_x(global.pt_bullet_trail_particles, 0.3, 0.3, 0, 0)
part_type_orientation(global.pt_bullet_trail_particles, 0, 0, 0, 0, 0);
part_type_color3(global.pt_bullet_trail_particles, #4e2b45, #4e2b45, #4e2b45);
part_type_alpha3(global.pt_bullet_trail_particles, 1, 1, 1);
part_type_blend(global.pt_bullet_trail_particles, false);
part_type_life(global.pt_bullet_trail_particles, 9, 9);
part_type_speed(global.pt_bullet_trail_particles, 0, 0, 0, 0);
part_type_direction(global.pt_bullet_trail_particles, 0, 360, 0, 0);
part_type_gravity(global.pt_bullet_trail_particles, 0, 0);