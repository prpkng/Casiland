
enum DUNGEON_TYPES {
    CASINO
}

/// @desc Runs the graph-based procedural generation algorithm and returns the array of its results
/// @param {Constant.DUNGEON_TYPES} dungeon_type The dungeon type (or biome)
/// @returns {Array<Struct.ProcRoomData>}
function procedurally_generate_dungeon_data(dungeon_type) {
    
    var graph = new Graph();
    
    // Add the predefined nodes
    
    // Graph starts with START -> NORMAL -> NORMAL -> BOSS
    graph.add_node(NODE_TYPE.START);
    graph.add_node(NODE_TYPE.NORMAL);
    graph.add_node(NODE_TYPE.NORMAL);
    graph.add_node(NODE_TYPE.BOSS);
    
    graph.add_edge(0, 1);
    graph.add_edge(1, 2);
    graph.add_edge(2, 3);

    var pre_grid_rewrite = new RewriteQueue([]);
    var post_grid_rewerite = new RewriteQueue([]);
    
    switch dungeon_type {
        #region ================= CASINO REWRITING STEPS ==================
        
        case DUNGEON_TYPES.CASINO: 
            
            pre_grid_rewrite.add_steps([
                new RuleAddNodeBetween(NODE_TYPE.START, NODE_TYPE.NORMAL, NODE_TYPE.NORMAL),
                new RuleAddNodeBetween(NODE_TYPE.NORMAL, NODE_TYPE.NORMAL, NODE_TYPE.NORMAL, 1, 50),
                new RuleAddLeafNodes(NODE_TYPE.NORMAL, NODE_TYPE.NORMAL, -1, 50),
                new RuleAddNodeBetween(NODE_TYPE.NORMAL, NODE_TYPE.NORMAL, NODE_TYPE.HUB, 1, 55),
                new RuleFillHubs(),
                new RuleAddNodeBetween(NODE_TYPE.NORMAL, NODE_TYPE.NORMAL, NODE_TYPE.NORMAL, 1, 75),
                new RuleFillDeadEnds(),
            ])
        
            post_grid_rewerite.add_steps([
                new RuleGridEnsureHubs()
            ])
        
            break;
            
        #endregion
    }
    
    
    while !pre_grid_rewrite.has_completed() {
        pre_grid_rewrite.perform_next(graph);
    }
    
    graph.graph_to_grid_list();
    
    while !post_grid_rewerite.has_completed() {
        post_grid_rewerite.perform_next(graph);
    }
    
    
    
    var result = graph.get_results_array();
    
    graph.cleanup();
    
    return result;
}

