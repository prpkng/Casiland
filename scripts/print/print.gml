
/// @desc Print function with variable arguments
function print(){
    if object_index == noone {
       throw("Cannot use 'print' without being an object");
    }
    
    var _str = "";
    for (var i = 0; i < argument_count; i++) {
    	_str += string(argument[i]);
    }
    
    show_debug_message("[{0}] - {1}: {2}", date_time_string(date_current_datetime()), object_index, _str);
}