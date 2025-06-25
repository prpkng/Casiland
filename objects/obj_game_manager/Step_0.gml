if keyboard_check_pressed(vk_backtick) {
    show_debug_overlay(!is_debug_overlay_open());
}

if keyboard_check_pressed(vk_f1) {
    show_debug_log(true);
}