function RuleFillDeadEnds() : RewriteStep() constructor{
    
    /// @param {Struct.Graph} graph Description
    function _apply(graph) {
        
        show_debug_message("============================");
        show_debug_message("===  RULE FILL DEAD ENDS ===");
        show_debug_message("============================");
        for (var i = 0; i < ds_list_size(graph.nodes); i++) {
        	var node = graph.nodes[| i];
            if node.type != NODE_TYPE.NORMAL {
                continue;
            }
            
            if array_length(node.neighbors) <= 1 {
                node.type = NODE_TYPE.DEAD_END;
                show_debug_message("- Filled dead end: {0}", i);
            }
        }
    }
}