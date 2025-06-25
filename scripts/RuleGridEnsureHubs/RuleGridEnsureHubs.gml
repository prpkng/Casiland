
function RuleGridEnsureHubs() : RewriteStep() constructor{
    
    /// @param {Struct.Graph} graph Description
    function _apply(graph) {
        
        show_debug_message("=============================");
        show_debug_message("=== RULE GRID ENSURE HUBS ===");
        show_debug_message("=============================");
        for (var i = 0; i < ds_list_size(graph.grid_data); i++) {
        	var grid_node = graph.grid_data[| i];
            if grid_node.node.type != NODE_TYPE.HUB {
                continue;
            }
            
            if grid_node._adjacent < 15 {
                grid_node.node.type = NODE_TYPE.NORMAL;
                show_debug_message("Hub '{0}' is not connected to four sides!", grid_node.node_idx);
            }
        }
    }
}