/// @desc Picks a random color from the color table
/// @returns {Real} The picked color
function ball_pick_color(){
    var i = floor(random_range(0, ds_list_size(global.ball_colors)));
    var value = global.ball_colors[| i];
    ds_list_delete(global.ball_colors, i);
    return value; 
}
