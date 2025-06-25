
#macro MIN_X 40
#macro MAX_X 800
#macro MIN_Y 30
#macro MAX_Y 240

randomize();

show_debug_message("===========================================");
show_debug_message("=== Starting procedural generation task ===");
show_debug_message("===========================================");

var now = get_timer();
proc_data = procedurally_generate_dungeon_data(DUNGEON_TYPES.CASINO);

var spent = get_timer() - now;

show_debug_message("===========================================");
show_debug_message("=== Took {0}us ({1}ms) to generate dungeon!", spent, spent / 1000);
show_debug_message("===========================================");
