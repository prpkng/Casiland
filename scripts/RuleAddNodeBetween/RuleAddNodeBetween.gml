/// @param {Real} type1 
/// @param {Real} type2 
/// @param {Real} new_type 
/// @param {Real} [count]
/// @param {Real} [gen_chance] The chance of generating a node between
function RuleAddNodeBetween(type1, type2, new_type, count=1, gen_chance=100) : RewriteStep() constructor{
    self.type1 = type1;
    self.type2 = type2;
    self.new_type = new_type;
    self.count = count;
    self.gen_chance = gen_chance;
    
    
    /// @param {Struct.Graph} graph Description
    function _apply(graph) {
        
        show_debug_message("=============================");
        show_debug_message("=== RULE ADD NODE BETWEEN ===");
        show_debug_message("=============================");
        var nodes_to_add = 0;
        var edges_to_add = [];
        
        for (var i = 0; i < ds_list_size(graph.nodes); i++) {
        	var node = graph.nodes[| i];
            if node.type != type1 {
                continue;
            }
            
            if gen_chance != 100 and random_range(0, 100) > gen_chance {
                continue;
            }
            
            
            var neighbors = graph.get_neighbors(i);
            for (var j = 0; j < array_length(neighbors); j++) {
                var idx = neighbors[j];
                
            	var other_node = graph.nodes[| idx];
                
                if other_node.type == type2 {
                    
                    
                    if graph.is_neighbor(i, idx) { graph.remove_neighbor(i, idx); }
                    if graph.is_neighbor(idx, i) { graph.remove_neighbor(idx, i); }
                    
                    repeat (count) {
                        nodes_to_add++;
                        array_push(edges_to_add, [i, idx]);
                    }
                }
            }
            
        }
        
        
        for (var i = 0; i < nodes_to_add; i++) {
        	var idx = graph.add_node(new_type);
            show_debug_message("Added node {0} between {1} and {2}", idx, edges_to_add[i][0], edges_to_add[i][1]);
            
            graph.add_edge(edges_to_add[i][0], idx);
            graph.add_edge(idx, edges_to_add[i][1]);
        }
    }
}