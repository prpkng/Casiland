

/// @param {Constant.NODE_TYPE} type
function Node(type) constructor {
    self.type = type;
    self.neighbors = [];
    self.node_depth = 0; 
}

/// @param {real} x Description
/// @param {real} y Description
function GridNode(x, y) constructor {
    _x = x;
    _y = y;
    _adjacent = 0; // Bit flag
    node_idx = 0;
    node = {}; 
    neighbors = array_create(4, -1); // Array storing instances of Nodes
}

#macro DIR_N 1
#macro DIR_S 2
#macro DIR_E 4
#macro DIR_W 8

function Graph() constructor {
    nodes = ds_list_create();
    grid_data = ds_list_create();
    
    /// @param {Constant.NODE_TYPE} type
    function add_node(type) {
        var idx = ds_list_size(nodes);
        ds_list_add(nodes, new Node(type));
        return idx;
    }
    
    function add_edge(from, to) {
        array_push(nodes[| from].neighbors, to);
        array_push(nodes[| to].neighbors, from);
    }
    
    function calculate_depths() {
        var _queue = ds_queue_create();
        var _visited = ds_map_create();
        
        var _start = self.nodes[| 0];
        _start.node_depth = 0;
        ds_queue_enqueue(_queue, _start);
        ds_map_add(_visited, _start, true);
        
        while !ds_queue_empty(_queue) {
            var _current = ds_queue_dequeue(_queue);
            var _current_depth = _current.node_depth;
            
            // Iterate over neighbors
            for (var i = 0; i < array_length(_current.neighbors); i++) {
            	var _neighbor = nodes[| _current.neighbors[i]];
                
                if !ds_map_exists(_visited, _neighbor) {
                    _neighbor.node_depth = _current_depth + 1;
                    ds_queue_enqueue(_queue, _neighbor);
                    ds_map_add(_visited, _neighbor, true);
                }
            }
        }
        
        ds_queue_destroy(_queue);
        ds_map_destroy(_visited);
    }
    
        
    function graph_to_grid_list() {
        var _queue = ds_queue_create();
        var _visited = ds_map_create();
        var _occupied = ds_map_create();
        ds_list_clear(grid_data);
    
        // Direction flags: [dx, dy, current_node_flag, neighbor_node_flag]
        var _dirs = [
            [ 0, -1, DIR_N, DIR_S], // North
            [ 0,  1, DIR_S, DIR_N], // South
            [ 1,  0, DIR_E, DIR_W], // East
            [-1,  0, DIR_W, DIR_E]  // West
        ];
    
        // Start node at (0, 0)
        var _start = nodes[| 0];
        var _start_node = new GridNode(0, 0);
        _start_node._node_idx = 0;
        _start_node.node = _start;
        ds_list_add(grid_data, _start_node);
        ds_map_add(_visited, _start, _start_node); // still track node → GridNode to help adjacency
        ds_map_add(_occupied, "0_0", true);
        ds_queue_enqueue(_queue, _start);
    
        while (!ds_queue_empty(_queue)) {
            var _current = ds_queue_dequeue(_queue);
            var _current_node = ds_map_find_value(_visited, _current);
            
            // C -> Current
            var _cx = _current_node._x;
            var _cy = _current_node._y;
    
            for (var i = 0; i < array_length(_current.neighbors); i++) {
                var _neighbor_idx = _current.neighbors[i];
                var _neighbor = nodes[| _neighbor_idx];
    
                if (!ds_map_exists(_visited, _neighbor)) {
                    
                    var _sorted_dirs = array_shuffle(_dirs);
                    
                    for (var d = 0; d < 4; d++) {
                        // D -> Direction
                        var _dx = _sorted_dirs[d][0];
                        var _dy = _sorted_dirs[d][1];
                        var _flag_self = _sorted_dirs[d][2];
                        var _flag_other = _sorted_dirs[d][3];
    
                        // N -> New
                        var _nx = _cx + _dx;
                        var _ny = _cy + _dy;
                        var _key = string(_nx) + "_" + string(_ny);
    
                        if (!ds_map_exists(_occupied, _key)) {
                            // Place neighbor here
                            var _neighbor_node = new GridNode(_nx, _ny);
                            _neighbor_node.node_idx = _neighbor_idx;
                            _neighbor_node.node = _neighbor;
                            
                            
                            ds_list_add(grid_data, _neighbor_node);
                            ds_map_add(_visited, _neighbor, _neighbor_node);
                            ds_map_add(_occupied, _key, true);
                            ds_queue_enqueue(_queue, _neighbor);
    
                            var _cur_dir = round(log2(_flag_self));
                            var _other_dir = round(log2(_flag_other));
                            
                            // Set direction flags
                            _current_node._adjacent |= _flag_self;
                            _neighbor_node._adjacent |= _flag_other;
    
                            // Set neighbor values
                            _current_node.neighbors[_cur_dir] = _neighbor_node;
                            _neighbor_node.neighbors[_other_dir] = _current_node;
                            
                            break;
                        }
                    }
                }
            }
        }
        
        ds_queue_destroy(_queue);
        ds_map_destroy(_visited);
        ds_map_destroy(_occupied);
    }
    
    
    /// @return {Array.Real}
    function get_neighbors(idx) {
        // Feather ignore GM1045
        return nodes[| idx].neighbors;
    }
    
    /// @return {Bool}
    function is_neighbor(idx1, idx2) {
        if (idx1 >= ds_list_size(nodes)) {
            throw "INDEX HIGHER THAN NODE COUNT";
        }
        return array_contains(nodes[| idx1].neighbors, idx2);
    }
    
    function remove_neighbor(a, b) {
        if (a >= ds_list_size(nodes)) {
            throw "INDEX HIGHER THAN NODE COUNT"; 
        }
        array_delete(nodes[| a].neighbors, array_get_index(nodes[| a].neighbors, b), 1);
    }
    
    /// @desc 
    /// @returns {Array<Struct.ProcRoomData>}
    function get_results_array() {
        var count = ds_list_size(grid_data);
        var proc_data_array = array_create(count);
        var node_to_proc = ds_map_create(); // GridNode → ProcRoomData
    
        // Step 1: Create all ProcRoomData instances
        for (var i = 0; i < count; i++) {
            var grid_node = grid_data[| i];
            var proc_data = new ProcRoomData();
    
            proc_data.connections = grid_node._adjacent;
            proc_data.type = grid_node.node.type;
            proc_data.grid_x = grid_node._x;
            proc_data.grid_y = grid_node._y;
    
            proc_data_array[i] = proc_data;
            ds_map_add(node_to_proc, grid_node, proc_data);
        }
    
        // Step 2: Fill connected_rooms using mapping
        for (var i = 0; i < count; i++) {
            var grid_node = grid_data[| i];
            var proc_data = proc_data_array[i];
            
            for (var d = 0; d < 4; d++) {
                var neighbor_node = grid_node.neighbors[d];
                if (neighbor_node != -1 && ds_map_exists(node_to_proc, neighbor_node)) {
                    proc_data.connected_rooms[d] = ds_map_find_value(node_to_proc, neighbor_node);
                }
            }
        }
    
        ds_map_destroy(node_to_proc);
        return proc_data_array;
    }
    
    function cleanup() {
        ds_list_destroy(nodes);
        ds_list_destroy(grid_data);
    }
}
