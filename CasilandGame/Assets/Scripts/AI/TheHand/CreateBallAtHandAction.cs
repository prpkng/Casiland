using System;
using BRJ.Bosses.Snooker;
using Casiland.Bosses.TheHand;
using Unity.Behavior;
using Unity.Properties;
using UnityEngine;
using Action = Unity.Behavior.Action;

namespace Casiland.AI.TheHand
{
    [Serializable, GeneratePropertyBag]
    [NodeDescription(name: "CreateBallAtHand", story: "Uses [TheHandBoss] to create a Pool ball at [Hand]", category: "Action/Bosses/TheHand", id: "dd7ac22a1428c5b9f617ee374cc11c0c")]
    public partial class CreateBallAtHandAction : Action
    {
        [SerializeReference] public BlackboardVariable<TheHandBoss> TheHandBoss;
        [SerializeReference] public BlackboardVariable<PoolHand> Hand;

        protected override Status OnStart()
        {
            Debug.Log($"Action ran on {Hand.Value}");
            
            TheHandBoss.Value.CreateBallAtHand(Hand.Value.transform);
            
            return Status.Running;
        }

        protected override Status OnUpdate()
        {
            return Status.Running;
        }

        protected override void OnEnd()
        {
        }
    }
}

