if ball != noone and !instance_exists(ball) {
    instance_destroy(self);
}

if ball == noone or !instance_exists(ball) { exit; }

x = ball.x;
y = ball.y;