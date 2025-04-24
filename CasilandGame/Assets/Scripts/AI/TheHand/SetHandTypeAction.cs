using BRJ.Bosses.Snooker;
using System;
using Unity.Behavior;
using UnityEngine;
using Action = Unity.Behavior.Action;
using Unity.Properties;

[Serializable, GeneratePropertyBag]
[NodeDescription(name: "SetHandType", story: "Set [Hand] sprite to [Type]", category: "Action", id: "f7ed7bd7d9b8b657076295ab7436be25")]
public partial class SetHandTypeAction : Action
{
    [SerializeReference] public BlackboardVariable<PoolHand> Hand;
    [SerializeReference] public BlackboardVariable<string> Type;

    protected override Status OnStart()
    {
        Hand.Value.SetHand(Type.Value.ToLower() switch
        {
            "idle" => HandType.Idle,
            "carry" => HandType.Carrying,
            "stick" => HandType.StickHand,
            "stickhand" => HandType.StickHand,
            "pool" => HandType.PoolHand,
            "poolhand" => HandType.PoolHand,
            "stomp" => HandType.Stomp,
            _ => HandType.Idle
        });
        return Status.Running;
    }

    protected override Status OnUpdate()
    {
        return Status.Success;
    }

    protected override void OnEnd()
    {
    }
}

