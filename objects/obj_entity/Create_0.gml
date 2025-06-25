max_health = 5;
cur_health = max_health;

can_die = true;

__death_callbacks = ds_list_create();

/// @desc Adds a new callback to the death event
/// @param {Function} callback
function on_death(callback) {
    ds_list_add(__death_callbacks, callback);
}