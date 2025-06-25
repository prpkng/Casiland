var debug = fmod_studio_system_get_listener_attributes(0);

scribble(string("[scale,0.25]==== FMOD ====\nview_pos: {0}\nvelocity: {1}", debug.attributes.position, debug.attributes.velocity)).draw(2, 48);