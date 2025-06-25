
#macro LDTK_TILESET_PREFIX "spr_ts_"
#macro LDTK_SOLID_OBJECT obj_solid

//ldtk_config = {
//    tileset_prefix: "spr_ts_"
//}


/// @param {string} text Description
function LDtkFile(text) constructor {
    data = json_parse(text);
 
    tileset_mappings = ds_map_create();
    
    var defs = data.defs;
    
    var tileset_definitions = defs.tilesets;
    
    for (var i = 0; i < array_length(tileset_definitions); i++) 
    {
    	var current = tileset_definitions[i];
        
        var name = current.identifier;
        var uid = current.uid;
        
        
        var asset = asset_get_index(LDTK_TILESET_PREFIX + name);
        
        if (asset_get_type(asset) != asset_sprite) {
            show_error("There is an asset with the given name, but it is not a sprite: " + LDTK_TILESET_PREFIX + name, true);
            return;
        }
        
        if asset == -1 {
            show_error("Failed to find a tileset named: " + LDTK_TILESET_PREFIX + name, true);
            return;
        }
        
        tileset_mappings[? uid] = asset;
    }
    
    
    /// @desc Gets the tileset asset associated with the given UID
    /// @param {Real} uid
    /// @returns {Asset.GMSprite}
    function get_tileset(uid) { 
        // Feather ignore GM1045
       return tileset_mappings[? uid];    
    }
    
    /// @desc Gets a level data by its name
    /// @param {string} world
    /// @param {string} level 
    /// @returns {Struct.LDtkLevel}
    function get_level_data(world, level) {
        return new LDtkLevel(self, world, level);
    }
}