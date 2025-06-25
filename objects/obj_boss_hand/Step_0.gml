image_xscale = -hand_side;

image_alpha = 1;

if !idle_enabled { exit; }

var dx = xstart + sin(current_time / 1000 * 2 * hand_side) * 10;
var dy = ystart + sin(current_time / 1000) * 18;

var distance = point_distance(0, 0, dx, dy);

var spd = 0.2;

if distance > 96 { spd = 0.025; }
else if distance > 48 { spd = 0.05; }
else if distance > 32 { spd = 0.1; }

x = lerp(x, dx, spd);
y = lerp(y, dy, spd);