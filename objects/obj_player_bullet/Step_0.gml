x += move_dx * move_speed;
y += move_dy * move_speed;

var p_dir = point_direction(0,0,move_dx, move_dy)

part_type_orientation(global.pt_bullet_trail_particles, p_dir, p_dir, 0, 0, 0);
part_particles_create(global.ps_above,x,y,global.pt_bullet_trail_particles,1)

