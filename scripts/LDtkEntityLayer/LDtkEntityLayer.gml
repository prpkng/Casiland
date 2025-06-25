function LDtkField() constructor {
    real_value = NaN;
    bool_value = false;
    string_value = "";
    color_value = c_black;
    enum_value = "";
    point_value = [];
    
    
    /// @returns {real}
    function get_real() {
        return real_value;
    }
    /// @returns {bool}
    function get_bool() {
        return bool_value;
    }
    /// @returns {string}
    function get_string() {
        return string_value;
    }
    /// @returns {Constant.Color}
    function get_color() {
        return color_value;
    }
    /// @returns {string}
    function get_enum() {
        return enum_value;
    }
    /// @returns {Array<Real>}
    function get_point() {
        if array_length(point_value) == 0 {
            return [NaN, NaN]
        }
        // Feather ignore GM1045
        return point_value;
    }
}


/// @param {Struct.LDtkFile} file
/// @param {Struct} data
function LDtkEntity(file, data) constructor {
    px = data[$ "px"][0]
    py = data[$ "py"][0]
    width = data[$ "width"];
    height = data[$ "height"];
    iid = data[$ "iid"];
    name = data[$ "identifier"];
    
    fields = array_create(array_length(data[$ "fieldInstances"]))
    
    for (var i = 0; i < array_length(fields); i++) {
        var field_data = data[$ "fieldInstances"][i];	
        
        var field = new LDtkField();
        
        switch field_data[$ "__type"] {
            case "Int":
            case "Float": {
                field.real_value = field_data[$ "__value"];   
            }    
            case "String": {
                field.string_value = field_data[$ "__value"];
            }
            case "Color": {
                field.color_value = field_data[$ "__value"];
            }
            case "Point": {
                field.point_value = field_data[$ "__value"];
            }
        }
        
        // Exception for enum fields
        if string_count("Enum", field_data[$ "__type"]) > 0 {
            field.enum_value = field_data[$ "__value"];
        }
        
        fields[i] = field;
    }
    
}


/// @param {Struct.LDtkFile} file
/// @param {Struct} data
function LDtkEntityLayer(file, data) constructor {

    entities = ds_list_create();
    
    
    
    for (var i = 0; i < array_length(data[$ "entityInstances"]); i++) {
        var entity_data = data[$ "entityInstances"];
        
        ds_list_add(entities, new LDtkEntity(file, entity_data));
    }
    
    
    /// @desc Cleans data structures
    function cleanup() {
        ds_list_destroy(entities);
    }
}