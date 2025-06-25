

/// @desc Loads an .ldtk file at the given path
/// @param {string} path
/// @returns {Struct.LDtkFile}
function ldtk_load_file(path) {
    if !file_exists(path) {
        show_error("ERROR: Failed to load LDtk file at location: " + path, true);
        return { };
    }
    
    var file_buffer = buffer_load(path);
    var text = buffer_read(file_buffer, buffer_string);
    buffer_delete(file_buffer);
    
    return new LDtkFile(text);
}