with obj_pool_ball {
    var _dist = point_distance(x, y, other.x, other.y);
    if _dist < 8 {
        instance_destroy(self);
    }
    
    if place_meeting(x, y, other) {
        phy_position_x = lerp(phy_position_x, other.x, other.follow_speed);
        phy_position_y = lerp(phy_position_y, other.y, other.follow_speed);
        phy_linear_velocity_x = lerp(phy_linear_velocity_x, 0, other.follow_speed);
        phy_linear_velocity_y = lerp(phy_linear_velocity_y, 0, other.follow_speed);
    }
}