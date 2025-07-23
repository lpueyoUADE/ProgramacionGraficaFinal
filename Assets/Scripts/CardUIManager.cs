using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CardUIManager : MonoBehaviour
{
    public List<CardUI> cards;
    public List<Transform> cardPositions;
    public GameObject ActionsPanel;

    public GameObject spawnParent;
    public Transform spawnPoint;

    private CardUI selectedCard;
    private CardUI invokedCard;

    private void Start()
    {
        selectedCard = null;
        invokedCard = null;

        ActionsPanel.SetActive(false);
    }

    void OnEnable()
    {
        CardUI.OnCardSelected += HandleCardSelected;
        CardUI.OnCardDeselected += HandleCardDeselected;
    }

    void OnDisable()
    {
        CardUI.OnCardSelected -= HandleCardSelected;
        CardUI.OnCardDeselected -= HandleCardDeselected;
    }

    void HandleCardSelected(CardUI card)
    {
        ActionsPanel.SetActive(true);

        selectedCard = card;

        bool found = false;
        Vector3 aux;
        for (int i = 0; i < cards.Count; i++)
        {
            if(found)
            {
                (cards[i], cards[i - 1]) = (cards[i - 1], cards[i]);

                aux = cards[i].RestingPosition;
                cards[i].UpdateRestingPostion(cards[i - 1].RestingPosition);
                cards[i - 1].UpdateRestingPostion(aux);
            }

            if(card == cards[i])
            {
                found = true;
            }
        }
    }

    void HandleCardDeselected(CardUI card)
    {
        selectedCard = null;
        ActionsPanel.SetActive(false);
    }


    public void InvokeCharacter()
    {
        if(invokedCard != null)
        {
            if (invokedCard == selectedCard)
            {
                return;
            }
            
            invokedCard.VanishCharacter();
        }

        selectedCard.InvokeCharacter(spawnPoint.position, spawnParent.transform);
        invokedCard = selectedCard;
    }

    public void VanishCharacter()
    {
        if (invokedCard != null)
        {
            invokedCard.VanishCharacter();
            invokedCard = null;
        }
    }
}
