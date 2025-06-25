var size = 48;

for (var i = 0; i < array_length(proc_data); i++) {
	var data = proc_data[i];
    var px = data.grid_x * size + 160;
    var py = data.grid_y * size + 160;
    
    draw_set_color(c_blue);
    switch (data.type) {
    	case NODE_TYPE.START:
            draw_set_color(c_purple);
            break;
    	case NODE_TYPE.HUB:
            draw_set_color(c_green);
            break;
    	case NODE_TYPE.DEAD_END:
            draw_set_color(c_red);
            break;
    	case NODE_TYPE.BOSS:
            draw_set_color(c_teal);
            break;
    }
    draw_rectangle(px, py, px+size, py+size, false);
    
    draw_text_scribble(px+size/4, py+size/4, string("[c_black][fa_center][fa_middle][scale,0.5]{0}", i));
    var _text = scribble("[c_black][fa_center][fa_middle]" + node_type_to_string(data.type))
    _text.transform(0.5, 0.5, 45);
    _text.draw(px+size/2, py+size/2);
}

for (var i = 0; i < array_length(proc_data); i++) {
	var data = proc_data[i];
    if !is_struct(data){
        continue;
    }
    
    var px = data.grid_x * size + 160;
    var py = data.grid_y * size + 160;
    
    draw_set_color(c_white);
    if data.connections & DIR_N == 0 {
        draw_line_width(px, py, px + size, py, 3);
    } else {
        draw_line_width(px, py, px + size/3, py, 3);
        draw_line_width(px + size/3*2, py, px + size, py, 3);
    }
    if data.connections & DIR_S == 0 {
        draw_line_width(px, py + size, px + size, py + size, 3);
    } else {
        draw_line_width(px, py + size, px + size/3, py + size, 3);
        draw_line_width(px + size/3*2, py + size, px + size, py + size, 3);
    }
    if data.connections & DIR_W == 0 {
        draw_line_width(px, py, px, py + size, 3);
    } else {
        draw_line_width(px, py, px, py + size/3, 3);
        draw_line_width(px, py + size/3*2, px, py + size, 3);
    }
    if data.connections & DIR_E == 0 {
        draw_line_width(px + size, py, px + size, py + size, 3);
    } else {
        draw_line_width(px + size, py, px + size, py + size/3, 3);
        draw_line_width(px + size, py + size/3*2, px + size, py + size, 3);
    }
	
}