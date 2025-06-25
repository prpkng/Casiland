// Inherit the parent event
event_inherited();

gun = instance_create_depth(x, y, depth-1, obj_player_gun);

// === PLAYER PARAMETERS

move_speed = 2.5;
move_accel = 0.7;
move_decel = 0.5;

input_x = 0;
input_y = 0;
input_length = 0;
input_direction = 0;

cur_movespeed = 0;

xspd = 0;
yspd = 0;

env_xspd = 0;
env_yspd = 0;

// === ROLL ===
roll_speed = 5.5;
roll_duration = 0.3;
roll_counter = 0;
roll_dx = 0;
roll_dy = 0;

/// @desc Moves the player with the current direction and acceleration
/// @param {any*} accel_rate Description
function apply_movement(accel_rate, speed) {
    cur_movespeed = lerp(cur_movespeed, speed, accel_rate); 
    
    var _xspd = xspd + env_xspd;
    var _yspd = yspd + env_yspd;
    
    if place_meeting(x + _xspd, y, obj_solid) {
        while !place_meeting(x+sign(_xspd), y, obj_solid) {
            x += sign(_xspd);
        }
        
        // === SLOPE COLLISION CHECKING ===
        var hitSlope = false;
        for (var i = -1; i <= 1; i+=2) {
        	if !place_meeting(x+_xspd, y+speed*4*i, obj_solid) {
                if place_meeting(x + _xspd, y, obj_solid) {
                    y += 1*i;
                    hitSlope = true;
                    _xspd *= 0.1;
                    break;
                }
            }
        }
        if !hitSlope {
            _xspd = 0; 
        }    
        
    }
    
    if place_meeting(x, y + _yspd, obj_solid) {
        while !place_meeting(x, y+sign(_yspd), obj_solid) {
            y += sign(_yspd);
        }
        
        
        // === SLOPE COLLISION CHECKING ===
        var hitSlope = false;
        for (var i = -1; i <= 1; i+=2) {
        	if !place_meeting(x + speed*4*i, y+_yspd, obj_solid) {
                if place_meeting(x, y + _yspd, obj_solid) {
                    x += 1*i;
                    hitSlope = true;
                    _yspd *= 0.1;
                    break;
                }
            }
        }
        if !hitSlope {
            _yspd = 0; 
        }    
        
    }
    
    x += _xspd;
    y += _yspd;
}

function idle_step() {
    if input_length > 0.25 {
        fsm.change("move");
    }
    xspd = 0;
    yspd = 0;
    apply_movement(move_decel, move_speed);
}

function move_step() {
    if input_length < 0.25 { 
        fsm.change("idle");
    }
           
    xspd = input_x * move_speed;
    yspd = input_y * move_speed;
    
    apply_movement(move_accel, move_speed);
}

function roll_step() {
    if roll_counter < 0 { 
        fsm.change("idle");
        return;
    }
    
    roll_counter -= delta_time / 1000000
           
    xspd = roll_dx * roll_speed;
    yspd = roll_dy * roll_speed;
    env_xspd = 0;
    env_yspd = 0;
    
    apply_movement(move_accel, roll_speed);
}

fsm = new SnowState("idle");
fsm
    .add("idle", {
        enter: function() {
            sprite_index = spr_player_idle;
        },
        step: idle_step   
    }) 
    .add("move", {
        enter: function() {
            sprite_index = spr_player_moving;
        },
        step: move_step
    })
    .add("roll", {
        enter: function() {
            sprite_index = spr_player_roll;
            roll_counter = roll_duration;
            roll_dx = input_x;
            roll_dy = input_y;
            instance_deactivate_object(gun);
        },
        step: roll_step,
        leave: function() {
            instance_activate_object(gun);
        } 
    });

fsm.add_transition("t_roll", "move", "roll");