
function ProcRoomData() constructor {
    grid_x = 0;
    grid_y = 0;
    connections = 0; // Bit flag (N=1 S=2 E=4 W=8)
    connected_rooms = array_create(4, { });
    type = -1;
}
