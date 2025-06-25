function LDtkTileData() constructor {
    alpha = 0;
    flip = 0b00;
    px = 0;
    py = 0;
    srcx = 0;
    srcy = 0;
    tile_id = 0;
}

/// @param {Struct.LDtkFile} file
/// @param {Struct} data
function LDtkTileLayer(file, data) constructor {
    tiles = ds_list_create();
    tileset = file.get_tileset(data[$ "__tilesetDefUid"])
    grid_size = data[$ "__gridSize"];
    offset_x = data[$ "pxOffsetX"];
    offset_y = data[$ "pxOffsetY"];
    identifier = data[$ "identifier"];
    
    
    var all_tiles = data[$ "autoLayerTiles"];
    
    for (var i = 0; i < array_length(all_tiles); i++) {
        var current = all_tiles[i];
        
        var tile = new LDtkTileData();
        tile.alpha = current[$ "a"];
        tile.flip = current[$ "f"];
        tile.px = current[$ "px"][0];
        tile.py = current[$ "px"][1];
        tile.srcx = current[$ "src"][0];
        tile.srcy = current[$ "src"][1];
        tile.tile_id = current[$ "t"];
        
        ds_list_add(tiles, tile);
    }
    
    /// @desc Cleans data structures
    function cleanup() {
        ds_list_destroy(tiles);
    }
}