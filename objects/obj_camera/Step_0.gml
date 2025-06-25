x = lerp(x, target.x, 1.0 / follow_delay);
y = lerp(y, target.y, 1.0 / follow_delay);

var _halfWid = camera_get_view_width(view_camera[0])/2;
var _halfHei = camera_get_view_height(view_camera[0])/2;


camera_set_view_pos(view_camera[0], x - _halfWid, y - _halfHei);

var vel_x = abs(x - xprevious) / (delta_time / 1000000);
var vel_y = abs(y - yprevious) / (delta_time / 1000000);

var attr = new Fmod3DAttributes();
attr.position = {x: x / FMOD_PPU, y: y / FMOD_PPU, z: 0};
attr.velocity = {x: vel_x / FMOD_PPU, y: vel_y / FMOD_PPU, z: 0};
attr.up = {x: 0, y: -1, z: 0};
attr.forward = {x: 0, y: 0, z: -1};

fmod_studio_system_set_listener_attributes(0, attr);
