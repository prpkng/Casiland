/// @desc  Creates an event reference to the given path
/// @param {string} event_path
function EventRef(event_path) constructor {
    ref = fmod_studio_system_get_event(event_path);
}