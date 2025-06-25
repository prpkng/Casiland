
/// @param {Struct.LDtkFile} file 
/// @param {string} world_id
/// @param {string} identifier
function LDtkLevel(file, world_id, identifier) constructor {
    world_idx = -1;
    data = {};
    
    width = 0;
    height = 0;
    
    tile_layers = ds_list_create();
    int_grid_layers = ds_list_create();
    entity_layers = ds_list_create();
    
    
    #region GET WORLD INDEX 
    {
        // Ensures that the given world exists in the file and gets its index
        
        if !variable_struct_exists(file.data, "worlds") {
            show_error("ERROR: 'worlds' doesn't exists at the LDtk file root. This file was probably imported without the 'Multi-World export' setting in LDtk.", true);
            return;
        }
        
        var worlds = file.data.worlds;
        
        for (var i = 0; i < array_length(worlds); i++) {
        	var world = worlds[i];
            var name = world.identifier;
            
            if name == world_id {
                world_idx = i;
                break;
            }
        }
        
        if world_idx == -1 {
            show_error("ERROR: the given world: \"" + world_id + "\" is not present in the ldtk file.", true);
            return;
        }
    }
    #endregion
    
    #region GET LEVEL DATA
    
    var world = file.data[$ "worlds"][world_idx];
    
    for (var i = 0; i < array_length(world.levels); i++) {
        var current = world[$ "levels"][i];
        var name = current[$ "identifier"];
        
        if name == identifier {
            data = current;
            break;
        }
    }
    
    if !variable_struct_exists(data, "identifier") {
        show_error(string("ERROR: the given level: \"{0}\" is not present in the world: \"{1}\"", identifier, world_id), true);
        return;
    }
    
    
    width = data[$ "pxWid"];
    heidth = data[$ "pxHei"];
    
    #endregion
     
    #region GET LEVEL LAYERS
    
    var layer_instances = data[$ "layerInstances"];
    for (var i = 0; i < array_length(layer_instances); i++) {
    	var current_layer = layer_instances[i];
        
        switch current_layer[$ "__type"] {
            case "AutoLayer": {
                var _layer = new LDtkTileLayer(file, current_layer);
                ds_list_add(tile_layers, _layer);
                break;
            }
            case "IntGrid": {
                var _int_grid = new LDtkIntGridLayer(file, current_layer);
                ds_list_add(int_grid_layers, _int_grid);
                
                var _layer = new LDtkTileLayer(file, current_layer);
                ds_list_add(tile_layers, _layer);
                break;
            }
            case "Entities": {
                var _layer = new LDtkEntityLayer(file, current_layer);
                ds_list_add(entity_layers, _layer);
                break;
            }
        }
    } 
    
    #endregion

    
    /// @desc Loads the level at the current room by spawning the desired objects for each layer
    /// @param {real} [x] X position of the level
    /// @param {real} [x] Y position of the level
    /// @param {real} [depth] Starting depth at first layer
    /// @param {real} [layer_depth_multiplier] How much each layer goes down in depth
    function spawn_level(x, y, depth = 0, layer_depth_multiplier = 10) {
        for (var i = 0; i < ds_list_size(tile_layers); i++) {
            var tile_layer = tile_layers[| i];
            
            var cur_depth = depth + layer_depth_multiplier * i;
            
            var obj = instance_create_depth(x, y, cur_depth, obj_TileLayerRenderer);
            obj.setup(tile_layer, cur_depth);
        }       
        
        for (var i = 0; i < ds_list_size(int_grid_layers); i++) {
        	var int_grid_layer = int_grid_layers[| i];
            
            for (var _j = 0; _j < array_length(int_grid_layer.collision_rectangles); _j++) {
                var _rect = int_grid_layer.collision_rectangles[_j];
                
                
                var obj = instance_create_depth(x + _rect[0] * int_grid_layer.grid_size, y + _rect[1] * int_grid_layer.grid_size, -1000, obj_solid);
                obj.image_xscale = _rect[2];
                obj.image_yscale = _rect[3];
            }
        }
    }
    
    /// @desc Destroys all data structures
    function cleanup() {
        for (var i = 0; i < ds_list_size(tile_layers); i++) {
        	tile_layers[| i].cleanup();
        } 
        
        ds_list_destroy(tile_layers);
        
        for (var i = 0; i < ds_list_size(int_grid_layers); i++) {
        	int_grid_layers[| i].cleanup();
        } 
        
        ds_list_destroy(int_grid_layers);
        
        for (var i = 0; i < ds_list_size(entity_layers); i++) {
        	entity_layers[| i].cleanup();
        } 
        
        ds_list_destroy(entity_layers);
    }
}