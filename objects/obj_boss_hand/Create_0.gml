hand_side = -1; // -1: left -- 1: right

image_speed = 0;
image_index = 0;

hand_stage = 0;

idle_enabled = true;

enum HAND_SPRITES {
    IDLE,
    POOL_AIM,
    STICK_PULL,
    STICK_STOMP,
    BALL_GRAB
}

/// @desc Set the hand sprite
/// @param {Constant.HAND_SPRITES} hand_spr
function set_hand_sprite(hand_spr) {
    switch (hand_spr) {
    	case HAND_SPRITES.IDLE:
            sprite_index = spr_hand_idle;
            break;
    	case HAND_SPRITES.POOL_AIM:
            sprite_index = spr_hand_pool_aim;
            break;
    	case HAND_SPRITES.STICK_PULL:
            sprite_index = spr_hand_stick_pull;
            break;
    	case HAND_SPRITES.STICK_STOMP:
            sprite_index = spr_hand_stick_stomp;
            break;
    	case HAND_SPRITES.BALL_GRAB:
            sprite_index = spr_hand_ball_grab;
            break;
    }
    
    image_speed = 0;
    image_index = hand_stage;
}

/// @desc Sets the hand sprite health stage
/// @param {Real} stage
function set_hand_stage(stage) {
    hand_stage = stage;
    image_index = hand_stage;
}
