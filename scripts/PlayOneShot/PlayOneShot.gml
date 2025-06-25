/// @desc Plays the event and releases it at the same frame
/// @param {Struct.EventRef} event_ref
/// @param {Real} [x]
/// @param {Real} [y]
function PlayOneShot(event_ref, x = 0, y = 0){
    var event = new EventInstance(event_ref);
    event.set_pos(x, y);
    
    event.start();
}