using System;
using BRJ.Systems.Visual;
using UnityEngine;
using UnityEngine.Rendering;

namespace BRJ.Bosses.Snooker
{
    public enum HandType
    {
        Idle,
        PoolHand,
        StickHand,
        Stomp,
        Carrying,
    }

    public class PoolHand : MonoBehaviour
    {
        [SerializeField] private SortingGroup sortingGroup;
        [SerializeField] private Animator animator;
        [SerializeField] private FlashSprite flashSprite;
        [SerializeField] private SpriteTrail spriteTrail;

        [SerializeField] private SpriteRenderer[] handLayers;

        [field: SerializeField] public SpriteRenderer CurrentHandLayer { get; private set; }

        private void Start()
        {
            SetLayer(0);
        }

        public void SetOrder(int order)
        {
            sortingGroup.sortingOrder = order;
        }
        public void SetHand(HandType handType)
        {
            animator.Play(handType switch
            {
                HandType.Idle => "Idle",
                HandType.PoolHand => "Pool",
                HandType.StickHand => "Point",
                HandType.Stomp => "Hold",
                HandType.Carrying => "Carry",
                _ => null
            });
        }
        public void SetLayer(int layer)
        {
            for (int i = 0; i < handLayers.Length; i++)
                handLayers[i].enabled = i == layer;

            CurrentHandLayer = handLayers[layer];
            flashSprite.SpriteRenderer = CurrentHandLayer;
            spriteTrail.targetRenderer = CurrentHandLayer;
        }
    }
}