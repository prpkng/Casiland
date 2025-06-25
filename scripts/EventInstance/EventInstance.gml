
/// @desc Creates an event instance from the given path
/// @param {Struct.EventRef} event_ref
function EventInstance(event_ref) constructor {
    
    event_inst = fmod_studio_event_description_create_instance(event_ref.ref);
    
    
    /// @desc Sets the event's 3d attributes position
    /// @param {real} x
    /// @param {real} y
    function set_pos(x, y) {
        
        var attr = new Fmod3DAttributes();
        attr.position = {x: x / FMOD_PPU, y: y / FMOD_PPU, z: 0};
        attr.velocity = {x: 0, y: 0, z: 0};
        attr.up = {x: 0, y: -1, z: 0};
        attr.forward = {x: 0, y: 0, z: -1};
        
        fmod_studio_event_instance_set_3d_attributes(event_inst, attr);
    }
    
    /// @desc Starts the event
    function start() {
        fmod_studio_event_instance_start(event_inst);
    }

    
    /// @desc Stops the event
    function stop() {
        fmod_studio_event_instance_stop(event_inst);
    }
    
    /// @desc Cleans everything up
    function cleanup() {
        fmod_studio_event_instance_release(event_inst);
    }
}

