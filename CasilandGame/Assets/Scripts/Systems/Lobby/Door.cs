namespace BRJ.Systems.Lobby
{
    using System.Linq;
    using BRJ.Systems.Saving;
    using LDtkUnity;
    using UnityEngine;
    using UnityEngine.SceneManagement;

    public class Door : MonoBehaviour, ILDtkImportedEntity
    {
        public SpriteRenderer doorRenderer;
        public Sprite snookerDoorSprite;
        public Sprite jokerDoorSprite;

        public string doorDestination;

        public void OnLDtkImportEntity(EntityInstance entityInstance)
        {
            var field = entityInstance.FieldInstances.First(f => f.Identifier == "DoorDestination");
            if (field == null) return;
            print($"Importing door with destination {field.Value}");
            print($"Importing door with destination type {field.Value.GetType()}");
            if (!field.IsEnum) return;

            switch (field.Value)
            {
                case "The_Hand":
                    doorRenderer.sprite = snookerDoorSprite;
                    doorDestination = "TheHand";
                    break;
                case "Joker":
                    doorRenderer.sprite = jokerDoorSprite;
                    doorDestination = "Joker";
                    break;
            }
        }

        private void OnTriggerEnter2D(Collider2D other)
        {
            if (other.CompareTag("Player"))
            {
                GameObject.FindWithTag("LobbyController")
                          .GetComponent<LobbyController>()
                          .LoadBoss(doorDestination, doorDestination switch
                          {
                              "TheHand" => SaveManager.GetSaveData().HaveSeenSnookerCutscene,
                              "Joker" => SaveManager.GetSaveData().HaveSeenJokerCutscene,
                              _ => true
                          });

                switch (doorDestination)
                {
                    case "TheHand":
                        SaveManager.SetSeenSnookerCutscene();
                        break;
                    case "Joker":
                        SaveManager.SetSeenJokerCutscene();
                        break;
                }
            }
        }
    }
}