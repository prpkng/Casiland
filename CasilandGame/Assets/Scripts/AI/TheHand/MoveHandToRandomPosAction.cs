using System;
using BRJ.Bosses.Snooker;
using Casiland.Bosses.TheHand;
using PrimeTween;
using Unity.Behavior;
using Unity.Properties;
using UnityEngine;
using UnityEngine.Serialization;
using Action = Unity.Behavior.Action;

namespace Casiland.AI.TheHand
{
    [Serializable, GeneratePropertyBag]
    [NodeDescription(name: "MoveHandToRandomPos", story: "Moves [Hand] to a random position\n dictated by [TheHandBoss]", category: "Action", id: "ffd782fe8cb68cc6e8d18ff171a99b2c")]
    public partial class MoveHandToRandomPosAction : Action
    {
        [SerializeReference] public BlackboardVariable<PoolHand> hand;
        [SerializeReference] public BlackboardVariable<TheHandBoss> theHandBoss;

        private bool m_Completed;
    
        protected override Status OnStart()
        {
            m_Completed = false;
            var tween = Tween.Position(hand.Value.transform, theHandBoss.Value.RandomBallPos + Vector2.up * 3, 1, Ease.InOutSine);
            
            tween.OnComplete(() => m_Completed = true);
        
            return Status.Running;
        }

        protected override Status OnUpdate()
        {
            return m_Completed ? Status.Success : Status.Running;
        }

        protected override void OnEnd()
        {
            Debug.Log("Finished!!");
        }
    }
}

