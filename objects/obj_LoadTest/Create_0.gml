var file = ldtk_load_file("data/rooms.ldtk");

depth+=10;

var level = file.get_level_data("casino", "room_0");
level.spawn_level(0, 0, -20);

level = file.get_level_data("casino", "room_1");
level.spawn_level(480, 0, -20);