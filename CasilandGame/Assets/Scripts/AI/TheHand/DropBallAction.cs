using BRJ.Bosses.Snooker;
using System;
using PrimeTween;
using Unity.Behavior;
using UnityEngine;
using Action = Unity.Behavior.Action;
using Unity.Properties;

[Serializable, GeneratePropertyBag]
[NodeDescription(name: "DropBall", story: "Asks [Hand] to drop the holding ball", category: "Action", id: "891a2d1cc565efb345774f83874b9f16")]
public partial class DropBallAction : Action
{
    [SerializeReference] public BlackboardVariable<PoolHand> Hand;

    private bool m_Completed = false;
    
    protected override Status OnStart()
    {
        var poolBall = Hand.Value.GetComponentInChildren<PoolBall>();
        var ballRigidbody = poolBall.GetComponent<Rigidbody2D>();
        
        poolBall.DetachShadow();
        
        m_Completed = false;
        
        Tween.Position(poolBall.transform, Hand.Value.transform.position + Vector3.down * 3, .75f, Ease.InQuint)
            .OnComplete(
                () =>
                {
                    poolBall.AttachShadow();

                    ballRigidbody.simulated = true;
                    poolBall.transform.SetParent(null);
                    poolBall.SetShadowLocalPos(Vector3.zero);

                    m_Completed = true;
                });
        return Status.Running;
    }

    protected override Status OnUpdate()
    {
        return m_Completed ? Status.Success : Status.Running;
    }

    protected override void OnEnd()
    {
    }
}

