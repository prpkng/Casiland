/// @param {Constant.NODE_TYPE} from 
/// @param {Constant.NODE_TYPE} new_type 
/// @param {Real} [count] The amount of nodes to generate (-1 means all possibilities)
/// @param {Real} [gen_chance] The chance of generating a node between
function RuleAddLeafNodes(from, new_type, count=-1, gen_chance=100) : RewriteStep() constructor {
    self.from = from;
    self.new_type = new_type;
    self.count = count;
    self.gen_chance = gen_chance;
    
    
    /// @param {Struct.Graph} graph Description
    function _apply(graph) {
        var _count = 0;
        
        show_debug_message("===========================");
        show_debug_message("=== RULE ADD LEAF NODES ===");
        show_debug_message("===========================");
        var nodes_to_add = 0;
        var edges_to_add = ds_list_create();
        
        for (var i = 0; i < ds_list_size(graph.nodes); i++) {
        	var node = graph.nodes[| i];
            if node.type != self.from {
                continue;
            }
            
            if gen_chance != 100 and random_range(0, 100) > gen_chance {
                continue;
            }
            
            nodes_to_add++;
            ds_list_add(edges_to_add, i);
        }
        
        
        for (var i = 0; i < nodes_to_add; i++) {
        	var idx = graph.add_node(new_type);
            show_debug_message("Added leaf node {0} from {1}", idx, edges_to_add[| i]);
            
            graph.add_edge(edges_to_add[| i], idx);
        }
        
        ds_list_destroy(edges_to_add);
    }
}