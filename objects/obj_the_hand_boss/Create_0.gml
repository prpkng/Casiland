left_hand = instance_create_depth(x + 32, y, depth-50, obj_boss_hand);
left_hand.hand_side = -1;
right_hand = instance_create_depth(x - 32, y, depth-50, obj_boss_hand);
right_hand.hand_side = 1;

stick = instance_create_depth(x, y, depth-40, obj_pool_stick);

balls = ds_list_create();
setup_ball_colors();

cur_state = THB_POPULATE_BALLS_STATE;


// === STATES ===

#macro THB_POPULATE_BALLS_STATE "populate_balls"
#macro THB_SHOT_BALLS_STATE "shot_balls"
#macro THB_IDLE_STATE "idle"

// ==============


fsm = new SnowState(THB_POPULATE_BALLS_STATE);

// === BALL SPAWN ===

#macro BALL_SPAWN_DEPTH depth-10
#macro TABLE_SPAWN_WIDTH 400
#macro TABLE_SPAWN_HEIGHT 180

#macro BALL_CARRY_DURATION 1
#macro BALL_DROP_DURATION 0.75
#macro BALL_SPAWN_DROP_HEIGHT 64

desired_ball_count = 4;
spawned_balls = 0;

// === IDLE ===

idle_duration = 0;
idle_counter = 0;
idle_next = "";

// === SHOT BALLS ===

push_ball_force = 450;
shot_balls_picked_ball = noone;
shot_balls_counter = 0;


function remove_deleted_balls() {
    var temp = ds_list_create();
    
    for (var i = 0; i < ds_list_size(balls); i++) {
        if instance_exists(balls[| i]) {
            ds_list_add(temp, balls[| i]);
        }
    }
    
    ds_list_clear(balls);
    ds_list_copy(balls, temp);
    ds_list_destroy(temp);
    
    spawned_balls = ds_list_size(balls);
}


#region === POPULATE BALLS STATE ===

/// @desc This coroutine triggers a single hand to do the populate work, should only be used with populate_balls_coroutine
/// @param {Id.Instance} hand
/// @param {Real} ball_count
function hand_populate_balls(hand, ball_count) {
    
    hand.set_hand_sprite(HAND_SPRITES.BALL_GRAB);
    hand.idle_enabled = false;
    
    CO_PARAMS.cur_hand = hand;
    CO_PARAMS.count = ball_count;
    
    CO_PARAMS.balls = balls;
    CO_PARAMS.depth = depth;

    spawned_balls += ball_count;
    
    return CO_BEGIN 
        CO_LOCAL.count = count;
        CO_LOCAL.hand = cur_hand;
        C_REPEAT CO_LOCAL.count C_THEN
            CO_LOCAL.dest_x = 320 + random_range(-TABLE_SPAWN_WIDTH/2, TABLE_SPAWN_WIDTH/2);
            CO_LOCAL.dest_y = 180 + random_range(-TABLE_SPAWN_HEIGHT/2, TABLE_SPAWN_HEIGHT/2);
            CO_LOCAL.carry_y = CO_LOCAL.dest_y - BALL_SPAWN_DROP_HEIGHT;
            
        
            CO_LOCAL.ball = instance_create_depth(CO_LOCAL.hand.x, CO_LOCAL.hand.y, BALL_SPAWN_DEPTH, obj_pool_ball_demo);
            CO_LOCAL.shadow = instance_create_depth(CO_LOCAL.hand.x, CO_LOCAL.hand.y + BALL_SPAWN_DROP_HEIGHT, BALL_SPAWN_DEPTH+1, obj_pool_ball_demo_shadow);
        
            C_AWAIT_ALL // Move hands and ball to destination
                tween_pos_to(CO_LOCAL.ball, CO_LOCAL.dest_x, CO_LOCAL.carry_y, BALL_CARRY_DURATION, Easings.CUBE_IO);
                tween_pos_to(CO_LOCAL.hand, CO_LOCAL.dest_x, CO_LOCAL.carry_y, BALL_CARRY_DURATION, Easings.CUBE_IO);
                tween_pos_to(CO_LOCAL.shadow, CO_LOCAL.dest_x, CO_LOCAL.dest_y, BALL_CARRY_DURATION, Easings.CUBE_IO);
            C_END
        
            C_DELAY 200 C_THEN
        
            C_AWAIT_ALL
                tween_pos_to(CO_LOCAL.ball, CO_LOCAL.dest_x, CO_LOCAL.dest_y, BALL_DROP_DURATION, Easings.CUBE_I);
            C_END
        
            var _ball = instance_create_depth(CO_LOCAL.ball.x, CO_LOCAL.ball.y, BALL_SPAWN_DEPTH, obj_pool_ball);
            _ball.color_idx = CO_LOCAL.ball.color_idx;
            _ball.sprite_index = CO_LOCAL.ball.sprite_index;
            ds_list_add(balls, _ball);
            instance_destroy(CO_LOCAL.ball);
    
            CO_LOCAL.shadow.ball = _ball;
            
            C_DELAY 200 C_THEN
        C_END
    CO_ON_COMPLETE
        hand.idle_enabled = true;
    CO_END
}

/// @desc This coroutines triggers both hands to populate the balls on the arena
function populate_balls_coroutine() {
    
    CO_SCOPE = self
    
    return CO_BEGIN // Begin coroutine
    
    CO_LOCAL.total_count = desired_ball_count - spawned_balls;
    
    C_AWAIT_ALL 
        hand_populate_balls(left_hand, floor(CO_LOCAL.total_count/2));
        hand_populate_balls(right_hand, ceil(CO_LOCAL.total_count/2));
    C_END
    
    CO_ON_COMPLETE
    
        on_finish_populate();
    
    CO_END
}

function on_finish_populate() {
    trigger_idle_state("shot_balls_follow_ball", 2);
}


fsm.add(THB_POPULATE_BALLS_STATE, {
    enter: function () {
        populate_balls_coroutine();
    }    
});

#endregion

#region === IDLE STATE ===

/// @desc Triggers an idle state with the given time and then goes to the given state
/// @param {String} next 
/// @param {Real} time 
function trigger_idle_state(next, time) {
    idle_duration = time;
    idle_counter = 0;
    idle_next = next;
    
    left_hand.image_angle = 0;
    right_hand.image_angle = 0;
    left_hand.idle_enabled = true;
    right_hand.idle_enabled = true;
    left_hand.set_hand_sprite(HAND_SPRITES.IDLE);
    right_hand.set_hand_sprite(HAND_SPRITES.IDLE);
    fsm.change(THB_IDLE_STATE);
}

function idle_step() {
    idle_counter += delta_time / 1000000;
    
    if idle_counter > idle_duration {
        fsm.change(idle_next);
    }
}

fsm.add(THB_IDLE_STATE, {
    step: idle_step
});

#endregion

#region === SHOT BALLS STATE ===

fsm.add(THB_SHOT_BALLS_STATE, {
    step: function() {

        if ds_list_size(balls) <= 0 {
            trigger_idle_state(THB_POPULATE_BALLS_STATE, 2);
            return;
        }
        
        if !instance_exists(shot_balls_picked_ball) {
            print("Ball destroyed! Halting...");
            remove_deleted_balls();
            fsm.change("shot_balls_follow_ball");
            return;
        }
        
        var plr = obj_player;
        var ball = shot_balls_picked_ball;
        var player_dir = point_direction(ball.x, ball.y, plr.x, plr.y);
        
        right_hand.set_hand_sprite(HAND_SPRITES.POOL_AIM);
        right_hand.x = lerp(right_hand.x, ball.x - lengthdir_x(64, player_dir), 0.25);
        right_hand.y = lerp(right_hand.y, ball.y - lengthdir_y(64, player_dir), 0.25);
        right_hand.image_angle = player_dir-180;
        
        left_hand.set_hand_sprite(HAND_SPRITES.STICK_PULL);
        left_hand.x = stick.x - lengthdir_x(96, player_dir);
        left_hand.y = stick.y - lengthdir_y(96, player_dir);
        left_hand.image_angle = player_dir;
        
        
    }
});
fsm.add_child(THB_SHOT_BALLS_STATE, "shot_balls_follow_ball", {
    
    enter: function() {

        left_hand.idle_enabled = false;
        right_hand.idle_enabled = false;
        
        var idx = random_range(0, ds_list_size(balls));
        shot_balls_picked_ball = balls[| idx];
        shot_balls_counter = 0;
    },
    step: function() {
        fsm.inherit();
        
        if !instance_exists(shot_balls_picked_ball) or shot_balls_counter > 1 { return; }
        
        var plr = obj_player;
        var ball = shot_balls_picked_ball;
        var player_dir = point_direction(ball.x, ball.y, plr.x, plr.y);
        
        var dist = point_distance(ball.x - lengthdir_x(32, player_dir), ball.y - lengthdir_y(32, player_dir), stick.x, stick.y);
        
        var spd = 0.5;
        
        if dist > 16 { spd = 0.15; }
        if dist > 48 { spd = 0.1; }
        
        stick.x = lerp(stick.x, ball.x - lengthdir_x(32, player_dir), spd);
        stick.y = lerp(stick.y, ball.y - lengthdir_y(32, player_dir), spd);
        stick.image_angle = player_dir;
        
        shot_balls_counter += delta_time / 1000000;
        
        if shot_balls_counter > 1 {
            fsm.change("shot_balls_pull_stick");
        }
    }
});
fsm.add_child(THB_SHOT_BALLS_STATE, "shot_balls_pull_stick", {
    enter: function() {
        shot_balls_counter = 0;
    },
    step: function() {
        fsm.inherit();
        
        if !instance_exists(shot_balls_picked_ball) or shot_balls_counter > 1 { return; }
            
        var plr = obj_player;
        var ball = shot_balls_picked_ball;
        var player_dir = point_direction(ball.x, ball.y, plr.x, plr.y);
        
        stick.x = lerp(stick.x, ball.x - lengthdir_x(96, player_dir), 0.1);
        stick.y = lerp(stick.y, ball.y - lengthdir_y(96, player_dir), 0.1);
        stick.image_angle = player_dir;
        
        shot_balls_counter += delta_time / 1000000;
        
        if shot_balls_counter > 1 {
            fsm.change("shot_balls_engage_stick");
        }
    }
});
fsm.add_child(THB_SHOT_BALLS_STATE, "shot_balls_engage_stick", {
    enter: function() {
        shot_balls_counter = 0;
    },
    step: function() {
        fsm.inherit();
        
        
        if !instance_exists(shot_balls_picked_ball) { return; }
            
        var plr = obj_player;
        var ball = shot_balls_picked_ball;
        var player_dir = point_direction(ball.x, ball.y, plr.x, plr.y);
        
        shot_balls_counter += delta_time / 1000000 / 0.2;
        
        stick.x = lerp(ball.x - lengthdir_x(96, player_dir), ball.x - lengthdir_x(32, player_dir), shot_balls_counter);
        stick.y = lerp(ball.y - lengthdir_y(96, player_dir), ball.y - lengthdir_y(32, player_dir), shot_balls_counter);
        stick.image_angle = player_dir;
        
        if shot_balls_counter > 1 {
            ball.push_ball_to_dir(player_dir, push_ball_force);
            fsm.change("shot_balls_wait");
        }
    }
});
fsm.add_child(THB_SHOT_BALLS_STATE, "shot_balls_wait", {
    enter: function() {
        shot_balls_counter = 0;
    },
    step: function() {
        shot_balls_counter += delta_time / 1000000;
        
        
        if shot_balls_counter > 0.35 {
            trigger_idle_state("shot_balls_follow_ball", 4);
        }
    }
});



#endregion

fsm.on("state changed", function (dest, src) {
    cur_state = dest;
});

