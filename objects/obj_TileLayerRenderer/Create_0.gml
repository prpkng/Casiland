tile_layer = {}

/// @param {Struct.LDtkTileLayer} tile_layer Description
function setup(tile_layer, depth) {
    self.tile_layer = tile_layer;
    
    layer = layer_create(depth, tile_layer.identifier);
}