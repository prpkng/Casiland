using System.Collections.Generic;
using BRJ.Bosses.Snooker;
using Unity.Behavior;
using UnityEngine;

namespace Casiland.Bosses.TheHand
{
    public class TheHandBoss : MonoBehaviour
    {
        public BehaviorGraphAgent ai;
        
        [Header("Prefabs:")] 
        public GameObject poolBallPrefab;

        [Header("AI Parameters:")]
        public Vector2 minBallPos;
        public Vector2 maxBallPos;
        
        public int BallCount => m_tableBalls.Count;
        public Vector2 RandomBallPos => new(Random.Range(minBallPos.x, maxBallPos.x),
            Random.Range(minBallPos.y, maxBallPos.y));
        
        private readonly List<PoolBall> m_tableBalls = new();
        
        public void CreateBallAtHand(Transform hand)
        {
            var ball = Instantiate(poolBallPrefab, hand);
            var ballComponent = ball.GetComponent<PoolBall>();
            var ballRigidbody = ball.GetComponent<Rigidbody2D>();

            ball.transform.localPosition = Vector3.zero;

            ballRigidbody.simulated = false;
            
            ballComponent.SetShadowLocalPos(Vector2.down * 3);
            
            m_tableBalls.Add(ballComponent);
        }  
    }
}