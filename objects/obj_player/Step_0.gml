input_x = InputX(INPUT_CLUSTER.MOVE);
input_y = InputY(INPUT_CLUSTER.MOVE);
input_direction = InputDirection(input_direction, INPUT_CLUSTER.MOVE);
input_length = sqrt(input_x * input_x + input_y * input_y);

if InputPressed(INPUT_VERB.ROLL) {
    fsm.trigger("t_roll");
}

env_xspd = 0;
env_yspd = 0;

var _ball = instance_place(x, y, obj_pool_ball);
if instance_exists(_ball) {
    if place_meeting(x - _ball.phy_speed_x*10, y -_ball.phy_speed_y*10, _ball) {
        env_xspd = _ball.phy_speed_x * 1;
        env_yspd = _ball.phy_speed_y * 1;
    }
}

fsm.step();

