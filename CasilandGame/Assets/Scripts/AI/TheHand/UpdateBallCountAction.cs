using System;
using Casiland.Bosses.TheHand;
using Unity.Behavior;
using Unity.Properties;
using UnityEngine;
using Action = Unity.Behavior.Action;

namespace Casiland.AI.TheHand
{
    [Serializable, GeneratePropertyBag]
    [NodeDescription(name: "UpdateBallCount", story: "Update [ballCount] from [TheHandBoss]", category: "Action", id: "5694445ac716626837d05f5c5d387b17")]
    public partial class UpdateBallCountAction : Action
    {
        [SerializeReference] public BlackboardVariable<int> BallCount;
        [SerializeReference] public BlackboardVariable<TheHandBoss> TheHandBoss;

        protected override Status OnStart()
        {
            BallCount.Value = TheHandBoss.Value.BallCount;
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
}

