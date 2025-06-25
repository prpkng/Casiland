
print(depth);

var tile_size = tile_layer.grid_size;

for (var j = 0; j < ds_list_size(tile_layer.tiles); j++) {
	var cur = tile_layer.tiles[| j];
    
    var flipx = (cur.flip & 1 != 0);
    var flipy = (cur.flip & 2 != 0);
    
    var px = x + cur.px + (flipx ? tile_size : 0);
    var py = y + cur.py + (flipy ? tile_size : 0);
    
    draw_sprite_part_ext(
        tile_layer.tileset,
        0,
        cur.srcx,
        cur.srcy,
        tile_size,
        tile_size,
        px,
        py,
        flipx ? -1 : 1,
        flipy ? -1 : 1,
        c_white,
        1
    );
}