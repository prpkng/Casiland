enum NODE_TYPE {
    START,
    NORMAL,
    HUB,
    DEAD_END,
    SHOP,
    BOSS,
}


function node_type_to_string(type) {
    switch type {
        case NODE_TYPE.START:
            return "START";
        case NODE_TYPE.NORMAL:
            return "NORMAL";
        case NODE_TYPE.HUB:
            return "HUB";
        case NODE_TYPE.DEAD_END:
            return "DEAD_END";
        case NODE_TYPE.SHOP:
            return "SHOP";
        case NODE_TYPE.BOSS:
            return "BOSS";
    }
    
    return "UNKNOWN";
}