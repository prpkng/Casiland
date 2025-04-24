using System;
using Unity.Behavior;
using UnityEngine;
using Modifier = Unity.Behavior.Modifier;
using Unity.Properties;

[Serializable, GeneratePropertyBag]
[NodeDescription(name: "Repeat X times", story: "Repeats the execution [loopCount] times", category: "Flow", id: "e98236aa839503886f32653941fcf997")]
public partial class RepeatXTimesModifier : Modifier
{
    [SerializeReference] public BlackboardVariable<int> loopCount;

    private int m_LoopedTimes;
    
    protected override Status OnStart()
    {
        var status = StartNode(Child);
        
        if (Child == null)
            return Status.Failure;
        
        if (status is Status.Failure or Status.Success)
            return Status.Running;

        m_LoopedTimes = 1;
        
        return Status.Waiting;
    }

    protected override Status OnUpdate()
    {
        if (Child.CurrentStatus is Status.Success or Status.Failure)
        {
            if (++m_LoopedTimes > loopCount.Value)
                return Status.Success;

            var status = StartNode(Child);
            if (status is Status.Failure or Status.Success)
                return Status.Running;

            return Status.Waiting;
        }

        return Status.Waiting;
    }

    protected override void OnEnd()
    {
    }
}

