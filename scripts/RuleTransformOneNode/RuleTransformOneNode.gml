/// @param {Constant.NODE_TYPE} type The node to be transformed
/// @param {Constant.NODE_TYPE} new_type The new node
/// @param {Real} [limit] The limit of operations (-1 = no limit)
function RuleTransformNode(type, new_type, limit = -1) : RewriteStep() constructor{
    self.type = type;
    self.new_type = new_type;
    self.limit = limit;
    
    /// @param {Struct.Graph} graph
    function _apply(graph) {
        show_debug_message("===========================");
        show_debug_message("=== RULE TRANSFORM NODE ===");
        show_debug_message("===========================");
        var counter = 0;
        for (var i = 0; i < ds_list_size(graph.nodes); i++) {
        	var node = graph.nodes[| i];
            if node.type != type {
                continue;
            }
            
            node.type = new_type;
            counter++;
            
            if limit != -1 and counter >= limit {
                break;
            }
        }
    }
}