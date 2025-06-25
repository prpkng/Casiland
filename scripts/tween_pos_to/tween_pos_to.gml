
/// @desc Creates a coroutine that moves the given object to a location
/// @param {Id.Instance} obj
/// @param {Real} dx
/// @param {Real} dy
/// @param {Real} duration
/// @param {Constant.Easings} [easing]
function tween_pos_to(obj, dx, dy, duration, easing = Easings.LINEAR) {
    
    CO_PARAMS.obj = obj;
    CO_PARAMS.dx = dx;
    CO_PARAMS.dy = dy;
    CO_PARAMS.duration = duration;
    CO_PARAMS.easing = easing;
    return CO_BEGIN
    
        CO_LOCAL.start_x = obj.x;
        CO_LOCAL.start_y = obj.y;
    
        CO_LOCAL.t = 0;
        
        C_WHILE CO_LOCAL.t < 1 C_THEN
    
            CO_LOCAL.t += delta_time / 1000000 / duration;
            
            obj.x = lerp(CO_LOCAL.start_x, dx, ease(0, 1, CO_LOCAL.t, easing));
            obj.y = lerp(CO_LOCAL.start_y, dy, ease(0, 1, CO_LOCAL.t, easing));
    
            C_YIELD C_THEN
        C_END
    
    
    CO_END
}