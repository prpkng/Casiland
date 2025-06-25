function RewriteStep() constructor {
    chance = 100;
    
    /// @desc  Returns the same instance with the chance applied
    /// @param {real} chance The chance in 0%-100% range
    /// @returns {Struct.RewriteStep}
    function with_chance(chance) {
        self.chance = chance;
        return self;
    }
    
    /// @param {Id.DsGrid} graph
    function _apply(graph) {
        // Logic goes here
    }
    
    /// @desc Applies the step using the chance
    function apply(graph) {
        if random_range(0, 100) <= chance {
            _apply(graph);
        }
        graph.calculate_depths();
    }
}



/// @param {Array.Struct.RewriteStep} steps
function RewriteQueue(steps) constructor {
    self.steps = steps;
    current_step = 0;
    
    function add_steps(steps) {
        self.steps = array_concat(self.steps, steps);
    }
    
    /// @desc 
    /// @returns {bool} Whether the queue has been completed
    function has_completed() {
        return current_step >= array_length(steps);
    }
    
    /// @param {Struct.Graph} graph
    function perform_next(graph) {
        show_debug_message("Performing next step...");
        steps[current_step].apply(graph);
        current_step++;
    }
}