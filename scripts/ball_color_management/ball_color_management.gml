
function setup_ball_colors() {
    
    global.ball_colors = ds_list_create();
    
    for (var i = 0; i < 16; i++) {
    	ds_list_add(global.ball_colors, i);
    }
}


function cleanup_ball_colors() {
    ds_list_destroy(global.ball_colors);
    global.ball_colors = undefined;
}