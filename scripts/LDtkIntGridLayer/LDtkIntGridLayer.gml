/// @param {Id.DsGrid} grid A grid where 0 = empty, non-zero = filled
/// @returns {Array<Array<Real>>} An array of rectangles: {_x, _y, _width, _height}

function get_rectangles_from_binary_grid(grid) {
    var _cols = ds_grid_width(grid);
    var _rows = ds_grid_height(grid);

    // Visited grid
    var _visited = ds_grid_create(_cols, _rows);
    ds_grid_clear(_visited, 0);

    var _rectangles = [];

    for (var _y = 0; _y < _rows; _y++) {
        for (var _x = 0; _x < _cols; _x++) {
            if (_visited[# _x, _y]) continue;
            if (grid[# _x, _y] == 0) continue;

            // Found top-left of a rectangle
            var _width = 1;
            var _height = 1;

            // Expand width to the right
            while ((_x + _width < _cols) && 
                   (grid[# _x + _width, _y] != 0) && 
                   (!_visited[# _x + _width, _y])) {
                _width += 1;
            }

            // Expand height downward
            var _can_expand = true;
            while (_can_expand && (_y + _height < _rows)) {
                for (var _dx = 0; _dx < _width; _dx++) {
                    if (grid[# _x + _dx, _y + _height] == 0 || 
                        _visited[# _x + _dx, _y + _height]) {
                        _can_expand = false;
                        break;
                    }
                }
                if (_can_expand) {
                    _height += 1;
                }
            }

            // Mark all tiles in this rectangle as visited
            for (var _dy = 0; _dy < _height; _dy++) {
                for (var _dx = 0; _dx < _width; _dx++) {
                    _visited[# _x + _dx, _y + _dy] = true;
                }
            }

            // Store rectangle {_x, _y, _width, _height}
            array_push(_rectangles, [_x, _y, _width, _height]);
        }
    }

    ds_grid_destroy(_visited);
    return _rectangles;
}


/// @param {Struct.LDtkFile} file
/// @param {Struct} data
function LDtkIntGridLayer(file, data) constructor {
    grid_size = data[$ "__gridSize"];
    cell_width = data[$ "__cWid"];
    cell_height = data[$ "__cHei"];
    identifier = data[$ "identifier"];
    int_grid = ds_grid_create(cell_width, cell_height);
    
    
    #region FILL INTGRID VALUES
    
    var csv_data = data[$ "intGridCsv"];
    
    for (var i = 0; i < cell_height; i++) {
    	for (var j = 0; j < cell_width; j++) {
            
            var index = i * cell_width + j;
            
        	int_grid[# j, i] = csv_data[index];
        }
    }
    
    #endregion
    
    #region CALCULATE RECTANGLES
    
    //var visited = ds_grid_create(cell_width, cell_height);
    //
    //for (var _y = 0; _y < cell_height; _y++) {
    //	for (var _x = 0; _x < cell_width; _x++) {
    //        if visited[# _x, _y] {
    //            continue;
    //        }
    //        
    //        var _value = int_grid[# _x, _y];
    //        
    //        // Find rectangle width
    //        
    //        
    //    }
    //}
    
    collision_rectangles = get_rectangles_from_binary_grid(int_grid);
    
    #endregion
    
    /// @desc Cleans data structures
    function cleanup() {
        ds_grid_destroy(int_grid);
    }
}