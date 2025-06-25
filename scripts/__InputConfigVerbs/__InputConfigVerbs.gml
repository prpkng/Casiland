function __InputConfigVerbs()
{
    enum INPUT_VERB
    {
        //Add your own verbs here!
        UP,
        DOWN,
        LEFT,
        RIGHT,
        SHOOT,
        ROLL,
        CONFIRM,
        TRIGGER_PAUSE,
    }
    
    enum INPUT_CLUSTER
    {
        //Add your own clusters here!
        //Clusters are used for two-dimensional checkers (InputDirection() etc.)
        MOVE,
    }
    
    InputDefineVerb(INPUT_VERB.UP,              "up",         "W",                     [-gp_axislv, gp_padu]);
    InputDefineVerb(INPUT_VERB.DOWN,            "down",       "S",                     [ gp_axislv, gp_padd]);
    InputDefineVerb(INPUT_VERB.LEFT,            "left",       "A",                     [-gp_axislh, gp_padl]);
    InputDefineVerb(INPUT_VERB.RIGHT,           "right",      "D",                     [ gp_axislh, gp_padr]);
    InputDefineVerb(INPUT_VERB.CONFIRM,         "confirm",    vk_space,                gp_face1);
    InputDefineVerb(INPUT_VERB.SHOOT,           "shoot",      mb_left,                 gp_face2);
    InputDefineVerb(INPUT_VERB.ROLL,            "roll",       [vk_shift, vk_space],    gp_face4);
    InputDefineVerb(INPUT_VERB.TRIGGER_PAUSE,   "pause",      vk_escape,               gp_start);
    
    //Define a cluster of verbs for moving around
    InputDefineCluster(INPUT_CLUSTER.MOVE, INPUT_VERB.UP, INPUT_VERB.RIGHT, INPUT_VERB.DOWN, INPUT_VERB.LEFT);
}