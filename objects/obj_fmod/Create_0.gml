// === INITIALIZE FMOD ===

print("Initializing FMOD");

var _max_channels = 1024
var _flags_core = FMOD_INIT.NORMAL;
var _flags_studio = FMOD_STUDIO_INIT.LIVEUPDATE;

// Pixels per unit
#macro FMOD_PPU 16 
#macro USE_DEBUG_CALLBACKS false // Should debugging be initialised?

/* If we enable debug callbacks in the macro above set them ON */
if (USE_DEBUG_CALLBACKS)
{
    fmod_debug_initialize(FMOD_DEBUG_FLAGS.LEVEL_LOG, FMOD_DEBUG_MODE.CALLBACK);
}

// Initialize fmod studio system
fmod_studio_system_create();
show_debug_message("fmod_studio_system_create: " + string(fmod_last_result()));
   
fmod_studio_system_init(_max_channels, _flags_studio, _flags_core);
show_debug_message("fmod_studio_system_init: " + string(fmod_last_result()));
   
/*
	FMOD Studio will create an initialize an underlying core system to work with.
*/
fmod_main_system = fmod_studio_system_get_core_system();


global.master_bank = fmod_studio_system_load_bank_file(fmod_path_bundle("FMOD/Master.bank"), FMOD_STUDIO_LOAD_BANK.NORMAL);
global.master_str_bank = fmod_studio_system_load_bank_file(fmod_path_bundle("FMOD/Master.strings.bank"), FMOD_STUDIO_LOAD_BANK.NORMAL);