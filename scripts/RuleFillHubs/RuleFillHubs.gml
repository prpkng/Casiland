function RuleFillHubs() : RewriteStep() constructor{
    
    /// @param {Struct.Graph} graph Description
    function _apply(graph) {
        
        show_debug_message("======================");
        show_debug_message("=== RULE FILL HUBS ===");
        show_debug_message("======================");
        for (var i = 0; i < ds_list_size(graph.nodes); i++) {
        	var node = graph.nodes[| i];
            if node.type != NODE_TYPE.HUB {
                continue;
            }
            
            while (array_length(node.neighbors) < 4) {
                var idx = graph.add_node(NODE_TYPE.NORMAL);
                graph.add_edge(i, idx);
            }
            
        }
    }
}